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
        raise Gigante::Errors::ServiceBadlyImplemented, "#{s.capitalize} lacks a find method" unless Gigante::Services.const_get(s.capitalize).respond_to?(:query)
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
    
    def query(lat = '-5.851560', lon = '43.366241', radius = 1, services = nil, *options)
      @results = {}
      @results[:meta] = {}
      @results[:meta][:parameters] = {:lat => lat, :lon => lon, :radius => radius}
      @results[:meta][:total_results] = 0
      @results[:results] = {}
      
      services ||= @available_services
      
      services.each do |s|
        raise Gigante::Errors::UnknownService, "Service #{s} is unknown" unless @available_services.include?(s)
      end
      
      services.each do |s|
        options = @options[s.to_sym]
        
        the_service =  Gigante::Services.const_get(s.capitalize)
        raise Gigante::Errors::ServiceAuthMissing, "#{s.capitalize} requires authorization, but none provided" unless ((options and options[:auth]) or (the_service::AUTH_REQUIRED == false))
        results = the_service.query(lat, lon, radius, options)
        @results[:results][s.to_sym] = results
        @results[:meta][:total_results] += results[:search][:total_results].to_i unless (results[:search].nil? || results[:search][:total_results].nil?)
      end
            
      return @results      
      
    end
    
  end
end