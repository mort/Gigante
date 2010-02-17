require File.dirname(__FILE__) + '/test_helper.rb'

class TestGigante < Test::Unit::TestCase
  
  context 'Gigante' do

    should 'have a list of available services' do
      Gigante::Services::AVAILABLE_SERVICES = %w(flickr wikipedia)
      
      assert Gigante::Search.available_services ==  %w(flickr wikipedia)
    end
    
    should 'tell which services need auth' do
      Gigante::Services::Flickr::AUTH_REQUIRED = true

      assert Gigante::Search.requires_auth?('flickr') == true
    end

    should 'tell which auth params are required for a service' do
      Gigante::Services::Oos::REQUIRED_AUTH_PARAMS = %(app_key app_secret)

      assert Gigante::Search.required_auth_params('oos') == %(app_key app_secret)
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
      assert @g.respond_to?(:find)
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
        @results = @g.find(@lat,@lon,@radius,['wadus'])
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
        @results = @g.find(@lat,@lon,@radius,['flickr'])
      end
    end
    
  end

  context 'a valid search across all services' do
    setup do
      options = {}
      options[:flickr] = {:auth => 'foo'}
      @lat, @lon, @radius = ['-5.851560', '43.366241', 1]
      Gigante::Services::AVAILABLE_SERVICES = %w(flickr)
      mock(Gigante::Services::Flickr).find(@lat,@lon,@radius, options[:flickr]) { 'foo' } 
      @g = Gigante::Search.new(options)
      @results = @g.find(@lat,@lon,@radius)
    end
    
    
    should 'be a hash' do
      assert @results.is_a?(Hash)
    end
    
    should 'return info about the search' do
      assert @results.keys.include?(:meta)
    end
    
    should 'return search results' do
      assert @results.keys.include?(:results)
    end
    
    should 'return coordinates and radius' do
      assert @results[:meta][:parameters] ==  {:lat => '-5.851560', :lon => '43.366241', :radius => 1}, @results[:meta].inspect
    end

    should 'be indexed by service name' do
      assert @results[:results].keys.include?(:flickr), @results.inspect
    end

    should 'return a hash that contains the results for that service' do
      assert @results[:results][:flickr] == 'foo', @results.inspect
    end

  end
  
  context 'two consecutive valid searches' do
   setup do
     options = {}
     options[:flickr] = {:auth => 'foo'}
     @lat, @lon, @radius = ['-5.851560', '43.366241', 1]
     Gigante::Services::AVAILABLE_SERVICES = %w(flickr)
     mock(Gigante::Services::Flickr).find(@lat,@lon,@radius, options[:flickr]) { 'foo' }.twice 
     @g = Gigante::Search.new(options)
     2.times { @results = @g.find(@lat,@lon,@radius) }
   end


   should 'be a hash the second time' do
     assert @results.is_a?(Hash)
   end

  end
     
 
end
