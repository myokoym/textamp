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
                      :times => "3",
                      :linefeed => "0"}
      last_response.ok? == true
      last_response.body.to_s.should =~ />texttexttext<\/textarea>/
    end

    it "add linefeed" do
      post '/clone', {:text => "text",
                      :times => "3",
                      :linefeed => "1"}
      last_response.ok? == true
      last_response.body.to_s.should =~ />text&#x000A;text&#x000A;text<\/textarea>/
    end

    it "increment option" do
      post '/clone', {:text => "text_#;",
                      :times => "3",
                      :linefeed => "0",
                      :increment => "1",
                      :increment_sign => "#",
                      :increment_start => "1",
                      :increment_digit => "3"}
      last_response.ok? == true
      last_response.body.to_s.should =~ />text_001;text_002;text_003;<\/textarea>/
    end
  end
end

