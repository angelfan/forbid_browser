module ForbidBrowser
  class Router
    attr_reader :config

    def initialize(app, &_block)
      @app = app
      @config = Config.new
      yield(@config)
    end

    def call(env)
      status, head, body = @app.call(env)
      return [status, head, body] if pass?(env)
      return [status, head, body] unless forbid?(env)
      return [302, { 'Location' => @config.redirect_to }, []] if @config.redirect_to
      render_nothing
    end

    private

    def render_nothing
      [400, { 'Content-Type' => 'text/plain' }, []]
    end

    def forbid?(env)
      @config.forbids.any? { |browser| browser.forbid?(env['HTTP_USER_AGENT']) }
    end

    def pass?(env)
      @config.excluded? env['REQUEST_PATH']
    end
  end
end
