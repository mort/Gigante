module Gigante
  module Services
    AVAILABLE_SERVICES = %w(flickr wikipedia)
    
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
    

    AVAILABLE_SERVICES.each do |s|
      require File.dirname(__FILE__) + "/services/#{s}.rb"
    end
  
    class Oos
      include ClassMethods
      
      AUTH_REQUIRED = true
      
      def self.search(lat, lon, radius, options = {}) 
      end
    end
        
    class Yelp
      def self.search(lat, lon, radius) 
      end
    end
    

  
  end
  
end


