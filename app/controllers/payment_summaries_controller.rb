class PaymentSummariesController < PublicController
  before_filter :user_needs_to_be_logged_in
  before_filter :load_wishlist 
  before_filter :load_payment_summary
  def summary
    @tscope = ['public','payment_summaries', 'confirm']
    @wishlist = Wishlist.user_admin(@current_user).find(params[:wishlist_id])
    @payment_summary_variants = @payment_summary.payment_summary_variants.includes(:variant => :product)
  end
  def confirm
    if @payment_summary.confirm
      @payment = @payment_summary.payments.find_by_user_id(@current_user.id)
      redirect_to pay_payment_url(@payment.id)
    else
      flash[:error] = "Something happened"
      require 'ruby-debug';debugger;1
      redirect_to summary_wishlist_payment_summary_url(@wishlist.id, @payment_summary.id)
    end
  end
  private
  def load_wishlist
    @wishlist = Wishlist.active.state("new").user_admin(@current_user).id_eq(params[:wishlist_id]).first
    raise ActiveRecord::RecordNotFound unless @wishlist
  end
  def load_payment_summary
    @payment_summary = @wishlist.payment_summary_to_confirm
    raise(ActiveRecord::RecordNotFound) if @payment_summary.blank? || @payment_summary.id != params[:id].to_i
  end
end
