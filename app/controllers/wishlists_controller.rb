class WishlistsController < PublicController
  before_filter :user_needs_to_be_logged_in
  def index
    @wishlists = @current_user.active_wishlists.includes(:user_admin, {confirmed_payment_summary: :payments})
  end
  def show
    @wishlist = @current_user.active_wishlists.includes(:variants).find(params[:id])
    @variants = @wishlist.variants
  end
  def edit
    @wishlist = @current_user.own_wishlists.state("new").find(params[:id])
    @friends = @graph.get_connections("me", "friends")
    @registered_friends = User.with_facebook_uid(@friends.map{|x| x["id"]})
  end
  
  def update
    @wishlist = @current_user.own_wishlists.state("new").find(params[:id])
    load_friends_and_registered_friends
    @friends_for_select = @wishlist.users.to_a.reject{|x| x == @current_user}
    if @wishlist.save
      flash[:notice] = t('public.wishlists.successfully_created')
      redirect_to wishlist_url @wishlist.id
    else
      flash[:error] = t('public.wishlists.error')
      render "edit"
    end
  end
  
  def new
    @random_products = Product.are_active.offset(rand(Product.count)).order("RAND()").limit(4)
    @wishlist = @current_user.own_wishlists.new
    load_friends_and_registered_friends
  end
  
  def create
    @random_products = Product.offset(rand(Product.count)).order("RAND()").limit(4)
    @wishlist = @current_user.own_wishlists.new(params[:wishlist])
    load_friends_and_registered_friends
    if @wishlist.save
      redirect_to wishlists_url, flash: {notice: t('public.wishlists.successfully_created')}
    else
      flash[:error] = t('public.wishlists.error')
      render "new"
    end
  end
  
  def vote
    vote = (params[:vote] == "true" || false)
    @wishlist = @current_user.active_wishlists.state("new").find(params[:id])
    variant = Variant.find(params[:variant_id])
    wishlist_variant_vote =  @wishlist.wishlist_variant_votes.find_by_variant_id_and_user_id(params[:variant_id], @current_user.id) || 
                              @wishlist.wishlist_variant_votes.new(:variant_id => params[:variant_id],
                                                                    :user_id => @current_user.id)
    wishlist_variant_vote.vote = vote
    wishlist_variant_vote.save
    
    respond_to do |format|
      format.js{ render :json => {vote_ok: t('public.wishlists.show.votes', votes: variant.num_votes(@wishlist, true)), 
                                  vote_ko: t('public.wishlists.show.votes', votes: variant.num_votes(@wishlist, false))}}
    end
  end
  
  def create_payments
    @wishlist = @current_user.own_wishlists.state("new").find(params[:id])
    @participants = @wishlist.all_participants
    variants_with_quantity = params[:variants].values
    variants_with_quantity.reject!{|x| x[:variant_id].blank? || x[:quantity].to_i <= 0}
    if variants_with_quantity.present? && (@payment_summary = @wishlist.create_payment_summary!(@participants, variants_with_quantity))
      flash[:notice] = "Please, confirm the payment"
      redirect_to summary_wishlist_payment_summary_url @wishlist.id, @payment_summary.id 
    else
      flash[:error] = "Something went wrong"
      redirect_to wishlist_url @wishlist.id
    end
    
  end
  
  def add_variant
    WishlistVariant.find_or_create_by_wishlist_id_and_variant_id(params[:id], params[:variant_id])
    respond_to do |format|
      format.all{ render :nothing => true}
    end
  end
  
  def remove_variant
    WishlistVariant.find_by_wishlist_id_and_variant_id(params[:id], params[:variant_id]).try(:destroy)
    respond_to do |format|
      format.all{ render :nothing => true}
    end
  end
  private
  def load_friends_and_registered_friends
    @friends = @graph.get_connections("me", "friends")
      registered_friends = User.with_facebook_uid(@friends.map{|x| x["id"]}).to_a
      @friends.map! do |friend|
        friend["db_id"] = registered_friends.select{|rf| rf.fb_authentication.uid.to_s == friend["id"]}.first.id
        friend
      end
      @registered_friends = @friends.select{|u| u["db_id"].present?}
  end
end
