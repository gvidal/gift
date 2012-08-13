module WishlistsHelper
  def add_to_wishlist(current_user, variant)
    wishlists = current_user.active_wishlists
    selecteds = wishlists.select{|wishlist| 
                wishlist.wishlist_variants.find_by_variant_id(variant.id)}.map(&:id)
    options = options_for_select(wishlists.map{|w| [w.name, w.id] }, selecteds)
    select_tag  "add_variant_to_wishlist", 
                options,multiple: true, 
                :class => :add_to_wishlist, :data => {variantid: variant.id}
  end
  
  def is_wishlist_admin?(current_user, wishlist)
    wishlist.user_admin_id == current_user.id
  end
end
