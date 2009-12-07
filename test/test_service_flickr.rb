require File.dirname(__FILE__) + '/test_helper.rb'

class TestServiceFlickr < Test::Unit::TestCase
  
  context 'a search without an API key' do

    should 'raise an exception' do
      assert_raise Gigante::Errors::ServiceForbidden do
        @lat, @lon, @radius = ['-5.851560', '43.366241', 1]
        Gigante::Services::Flickr.search(@lat,@lon,@radius,{})
      end
    end
  
  end
  
  context 'a valid search' do
    setup do
      
      response = File.read(File.dirname(__FILE__)+'/fixtures/flickr_response.txt')
        
      @lat, @lon, @radius = ['-5.851560', '43.366241', 1]
      url = "http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=wadus&lat=#{@lat}&lon=#{@lon}&radius=#{@radius}&extras=geo&format=json&nojsoncallback=1"

      mock(HTTParty).get(url){response}
      @results = Gigante::Services::Flickr.search(@lat, @lon, @radius, :auth => {:api_key => 'wadus'})
    end
    
    should 'return a hash' do
      r = JSON.parse(@results)
      assert r.is_a?(Hash)
    end
    
  end
  
  
end