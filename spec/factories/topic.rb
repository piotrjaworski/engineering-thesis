FactoryGirl.define do
  factory :topic do
    name "Topic"
    description "Desc"
    association :category
    association :user
    after(:create) do |t|
      user = create(:user)
      t.posts.create(content: "content", user_id: user.id)
    end
  end
end
