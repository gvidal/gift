module WishlistsHelper
  def add_to_wishlist(current_user, product)
#    return "" if !current_user || current_user.active_wishlists.size == 0
    select_tag "wishlist_product_#{product.id}", options_from_collection_for_select(current_user.active_wishlists, "id", "name"),multiple: true, class: :add_to_wishlist
  end
end
