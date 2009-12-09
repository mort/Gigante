module Gigante
  module Services
   class Yelp
      include ClassMethods

       AUTH_REQUIRED = true

       SERVICE_NAME = 'Yelp'
       SERVICE_URL  = 'http://yelp.com'
       SERVICE_API_URL = 'http://www.yelp.com/developers/documentation/search_api'
       SERVICE_DESCRIPTION = 'Real people. Real reviews.'

       def self.search(lat, lon, radius, options)
         auth = options.delete(:auth)
         raise Gigante::Errors::ServiceForbidden, "You must supply a Yelp API key via the auth hash" unless (auth and auth[:api_key])
         api_key = auth.delete(:api_key)
         
         url = "http://api.yelp.com/business_review_search?term=yelp&lat=#{lat}&long=#{lon}&radius=#{radius}&num_biz_requested=20&ywsid=#{api_key}"
         response = HTTParty.get(url)
         results = build_results(response)
       end
       
       private
       
       def self.build_results(response)
         r = JSON.parse(response)
         results = {}
         results[:meta] = {}
         results[:search] = {}

         results[:meta][:service_name]        = SERVICE_NAME
         results[:meta][:service_url]         = SERVICE_URL
         results[:meta][:service_api_url]     = SERVICE_API_URL
         results[:meta][:service_description] = SERVICE_DESCRIPTION

         results[:search][:status] = 'ok'

         results[:search][:total_results] = r['businesses'].size
         results[:search][:results] = []

         r['businesses'].each do |b|
           node = {}
           node[:lat]   = b['latitude']
           node[:lon]   = b['longitude']
           node[:title] = b['name']
           node[:url]   = b['url']

           results[:search][:results].push(node)

         end

         return results.to_json
       end
    end
  end
end