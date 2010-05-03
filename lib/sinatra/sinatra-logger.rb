require 'sinatra/base'
require 'sinatra/request-logger'

module Sinatra
  class SinatraLogger
    def self.registered(app)
      app.use SyslogLogger, Proc.new{ |x| x.settings.logger}
      app.set :show_exceptions, false
      app.error do
        settings.logger.info("#{env['sinatra.error'].class} (#{env['sinatra.error'].message})")
        settings.logger.info(env['sinatra.error'].backtrace.join("\n"))
      end
    end
  end
end
