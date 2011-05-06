Factory.define :user do |f|
  f.username "username%d"
  f.password 'password' 
  f.email "%{username}@example.com"
end

# Factory.define :convo do |f|
#   f.title "title%d"
#   f.privacy 'public'
#   owner { Factory :user }
# end
# 
# 
# Factory.define :subscription do |f|
#   user { Factory :user }
#   convo { Factory :convo }
# end
# 
# 
# Factory.define :invitation do |f|
#   user { Factory :user }
#   convo { Factory :convo }
#   requestor { Factory :user }
# end
# 
# 
# Factory.define :message do |f|
#   convo { Factory :convo }
#   owner { Factory :user }
#   body "body%d"
# end