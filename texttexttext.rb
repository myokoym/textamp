# encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'haml'
require 'uri'

get "/" do
  haml :index
end

post "/clone" do
  @text = clone(params)
  @http_get_url = http_get_url
  haml :index
end

get "/clone" do
  @text = clone(params)
  @http_get_url = http_get_url
  haml :index
end

private
def clone(params)
  text = params[:text]
  results = Array.new(params[:times].to_i) { text }

  if params[:increment] == "1"
    results = increment(results)
  end

  result = ""
  if params[:linefeed] == "1"
    result = results.join("\n")
  else
    result = results.join
  end

  result
end

def increment(results)
  format = "%0#{params[:increment_digit]}d"
  sign = params[:increment_sign]
  start = params[:increment_start].to_i
  results.map.with_index do |t, i|
    sign_count = t.count(sign)
    t.gsub("#{sign}", format) % Array.new(sign_count) { i + start }
  end
end

def http_get_url
  "#{url}?#{URI.encode_www_form(params)}"
end
