module Gigante
  class Search
    
    attr_reader :available_services
    
    def initialize
            
      @available_services = Gigante::Services::AVAILABLE_SERVICES
      
      @available_services.each do |s|
        raise ServiceNotImplemented unless Gigante::Services.constants.include?(s.capitalize)
        raise ServiceBadlyImplemented, "#{s.capitalize} lacks a search method" unless Gigante::Services.const_get(s.capitalize).respond_to?(:search)
      end
      
    end
    
    def search(lat = '-5.851560', lon = '43.366241', radius = 1, services = [], *options)
      @results = {}
      services = services.any? ? services : @available_services
      
      services.each do |s|
        raise UnknownService, "Service #{s} is unknown" unless @available_services.include?(s)
      end
      
      services.each do |s|
        results = Gigante::Services.const_get(s.capitalize).search(lat, lon, radius)
        @results[s.to_sym] = results
      end
      
      @results

    end
  end
end