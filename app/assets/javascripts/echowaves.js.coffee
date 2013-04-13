$ ->

#  $("#convo_menu_link").qtip
#    content: { text: $("#convo_menu") }
#    show: { when: 'click', delay: 0 }
#    hide:
#      when: 'unfocus'
#      fixed: true
#    position:
#      corner:
#        target: 'bottomMiddle'
#        tooltip: 'topMiddle'
#    style:
#      tip: 'topMiddle'
#      name: 'dark'
#      border: { radius: 8 }

  Math.uuid = ->
    chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.split('')
    uuid = new Array(36)
    random = 0
    for digit in [0..36]
      switch digit
        when 8, 13, 18, 23
          uuid[digit] = '-'
        when 14
          uuid[digit] = '4'
        else
          random = 0x2000000 + (Math.random() * 0x1000000) | 0 if (random <= 0x02)
          r = random & 0xf
          random = random >> 4
          uuid[digit] = chars[if digit == 19 then (r & 0x3) | 0x8 else r]
    uuid.join('')

  # draw a message TODO:remove the duplication with echowaves.js.coffee
  #----------------------------------------------------------------------
  messageView = (container, message, template) ->
    msg = template.clone().attr 'id', message.uuid
    draw = ->
      msg.find('.body').text message.text
      msg.find('.avatar_img').attr "src", message.gravatar_url
      container.append(msg)
    draw()

  # socky
  #----------------------------------------------------------------------

  Socky.prototype.respond_to_message = (m) ->
    msg = JSON.parse m
    if $("##{msg.uuid}").length == 0
      new messageView $('#messages'), msg, $('#message_template')
      $("#convo_content").attr
        scrollTop: $("#convo_content").attr("scrollHeight") - $('#convo_content').height()
        3000

  # Socky.prototype.respond_to_connect = function() {};
  # Socky.prototype.respond_to_authentication_success = function() {};
  # Socky.prototype.respond_to_authentication_failure = function() {};
  # Socky.prototype.respond_to_disconnect = function() {
  #   setTimeout(function(instance) { instance.connect(); }, 1000, this);
