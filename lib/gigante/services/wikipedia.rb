module Gigante
  module Services
    class Wikipedia
      include ClassMethods
        
      AUTH_REQUIRED = false
  
      SERVICE_NAME = 'Wikipedia'
      SERVICE_URL  = 'http://wikipedia.org'
      SERVICE_API_URL = 'http://www.geonames.org/export/wikipedia-webservice.html'
      SERVICE_DESCRIPTION = 'The free encyclopedia that anyone can edit.'

      def self.search(lat, lon, radius, options = {}) 
        url = "http://ws.geonames.org/findNearbyWikipedia?lat=#{lat}&lng=#{lon}&radius=#{radius}"
        response = HTTParty.get(url)

        results = build_results(response)

        return results
      end
  
      private 
  
        def self.build_results(response)

          results = {}
          results[:meta] = {}
          results[:search] = {}

          results[:meta][:service_name]    = SERVICE_NAME
          results[:meta][:service_url]     = SERVICE_URL
          results[:meta][:service_api_url] = SERVICE_API_URL
          results[:meta][:service_description] = SERVICE_DESCRIPTION

          results[:search][:status] = 'ok'

          results[:search][:total_results] = response['geonames']['entry'].size
          results[:search][:results] = []

          response['geonames']['entry'].each do |e|
          
            node = {}
            node[:lat]   = e['lat']
            node[:lon]   = e['lng']
            node[:title] = e['title']
            node[:url]   = e['wikipediaUrl']
          
            results[:search][:results].push(node)
          end

          return results.to_json


        end
    end
  end
end