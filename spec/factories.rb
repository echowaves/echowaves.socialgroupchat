Factory.define :user do |f|
  f.username "username%d"
  f.password 'password' 
  f.email "%{username}@example.com"
end

Factory.define :followership do |f|
  f.follower  { Factory :user }
  f.leader    { Factory :user }
end

Factory.define :visit do |f|
  f.user  { Factory :user }
  f.convo { Factory :convo }
end

Factory.define :convo do |f|
  f.title "title%d"
  f.privacy_level 0 # 0 -> private, 1 -> public
  f.owner { Factory :user }
end

Factory.define :subscription do |f|
  f.user  { Factory :user }
  f.convo { Factory :convo }
end


Factory.define :invitation do |f|
  f.user { Factory :user }
  f.convo { Factory :convo }
  f.requestor { Factory :user }
end



Factory.define :message do |f|
  f.convo { Factory :convo }
  f.owner { Factory :user }
  f.body "body%d"
  f.uuid "%d"
end