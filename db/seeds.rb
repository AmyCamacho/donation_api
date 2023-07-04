3.times do
  user = User.create!(email: Faker::Internet.email, password: 'locadex1234')
  puts "Created a new user: #{user.email}"

  2.times do
    donation = Donation.create!(
      amount: rand(1.0..100.0),
      payment_method: rand(1..3),
      email: user.email,
      user_agent: Faker::Internet.user_agent,
      ip_address: Faker::Internet.ip_v4_address,
      user_id: user.id
    )
    puts "Created a brand new donation with amount #{donation.amount}"
  end
end