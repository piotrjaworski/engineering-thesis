FactoryGirl.define do
  factory :user do |u|
    u.sequence(:email) { |n| "foo_#{n}@bar.com"}
    password  "haslo1234"
    password_confirmation "haslo1234"
    u.sequence(:username) { |n| "foo_#{n}bar"}
    full_name "Foo Bar"
  end

  factory :admin, class: User do |u|
    u.sequence(:email) { |n| "admin_#{n}@bar.com"}
    password  "haslo1234"
    password_confirmation "haslo1234"
    u.sequence(:username) { |n| "admin_#{n}bar"}
    full_name "Foo admin"
    role 1
  end
end
