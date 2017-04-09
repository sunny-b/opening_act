require 'bundler/setup'
require 'sinatra'
require 'tilt/erubis'
require 'rack'
require 'date'
require File.join(File.dirname(__FILE__), 'environment')

configure(:development) do
  require 'sinatra/reloader'
  require 'pry'
end

helpers do
  # add your helpers here
end

# index page
get '/' do
  erb :index
end
