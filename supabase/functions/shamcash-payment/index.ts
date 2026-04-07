import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

const supabase = createClient(supabaseUrl, serviceRoleKey);

function generateReference(): string {
  return "SHAM" + crypto.randomUUID().slice(0, 8).toUpperCase();
}

serve(async (req) => {
  try {
    const body = await req.json();
    const action = body.action;

    // --------------------------------------------
    // CREATE SESSION
    // --------------------------------------------
    if (action === "create-session") {
      const { orderId, amount, userId } = body;

      const { data: order, error: orderError } = await supabase
        .from("orders")
        .select("id, client_id, status, price")
        .eq("id", orderId)
        .maybeSingle();

      if (orderError || !order) {
        return new Response(JSON.stringify({ error: "Order not found" }), {
          status: 404,
        });
      }

      if (order.client_id !== userId) {
        return new Response(JSON.stringify({ error: "Not authorized" }), {
          status: 403,
        });
      }

      // ✅ إنشاء سجل دفع جديد
      const referenceNumber = generateReference();

      const { data: payment, error: paymentError } = await supabase
        .from("payments")
        .insert({
          order_id: orderId,
          user_id: userId,
          amount: amount,
          payment_method: "sham_cash",
          status: "pending",
          reference_number: referenceNumber,
          created_at: new Date().toISOString(),
        })
        .select()
        .single();

      if (paymentError) {
        console.error("Payment creation error:", paymentError);
        return new Response(
          JSON.stringify({ error: "Failed to create payment record" }),
          { status: 500 }
        );
      }

      return new Response(
        JSON.stringify({
          success: true,
          reference_number: referenceNumber,
          payment_url: "shamcash://payment/" + referenceNumber,
          expires_at: new Date(Date.now() + 5 * 60 * 1000).toISOString(),
          amount,
          merchant: "Hirfati",
          payment_id: payment.id, // ✅ إرجاع payment_id
        }),
        { status: 200 }
      );
    }

    // --------------------------------------------
    // CONFIRM PAYMENT
    // --------------------------------------------
    if (action === "confirm-payment") {
      const { orderId, pin, userId, idempotencyKey } = body;

      if (!orderId || !pin || !userId || !idempotencyKey) {
        return new Response(
          JSON.stringify({ error: "Missing required fields" }),
          { status: 400 }
        );
      }

      console.log("Confirming payment:", {
        orderId,
        userId,
        pin,
        idempotencyKey,
      });

      // ✅ أولاً: جلب سجل الدفع المرتبط بهذا الطلب
      const { data: payment, error: paymentError } = await supabase
        .from("payments")
        .select("id")
        .eq("order_id", orderId)
        .eq("user_id", userId)
        .eq("status", "pending")
        .maybeSingle();

      if (paymentError || !payment) {
        return new Response(JSON.stringify({ error: "Payment not found" }), {
          status: 404,
        });
      }

      // ✅ ثانياً: استدعاء دالة confirm_sham_cash_payment مع payment_id الصحيح
      const { data: result, error: rpcError } = await supabase.rpc(
        "confirm_sham_cash_payment",
        {
          p_payment_id: payment.id, // ✅ الآن نمرر payment_id الصحيح
          p_client_id: userId,
          p_pin: pin,
        }
      );

      if (rpcError) {
        console.error("RPC Error:", rpcError);
        return new Response(JSON.stringify({ error: rpcError.message }), {
          status: 400,
        });
      }

      if (!result || !result.success) {
        return new Response(
          JSON.stringify({ error: result?.message || "Payment failed" }),
          { status: 400 }
        );
      }

      return new Response(
        JSON.stringify({
          success: true,
          payment_id: result.payment_id,
          transaction_id: result.reference_number,
          reference_number: result.reference_number,
          paid_at: result.paid_at,
          amount: result.amount,
        }),
        { status: 200 }
      );
    }

    return new Response(JSON.stringify({ error: "Unknown action" }), {
      status: 400,
    });
  } catch (e) {
    console.error("Error:", e);
    return new Response(JSON.stringify({ error: e.toString() }), {
      status: 500,
    });
  }
});
