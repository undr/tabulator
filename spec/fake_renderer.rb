class FakeRenderer
  def initialize(mock)
    @mock = mock
  end
  
  def render(options = {}, locals = {}, &block)
    RenderCalls.add(options, locals) && ""
  end
  
  def capture(*args, &block)
    self.output_buffer, old_buffer = "", self.output_buffer
    block.call
  ensure
    self.output_buffer = old_buffer
  end

  def output_buffer=(txt)
    @output_buffer = txt
  end

  def output_buffer
    @output_buffer ||= ""
  end
  
  def method_missing(m, *args, &block)
    @mock.send(m, *args, &block)
  end
end

class RenderCalls
  class << self
    def add(options, locals)
      calls << {:options => options, :locals => locals}
    end

    def last
      calls.last
    end

    def last_options
      last[:options]
    end

    def last_locals
      last[:locals]
    end

    private
    def calls
      @calls ||= []
    end
  end
end

def my_eval_erb(text)
  ERB.new(text, nil, nil, '@template.output_buffer').result(binding)
end