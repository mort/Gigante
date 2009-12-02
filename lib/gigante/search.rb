module Gigante
  class Search
    
    attr_reader :available_services, :options
    
    def initialize(*options)
        
      @options = options      
      @available_services = Gigante::Services::AVAILABLE_SERVICES
      
      @available_services.each do |s|
        raise ServiceNotImplemented unless Gigante::Services.constants.include?(s.capitalize)
        raise ServiceBadlyImplemented, "#{s.capitalize} lacks a search method" unless Gigante::Services.const_get(s.capitalize).respond_to?(:search)
      end
      
    end
    
    def search(lat = '-5.851560', lon = '43.366241', radius = 1, services = nil, *options)
      @results = {}
      services ||= @available_services
      
      services.each do |s|
        raise UnknownService, "Service #{s} is unknown" unless @available_services.include?(s)
      end
      
      
      services.each do |s|
        the_service =  Gigante::Services.const_get(s.capitalize)
        
        raise AuthMissing, "#{s.capitalize} requires authorization, but none provided" unless (auth_provided_for?(s) || the_service.no_auth_required?)
        
        results = the_service.search(lat, lon, radius)
        @results[s.to_sym] = results
      end
      
      @results

    end
    
    
    private
    
    def auth_provided_for?(s)
      (@options[:auth] && @options[:auth].has_key?(s.to_sym))
    end
    
  end
end