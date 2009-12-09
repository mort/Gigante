require 'rubygems'
require 'json'
require 'httparty'

api_key = '842ff12e5390937328913c5a8ee05fb8'
lat = '51.500915'
lon = '-0.122405' 
radius = 1

# http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=59d6ebde65831338512fa9254d0c8157&lat=-5&lon=43&radius=1&auth_token=72157622919132130-57bcdd2cba705035&api_sig=312b0f439f9a4f5b571d446d62b0abea
url = "http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=#{api_key}&lat=#{lat}&lon=#{lon}&radius=#{radius}&extras=geo&format=json&nojsoncallback=1"
response = HTTParty.get(url)
puts response
puts "=================="
puts JSON.parse(response).inspect