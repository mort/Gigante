$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Gigante
  VERSION = '0.0.1'

  class ServiceNotImplemented < StandardError; end
  class ServiceBadlyImplemented < StandardError; end
  class UnknownService < StandardError; end
    
  require 'gigante/services'
  require 'gigante/search'
  
  
end