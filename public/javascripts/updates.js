function updates(){
    // load the updated subscriptions
      $("#updated_subscriptions").load("/updates");
}

$(updates());

setInterval("updates()",60000);
