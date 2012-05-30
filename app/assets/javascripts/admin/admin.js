//= require application
//= require tinymce-jquery
//= require admin/behaviour
//= require admin/token_inputs
//= require ckeditor/init
//= require admin/datetimepicker

$(document).ready(function(){
    var width = $("#content_bottom > div.inner").first().css("width");
    if(!$('div#sidebar').length || !$.trim($('div#sidebar').html()).length){
        $('div#sidebar').remove();
        $("div#info").css("width", width);
    }
});