module Gigante
  module Services
    AVAILABLE_SERVICES = %w(oos flickr)
    
    module ClassMethods
    
      def auth_required?
        puts self.class
      end
        
      def no_auth_required?
        !auth_required?
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
    
  
    class Oos
      def self.search(lat, lon, radius) 
      end
    end
    
    class Flickr
      include ClassMethods
      
      @@auth_required = true
      
      def self.search(lat, lon, radius) 
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


