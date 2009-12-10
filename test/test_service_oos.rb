require File.dirname(__FILE__) + '/test_helper.rb'

class TestServiceOos < Test::Unit::TestCase
  
  context 'a search without an app key or secret' do

    should 'raise an exception' do
      assert_raise Gigante::Errors::ServiceForbidden do
        @lat, @lon, @radius = ['-5.851560', '43.366241', 1]
        Gigante::Services::Oos.search(@lat,@lon,@radius,{})
      end
    end
  
  end
  
  # context 'a valid search without results' do
  #     setup do
  #       
  #       response = File.read(File.dirname(__FILE__)+'/fixtures/oos_response_no_results.txt')
  #         
  #       @lat, @lon, @radius = ['-5.851560', '43.366241', 1]
  #       url = "http://api.flickr.com/services/rest/?api_key=wadus&extras=geo&format=json&lat=#{@lat}&lon=#{@lon}&method=flickr.photos.search&nojsoncallback=1&radius=#{@radius}"
  #       mock(HTTParty).get(url){response}
  #       @results = Gigante::Services::Flickr.search(@lat, @lon, @radius, :auth => {:api_key => 'wadus'})
  #       @r = JSON.parse(@results)
  #     end
  # 
  #     should 'return results' do
  #       assert !@results.nil?
  #     end
  #     
  #     should 'return a hash' do
  #       assert @r.is_a?(Hash)
  #     end
  #     
  #     should 'have a meta key' do
  #       assert @results['meta']
  #     end
  #     
  #     should 'have a meta/service name key' do
  #       assert @results['meta']['service_name']
  #     end
  #     
  #     should 'have a meta/service description key' do
  #       assert @results['meta']['service_description']
  #     end
  #     
  #     should 'have a meta/service url key' do
  #       assert @results['meta']['service_url']
  #     end
  # 
  #     should 'have a meta/service api url key' do
  #       assert @results['meta']['service_api_url']
  #     end
  # 
  #     should 'have a search key' do
  #       assert @results['search']
  #     end
  #     
  #     should 'have a search status key' do
  #       assert @results['search']['status']
  #     end
  #     
  #     
  #     should 'have a valid result counter of zero' do
  #       assert @results['search']['total_results'] = 0
  #     end
  #     
  #     
  #   end
  
  context 'a valid search with results' do
    setup do
      @o = Oos4ruby::Oos.new
      response = File.read(File.dirname(__FILE__)+'/fixtures/oos_response.txt')
      @lat, @lon, @radius = ['-5.851560', '43.366241', 1]
      app_key = '7a5e65802381edf4ca98afd71eb20bd2'
      secret = '8b7e77652569239b22a2a42c891757cf'
      #mock.instance_of(Oos4ruby::Oos).auth_app('wadus','wadus') {true}
      #mock.instance_of(Oos4ruby::Oos).search(:lat => @lat, :lon => @lon, :radius => @radius){response}

      @results = Gigante::Services::Oos.search(@lat, @lon, @radius, :auth => {:app_key => app_key, :app_secret => secret})
    end

    should 'return results' do
      assert !@results.nil?
    end
    
    should 'return a hash' do
      assert @results.is_a?(Hash)
    end
    
    should 'have a meta key' do
      assert @results['meta']
    end
    
    should 'have a meta/service name key' do
      assert @results['meta']['service_name']
    end
    
    should 'have a meta/service description key' do
      assert @results['meta']['service_description']
    end
    
    should 'have a meta/service url key' do
      assert @results['meta']['service_url']
    end

    should 'have a meta/service api url key' do
      assert @results['meta']['service_api_url']
    end

    should 'have a search key' do
      assert @results['search']
    end
    
    should 'have a search status key' do
      assert @results['search']['status']
    end
    
    should 'have a search/results key' do
      assert @results['search']['results']
    end
    
    should 'have an array of results' do
      assert @results['search']['results'].is_a?(Array)
    end
    
    should 'have a number of results' do
      assert @results['search']['results'].size > 0
    end
    
    should 'have a valid result counter' do
      assert @results['search']['total_results'].to_i == @results['search']['results'].size
    end
    
    context 'each result' do
      setup do
        @result = @results['search']['results'].first
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