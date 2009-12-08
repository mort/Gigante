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

      def self.search(lat, lon, radius, options) 

        auth = options.delete(:auth)
        raise Gigante::Errors::ServiceForbidden, "You must supply a Flickr API key via the auth hash" unless (auth and auth[:api_key])

        api_key = auth.delete(:api_key)

        query_string = build_query_string(api_key, lat, lon, radius)

        url = "http://api.flickr.com/services/rest/?#{query_string}"
        response = HTTParty.get(url)

        return response

      end

      private

      def build_query_string(api_key, lat, lon, radius)
         query_params = {}
          query_params[:method] = 'flickr.photos.search'
          query_params[:api_key] = api_key
          query_params[:lat] = lat
          query_params[:lon] = lon
          query_params[:radius] = radius
          query_params[:extras] = 'geo'
          query_params[:format] = 'json'
          query_params[:nojsoncallback] = 1

          query_string = ''

          query_params.each_pair do |k,v|
            query_string << "#{k}=#{v}"
          end

          query_string
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


