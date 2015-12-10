#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require bootstrap-notify
#= require_self

$ ->
  container = $('.ff-notification-wrapper')
  $.notify {}, {
    element: 'body',
    position: null,
    type: 'info',
    allow_dismiss: true,
    newest_on_top: false,
    showProgressbar: false,
    placement: {
      from: 'bottom',
      align: 'center'
    },
    offset: 0,
    spacing: 10,
    z_index: 1031,
    delay: 0,
    timer: 1000,
    mouse_over: null,
    animate: {
      enter: 'animated fadeInUp',
      exit: 'animated fadeOutDown'
    },
    onShow: null,
    onShown: null,
    onClose: null,
    onClosed: null,
    icon_type: 'class',
    template: container.html()
  } if container.length > 0
