# encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'haml'

get "/" do
  haml :index
end

post "/clone" do
  @text = clone(params)
  haml :index
end

get "/clone" do
  clone(params)
end

private
def clone(params)
  params[:text] * params[:times].to_i
end
