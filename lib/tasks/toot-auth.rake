namespace :toot do
  namespace :auth do

    desc "Add the specified username and password to the credential store"
    task :add, [:username, :password] => :environment do |t, args|
      creds = Toot::Auth::Credentials.new(args[:username], args[:password])
      Toot::Auth::AddsCredentials.(credentials: creds)
    end

    desc "Remove the specified username's credentials from the store"
    task :remove, [:username] => :environment do |t, args|
      Toot::Auth::RemovesCredentials.(username: args[:username])
    end

    desc "Generate a new username and password prefixing the username with name"
    task :generate, [:name] => :environment do |t, args|
      creds = Toot::Auth::GeneratesCredentials.(name: args[:name])
      Toot::Auth::AddsCredentials.(credentials: creds)
      puts "Username: #{creds.username}"
      puts "Password: #{creds.password}"
    end

    desc "List the usernames added to the credential store"
    task :list => :environment do |t, args|
      p Toot::Auth::ListsCredentials.()
    end

  end
end
