class CheckoutController < ApplicationController
  def create
    # Replace with your real Stripe Price IDs
    price_id = params[:price_id]

    session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      line_items: [{
        price: price_id,
        quantity: 1
      }],
      mode: "subscription",
      success_url: root_url + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: root_url
    )

    redirect_to session.url, allow_other_host: true
  end
end
