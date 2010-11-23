require "pp"
module TabulatorHelper
  def tabulator_init
    output = []
    output << stylesheet_link_tag('tabulator')
    output << javascript_include_tag('tabulator')
    output.join("\n")
  end
  
  def tabulator(options={}, &block)
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
      @tabs = {}#::OrderedHash.new
      @status = false
    end
    
    # === Example
    # 
    #   <% t.tab(:tab_id, "Tab title") do -%>
    #     Some content
    #   <% end -%>
    # 
    #   <% t.tab(:tab_id, "Tab title", true) do -%>
    #     Some content
    #   <% end -%>
    # 
    #   <% t.tab(:tab_id, "Tab title", "Some content") -%>
    # 
    #   <% t.tab(:tab_id, "Tab title", "Some content", true) -%>
    # 
    def tab(id, name, content_or_active="", active=false, &block)
      if content_or_active.is_a?(::String)
        content = content_or_active
      elsif content_or_active.is_a?(::TrueClass)
        active = content_or_active
      else
        content = ""
      end
      content = @template.capture(&block) if block_given?
      
      @tabs[id] = Tab.new(name, active, content)
    end
    
    def status(content)
      @status = content
    end
    
    def build!
     @template.concat(@template.render(:partial => @partial, :locals => {:tabs => @tabs, :height => @options[:height], :status => @status}))
    end
  end
end
