jQuery ->
  $('form').on 'click', '.remove_variant_image_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('div.row').hide()
    event.preventDefault()
  
  $('form').on 'click', '.add_variant_image_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $('#variant_images').append($(this).data('fields').replace(regexp, time))
    event.preventDefault()