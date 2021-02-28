json.array! @posts do |post|
  json.partial! 'posts/show', post: post
end
