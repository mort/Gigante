module Gigante
  module Services
   class Oos
     
     include ClassMethods
     require 'oos4ruby'
     require 'crack'

     AUTH_REQUIRED = true
 
     SERVICE_NAME = '11870'
     SERVICE_URL  = 'http://11870.com'
     SERVICE_API_URL = 'http://code.google.com/p/api-11870/'
     SERVICE_DESCRIPTION = ''

     def self.search(lat, lon, radius, options) 

       auth = options.delete(:auth)
       raise Gigante::Errors::ServiceForbidden, "You must supply an app key and an app secret for 11870 via the auth hash" unless (auth and auth[:app_key] and auth[:app_secret])

       app_key = auth.delete(:app_key)
       app_secret = auth.delete(:app_secret)
       
       oos = Oos4ruby::Oos.new

       oos.auth_app app_key, app_secret

       results = oos.search :lat => lat, :lon => lon, :radius => radius

       results = build_results(response)
   
       return results

     end
     
     private 
     
     def self.build_results(response)

       results = {}
       results[:meta] = {}
       results[:search] = {}
   
       results[:meta][:service_name]    = SERVICE_NAME
       results[:meta][:service_url]     = SERVICE_URL
       results[:meta][:service_api_url] = SERVICE_API_URL
       results[:meta][:service_description] = SERVICE_DESCRIPTION
   
       results[:search][:status] = 'ok'

        
     end
     
   end
 end
end