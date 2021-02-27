FactoryBot.define do
  factory :post do
    title { 'Latest updates, August 1st' }
    content { 'The whole text for the blog post goes here in this key' }
    user
    published_at { Time.zone.now }
  end
end
