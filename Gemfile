source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.3"

# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails", "~> 5.2.3"
# Use postgresql as the database for Active Record
gem "pg", ">= 0.18", "< 2.0"
# Use Puma as the app server
gem "puma", "~> 3.12", ">= 3.12.1"
# Use SCSS for stylesheets
gem "sassc-rails", "~> 2.1", ">= 2.1.1"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem "mini_racer", platforms: :ruby

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.5"
# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"
# Use ActiveModel has_secure_password
gem "bcrypt", "~> 3.1", ">= 3.1.12"

# Use ActiveStorage variant
# gem "mini_magick", "~> 4.9", ">= 4.9.3"

# Use Capistrano for deployment
# gem "capistrano-rails", group: :development

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.1.0", require: false

# Use slim instead of erb
gem "html2slim", "~> 0.2.0"
gem "slim-rails", "~> 3.2"

# Use jQuery 3 and Bootstrap 4
gem "bootstrap", "~> 4.3", ">= 4.3.1"
gem "jquery-rails", "~> 4.3", ">= 4.3.3"

# Use statefulEnum to handle state of instance
gem "stateful_enum", "~> 0.6.0"

# Use devise for authentication
# gem "devise", "~> 4.6", ">= 4.6.2"
# gem "devise-i18n", "~> 1.8"
# gem "omniauth", "~> 1.9"
# gem "omniauth-twitter", "~> 1.4"
# gem "omniauth-facebook", "~> 5.0"
# gem "omniauth-google-oauth2", "~> 0.6.1"
# gem "omniauth-github", "~> 1.3"
# gem "omniauth-instagram", "~> 1.3"

# Use pagy for pagination
# gem "pagy", "~> 2.1", ">= 2.1.4"

# Use FriendlyId to create pretty URLs
# gem "friendly_id", "~> 5.2", ">= 5.2.5"

# Use rQRCode for endcoding QR Codes of each room"s URL
# gem "rqrcode", "~> 0.10.1"

# Find url and make it link automatically
# gem "rails_autolink", "~> 1.1", ">= 1.1.6"

# Use ransack for use of search function
gem "ransack", "~> 2.1", ">= 2.1.1"

group :development, :test do
  # Call "byebug" anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  # Use dotenv for some secure information
  gem "dotenv-rails", "~> 2.7", ">= 2.7.2"
  # Use factory_bot for generate some test data
  gem "factory_bot_rails", "~> 5.0", ">= 5.0.2"
  # Use RuboCop for code style checking
  gem "rubocop", "~> 0.71.0", require: false
  gem "rubocop-performance", "~> 1.3", require: false
  gem "rubocop-rails", "~> 2.0", require: false
  gem "rubocop-rspec", "~> 1.33", require: false
end

group :development do
  # Access an interactive console on exception pages or by calling "console" anywhere in the code.
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "web-console", ">= 3.3.0"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  # Use RSpec and Capybara with Headless Chrome
  gem "capybara", "~> 3.22"
  gem "rspec-rails", "~> 3.8", ">= 3.8.2"
  gem "selenium-webdriver", "~> 3.142", ">= 3.142.3"
  gem "webdrivers", "~> 4.0"
end
