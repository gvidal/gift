class WishlistsController < PublicController
  before_filter :user_needs_to_be_logged_in
  def index
    @wishlists = @current_user.active_wishlists
  end
  def show
    @wishlists = @current_user.active_wishlists.find(params[:id])
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
  
  def add
    @friends = @graph.get_connections("me", "friends")
#    @wishlists = @current_user.wishlists << .find(params[:id])
  end
end
