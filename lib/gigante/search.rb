require 'json'
require 'httparty'

module Gigante
  class Search
    attr_reader :available_services, :options
    
    def initialize(options = {})
        
      @options = options      
      @available_services = Gigante::Services::AVAILABLE_SERVICES
      
      @available_services.each do |s|
        raise Gigante::Errors::ServiceNotImplemented unless Gigante::Services.constants.include?(s.capitalize)
        raise Gigante::Errors::ServiceBadlyImplemented, "#{s.capitalize} lacks a find method" unless Gigante::Services.const_get(s.capitalize).respond_to?(:find)
      end
      
    end
    
    def self.available_services
      Gigante::Services::AVAILABLE_SERVICES.sort
    end
    
    def self.requires_auth?(service)
      the_service =  Gigante::Services.const_get(service.capitalize)
      the_service::AUTH_REQUIRED
    end
    
    def self.required_auth_params(service)
      the_service =  Gigante::Services.const_get(service.capitalize)
      the_service::REQUIRED_AUTH_PARAMS
    end
    
    def find(lat = '-5.851560', lon = '43.366241', radius = 1, services = nil, *options)
      @results = {}
      services ||= @available_services
      
      services.each do |s|
        raise Gigante::Errors::UnknownService, "Service #{s} is unknown" unless @available_services.include?(s)
      end
      
      
      services.each do |s|
        
        options = @options.delete(s.to_sym)
        
        the_service =  Gigante::Services.const_get(s.capitalize)
        
        raise Gigante::Errors::ServiceAuthMissing, "#{s.capitalize} requires authorization, but none provided" unless ((options and options[:auth]) or (the_service::AUTH_REQUIRED == false))
        
        results = the_service.find(lat, lon, radius, options)
        @results[s.to_sym] = results
      end
      
      @results.to_json

    end
    
  end
end