json.id post.id
json.published post.created_at.as_json
json.updated post.updated_at.as_json
json.title post.title
json.content post.content

json.user do
  json.partial! 'users/show', user: post.user
end
