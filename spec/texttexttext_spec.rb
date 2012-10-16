# encoding: utf-8
require 'rspec'
require 'rack/test'

MY_APP = Rack::Builder.parse_file('config.ru').first

include Rack::Test::Methods
def app
  MY_APP
end

describe "TextTextText" do
  context "root" do
    it "last response ok?" do
      get '/'
      last_response.ok? == true
    end
  end

  context "clone" do
    it "text to 3 times" do
      post '/clone', {:text => "text",
                      :times => "3"}
      last_response.ok? == true
      last_response.body.to_s.should =~ /value='texttexttext'/
    end
  end
end

