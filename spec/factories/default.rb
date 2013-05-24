FactoryGirl.define do
  factory :episode do
    sequence(:title) { |n| "##{n}: Topic" }
    state :unpublished
  end
end
