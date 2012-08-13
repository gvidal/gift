class PaymentsController < PublicController
  before_filter :user_needs_to_be_logged_in
  before_filter :load_wishlist
  def summary
    @payment_summary = @wishlist.create_payment_summary!(users, variant_ids_with_quantity)
    if @payment_summary
      flash[:notice] = "Please, confirm the payment"
      redirect_to confirm_wishlist_payment_summary_url @wishlist.id, @payment_summary.id 
    else
      flash[:error] = "Something went wrong"
      redirect_to wishlist_url @wishlist.id
    end
  end
  
  private
  def load_wishlist
    @wishlist = Wishlist.active.state("new").find_by_user_admin_id_and_wishlist_id(current_user.id, params[:wishlist_id])
    raise ActiveRecord::RecordNotFound unless @wishlist
  end
end
