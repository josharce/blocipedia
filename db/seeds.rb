# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'random_data'
require 'faker'

=begin
10.times do
  Wiki.create!(
    title:  RandomData.random_sentence,
    body:   RandomData.random_paragraph,
    private: false
  )
end
=end

15.times do
  Wiki.create!(
    title:  Faker::Lorem.sentence,
    body:   Faker::Lorem.paragraphs,
    private: false
  )
end

5.times do
  User.create!(
    email: Faker::Internet.email,
    password: Faker::Internet.password
  )
end

User.create!(
  email: "josh@bloci.com",
  password: "bebedk12"
)

wikis = Wiki.all
users = User.all

puts "Seed finished"
puts "#{Wiki.count} wikis created (should be 15)"
puts "#{User.count} users created (should be 6)"
