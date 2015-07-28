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

1.upto(2) { |i| Category.create(name: "Category #{i}") }

u = User.first

if u.persisted?
  1.upto(100) do |i|
    t = Topic.new(name: "Topic #{i}", description: "It's topic no. #{i}", creator_id: u.id, category_id: Category.last.id)
    t.save
    1.upto(25) { |j| Post.create(content: "This is a sample post with a sample content. It's no. is #{j}", topic_id: t.id, user_id: u.id) }
  end
end

puts "Seed run successfully!"
