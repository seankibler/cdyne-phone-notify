require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('cdyne-phone-notify', '0.2.1') do |p|
	p.description 							= 'Connector for the CDYNE PhoneNotify API.'
	p.url												= 'http://github.com/skibler/cdyne-phone-notify'
	p.author										= 'Sean Kibler'
	p.email											= 'seankibler@skiblerspot.net'
	p.ignore_pattern						= ['tmp/*', 'script/* nbproject']
	p.development_dependencies	= []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each{ |ext| load ext }
