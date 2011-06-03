$ ->
  # scroll the convo to the bottom
  #----------------------------------------------------------------------
  window.scrollBottom = ->
    $("#convo_content").attr
      scrollTop: $("#convo_content").attr("scrollHeight") - $('#convo_content').height()
      3000


  # draw a message TODO:remove the duplication with echowaves.js.coffee
  #----------------------------------------------------------------------
  messageView = (container, message, template) ->
    msg = template.clone().attr 'id', message.uuid
    draw = ->
      msg.find('.body').text message.text
      msg.find('.avatar_img').attr "src", message.gravatar_url
      container.append(msg)
    draw()


  # send message
  #----------------------------------------------------------------------
  $("#message_area").keydown (e) ->
    if ((e.keyCode || e.which) == 13)
      #----------------------------------------------------------------------
      # mesage attributes
      #----------------------------------------------------------------------
      text = $("#message_area").val()
      uuid = Math.uuid 8, 16
      msg =
        uuid: uuid
        text: text
        gravatar_url: g.userGravatar

      messageView $('#messages'), msg, $('#message_template')
      scrollBottom()
      $.post "/convos/#{g.convoId}/messages", msg
      $("#message_area").val ""


  # load the convo messages
  #----------------------------------------------------------------------
  if g.convoId > 0
    $.getJSON "/convos/#{g.convoId}/messages.json", (messages) ->
      $("#messages").html ""
      $.each messages, (index, msg) ->
        new messageView $('#messages'), msg, $('#message_template')
      scrollBottom()

