module Sinatra
  module RequestLogger
    def self.registered(app)
      app.set :proxy_logger, ProxyLogger.new(app.logger)
      app.use Rack::CommonLogger, app.proxy_logger
      app.use ErrorLogger, app.proxy_logger
    end

    class ProxyLogger
      def initialize(logger)
        @logger = logger
      end

      def write(msg)
        @logger.info(msg)
      end

      def flush
        #nothing
      end

      def puts(msg)
        if msg.is_a?(Array)
          @logger.info(msg.map(&:chomp).join("\n"))
        elsif msg.is_a?(String)
          @logger.info(msg.chomp)
        else
          @logger.info(msg)
        end
      end

      def method_missing(method, *args)
        @logger.send(method, *args)
      end
    end

    class ErrorLogger
      def initialize(app, logger)
        @app = app
        @logger = logger
      end

      def call(env)
        env['rack.errors'] = @logger
        @app.call(env)
      end
    end
  end
end
