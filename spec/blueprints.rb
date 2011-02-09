Sham.username {|index| "user_#{index}" }
Sham.email { Faker::Internet.email }
Sham.title { Faker::Lorem.sentence }
Sham.body  { Faker::Lorem.paragraph }

User.blueprint do
  username { Sham.username }
  password { 'password' }
  email {Sham.email}
end

Convo.blueprint do
  title {Sham.title}
  privacy {'public'}
  user { User.make }
end

Subscription.blueprint do
  user { User.make }
  convo { Convo.make }
end

Invitation.blueprint do
  user { User.make }
  convo { Convo.make }
end

Message.blueprint do
  user { User.make }
  convo { Convo.make }
  body {Sham.body}
end