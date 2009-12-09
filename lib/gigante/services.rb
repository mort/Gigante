module Gigante
  module Services
    AVAILABLE_SERVICES = %w(oos flickr)
    
    module ClassMethods
    
      @@parent = nil
      
      def auth_required?
        @@parent::AUTH_REQUIRED
      end
        
      def no_auth_required?
        !auth_required?
      end
  

      def self.included(base)
        base.extend(ClassMethods)
        @@parent = base
      end
    end
    
    class Flickr
      include ClassMethods

      AUTH_REQUIRED = true
      
      SERVICE_NAME = 'Flickr'
      SERVICE_URL  = 'http://flickr.com'
      SERVICE_API_URL = 'http://www.flickr.com/services/api/'

      def self.search(lat, lon, radius, options) 

        auth = options.delete(:auth)
        raise Gigante::Errors::ServiceForbidden, "You must supply a Flickr API key via the auth hash" unless (auth and auth[:api_key])

        api_key = auth.delete(:api_key)

        query_string = build_query_string(api_key, lat, lon, radius)

        url = "http://api.flickr.com/services/rest/?#{query_string}"
        response = HTTParty.get(url)

        results = build_results(response)
        
        results

      end

      private

      def self.build_query_string(api_key, lat, lon, radius)
         query_params = {}
          query_params[:method] = 'flickr.photos.search'
          query_params[:api_key] = api_key
          query_params[:lat] = lat
          query_params[:lon] = lon
          query_params[:radius] = radius
          query_params[:extras] = 'geo'
          query_params[:format] = 'json'
          query_params[:nojsoncallback] = 1

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
        
        results[:search][:status] = 'ok'
        
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
          
          node[:url] = "http://farm#{farm_id}.static.flickr.com/#{server_id}/#{id}_#{secret}.jpg"
          
          results[:search][:results].push(node)
          
        end
        
        return results.to_json
        
        
      end
      
      
    end
  
  
  
    class Oos
      include ClassMethods
      
      def self.search(lat, lon, radius, options = {}) 
      end
    end
        
    class Yelp
      def self.search(lat, lon, radius) 
      end
    end
    
    class Wikipedia
      def self.search(lat, lon, radius) 
      end
    end
  
  end
  
end


