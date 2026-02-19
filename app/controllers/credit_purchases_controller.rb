class CreditPurchasesController < ApplicationController
  def show
    @credit_purchase = CreditPurchase.find_by(id: params[:id])
  end
end
