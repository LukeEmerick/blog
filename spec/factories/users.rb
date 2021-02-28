FactoryBot.define do
  factory :user do
    displayName { 'rubens silva' }
    image { 'http://4.bp.blogspot.com/_YA50adQ-7vQ/S1gfR_6ufpI/AAAAAAAAAAk/1ErJGgRWZDg/S45/brett.png' }
    password { 'test1234' }
    sequence(:email) { |n| "user_#{n}@example.com" }
  end
end
