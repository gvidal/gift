#http://www.queness.com/resources/html/jcarousel/index.html
$ ->
  $($(".tinycarousel").first()).tinycarousel()
  new ProductsAddToWishlist
  
class ProductsAddToWishlist
  constructor: ->
    @elements().multiselect()
    @multiselects()
  elements: =>
    $(".add_to_wishlist")
  ajax_parameters: (type, wishlist_id, variant_id) =>
    parameters = {dataType: "html"}
    if type == "add"
      parameters.url = "/wishlists/#{wishlist_id}/add_variant/#{variant_id}"
      parameters.type = "POST"
    else if type == "remove"
      parameters.url = "/wishlists/#{wishlist_id}/remove_variant/#{variant_id}"
      parameters.type = "DELETE"
    parameters
  multiselects: => 
    selecteds = @elements()
    selecteds.unbind "multiselectclick"
    selecteds.bind "multiselectclick", @multiselect_click      
  multiselect_click: (event, ui) => 
    wishlist_id = ui.value
    type = if ui.checked then "add" else "remove"
    variant_id = $("#add_variant_to_wishlist").data("variantid")
    ajax_params = @ajax_parameters(type, wishlist_id, variant_id)
    $.ajax ajax_params
    
  