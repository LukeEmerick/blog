json.array! @users do |user|
  json.call(user, :id, :displayName, :email, :image)
end
