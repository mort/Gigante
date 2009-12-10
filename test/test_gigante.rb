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
      Gigante::Services::AVAILABLE_SERVICES = %w(flickr)
      @g = Gigante::Search.new
    end
    
    should 'raise an UnknownService exception' do
      assert_raise Gigante::Errors::UnknownService do
        @lat, @lon, @radius = ['-5.851560', '43.366241', 1]
        @results = @g.search(@lat,@lon,@radius,['wadus'])
      end
    end
    
  end
  
  context 'a search without auth credentials for a service' do
    setup do
      Gigante::Services::AVAILABLE_SERVICES = %w(flickr)
      @g = Gigante::Search.new
    end
    
    should 'raise a ServiceAuthMissing exception' do
      assert_raise Gigante::Errors::ServiceAuthMissing do
        @lat, @lon, @radius = ['-5.851560', '43.366241', 1]
        @results = @g.search(@lat,@lon,@radius,['flickr'])
      end
    end
    
  end

  context 'a valid search' do
    setup do
      options = {}
      options[:flickr] = {:auth => 'foo'}
      @lat, @lon, @radius = ['-5.851560', '43.366241', 1]
      Gigante::Services::AVAILABLE_SERVICES = %w(flickr)
      mock(Gigante::Services::Flickr).search(@lat,@lon,@radius, options[:flickr]) { 'foo' } 
      @g = Gigante::Search.new(options)
      @results = @g.search(@lat,@lon,@radius)
    end
    
    should 'return a hash of results' do
      assert @results.is_a?(Hash)
    end
    
    should 'return a hash indexed by service name' do
      assert @results.keys.include?('flickr'.to_sym)
    end
    
    should 'return a hash that contains the results for that service' do
      assert @results['flickr'.to_sym] == 'foo', @results['flickr'.to_sym]
    end
    
  end
 
end
