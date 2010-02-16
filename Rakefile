require 'rubygems'
require 'rake'
begin
	require 'echoe'
rescue LoadError => pow
	puts "Missing a dependency required for meta-operations on this gem."
	puts "#{pow.to_s.capitalize}"

	desc 'No effect.'
	task :default do; end

	# allow running tests without Echo
	desc 'Run test suite.'
	task :test do
		puts "No testing available yet."
	end
end

Echoe.new('cdyne-phone-notify', '0.7.1') do |p|
	p.author										= 'Sean Kibler'
	p.email											= 'seankibler@skiblerspot.net'
	p.description 							= 'Connector for the CDYNE PhoneNotify API.'
	p.url												= 'http://github.com/skibler/cdyne-phone-notify'
	p.ignore_pattern						= /(nbproject|tmp|script)/
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each{ |ext| load ext }
