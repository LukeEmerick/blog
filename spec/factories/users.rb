FactoryBot.define do
  factory :user do
    displayName { 'Joe' }
    image { 'http://4.bp.blogspot.com/_YA50adQ-7vQ/S1gfR_6ufpI/AAAAAAAAAAk/1ErJGgRWZDg/S45/brett.png' }
    password_digest { 'test1234' }
    sequence(:email) { |n| "#{displayName}_#{n}@example.com" }
  end
end
