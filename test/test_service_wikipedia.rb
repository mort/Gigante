require File.dirname(__FILE__) + '/test_helper.rb'

class TestServiceWikipedia < Test::Unit::TestCase
  require 'crack'
  
  context 'a valid search' do
    setup do
      
      response = Crack::XML.parse(File.read(File.dirname(__FILE__)+'/fixtures/wikipedia_response.txt'))
      @lat, @lon, @radius = ['-5.851560', '43.366241', 1]
      url = "http://ws.geonames.org/findNearbyWikipedia?lat=#{@lat}&lng=#{@lon}&radius=#{@radius}"
      mock(HTTParty).get(url){response}
      @results = Gigante::Services::Wikipedia.search(@lat, @lon, @radius)
      @r = JSON.parse(@results)
    end

    should 'return results' do
      assert !@results.nil?
    end
    
    should 'return a hash' do
      assert @r.is_a?(Hash)
    end
    
    should 'have a meta key' do
      assert @r['meta']
    end
    
    should 'have a meta/service name key' do
      assert @r['meta']['service_name']
    end
    
    should 'have a meta/service description key' do
      assert @r['meta']['service_description']
    end
    
    should 'have a meta/service url key' do
      assert @r['meta']['service_url']
    end

    should 'have a meta/service api url key' do
      assert @r['meta']['service_api_url']
    end

    should 'have a search key' do
      assert @r['search']
    end
    
    should 'have a search status key' do
      assert @r['search']['status']
    end
    
    should 'have a search/results key' do
      assert @r['search']['results']
    end
    
    should 'have an array of results' do
      assert @r['search']['results'].is_a?(Array)
    end
    
    should 'have a number of results' do
      assert @r['search']['results'].size > 0
    end
    
    should 'have a valid result counter' do
      assert @r['search']['total_results'].to_i == @r['search']['results'].size
    end
    
    context 'each result' do
      setup do
        @result = @r['search']['results'].first
      end
      
      should 'be a hash' do
        assert @result.is_a?(Hash)
      end

      should 'have a title key' do
        assert @result['title']
      end
      
      should 'have a url key' do
        assert @result['url']
      end
      
      should 'have a lat key' do
        assert @result['lat']
      end
      
      should 'have a lon key' do
        assert @result['lon']
      end
      
    end
    
    
  end
  
  
end