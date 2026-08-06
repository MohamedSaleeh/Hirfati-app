import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import {
  createClient,
  type SupabaseClient,
} from "https://esm.sh/@supabase/supabase-js@2";
import { google } from "https://esm.sh/googleapis@121";

type ServiceClient = SupabaseClient<any, "public", "public", any, any>;
type ProfileRoleRow = { role: string | null };
type OrderAuthorizationRow = {
  client_id: string;
  workers?: { user_id: string | null } | { user_id: string | null }[] | null;
};
type ConversationAuthorizationRow = {
  user1_id: string;
  user2_id: string;
};

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

const allowedTypes = new Set([
  "order",
  "payment",
  "payment_request",
  "message",
  "system",
]);

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return jsonResponse({ error: "method_not_allowed" }, 405);
  }

  try {
    const authorization = req.headers.get("Authorization") ?? "";
    if (!authorization.startsWith("Bearer ")) {
      return jsonResponse({ error: "unauthenticated" }, 401);
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    const anonKey = Deno.env.get("SUPABASE_ANON_KEY");

    if (!supabaseUrl || !serviceRoleKey || !anonKey) {
      return jsonResponse({ error: "server_misconfigured" }, 500);
    }

    const callerClient = createClient(supabaseUrl, anonKey, {
      global: { headers: { Authorization: authorization } },
    });
    const serviceClient = createClient(supabaseUrl, serviceRoleKey);

    const { data: authData, error: authError } = await callerClient.auth
      .getUser();
    const caller = authData.user;

    if (authError || !caller) {
      return jsonResponse({ error: "unauthenticated" }, 401);
    }

    const payload = await readPayload(req);
    if (!payload.ok) return jsonResponse({ error: payload.error }, 400);

    const { userId, title, body, type, orderId, data } = payload.value;
    const notificationType = type || "system";

    if (!allowedTypes.has(notificationType)) {
      return jsonResponse({ error: "invalid_notification_type" }, 400);
    }

    if (!isUuid(userId) || !isSafeText(title, 140) || !isSafeText(body, 500)) {
      return jsonResponse({ error: "invalid_payload" }, 400);
    }

    const isAdmin = await callerIsAdmin(serviceClient, caller.id);
    const authorized = await canSendNotification({
      serviceClient,
      callerId: caller.id,
      targetUserId: userId,
      type: notificationType,
      orderId,
      data,
      isAdmin,
    });

    if (!authorized) {
      return jsonResponse({ error: "forbidden" }, 403);
    }

    const { error: insertError } = await serviceClient
      .from("notifications")
      .insert({
        user_id: userId,
        title,
        body,
        type: notificationType,
        is_read: false,
        created_at: new Date().toISOString(),
      });

    if (insertError) {
      return jsonResponse({ error: "notification_store_failed" }, 500);
    }

    const { data: tokens, error: tokensError } = await serviceClient
      .from("device_tokens")
      .select("fcm_token")
      .eq("user_id", userId);

    if (tokensError) {
      return jsonResponse({ error: "device_token_lookup_failed" }, 500);
    }

    if (!tokens || tokens.length === 0) {
      return jsonResponse({ success: true, sent: 0 });
    }

    const jwtClient = new google.auth.JWT({
      email: Deno.env.get("FIREBASE_CLIENT_EMAIL")!,
      key: Deno.env.get("FIREBASE_PRIVATE_KEY")!,
      scopes: ["https://www.googleapis.com/auth/firebase.messaging"],
    });

    await jwtClient.authorize();
    const firebaseProjectId = Deno.env.get("FIREBASE_PROJECT_ID");
    if (!firebaseProjectId) {
      return jsonResponse({ error: "server_misconfigured" }, 500);
    }

    const fcmUrl =
      `https://fcm.googleapis.com/v1/projects/${firebaseProjectId}/messages:send`;
    const sendResults = await Promise.all(
      tokens.map((tokenRow) =>
        sendFcm({
          url: fcmUrl,
          accessToken: jwtClient.credentials.access_token ?? "",
          token: tokenRow.fcm_token,
          title,
          body,
          type: notificationType,
          orderId,
          data,
        })
      ),
    );

    const invalidTokens = sendResults
      .filter((result) => result.invalidToken)
      .map((result) => result.token);

    if (invalidTokens.length > 0) {
      await serviceClient
        .from("device_tokens")
        .delete()
        .in("fcm_token", invalidTokens);
    }

    return jsonResponse({
      success: true,
      sent: sendResults.filter((result) => result.success).length,
      failed: sendResults.filter((result) => !result.success).length,
    });
  } catch (_error) {
    return jsonResponse({ error: "server_error" }, 500);
  }
});

