# Hacks to get spec/rails to work

class ApplicationController < ActionController::Base
  def render(options = {}, locals = {}, &block)
    RenderCalls.add([options, locals])
  end
  class RenderCalls
    class << self
      def add(render_args)
        calls << render_args
      end
      
      def last
        calls.last
      end
      
      def clear!
        @calls = []
      end
      
      def calls
        @calls || []
      end
    end
  end
end

module Rails
  module VERSION
    STRING = '2.3.8'
  end
end