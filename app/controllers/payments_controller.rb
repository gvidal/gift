class PaymentsController < PublicController
  before_filter :user_needs_to_be_logged_in
  
  def pay
    @payment = @current_user.payments.state("to_pay").includes(:payment_summary => [:wishlist, :payment_summary_variants]).find(params[:id])
    @payment_summary = @payment.payment_summary
    @wishlist = @payment_summary.wishlist
    @payment_summary_variants = @payment_summary.payment_summary_variants
  end
  
  def credit_card_payment
    @payment = @current_user.payments.state("to_pay").includes(:payment_summary => [:wishlist, :payment_summary_variants]).find(params[:id])
    @payment_summary = @payment.payment_summary
    @wishlist = @payment_summary.wishlist
    @payment_summary_variants = @payment_summary.payment_summary_variants
    if @payment.save_with_payment(params[:payment])
      flash[:notice] = "Payment done!"
      redirect_to root_url
    else
      flash[:error] = "Something went wrong"
      render "pay"
    end
  end
end
