require File.dirname(__FILE__) + '/../spec_helper'

describe TabulatorHelper do
  describe "tabulator_init" do
    before(:each) do
      @header = eval_erb(%(
        <%= tabulator_init %>
        ))
    end
    it "should return valid script tag" do
      # <script src="/javascripts/tabulator.js?1290151356" type="text/javascript"></script>
      @header.should match /<script src="\/javascripts\/tabulator\.js([?\d]*)" type="text\/javascript"><\/script>/
    end
    it "should return valid css link" do
      # <link href="/stylesheets/tabulator.css?1290151356" media="screen" rel="stylesheet" type="text/css" />
      @header.should match /<link href="\/stylesheets\/tabulator\.css([?\d]*)" media="screen" rel="stylesheet" type="text\/css" \/>/
    end
  end
end