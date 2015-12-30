FactoryGirl.define do
  factory :topic do
    name "Topic"
    description "Desc"
    association :category
    association :user
    before(:create) do |t|
      user = create(:user)
      t.posts.new(content: "content", user_id: user.id)
    end
  end
end
