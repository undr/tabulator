include TabulatorHelper

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
      @calls ||= []
    end
  end
end

describe "tabulator" do
  before(:each) do
    @template = mock()
  end
  context "called with default options" do
    it "should call method render and concat for @template with default options" do
      @template.expects(:render).with(:partial => "shared/tabulator", :locals => {:tabs => {}, :height => false, :status => false}).returns("")
      @template.expects(:concat).with("").returns("")
      tabulator{|t| }.should == ""
    end
  end
  it "should call method render and concat for @template with partial and height options" do
    @template.expects(:render).with(:partial => "my_template", :locals => {:tabs => {}, :height => "200px", :status => false}).returns("")
    @template.expects(:concat).with("").returns("")
    tabulator(:partial => "my_template", :height => "200px"){|t| }.should == ""
  end
  it "should call method render and concat for @template with partial and height options and the status" do
    @template.expects(:render).with(:partial => "my_template", :locals => {:tabs => {}, :height => "200px", :status => "Some status content"}).returns("")
    @template.expects(:concat).with("").returns("")
    tabulator(:partial => "my_template", :height => "200px") do|t| 
      t.status("Some status content")
    end.should == ""
  end
=begin
  it "should call method render and concat for @template with tabs" do
    tabs = {}
    tabs[:tab_id1] = TabulatorHelper::Tab.new("Tab title 1", false, "Content for :tab_id1")
    tabs[:tab_id2] = TabulatorHelper::Tab.new("Tab title 2", true, "Content for :tab_id2")
    #@template.expects(:render).with(:partial => "my_template", :locals => {:tabs => tabs, :height => false, :status => false}).returns("")
    @template.expects(:concat).with("").returns("")
    def @template.render(options = {}, locals = {}, &block)
      RenderCalls.add([options, locals])
      ""
    end 
    tabulator(:partial => "my_template") do|t| 
      t.tab(:tab_id1, "Tab title 1", "Content for :tab_id1")
      t.tab(:tab_id2, "Tab title 2", "Content for :tab_id2", true)
    end
    RenderCalls.last[0][:locals][:tabs].should be tabs
  end
=end
end
