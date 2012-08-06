class WishlistsController < PublicController
  before_filter :user_needs_to_be_logged_in
  def index
    @wishlists = @current_user.active_wishlists
  end
  def show
    @wishlist = @current_user.active_wishlists.find(params[:id])
    @variants = @wishlist.variants
  end
  
  def new
    @random_products = Product.are_active.offset(rand(Product.count)).order("RAND()").limit(4)
    @wishlist = @current_user.own_wishlists.new
    @friends = @graph.get_connections("me", "friends")
    @registered_friends = User.with_facebook_uid(@friends.map{|x| x["id"]})
  end
  
  def create
    @random_products = Product.offset(rand(Product.count)).order("RAND()").limit(4)
    @friends = @graph.get_connections("me", "friends")
    @wishlist = @current_user.own_wishlists.new(params[:wishlist])
    @registered_friends = User.with_facebook_uid(@friends.map{|x| x["id"]})
    if @wishlist.save
      redirect_to wishlists_url, flash: {notice: t('public.wishlists.successfully_created')}
    else
      render "new"
    end
  end
  
  def vote
    vote = (params[:vote] == "true" || false)
    @wishlist = @current_user.active_wishlists.find(params[:id])
    @variant = Variant.find(params[:variant_id])
    @wishlist_variant_vote =  @wishlist.wishlist_variant_votes.find_by_variant_id(params[:variant_id]) || 
                              @wishlist.wishlist_variant_votes.new(:variant_id => params[:variant_id])
    @wishlist_variant_vote.vote = vote
    @wishlist_variant_vote.save
    
    respond_to do |format|
      format.js{ render :json => {vote_ok: t('public.wishlists.show.votes', votes: @variant.num_votes(@wishlist, true)), 
                                  vote_ko: t('public.wishlists.show.votes', votes: @variant.num_votes(@wishlist, false))}}
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
  
end
