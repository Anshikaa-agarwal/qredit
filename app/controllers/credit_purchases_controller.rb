class CreditPurchasesController < ApplicationController
  before_action :authenticate_user!

  def show
    @credit_purchase = CreditPurchase.find_by(stripe_transaction_id: params[:stripe_transaction_id])
    redirect_to root_path, alert: "Not authorized" unless @credit_purchase.user == current_user
  end
end
