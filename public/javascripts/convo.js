$(function(){

    messageView = function(container, message, template){
        msg = template.clone().attr('id',message.uuid);
        var draw = function(){
            msg.find('.body').text(message.text);
            container.append(msg);
        };
        draw();
    };

});