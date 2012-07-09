class WishlistsController < PublicController
  before_filter :user_needs_to_be_logged_in
  def index
    @wishlists = @current_user.all_wishlists
  end
  def show
    @wishlists = @current_user.all_wishlists.find(params[:id])
  end
  
  def new
    @wishlist = @current_user.own_wishlists.new
    @friends = @graph.get_connections("me", "friends")
  end
  
  def create
    @friends = @graph.get_connections("me", "friends")
    @wishlist = @current_user.own_wishlists.new(params[:wishlist])
    
  end
  
  def add
    @friends = @graph.get_connections("me", "friends")
#    @wishlists = @current_user.wishlists << .find(params[:id])
  end
end
