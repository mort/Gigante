require 'rubygems'
require 'httparty'
require 'json'

api_key = 'ZPJ11diDtP2Bob2AhVvhtQ'
lat = '51.500915'
lon = '-0.122405' 
radius = 1


url = "http://api.yelp.com/business_review_search?term=yelp&lat=#{lat}&long=#{lon}&radius=#{radius}&num_biz_requested=5&ywsid=#{api_key}"

response = HTTParty.get(url)

puts response.body