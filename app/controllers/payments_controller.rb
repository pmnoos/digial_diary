class PaymentsController < ApplicationController
  def new
    # Renders payment form
  end

  def create
    # Handles Stripe payment submission
    Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
    begin
      charge = Stripe::Charge.create(
        amount: params[:amount], # Amount in cents
        currency: 'usd',
        source: params[:stripeToken],
        description: 'Diary App Payment'
      )
      flash[:notice] = "Payment successful!"
      redirect_to root_path
    rescue Stripe::CardError => e
      flash[:alert] = e.message
      render :new
    end
  end
end
