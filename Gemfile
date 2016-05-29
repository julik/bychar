source "http://rubygems.org"

group :development do
  gem "rake"
  gem "rdoc", "~> 3.12"
  gem 'test-unit'
  gem "jeweler", '1.8.4'
  
  if RUBY_VERSION < "1.9"
    gem "flexmock", "~> 0.8", :require => %w( flexmock flexmock/test_unit ) # Max. supported on 1.8
  else
    gem "flexmock", "~> 1.3.2", :require => %w( flexmock flexmock/test_unit )
  end
  
end
