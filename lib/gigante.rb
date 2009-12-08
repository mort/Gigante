$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Gigante
  VERSION = '0.0.1'

  module Errors
    class ServiceNotImplemented < StandardError; end
    class ServiceBadlyImplemented < StandardError; end
    class UnknownService < StandardError; end
    class ServiceAuthMissing < StandardError; end
    class ServiceForbidden < StandardError; end
  end  
    
  require 'gigante/services'
  require 'gigante/search'
  
  
end