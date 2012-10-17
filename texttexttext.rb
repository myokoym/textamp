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
  text = params[:text]
  if params[:increment] == "1"
    result = ""
    format = "%0#{params[:increment_digit]}d"
    sign = params[:increment_sign]
    sign_count = text.count(sign)
    text.gsub!("#{sign}", format)
    start = params[:increment_start].to_i
    params[:times].to_i.times do |i|
      result << text % Array.new(sign_count) { i + start }
      result << "\n" if params[:linefeed] == "1"
    end
    result
  else
    text << "\n" if params[:linefeed] == "1"
    text * params[:times].to_i
  end
end
