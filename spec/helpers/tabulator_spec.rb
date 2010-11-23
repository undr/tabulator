require File.dirname(__FILE__) + '/../spec_helper'
include TabulatorHelper

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

describe "tabulator" do
  context "called without args" do
    before(:each) do
      @template = prepare_template
    end
    
    it "should call method render @template with default options" do
      @template.expects(:render).with(:partial => "shared/tabulator", :locals => {:tabs => {}, :height => false, :status => false}).returns("")
      tabulator{|t| }.should == ""
    end
  end
  
  context "called with args" do
    before(:each) do
      @template = prepare_template
    end
    
    it "should call method render for @template with custom :partial option" do
      @template.expects(:render).with(:partial => "my_template", :locals => {:tabs => {}, :height => false, :status => false}).returns("")
      tabulator(:partial => "my_template"){|t| }.should == ""
    end
    it "should call method render for @template with :height option" do
      @template.expects(:render).with(:partial => "shared/tabulator", :locals => {:tabs => {}, :height => "200px", :status => false}).returns("")
      tabulator(:height => "200px"){|t| }.should == ""
    end
    
    it "should call method render for @template with status" do
      @template.expects(:render).with(:partial => "shared/tabulator", :locals => {:tabs => {}, :height => false, :status => "Some status content"}).returns("")
      tabulator do|t| 
        t.status("Some status content")
      end.should == ""
    end
    
    it "should call method render for @template with all options and status" do
      @template.expects(:render).with(:partial => "my_tabulator", :locals => {:tabs => {}, :height => "200px", :status => "Some status content"}).returns("")
      tabulator(:partial => "my_tabulator", :height => "200px") do |t| 
        t.status("Some status content")
      end.should == ""
    end
    
    it "should call method render for @template with tabs" do
      def @template.render(options = {}, locals = {}, &block)
        RenderCalls.add(options, locals) && ""
      end 
      tabulator do|t| 
        t.tab(:tab_id1, "Tab title 1", "Content for :tab_id1")
        t.tab(:tab_id2, "Tab title 2", "Content for :tab_id2", true)
      end
      tabs = RenderCalls.last_options[:locals][:tabs]
      tabs[:tab_id1].name.should == "Tab title 1"
      tabs[:tab_id1].active.should == false
      tabs[:tab_id1].content.should == "Content for :tab_id1"
      tabs[:tab_id2].name.should == "Tab title 2"
      tabs[:tab_id2].active.should == true
      tabs[:tab_id2].content.should == "Content for :tab_id2"
    end
  end
  
  context "called with blocks in tab() and status() methods" do
    before(:each) do
      @template = prepare_template(true)
      
      def @template.render(options = {}, locals = {}, &block)
        RenderCalls.add(options, locals) && ""
      end
      
      def @template.capture(*args, &block)
        self.output_buffer, old_buffer = "", self.output_buffer
        block.call
      ensure
        self.output_buffer = old_buffer
      end
      
      def @template.output_buffer=(txt)
        @output_buffer = txt
      end
      
      def @template.output_buffer
        @output_buffer ||= ""
      end
    end
    
    it "should call method render for @template with tab, status and default options" do
      my_eval_erb(%(
        <% tabulator do |t| %>
          <% t.tab :tab1, "Tab #1" do %>
          Tab text
          <% end %>
          <% t.status do %>
          Status
          <% end %>
        <% end %>
        ))

      options = RenderCalls.last_options
      tabs = options[:locals][:tabs]
      tabs[:tab1].name.should == "Tab #1"
      tabs[:tab1].active.should == false
      tabs[:tab1].content.should match(/Tab text/)
      options[:partial].should == "shared/tabulator"
      options[:locals][:status].should match(/Status/)
      options[:locals][:height].should == false
    end
    it "should call method render for @template with tab, status and defined options" do
      my_eval_erb(%(
        <% tabulator(:partial => "my_tabulator", :height => "200px") do |t| %>
          <% t.tab :tab1, "Tab #1", true do %>
          Tab text
          <% end %>
          <% t.status do %>
          Status
          <% end %>
        <% end %>
        ))

      options = RenderCalls.last_options
      tabs = options[:locals][:tabs]
      tabs[:tab1].name.should == "Tab #1"
      tabs[:tab1].active.should == true
      tabs[:tab1].content.should match(/Tab text/)
      options[:partial].should == "my_tabulator"
      options[:locals][:status].should match(/Status/)
      options[:locals][:height].should == "200px"
    end
  end
end

def my_eval_erb(text)
  ERB.new(text, nil, nil, '@template.output_buffer').result(binding)
end

def prepare_template(as_null_object=false)
  template = mock("template")
  template.as_null_object if as_null_object
  template.expects(:concat).with("").returns("")
  template
end