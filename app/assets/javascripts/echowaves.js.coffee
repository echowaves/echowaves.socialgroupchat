$ ->

  $("#convo_menu_link").qtip
    content: { text: $("#convo_menu") }
    show: { when: 'click', delay: 0 }
    hide:
      when: 'unfocus'
      fixed: true
    position:
      corner:
        target: 'bottomMiddle'
        tooltip: 'topMiddle'
    style:
      tip: 'topMiddle'
      name: 'dark'
      border: { radius: 8 }

  Math.uuid = ->
    # Private array of chars to use
    CHARS = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.split ''

    return (len, radix) ->
      chars = CHARS
      uuid = []
      radix = radix || chars.length

      if len
        # compact form
        for i in [0..len]
          uuid[i] = chars[0 | Math.random()*radix]
      else
        # rfc4122, version 4 form
        # rfc4122 requires these characters
        uuid[8] = '-'
        uuid[13] = '-'
        uuid[18] = '-'
        uuid[23] = '-'
        uuid[14] = '4'

        # Fill in random data.  At i==19 set the high bits of clock sequence as
        # per rfc4122, sec. 4.1.5
        for i in [0..36]
          if !uuid[i]
            r = 0 | Math.random()*16
            uuid[i] = chars[(i == 19) ? (r & 0x3) | 0x8 : r]
      uuid.join ''


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
