class StripeWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]

    event = Stripe::Webhook.construct_event(
      payload,
      sig_header,
      Rails.application.credentials.dig(:stripe, :webhook_secret)
    )

    case event.type
    when "checkout.session.completed"
      handle_checkout_completed(event.data.object)
    end

    head :ok
  rescue JSON::ParserError, Stripe::SignatureVerificationError
    head :bad_request
  end

  private

  def handle_checkout_completed(session)
    # Only process paid sessions
    return unless session.payment_status == "paid"

    # Use payment_intent id as the transaction id for idempotency
    transaction_id = session.payment_intent
    return if CreditPurchase.exists?(stripe_transaction_id: transaction_id)

    user = User.find_by(id: session.metadata.user_id)
    package = PACKAGE_PRICES[session.metadata.package]

    return unless user && package

    begin
      ActiveRecord::Base.transaction do
        purchase = CreditPurchase.create!(
          user: user,
          amount: package[:amount],
          unit: package[:unit],
          status: :successful,
          stripe_transaction_id: transaction_id
        )

        user.increment!(:credits, package[:unit])

        CreditTransaction.create!(
          user: user,
          units: package[:unit],
          reason: "Credit purchase",
          source: purchase,
          type: 1  # Type 1 is 'earnt' enum value
        )
      end
    rescue StandardError => e
      Rails.logger.error("Error processing checkout session #{session.id}: #{e.message}")
    end
  end
end
