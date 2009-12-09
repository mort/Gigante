require 'rubygems'
require 'httparty'
require 'json'

lat = '51.500915'
lon = '-0.122405' 
radius = 1

url = "http://ws.geonames.org/findNearbyWikipedia?lat=#{lat}&lng=#{lon}&radius=#{radius}"
response = HTTParty.get(url)
puts response.body
#reader = Nokogiri::XML::Reader(response)

#reader.each do |node|
 # puts node.name
#end
