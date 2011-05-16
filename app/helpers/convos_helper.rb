module ConvosHelper
  
  def privacy_level(args)
    convo = args[:convo]
    if convo.social?
      "social"
    else
      "confidential"
    end
  end


  def accessible(args)
    convo = args[:convo]
    if convo.accesible_by_user? current_user
      "accessible"
    else
      "non accessible"
    end
  end
  
end