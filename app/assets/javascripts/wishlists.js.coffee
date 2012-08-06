$ ->
  $("#wishlist_gift_receiver_facebook_id").select2()
  $("#wishlist_user_ids").select2()
  new VoteVariant
  
  
class VoteVariant
  constructor: () ->
    @wishlist_array = $("div.wishlist-info")
    @click_objects = $("div.wishlist-info div.wishlist-vote a")
    @click_objects.bind "click", @vote
  vote: (event) => 
    html_object = $(event.currentTarget)
    if @image(html_object).hasClass("voted")
      return false
    url = html_object.attr "href"
    $.post url, (data) =>
      @vote_callback(data, html_object)
    , "json"
    return false
  vote_callback: (data, current_html_object)=>
    @image(current_html_object).addClass("voted")
    @other_image(current_html_object).removeClass("voted")
    @update_votes(data,current_html_object)
    @click_objects.unbind "click"
    @click_objects.bind "click", @vote
  image: (html_object)=>
    $($(html_object).find("img")[0])
  parent_div: (html_object) =>
    $(html_object.closest("div.wishlist-vote"))
  root: (html_object) =>
    $ html_object.closest("div.wishlist-info")
  other_image: (html_object)=>
    root = @root(html_object)
    class_to_search = if @parent_div(html_object).hasClass "ok" then "ko" else "ok"
    @image(root.find("div.wishlist-vote.#{class_to_search}"))
  update_votes: (data, html_object)=>
    root = @root(html_object)
    root.find("span.wishlist-num-votes-ok").html data.vote_ok
    root.find("span.wishlist-num-votes-ko").html data.vote_ko
  
  
    

