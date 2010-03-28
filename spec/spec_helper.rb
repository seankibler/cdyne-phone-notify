Spec::Runner.configure do |config|
  config.mock_with :mocha
end

require 'mocha'
require 'ruby-debug'
require File.expand_path(File.dirname(__FILE__) + '/../lib/phone_notify')