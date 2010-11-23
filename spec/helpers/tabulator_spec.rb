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
    @template.expects(:concat).with("").returns("")
  end
  context "called with default options" do
    it "should call method render and concat for @template with default options" do
      @template.expects(:render).with(:partial => "shared/tabulator", :locals => {:tabs => {}, :height => false, :status => false}).returns("")
      tabulator{|t| }.should == ""
    end
  end
  it "should call method render and concat for @template with partial and height options" do
    @template.expects(:render).with(:partial => "my_template", :locals => {:tabs => {}, :height => "200px", :status => false}).returns("")
    tabulator(:partial => "my_template", :height => "200px"){|t| }.should == ""
  end
  it "should call method render and concat for @template with partial and height options and the status" do
    @template.expects(:render).with(:partial => "my_template", :locals => {:tabs => {}, :height => "200px", :status => "Some status content"}).returns("")
    tabulator(:partial => "my_template", :height => "200px") do|t| 
      t.status("Some status content")
    end.should == ""
  end

  it "should call method render and concat for @template with tabs" do
    def @template.render(options = {}, locals = {}, &block)
      RenderCalls.add([options, locals])
      ""
    end 
    tabulator(:partial => "my_template") do|t| 
      t.tab(:tab_id1, "Tab title 1", "Content for :tab_id1")
      t.tab(:tab_id2, "Tab title 2", "Content for :tab_id2", true)
    end
    RenderCalls.last[0][:locals][:tabs][:tab_id1].name.should == "Tab title 1"
    RenderCalls.last[0][:locals][:tabs][:tab_id1].active.should == false
    RenderCalls.last[0][:locals][:tabs][:tab_id1].content.should == "Content for :tab_id1"
    RenderCalls.last[0][:locals][:tabs][:tab_id2].name.should == "Tab title 2"
    RenderCalls.last[0][:locals][:tabs][:tab_id2].active.should == true
    RenderCalls.last[0][:locals][:tabs][:tab_id2].content.should == "Content for :tab_id2"
  end

end
