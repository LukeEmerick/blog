json.id post.id
json.published post.created_at.rfc3339
json.updated post.updated_at.rfc3339
json.title post.title
json.content post.content

json.user do
  json.partial! 'users/show', user: post.user
end
