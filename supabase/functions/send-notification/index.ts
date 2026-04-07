import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { google } from "https://esm.sh/googleapis@121"; // Google API client

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { userId, title, body, type, orderId } = await req.json();
    console.log(`📨 Sending notification to user: ${userId}`);

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    // جلب جميع أجهزة المستخدم
    const { data: tokens, error: tokensError } = await supabase
      .from("device_tokens")
      .select("fcm_token")
      .eq("user_id", userId);

    if (tokensError) throw new Error(`Database error: ${tokensError.message}`);
    if (!tokens || tokens.length === 0)
      return new Response(
        JSON.stringify({ error: "No device tokens found for this user" }),
        {
          status: 404,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );

    // ✅ تهيئة Firebase Admin باستخدام Secrets المنفصلة
    const jwtClient = new google.auth.JWT({
      email: Deno.env.get("FIREBASE_CLIENT_EMAIL")!,
      key: Deno.env.get("FIREBASE_PRIVATE_KEY")!,
      scopes: ["https://www.googleapis.com/auth/firebase.messaging"],
    });

    await jwtClient.authorize();
    const fcmUrl = `https://fcm.googleapis.com/v1/projects/${Deno.env.get(
      "FIREBASE_PROJECT_ID"
    )!}/messages:send`;

    // إرسال إشعار لكل جهاز
    const fcmResults = await Promise.all(
      tokens.map(async (token) => {
        const payload = {
          message: {
            token: token.fcm_token,
            notification: { title, body },
            data: { type: type || "system", orderId: orderId || "" },
          },
        };

        try {
          const response = await fetch(fcmUrl, {
            method: "POST",
            headers: {
              Authorization: `Bearer ${jwtClient.credentials.access_token}`,
              "Content-Type": "application/json",
            },
            body: JSON.stringify(payload),
          });

          const result = await response.json();
          console.log(`📤 Sent to ${token.fcm_token}:`, result);
          return { success: response.ok, result };
        } catch (err) {
          console.error(`❌ Failed to send to ${token.fcm_token}:`, err);
          return { success: false, error: err.message };
        }
      })
    );

    const successCount = fcmResults.filter((r) => r.success).length;
    console.log(
      `✅ Successfully sent to ${successCount}/${tokens.length} devices`
    );

    // حفظ الإشعار في قاعدة البيانات
    const { error: insertError } = await supabase.from("notifications").insert({
      user_id: userId,
      title,
      body,
      type: type || "system",
      is_read: false,
      created_at: new Date().toISOString(),
    });

    if (insertError) console.error("Error saving notification:", insertError);
    else console.log("💾 Notification saved to database");

    return new Response(
      JSON.stringify({
        success: true,
        message: `Notification sent to ${successCount}/${tokens.length} devices`,
        tokensFound: tokens.length,
        fcmResults,
      }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (error) {
    console.error("❌ Error:", error.message);
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
