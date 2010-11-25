require 'rubygems'
gem 'activesupport', "<3.0.0"
gem 'actionpack', "<3.0.0"
require "action_view"
require "action_controller"
$:.unshift File.dirname(__FILE__)+'/for_spec_rails'
RAILS_ENV = 'test'
#require 'spec'
require 'spec/rails'
gem "mocha", ">= 0.9.8"
require "mocha"
require File.dirname(__FILE__) + '/fake_renderer'
require File.dirname(__FILE__) + '/../lib/tabulator_helper'
