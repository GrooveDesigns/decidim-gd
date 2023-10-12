# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gem "decidim", "0.26.2"
gem "decidim-decidim_awesome", "~> 0.8.0"
# gem "decidim-conferences", "0.24.3"
# gem "decidim-consultations", "0.24.3"
# gem "decidim-elections", "0.24.3"
# gem "decidim-initiatives", "0.24.3"
# gem "decidim-templates", "0.24.3"

gem "bootsnap", "~> 1.3"

gem "puma", ">= 5.5.1"
gem "uglifier", "~> 4.1"

gem "faker", "~> 2.14"

gem "wicked_pdf", "~> 2.1"

gem "sidekiq"
gem 'redis-namespace'
gem "fog-aws"
gem 'aws-sdk-s3'
gem "nokogiri", ">= 1.11.7"
gem 'newrelic_rpm'

gem 'dotenv-rails', groups: [:development, :test]

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", "0.26.2"
  gem 'rspec-rails'
  gem 'factory_bot_rails'
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"
end
