# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'faker'
require 'securerandom'

puts 'Starting Seeds...'
puts 'Destroying users table'
User.destroy_all
puts 'Destroying token table'
Token.destroy_all
puts 'Destroying tk_balance'
TkBalance.destroy_all
puts 'Destroying transactions'
Transaction.destroy_all
puts 'Destroying raffles'
Raffle.destroy_all
puts 'Destroying creators'
Creator.destroy_all

puts "Create users..."
password = "111111"

site_users = [
  'PaleBlue ID Generator',
  'PaleBlue Donation Account',
  'PaleBlue Raffle Ticket Generator',
  'Donation Token Generator',
  'Creator',
  'Appreciator'
]
2.times do |index|
  user = User.new(
    wlt_address: SecureRandom.hex(10),
    nickname: site_users[index],
    password:,
    password_confirmation: password
  )
  user.save!
end
puts "Users done"

users = User.all

unlimited = [
  'True',
  'True',
  'False',
  'False',
  'True'
]

max_mintable = [
  nil,
  nil,
  10_000_000,
  20_000_000,
  nil
]

puts 'Create tokens...'
5.times do |index|
  token = Token.new(
    tk_address: SecureRandom.hex,
    unlimited: unlimited[index],
    max_mint: max_mintable[index],
    minted_so_far: rand(1...5_000_000),
    user: users.first
  )
  token.save!
end
puts 'tokens done'

ActiveRecord::Base.logger = Logger.new(STDOUT)

puts 'Create creator'
creator = Creator.new(
  q1: Faker::Lorem.paragraphs(number: 1),
  q2: Faker::Lorem.paragraphs(number: 1),
  q3: Faker::Lorem.paragraphs(number: 1),
  non_profit: [true, false].sample,
  about: Faker::Lorem.paragraphs(number: 1),
  location: Faker::Address.city,
  facebook: nil,
  instagram: nil,
  linkedin: nil,
  website: nil,
  tag1: Faker::Food.dish,
  tag2: Faker::Food.dish,
  tag3: Faker::Food.dish,
  token: Token.first
)
puts "Hello"
creator.save
creator.errors.full_messages
creator.save!
puts 'creator done'

puts 'Create tk_balance...'
2.times do
  tk_balance = TkBalance.new(
    tk_amount: rand(1...5_000_000),
    token: Token.first,
    user: users.sample
  )
  tk_balance.save!
end
puts 'tk_balance done'

puts 'Create transactions...'
2.times do
  transaction = Transaction.new(
    tk_amount: rand(1...5_000_000),
    from_user: User.first,
    to_user: User.second,
    token: Token.first
  )
  transaction.save!
end
puts 'transactions done'

puts 'Create raffle'
raffle = Raffle.new(
  name: Faker::Science.element,
  about: Faker::Lorem.paragraphs(number: 1),
  tag1: Faker::Food.dish,
  tag2: Faker::Food.dish,
  tag3: Faker::Food.dish,
  creator: Creator.first,
  token: Token.first
)
raffle.save!
puts 'raffle done'
