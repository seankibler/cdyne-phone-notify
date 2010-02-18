$:.unshift(File.join(File.dirname(__FILE__), 'phone_notify'))

require 'yaml'
require 'soap/wsdlDriver'
require 'base'
require 'voice'

module PhoneNotify
  class CantConnect < StandardError; end
  class Unavailable < StandardError; end
  class ApiError < StandardError; end
end
