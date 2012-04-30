//= require application
//= require tinymce-jquery
//= require admin/behaviour

$(document).ready(function(){
    var width = $("#content_bottom > div.inner").first().css("width");
    if(!$.trim($('div#sidebar').html()).length){
        $('div#sidebar').remove();
        $("div#info").css("width", width);
    }
});