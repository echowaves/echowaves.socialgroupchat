namespace :db do
  desc "resets the db and Load some sample data, intended for use during development"
  task :load_sample_data => :environment do

    User.destroy_all

    (1..10).each do |n|
      User.create(:email => "user#{n}@echowaves.com",
                  :password => "pass123",
                  :password_confirmation => "pass123",
                  :confirmation_token => nil,
                  :confirmation_sent_at => Time.now,
                  :confirmed_at => Time.now,
                  :username => "user#{n}")
    end

  end
end
