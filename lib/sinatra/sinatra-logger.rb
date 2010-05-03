require 'sinatra/base'
require 'sinatra/request-logger'

module Sinatra
  module SinatraLogger
    def self.registered(app)
      app.use RequestLogger, app.logger
      app.set :show_exceptions, false
      app.error do
        settings.logger.info("#{env['sinatra.error'].class} (#{env['sinatra.error'].message})")
        settings.logger.info(env['sinatra.error'].backtrace.join("\n"))
      end
    end
  end
end
