password = "haslo1234"
#Admin user
if u = User.create(email: "piotr.jaworski@live.com", password: password, password_confirmation: password, role: 1)
  puts "Admin user #{u.email} has been created!"
end

1.upto(2) do |i|
  Category.create(name: "Category #{i}")
end

u = User.first

1.upto(100) do |i|
  t = Topic.new(name: "Topic #{i}", description: "It's topic no. #{i}", creator_id: u.id, category_id: Category.last.id)
  t.save
  1.upto(25) do |j|
    Post.create(content: "This is a sample post with a sample content. It's no. is #{j}", topic_id: t.id, user_id: u.id)
  end
end
