require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "Ivan Lučev",
                 :email => "lucev.ivan@gmail.com",
                 :password => "foobar",
                 :password_confirmation => "foobar")
    admin.toggle!(:admin)                 
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      location = Faker::Address.city
      password  = "password"
      User.create!(:name => name,
                   :email => email,
                   :location => location,
                   :password => password,
                   :password_confirmation => password)
    end
  end
end
