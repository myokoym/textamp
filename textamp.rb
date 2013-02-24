# encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'haml'
require 'uri'

get "/" do
  haml :index
end

amplify = lambda do
  @text = amplify(params)
  @http_get_url = http_get_url
  haml :index
end
get "/amplify", &amplify
post "/amplify", &amplify

private
def amplify(params)
  text = params[:text]
  results = Array.new(params[:volume].to_i) { text }

  if params[:increment] == "1"
    results = increment(results)
  end

  if params[:template] == "1"
    results = template(results)
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
    part = format % (i + start)
    t.gsub("#{sign}", part)
  end
end

def template(results)
  sign = params[:template_sign]
  results.map.with_index do |t, i|
    template_texts = params[:template_text].split(/\n/)
    part = template_texts[i % template_texts.count].chomp
    t.gsub("#{sign}", part)
  end
end

def http_get_url
  "#{url}?#{URI.encode_www_form(params)}"
end
