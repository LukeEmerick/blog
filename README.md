# Blog

A simple api blog project to manage users and posts

### Prerequisites

* [ruby-3.0](https://www.ruby-lang.org/en/documentation/installation/)
* [bundler-2.2.3](https://bundler.io/)
* [postgres](https://computingforgeeks.com/how-to-install-postgresql-13-on-ubuntu)


### Installing

Install gems

```shell
$ bundle install
```

Create database

```shell
rails db:create
```

Run migrations

```shell
rails db:migrate
```

Make sure postgres is running, if your Linux distribution uses systemd, you can use:

```shell
systemctl status postgresql
```

If you need it, restart

```shell
systemctl restart postgresql
```

Run server

```shell
rails s
```
after this you can send your rest requests to `http://localhost:3000/`

## Examples

Create user
```shell
curl --location --request POST 'http://localhost:3000/user' \
--header 'Content-Type: application/json' \
--data-raw '{
    "email": "asome@email.com",
    "displayName": "Namest Name",
    "password": "some password"
}'
```

Create post, use the received token on the authorization header
```shell
curl --location --request POST 'localhost:3000/post' \
--header 'Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMSwiZXhwIjoxNjE0NzM0MDMzfQ.7e5LYnglYKrJS0RrqmSaoaXTIZ4JZsaNj1vaUh_JNLY' \
--header 'Content-Type: application/json' \
--data-raw '{
    "title": "A good title",
    "content": "Some content"
}'
```

## Running tests

```shell
bundle exec rspec
```
