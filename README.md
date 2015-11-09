# Toot::Auth

An authentication implementation for the [Toot][1] event dispatch gem.
It uses HTTP Basic auth with Redis as the credential storage medium.
It's just a way to quickly and easily secure your Toot endpoints.

## Usage

`toot-auth` is a really simple authentication solution for the [Toot][1]
gem. Install it just like any other gem (see "Installation" below if you
are unsure) and follow the configuration steps below.

### Configuration

There are two parts to securing your Toot services. One, the remote
calls need to add authentication to the request, and two, the services
need to check for valid authentication in the request.

To solve the first one, you simply need to configure the Username and
Password for your client application using the Toot.config object:

```ruby
Toot.config do |c|
  c.auth_username = "myapp"
  c.auth_password = "secret"
end
```

You then need to apply the client configuration which can be done with a
single method call:

```ruby
Toot::Auth.install_client_auth
```

To install on your services you need to wrap the service Rack apps in a
middleware. The `Toot::Auth` module has a macro for doing this called
`service_wrapper`. So your routes file in your app might look something
like this:

```ruby
match "/subscriptions", to: Toot::Auth.service_wrapper(Toot::SubscriptionsService) via: :post
match "/callbacks", to: Toot::Auth.service_wrapper(Toot::HandlerService), via: :post
```

### Credential Management

There are rake tasks for adding, generating, listing, and removing
credentials from the Redis data store:

```
rake toot:auth:add[username,password]  # Add the specified username and password to the credential store
rake toot:auth:generate[name]          # Generate a new username and password prefixing the username with name
rake toot:auth:list                    # List the usernames added to the credential store
rake toot:auth:remove[username]        # Remove the specified username's credentials from the store
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'toot-auth'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install toot-auth

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/watermarkchurch/toot-auth.

[1]: https://github.com/watermarkchurch/toot
