$(function(){

    messageView = function(container, message, template){
        msg = template.clone().attr('id',message.uuid);
        var draw = function(){
            msg.find('.body').text(message.text);
            msg.find('.avatar_img').attr("src",message.gravatar_url);
            container.append(msg);
        };
        draw();
    };

});
