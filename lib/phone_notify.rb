require 'soap/wsdlDriver'
require 'yaml'

$:.unshift(File.dirname(__FILE__) + "/phone_notify")
require 'base.rb'

module PhoneNotify
  class CantConnect < StandardError; end
  class Unavailable < StandardError; end
  class ApiError < StandardError; end
end
