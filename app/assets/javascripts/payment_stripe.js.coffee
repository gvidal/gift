jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  $("#form_payment").submit (event)->
    #// disable the submit button to prevent repeated clicks
    $('.submit-button').attr("disabled", "disabled")
    Stripe.createToken({
        number: $('.card-number').val(),
        cvc: $('.card-cvc').val(),
        exp_month: $('.card-expiry-month').val(),
        exp_year: $('.card-expiry-year').val()
      }
    , stripeResponseHandler)
    false
  stripeResponseHandler = (status, response) ->
    if response.error
        #// show the errors on the form
        payment_errors = $(".payment-errors")
        payment_errors.text(response.error.message)
        if !payment_errors.hasClass?("error") then payment_errors.addClass("error")
        
        $(".submit-button").removeAttr("disabled")
    else 
        form$ = $("#form_payment")
        #// token contains id, last4, and card type
        token = response['id']
        #// insert the token into the form so it gets submitted to the server
        form$.append "<input type='hidden' name='stripeToken' value='" + token + "'/>"
        #// and submit
        form$.get(0).submit()