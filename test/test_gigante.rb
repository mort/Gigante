require File.dirname(__FILE__) + '/test_helper.rb'

class TestGigante < Test::Unit::TestCase
  
  context 'Gigante' do

    should 'have a list of available services' do
      assert Gigante::Services::AVAILABLE_SERVICES.is_a?(Array)
    end

  end

  context 'an instance' do
    
    setup do
      @g = Gigante::Search.new
    end
    
    should 'have a list of available services' do
      assert @g.available_services.is_a?(Array)
    end
    
    should 'have a search method' do
      assert @g.respond_to?(:search)
    end
    
  end

  context 'a search with unknown services' do
    setup do
      Gigante::Services::AVAILABLE_SERVICES = %w(oos)
      @g = Gigante::Search.new
    end
    
    should 'raise an UnknownService exception' do
      assert_raise Gigante::UnknownService do
        @lat, @lon, @radius = ['-5.851560', '43.366241', 1]
        @results = @g.search(@lat,@lon,@radius,['wadus'])
      end
    end
    
  end
  

  context 'a search' do
    setup do
      @lat, @lon, @radius = ['-5.851560', '43.366241', 1]
      Gigante::Services::AVAILABLE_SERVICES = %w(oos)
      mock(Gigante::Services::Oos).search(@lat,@lon,@radius) { 'foo' } 
      @g = Gigante::Search.new
      @results = @g.search(@lat,@lon,@radius, ['oos'])
    end
    
    should 'return a hash of results' do
      assert @results.is_a?(Hash)
    end
    
    should 'return a hash indexed by service name' do
      assert @results.keys.include?('oos'.to_sym)
    end
    
    should 'return a hash that contains the results for that service' do
      assert @results['oos'.to_sym] == 'foo', @results['oos'.to_sym]
    end
    
  end
 
end
