#http://www.queness.com/resources/html/jcarousel/index.html

$ ->
    carou_init_callback = (carousel) ->
      carousel.clip.hover ->
          carousel.stopAuto()
      , ->
          carousel.startAuto()
    
    carousel_options = {
                          vertical: true, 
                          scroll: 1, 
                          auto: 2,
                          wrap: 'last', 
                          initCallback: carou_init_callback()
                      }
    $('#carousel').jcarousel(carousel_options)
 
    #Front page Carousel - Initial Setup
    #set all the item to full opacity
    $('div#slideshow-carousel a img').css({'opacity': '0.5'});
     
    #readjust the first item to 50% opacity
    $('div#slideshow-carousel a img:first').css({'opacity': '1.0'});
     
    #append the arrow to the first item
    $('div#slideshow-carousel li a:first').append('<span class="arrow"></span>')
  
    #Add hover and click event to each of the item in the carousel
    $('div#slideshow-carousel li a').hover ->             
            #check to make sure the item is not selected
          if !$(this).has('span').length 
              #reset all the item's opacity to 50%
              $('div#slideshow-carousel li a img').stop(true, true).css({'opacity': '0.5'});
              #adust the current selected item to full opacity
              $(this).stop(true, true).children('img').css({'opacity': '1.0'})    
        , ->
            #on mouse out, reset all the item back to 50% opacity
            $('div#slideshow-carousel li a img').stop(true, true).css({'opacity': '0.5'})
            #reactivate the selected item by loop through them and look for the one
            #that has the span arrow
            $('div#slideshow-carousel li a').each ->
                #found the span and reset the opacity back to full opacity
                $(this).children('img').css({'opacity': '1.0'}) if $(this).has('span').length
    .click ->
         #remove the span.arrow
        $('span.arrow').remove()
        #append it to the current item       
        $(this).append('<span class="arrow"></span>')
        #remove the active class from the slideshow main
        $('div#slideshow-main li').removeClass('active')
        #display the main image by appending active class to it.       
        $('div#slideshow-main li.' + $(this).attr('rel')).addClass('active');
        false