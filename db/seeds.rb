password = "haslo1234"
#Admin user
if u = User.create(email: "piotr.jaworski@live.com", password: password, password_confirmation: password, role: 1)
  puts "Admin user #{u.email} has been created!"
end
