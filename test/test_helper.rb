require 'stringio'
require 'test/unit'
require 'shoulda'
require 'rr'
require File.dirname(__FILE__) + '/../lib/gigante'

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
end