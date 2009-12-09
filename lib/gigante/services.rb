module Gigante
  module Services
    AVAILABLE_SERVICES = %w(flickr wikipedia yelp)
    
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
          
  end
  
end


