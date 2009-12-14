require File.dirname(__FILE__) + '/test_helper.rb'

class TestServiceYelp < Test::Unit::TestCase
  require 'crack'
  
  context 'a search without an API key' do

    should 'raise an exception' do
      assert_raise Gigante::Errors::ServiceForbidden do
        @lat, @lon, @radius = ['-5.851560', '43.366241', 1]
        Gigante::Services::Yelp.find(@lat,@lon,@radius,{})
      end
    end
  
  end
  
  context 'a valid search without results' do
    setup do
      response = File.read(File.dirname(__FILE__)+'/fixtures/yelp_response_no_results.txt')
      @lat, @lon, @radius = ['-5.851560', '43.366241', 1]
      url = "http://api.yelp.com/business_review_search?term=yelp&lat=#{@lat}&long=#{@lon}&radius=#{@radius}&num_biz_requested=20&ywsid=wadus"
      mock(HTTParty).get(url){response}
      @results = Gigante::Services::Yelp.find(@lat, @lon, @radius, :auth => {:api_key => 'wadus'})
    end

    should 'return results' do
      assert !@results.nil?
    end
    
    should 'return a hash' do
      assert @results.is_a?(Hash)
    end
    
    should 'have a meta key' do
      assert @results[:meta]
    end
    
    should 'have a meta/service name key' do
      assert @results[:meta][:service_name]
    end
    
    should 'have a meta/service description key' do
      assert @results[:meta][:service_description]
    end
    
    should 'have a meta/service url key' do
      assert @results[:meta][:service_url]
    end

    should 'have a meta/service api url key' do
      assert @results[:meta][:service_api_url]
    end

    should 'have a search key' do
      assert @results[:search]
    end
    
    should 'have a search status key' do
      assert @results[:search][:status]
    end
    
    
    should 'have a valid result counter of zero' do
      assert @results[:search][:total_results] == 0
    end
    
  
  end
  
  context 'a valid search with results' do
    setup do
      response = File.read(File.dirname(__FILE__)+'/fixtures/yelp_response.txt')
      @lat, @lon, @radius = ['-5.851560', '43.366241', 1]
      url = "http://api.yelp.com/business_review_search?term=yelp&lat=#{@lat}&long=#{@lon}&radius=#{@radius}&num_biz_requested=20&ywsid=wadus"
      mock(HTTParty).get(url){response}
      @results = Gigante::Services::Yelp.find(@lat, @lon, @radius, :auth => {:api_key => 'wadus'})
    end

    should 'return results' do
      assert !@results.nil?
    end
    
    should 'return a hash' do
      assert @results.is_a?(Hash)
    end
    
    should 'have a meta key' do
      assert @results[:meta]
    end
    
    should 'have a meta/service name key' do
      assert @results[:meta][:service_name]
    end
    
    should 'have a meta/service description key' do
      assert @results[:meta][:service_description]
    end
    
    should 'have a meta/service url key' do
      assert @results[:meta][:service_url]
    end

    should 'have a meta/service api url key' do
      assert @results[:meta][:service_api_url]
    end

    should 'have a search key' do
      assert @results[:search]
    end
    
    should 'have a search status key' do
      assert @results[:search][:status]
    end
    
    should 'have a search/results key' do
      assert @results[:search][:results]
    end
    
    should 'have an array of results' do
      assert @results[:search][:results].is_a?(Array)
    end
    
    should 'have a number of results' do
      assert @results[:search][:results].size > 0
    end
    
    should 'have a valid result counter' do
      assert @results[:search][:total_results].to_i == @results[:search][:results].size
    end
    
    context 'each result' do
      setup do
        @result = @results[:search][:results].first
      end
      
      should 'be a hash' do
        assert @result.is_a?(Hash), @result.inspect
      end

      should 'have a title key' do
        assert @result[:title]
      end
      
      should 'have a url key' do
        assert @result[:url], @result.inspect
      end
      
      should 'have a lat key' do
        assert @result[:lat], @result.inspect
      end
      
      should 'have a lon key' do
        assert @result[:lon]
      end
      
    end
  
  end
end