$ ->
  multiselecteds = $(".add_to_wishlist")
  multiselecteds.multiselect()
  multiselecteds.bind "multiselectclick", (event, ui) ->
    alert "a"
    
$ ->
  $("#wishlist_gift_receiver_facebook_id").select2()
  $("#wishlist_user_ids").select2()

