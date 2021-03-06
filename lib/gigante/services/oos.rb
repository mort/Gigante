module Gigante
  module Services
   class Oos
     
     include ClassMethods
     require 'rubygems'
     require 'md5'
     require 'crack'

     AUTH_REQUIRED = true
     
     REQUIRED_AUTH_PARAMS = %w(app_key app_secret)
 
     SERVICE_NAME = '11870'
     SERVICE_URL  = 'http://11870.com'
     SERVICE_API_URL = 'http://code.google.com/p/api-11870/'
     SERVICE_DESCRIPTION = ''

     def self.query(lat, lon, radius, options) 

       auth = options[:auth]
       raise Gigante::Errors::ServiceForbidden, "You must supply an app key and an app secret for 11870 via the auth hash" unless (auth and auth[:app_key] and auth[:app_secret])

       app_key = auth[:app_key]
       app_secret = auth[:app_secret]
       
       authSign = auth_sign(app_key, app_secret)
       
      #url = "http://11870.com/api/v1/search?lat=#{lat}&lon=#{lon}&radius=#{radius}&appToken=#{app_key}&authSign=#{authSign}"
       url =   "http://11870.com/api/v1/search?appToken=#{app_key}&authSign=#{authSign}"
      
       if options.has_key?(:query)
         query_string = options[:query].map do |k,v|
           "#{k}=#{v}"
          end.sort.join('&')
          
          url = url << "&#{query_string}"
          puts url 
       end
       
       response = HTTParty.get(url) 
       
       results = build_results(response)
       results[:meta][:query_url] = url
       results[:meta][:query_params] = options[:query] if options.has_key?(:query)
       
   
       return results  
     end
     
     def self.auth_sign(app_key, app_secret)
       Digest::MD5.hexdigest("#{app_key}#{app_secret}")
     end
     
     private 
     
     def self.build_results(response)

       r = Crack::XML.parse(response)
       
       results = {}
       results[:meta] = {}
       results[:search] = {}
   
       results[:meta][:service_name]    = SERVICE_NAME
       results[:meta][:service_url]     = SERVICE_URL
       results[:meta][:service_api_url] = SERVICE_API_URL
       results[:meta][:service_description] = SERVICE_DESCRIPTION
   
       results[:search][:status] = 'ok'
       results[:search][:results] = []
       
       unless r['feed']['entry'].nil?
         results[:search][:total_results] = r['feed']['entry'].size
       

         r['feed']['entry'].each do |e|
           begin
           puts e.inspect
           puts e['georss:where'].inspect
           puts e['georss:where']['gml:Point'].inspect
           puts e['georss:where']['gml:Point']['gml:pos'].inspect
           puts e['georss:where']['gml:Point']['gml:pos'].split(' ').inspect
           lat, lon =  e['georss:where']['gml:Point']['gml:pos'].split(' ')
           puts lat
           puts lon
           node = {}
           node[:lat]   = lat
           node[:lon]   = lon
           node[:title] = e['title']
         
           u = e['link'].is_a?(Hash) ? e['link'] : e['link'].first
         
           node[:url] = u['href']
         
           results[:search][:results].push(node)
          rescue TypeError
            puts "Error en"
            puts e.inspect
          end
         end
       else
         results[:search][:total_results] = 0   
       end
     
       return results
        
     end
     
   end
 end
end