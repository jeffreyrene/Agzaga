source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.8'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.0'
# Use pg as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# gem 'searchkick'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# E-commerce
gem 'solidus'
gem 'solidus_stripe', '~> 3.0'
gem 'fog-aws'
gem 'solidus_volume_pricing', '~> 1.0'
gem 'solidus_paypal_commerce_platform'

gem 'omniauth'
gem 'omniauth-google-oauth2'
gem "omniauth-rails_csrf_protection", "~> 1.0"

gem 'algoliasearch-rails'
gem 'order_as_specified'
gem 'devise', '~> 4.8.1'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false
gem 'gibbon'
gem 'mandrill-api'
gem 'solidus_importer'
gem 'solidus_reviews', github: 'solidusio-contrib/solidus_reviews'
gem 'solidus_favorites', github: 'magma-labs/solidus_favorites'
gem 'solidus_sale_prices', github: 'solidusio-contrib/solidus_sale_prices'

gem 'solidus_tax_cloud'
gem 'sidekiq'
gem 'sidekiq-scheduler'

gem 'solidus_affirm_v2', github: 'solidusio-contrib/solidus_affirm_v2'
# editor
gem 'solidus_editor', github: 'solidusio-contrib/solidus_editor', branch: 'master'

gem 'wicked'
gem 'hellosign-ruby-sdk'
gem 'affirm'

gem "scenic"
gem 'google-apis-indexing_v3'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem "letter_opener"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'dotenv-rails'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'solidus_auth_devise'

gem "sentry-ruby"
gem "sentry-rails"

gem 'solidus_sitemap', github: 'solidusio-contrib/solidus_sitemap'

# touched on 2025-05-22T20:44:32.255384Z
# touched on 2025-05-22T22:32:10.060077Z
