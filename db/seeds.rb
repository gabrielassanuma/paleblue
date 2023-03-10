# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'faker'
require 'securerandom'
require "open-uri"

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

puts "Generate users..."
password = SecureRandom.hex(8)

site_users = [
  'PaleBlue ID Generator',
  'PaleBlue Donation Account',
  'PaleBlue Raffle Ticket Generator',
  'Donation Token Generator',
  'JM Cousteau',
  'Diogo'
]

6.times do |index|
  User.create!(
    wlt_address: SecureRandom.hex(10),
    nickname: site_users[index],
    password: password
  )
end
puts "Users done"

puts 'Generate tokens and balances...'

# Pale Blue ID
# Token.first
pale_blue_id = Token.new(
  nickname: 'PaleBlue ID #1',
  user: User.first
)
pale_blue_id.save!

pale_blue_balance = TkBalance.new(
  tk_amount: pale_blue_id.max_mint,
  token: pale_blue_id,
  user: User.first
)
pale_blue_balance.save!

token = Token.first
token.minted_so_far += 1 if pale_blue_id.minted_so_far < pale_blue_id.max_mint
token.save!

# Raffle item
# Token.second
raffle_item = Token.new(
  nickname: 'Raffle Item',
  user: User.fifth
)
file = URI.open('https://upload.wikimedia.org/wikipedia/commons/7/76/Tahiti%2C_French_Polynesia_-_NASA_Earth_Observatory.jpg')
raffle_item.photo.attach(io: file, filename: "nes.jpg", content_type: "image/jpg")
raffle_item.save!

raffle_item_balance = TkBalance.new(
  tk_amount: raffle_item.max_mint,
  token: raffle_item,
  user: User.fifth
)
raffle_item_balance.save!

token = Token.second
token.minted_so_far += 1 if raffle_item.minted_so_far < raffle_item.max_mint
token.save!

# Creator File Key
# Token.third
creator_file_key = Token.new(
  nickname: 'Creator File Key',
  user: User.fifth,
  unlimited: true
)
creator_file_key.save!

creator_file_key_balance = TkBalance.new(
  tk_amount: creator_file_key.max_mint,
  token: creator_file_key,
  user: User.fifth
)
creator_file_key_balance.save!

token = Token.third
token.minted_so_far += 1
token.save!

# Raffle Ticket
# Token.fourth
raffle_ticket = Token.new(
  nickname: 'Raffle Ticket',
  user: User.third,
  unlimited: true
)
raffle_ticket.save!

raffle_ticket_balance = TkBalance.new(
  tk_amount: raffle_ticket.max_mint,
  token: raffle_ticket,
  user: User.third
)
raffle_ticket_balance.save!

token = Token.fourth
token.minted_so_far += 1
token.save!

# Donation Tokens
donation_tokens = [
  'SOL',
  'ETH',
  'BTC',
  'USDT',
  'USDC',
  'DOGE ;)',
  'BNB',
  'BUSD',
  'ATOM'
]
# Token.fifth
donation_tokens.size.times do |index|
  Token.create!(
    nickname: donation_tokens[index],
    user: User.fourth,
    unlimited: true
  )

  TkBalance.create!(
    tk_amount: 0,
    token: Token.find(index + 5),
    user: User.fourth
  )

  TkBalance.create!(
    tk_amount: Token.find(index + 5).max_mint,
    token: Token.last,
    user: User.fifth
  )
  token = Token.find(index + 5)
  token.minted_so_far += 1
  token.save!
end

creator_pale_blue_id_balance = TkBalance.new(
  token: pale_blue_id,
  user: User.fifth
)
creator_pale_blue_id_balance.save!

transaction_new = Transaction.new(
  tk_amount: 1,
  token: Token.first,
  from_user: User.first,
  to_user: User.fifth
)
transaction_new.save!

puts 'tokens and balances done'

ActiveRecord::Base.logger = Logger.new(STDOUT)

puts 'Generate creator'

application_responses = [
  'Plastic...The ocean is increasingly becoming a plastic soup that is killing
  hundreds of marine animals on a daily basis. Sooner or later, these millions
  of plastic pieces will end up in our stomachs.
  The size of the Great Pacific Garbage Patch ranges between 700,000 square
  kilometers (270,000 square miles) and 15,000,000 square kilometers (5,800,000 square miles).',
  'Trash...The amount of litter left on the beaches or thrown into inland waterways,
  such as rivers and streams, will end up in the ocean. The situation is more
  serious when it comes to non-biodegradable waste, such as plastics, which
  break up into smaller particles - microplastics - and are mistaken for food by many marine species.
  The microplastics present in hygiene products and domestic and industrial
  cleaning products will also have the same destination. The garbage islands
  are already a reality in some areas of the oceans.',
  'Many fertilizers and pesticides used systematically in agriculture end up
  falling into the ocean. Some of these products cause irreversible and fatal
  changes to the species; for example, they affect the reproduction process.
  Also, if ingested by humans, they can cause health issues.'
]

creator = Creator.new(
  title: 'JM Cousteau',
  q1: application_responses.first,
  q2: application_responses.second,
  q3: application_responses.third,
  non_profit: false,
  about: 'I come from a family of oceanographers (my father was the famous deep-sea adventurer, scientist, and
  filmmaker Jacques-Yves Cousteau), so it isn\'t surprising that, in 1990,
  I started the Ocean Futures Society in an effort to educate the public about
  marine conservation. Cousteau is also known for building an eco-oriented
  resort in Fiji and for becoming the first person to represent the
  Environment at an Olympic Games opening ceremony in 2002.',
  location: 'Toulon, France',
  facebook: 'https://www.facebook.com/OceanFuturesSociety',
  twitter: 'https://twitter.com/JMCOUSTEAU',
  instagram: 'https://www.instagram.com/oceanfuturessociety/',
  linkedin: 'https://www.linkedin.com/in/ocean-futures-49402211b',
  website: 'https://www.oceanfutures.org/',
  tag1: 'Global',
  tag2: 'Marine',
  tag3: 'Environment',
  pale_blue: Token.first,
  file_key: Token.third
)

file = URI.open('https://www.fijiresort.com/wp-content/uploads/2018/04/jean-cousteau-michel-diving-2-e1522826162279.jpg')
creator.photo.attach(io: file, filename: "nes.png", content_type: "image/png")
creator.save!
puts 'creator done'

puts 'Create raffle'
raffle = Raffle.new(
  name: 'Trip to Tahiti',
  about: 'This all inclusive trip to tahiti includes all. Includes sailing from anywhere in
  the world to enjoy our warm waters for one month.',
  tag1: 'Global',
  tag2: 'Marine',
  tag3: 'Environment',
  creator: Creator.first,
  token: Token.second,
  metadata: []
)
raffle.save!
puts 'raffle done :) enjoy the game'
