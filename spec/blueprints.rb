User.blueprint do
  username { "username#{sn}" }
  password { 'password' }
  email {"#{object.username}@example.com"}
end


Convo.blueprint do
  title {"title#{sn}"}
  privacy {'public'}
  # associations eventually should just work, perhaps not working as expected because the user is embedded, oh well
  user { User.make }
end


Subscription.blueprint do
  user
  convo
end


Invitation.blueprint do
  user
  convo
end


Message.blueprint do
  user
  convo
  body { "body#{sn}"}
end