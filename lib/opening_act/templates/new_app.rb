require "rubygems"
require "bundler/setup"
require "sinatra"
require File.join(File.dirname(__FILE__), "environment")

configure do
  set :views, "#{File.dirname(__FILE__)}/views"
end

helpers do
  # add your helpers here
end

# index page
get "/" do
  erb :index
end
