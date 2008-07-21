# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use (only works if using vendor/rails).
  # To use Rails without a database, you must remove the Active Record framework
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_ruby_footprints_session',
    :secret      => '4dc452c77a1b789d380c3ea14e7b24a22d4e1cd5486b77371a335d5bca2af3f0f824cac5bb01cc01a7e274dee0ace05ad5c278f84b0ff7571866c1bbade85698'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running


  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
end


#MONKEY_PATCH_TAG
 module Facebooker
   class Service   
     def post_with_api_logging(params)  
       unless(RAILS_ENV == "production")
         RAILS_DEFAULT_LOGGER.debug(" Posting to #{url} #{params.inspect} ")
       end
       return post_without_api_logging(params)     
     end
     alias_method_chain :post, :api_logging
   end
    
   class Parser
     class <<self
       
       def parse_with_logging(api_method,response)
         unless(RAILS_ENV == "production")
           RAILS_DEFAULT_LOGGER.debug(" Return value #{response.body}")
         end
         return parse_without_logging(api_method, response)     
       end
       alias_method_chain :parse, :logging
     end
   end
 end
#MONKEY_PATCH_TAG
                             