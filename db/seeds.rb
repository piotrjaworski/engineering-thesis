password = "haslo1234"
if User.create(email: "piotr.jaworski@live.com",
               password: password,
               password_confirmation: password,
               role: 1,
               full_name: "Piotr Jaworski",
               username: "pjaworski")
  puts "Admin user has been created!"
else
  "Cannot create admin user"
end

1.upto(3) { Category.create(name: Faker::Lorem.word) }


1.upto(40) do |i|
  if User.create(full_name: Faker::Name.name, username: Faker::Name.name, email: Faker::Internet.email, password: password, password_confirmation: password)
    puts "User #{i} has been created!"
  end
end

1.upto(100) do |i|
  t = Topic.new(name: Faker::Lorem.sentence, description: "It's topic no. #{i}", creator_id: User.all.sample.id, category_id: Category.all.sample.id)
  t.posts.new(content: Faker::Lorem.paragraph, user_id: User.all.sample.id)
  if t.save
    puts "Topic #{i} has been created!"
    1.upto(25) { |j| Post.create(content: Faker::Lorem.paragraph, topic_id: t.id, user_id: User.all.sample.id) }
  end
end
puts "Topics and posts have been created"
puts "Seed run successfully!"
