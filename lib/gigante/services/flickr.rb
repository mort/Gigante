module Gigante
  module Services
    class Flickr
      include ClassMethods
      require 'rubygems'
      require 'base58'

      AUTH_REQUIRED = true
      
      REQUIRED_AUTH_PARAMS = %w(api_key)
      
      SERVICE_NAME = 'Flickr'
      SERVICE_URL  = 'http://flickr.com'
      SERVICE_API_URL = 'http://www.flickr.com/services/api/'
      SERVICE_DESCRIPTION = 'Almost certainly the best online photo management and sharing application in the world'

      def self.query(lat, lon, radius, options) 

        auth = options[:auth]
        raise Gigante::Errors::ServiceForbidden, "You must supply a Flickr API key via the auth hash" unless (auth and auth[:api_key])

        api_key = auth[:api_key]

        query_string = build_query_string(api_key, lat, lon, radius, options[:query])

        puts url = "http://api.flickr.com/services/rest/?#{query_string}"
        response = HTTParty.get(url)

        results = build_results(response)
    
        results

      end

      private

      def self.build_query_string(api_key, lat, lon, radius, options = nil)
        
        radius = 32 if (radius.to_f > 32.0)
        
        query_params = {}
        query_params[:method] = 'flickr.photos.search'
        query_params[:api_key] = api_key
        #query_params[:lat] = lat
        #query_params[:lon] = lon
        #query_params[:radius] = radius
        query_params[:extras] = 'geo'
        query_params[:format] = 'json'
        query_params[:nojsoncallback] = 1
          
        query_params.merge!(options) if options.is_a?(Hash)
          
        query_string = query_params.map do |k,v|
          "#{k}=#{v}"
        end.sort.join('&')

        query_string
      
      end
  
      def self.build_results(response)
    
        r = JSON.parse(response)

        results = {}
        results[:meta] = {}
        results[:search] = {}
    
        results[:meta][:service_name]    = SERVICE_NAME
        results[:meta][:service_url]     = SERVICE_URL
        results[:meta][:service_api_url] = SERVICE_API_URL
        results[:meta][:service_description] = SERVICE_DESCRIPTION
    
        results[:search][:status] = 'ok'
    
        results[:search][:total_results] = 0
    
        results[:search][:total_results] = r['photos']['total']
        results[:search][:results] = []
    
        r['photos']['photo'].each do |photo|
          node = {}
          node[:lat] = photo['latitude']
          node[:lon] = photo['longitude']
          node[:title] = photo['title']
      
          farm_id = photo['farm']
          server_id = photo['server']
          id = photo['id']
          secret = photo['secret']
      
          #node[:url] = "http://farm#{farm_id}.static.flickr.com/#{server_id}/#{id}_#{secret}.jpg"
          node[:url] = "http://flic.kr/p/#{Base58.int_to_base58(id.to_i)}"
          results[:search][:results].push(node)
      
        end
        
        return results
    
    
      end
  
    end
  end
end