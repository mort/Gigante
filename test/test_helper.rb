require 'rubygems'
require 'stringio'
require 'test/unit'
require 'shoulda'
require 'rr'
require 'fakeweb'
require File.dirname(__FILE__) + '/../lib/gigante'

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
end