Sham.name  { Faker::Name.name }
Sham.email { Faker::Internet.email }
Sham.title { Faker::Lorem.sentence }
Sham.body  { Faker::Lorem.paragraph }


User.blueprint do
  password {'password'}
  password_confirmation {'password'}
  name {Sham.name}
  email {Sham.email}
end