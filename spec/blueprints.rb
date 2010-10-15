Sham.name  { Faker::Name.name }
Sham.email { Faker::Internet.email }
Sham.title { Faker::Lorem.sentence }
Sham.body  { Faker::Lorem.paragraph }


User.blueprint do
  username {Sham.name}
  password {'test123'}
  email {Sham.email}
end

Convo.blueprint do
  title {Sham.title}
  privacy {"public"}
  user
end

ConvoUser.blueprint do
  user
  convo
end
