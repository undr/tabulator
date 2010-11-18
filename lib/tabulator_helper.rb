module TabulatorHelper
  def tabulator_init
    output = []
    output << stylesheet_link_tag('/stylesheets/tabulator.css')
    output << javascript_include_tag('/javascripts/tabulator.js')
    output.join("\n")
  end
  
  def tabulator(options, &block)
    partial = options.delete(:partial) || "shared/tabulator"
    tabulator = Base.new(partial.to_s, options, @template)
    yield tabulator
    tabulator.build!
  end
  
  Tab = Struct.new(:name, :active, :content)
  class Base
    def initialize(partial, options, template)
      @options = {:height => false, :status => false}.merge(options)
      @partial, @template = partial, template
      @tabs = OrderedHash.new
      @status = false
    end
    
    def tab(options, content="", &block)
      content = @template.capture(&block) if block_given?
      id = options.delete(:id)
      name = options.delete(:name)
      active = options.delete(:active) || false
      @tabs[id] = Tab.new(name, active, content)
    end
    
    def status(content)
      @status = content
    end
    
    def build!
     @template.render(:partial => @partial, :locals => {:tabs => @tabs, :height => @options[:height], :status => @status})
    end
  end
end
