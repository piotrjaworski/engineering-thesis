FactoryGirl.define do
  factory :topic do
    name "Topic"
    description  "Desc"
    association :category
  end
end
