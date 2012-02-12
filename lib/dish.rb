require "httparty"
Dir[File.dirname(__FILE__) + '/dish/*.rb'].each do |file|
  require file
end