$ ->
  form = $('.active_admin form.formtastic')
  form.find('.select.input select, .polymorphic_select.input select').width("76%").chosen
    allow_single_deselect: true

  form.find('.polymorphic_select.input select').each () ->
    field      = $(this)
    targetName = field.data 'target'
    target     = form.find("[name='#{targetName}']")

    field.on 'change', (evt) ->
      target.val $(this).find(":selected").data('type')
