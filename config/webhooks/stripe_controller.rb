# app/controllers/webhooks/stripe_controller.rb
module Webhooks
  class StripeController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      # Handle the Stripe webhook event
      payload = request.body.read
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']

      begin
        event = Stripe::Webhook.construct_event(
          payload, sig_header, Rails.application.credentials.dig(:stripe, :webhook_secret)
        )
      rescue JSON::ParserError => e
        render json: { error: "Invalid payload" }, status: 400 and return
      rescue Stripe::SignatureVerificationError => e
        render json: { error: "Invalid signature" }, status: 400 and return
      end

      # ✅ Example: handle checkout completed
      case event['type']
      when 'checkout.session.completed'
        session = event['data']['object']
        # Do something with session (like upgrading a user’s plan)
      end

      render json: { message: "success" }, status: 200
    end
  end
end
