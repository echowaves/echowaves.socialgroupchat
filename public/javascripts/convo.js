$(function(){
    // scroll the convo to the bottom
    //----------------------------------------------------------------------
    scrollBottom = function(){
        $("#convo_content").attr({ scrollTop: $("#convo_content").attr("scrollHeight") - $('#convo_content').height() }, 3000);
    };

    // draw a message
    //----------------------------------------------------------------------
    messageView = function(container, message, template){
        var msg = template.clone().attr('id',message.uuid);
        var draw = function(){
            msg.find('.body').text(message.text);
            msg.find('.avatar_img').attr("src",message.gravatar_url);
            container.append(msg);
        };
        draw();
    };

    // send message
    //----------------------------------------------------------------------
	  $("#message_area").keydown(function(e){
	      if ((e.keyCode || e.which) == 13){
            //----------------------------------------------------------------------
            // message attributes
            //----------------------------------------------------------------------
	          var text = $("#message_area").val();
	          var uuid = Math.uuid(8, 16);
            var msg = {uuid:uuid, text:text, gravatar_url:g.userGravatar};

            new messageView($('#messages'),msg,$('#message_template'));
            scrollBottom();
	          $.post("/convos/" + g.convoId + "/messages", msg);
	          $("#message_area").val("");
	      };
	  });

    // load the convo messages
    //----------------------------------------------------------------------
    $.getJSON('/convos/' + g.convoId + '/messages.json', function(messages) {
        $("#messages").html("");
        $.each(messages, function(index, msg){
            new messageView($('#messages'),msg,$('#message_template'));
        });
        scrollBottom();
    });

});
