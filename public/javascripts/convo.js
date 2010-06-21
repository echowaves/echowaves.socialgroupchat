$(function(){

    WebSocket.__swfLocation = "/WebSocketMain.swf";
    var server = new Pusher('381b300d73c5fd5e106e', 'test_echowaves');
    server.bind('message-create', function(m) {
        if($("#"+m.uuid).length == 0){
            $('<div class="message" style="color:#'+ Math.uuid(6, 16)+'"id="'+m.uuid+'">').append(m.message).appendTo("#convo_content");
            $("#convo_content").attr({ scrollTop: $("#convo_content").attr("scrollHeight") - $('#convo_content').height() }, 3000);
        };
    });

  $("#message_area").keydown(function(e){
    if ((e.keyCode || e.which) == 13){
      var m = $("#message_area").val();
      var uuid = Math.uuid(8, 16);
      $('<div class="message" style="color:#'+ Math.uuid(6, 16)+'"id="'+uuid+'">').append(m).appendTo("#convo_content");

        $("#convo_content").attr({ scrollTop: $("#convo_content").attr("scrollHeight") - $('#convo_content').height() }, 3000);

      $.post("/messages",{uuid:uuid, message:m});
     $("#message_area").val("");
    };
  });

});