async function readPayload(req: Request): Promise<
  | {
    ok: true;
    value: {
      userId: string;
      title: string;
      body: string;
      type?: string;
      orderId?: string;
      data?: Record<string, unknown>;
    };
  }
  | { ok: false; error: string }
> {
  try {
    const value = await req.json();
    return { ok: true, value };
  } catch (_error) {
    return { ok: false, error: "invalid_json" };
  }
}

async function callerIsAdmin(serviceClient: ServiceClient, callerId: string) {
  const { data } = await serviceClient
    .from("profiles")
    .select("role")
    .eq("id", callerId)
    .maybeSingle<ProfileRoleRow>();

  return data?.role === "admin";
}

async function canSendNotification({
  serviceClient,
  callerId,
  targetUserId,
  type,
  orderId,
  data,
  isAdmin,
}: {
  serviceClient: ServiceClient;
  callerId: string;
  targetUserId: string;
  type: string;
  orderId?: string;
  data?: Record<string, unknown>;
  isAdmin: boolean;
}) {
  if (isAdmin) return true;

  if (type === "message") {
    return canSendMessageNotification({
      serviceClient,
      callerId,
      targetUserId,
      data,
    });
  }

  if (!orderId || !isUuid(orderId)) return targetUserId === callerId;

  const { data: order } = await serviceClient
    .from("orders")
    .select("id, client_id, workers!inner(user_id)")
    .eq("id", orderId)
    .maybeSingle<OrderAuthorizationRow>();

  if (!order) return false;

  const worker = Array.isArray(order.workers)
    ? order.workers[0]
    : order.workers;
  const workerUserId = worker?.user_id;
  const callerIsClient = order.client_id === callerId;
  const callerIsWorker = workerUserId === callerId;
  const targetIsClient = order.client_id === targetUserId;
  const targetIsWorker = workerUserId === targetUserId;

  if (callerIsWorker && targetIsClient) {
    return type === "order" || type === "payment_request";
  }

  if (callerIsClient && targetIsWorker) {
    return type === "order" || type === "payment";
  }

  return false;
}

async function canSendMessageNotification({
  serviceClient,
  callerId,
  targetUserId,
  data,
}: {
  serviceClient: ServiceClient;
  callerId: string;
  targetUserId: string;
  data?: Record<string, unknown>;
}) {
  const conversationId = data?.conversation_id?.toString();
  const senderId = data?.sender_id?.toString();

  if (!conversationId || !isUuid(conversationId) || senderId !== callerId) {
    return false;
  }

  const { data: conversation } = await serviceClient
    .from("conversations")
    .select("user1_id, user2_id")
    .eq("id", conversationId)
    .maybeSingle<ConversationAuthorizationRow>();

  if (!conversation) return false;

  const participants = [conversation.user1_id, conversation.user2_id];
  return participants.includes(callerId) && participants.includes(targetUserId);
}

async function sendFcm({
  url,
  accessToken,
  token,
  title,
  body,
  type,
  orderId,
  data,
}: {
  url: string;
  accessToken: string;
  token: string;
  title: string;
  body: string;
  type: string;
  orderId?: string;
  data?: Record<string, unknown>;
}) {
  const messageData = stringifyData({ ...(data ?? {}), type, orderId });

  const response = await fetch(url, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${accessToken}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      message: {
        token,
        notification: { title, body },
        data: messageData,
      },
    }),
  });

  if (response.ok) return { success: true, token, invalidToken: false };

  let status = "";
  try {
    const result = await response.json();
    status = result?.error?.status ?? "";
  } catch (_error) {
    status = "";
  }

  const invalidToken = status === "NOT_FOUND" || status === "INVALID_ARGUMENT";
  return { success: false, token, invalidToken };
}

function stringifyData(data: Record<string, unknown>) {
  const result: Record<string, string> = {};

  for (const [key, value] of Object.entries(data)) {
    if (value == null) continue;
    result[key] = String(value).slice(0, 500);
  }

  return result;
}

function isSafeText(value: unknown, maxLength: number) {
  return (
    typeof value === "string" &&
    value.trim().length > 0 &&
    value.length <= maxLength
  );
}

function isUuid(value: unknown) {
  return (
    typeof value === "string" &&
    /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i
      .test(value)
  );
}

function jsonResponse(body: Record<string, unknown>, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}
