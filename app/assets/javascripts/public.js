// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//= require select2.min
//= require wishlists
//= require jquery.tinycarousel.min
//= require products
//= require payment_stripe
$(document).ready(function(){
  var flash = "";
  for (var key in flash_messages) {
      if (flash_messages.hasOwnProperty(key) && flash_messages[key] != "" && flash_messages[key] != null) {
        flash += '<div class="' + key +'">' + flash_messages[key] + '</div>';
      }
  }
   if(flash != ""){
       $("div#container").prepend('<div class="wrapper">' + flash + '</div>'); 
   }
});

