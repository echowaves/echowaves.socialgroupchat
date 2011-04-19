User.blueprint do
  username { "username#{sn}" }
  password { 'password' }
  email {"#{object.username}@example.com"}
end


Convo.blueprint do
  title {"title#{sn}"}
  privacy {'public'}
  # associations eventually should just work, perhaps not working as expected because the user is embedded, oh well
  owner { User.make }
end


Subscription.blueprint do
  user
  convo
end


Invitation.blueprint do
  user
  convo
  requestor { User.make }
end


Message.blueprint do
  convo
  owner { User.make }
  body { "body#{sn}"}
end