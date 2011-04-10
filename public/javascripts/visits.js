$(function(){
    // load the visited convos
    //----------------------------------------------------------------------
    // $.getJSON('/convos/' + g.convoId + '/messages.json', function(messages) {
      $("#visited_convos").load("/visits");


    // });

});
