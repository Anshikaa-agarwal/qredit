class StripeCheckoutsController < ApplicationController
  before_action :authenticate_user!

  def create
    package_key = params[:package]
    package = PACKAGE_PRICES[package_key]

    unless package
      return render json: { error: "Invalid package" }, status: :unprocessable_entity
    end

    session = Stripe::Checkout::Session.create(
      ui_mode: "embedded",
      line_items: [ {
        price_data: {
          currency: "inr",
          unit_amount: package[:amount],
          product_data: {
            name: "#{package[:unit]} Credits"
          }
        },
        quantity: 1
      } ],
      mode: "payment",
      metadata: {
        package: package_key,
        user_id: current_user.id
      },
      return_url: credits_url
    )

    render json: { clientSecret: session.client_secret }
  rescue Stripe::StripeError => e
    Rails.logger.error "Stripe error: #{e.message}"
    render json: { error: "Payment initialization failed" }, status: :unprocessable_entity
  end
end
