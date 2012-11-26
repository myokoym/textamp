# encoding: utf-8
require 'rspec'
require 'rack/test'

MY_APP = Rack::Builder.parse_file('config.ru').first

include Rack::Test::Methods
def app
  MY_APP
end

describe "Textamp" do
  context "root" do
    it "last response ok?" do
      get '/'
      last_response.ok? == true
    end
  end

  context "clone (HTTP POST)" do
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
      post '/clone', {:text => "text_?;",
                      :times => "3",
                      :linefeed => "0",
                      :increment => "1",
                      :increment_sign => "?",
                      :increment_start => "1",
                      :increment_digit => "3"}
      last_response.ok? == true
      last_response.body.to_s.should =~ />text_001;text_002;text_003;<\/textarea>/
    end

    it "template option" do
      post '/clone', {:text => "text_@@@;",
                      :times => "3",
                      :linefeed => "0",
                      :template => "1",
                      :template_sign => "@@@",
                      :template_text => "aaa\nbbb\nccc"}
      last_response.ok? == true
      last_response.body.to_s.should =~ />text_aaa;text_bbb;text_ccc;<\/textarea>/
    end

    it "print HTTP GET URL" do
      post '/clone', {:text => "text",
                      :times => "3",
                      :linefeed => "0",
                      :increment => "1",
                      :increment_sign => "?",
                      :increment_start => "1",
                      :increment_digit => "3"}
      last_response.ok? == true
      last_response.body.to_s.should =~ /text=text/
      last_response.body.to_s.should =~ /times=3/
      last_response.body.to_s.should =~ /linefeed=0/
      last_response.body.to_s.should =~ /increment=1/
      last_response.body.to_s.should =~ /increment_sign=%3F/
      last_response.body.to_s.should =~ /increment_start=1/
      last_response.body.to_s.should =~ /increment_digit=3/
    end
  end

  context "clone (HTTP GET)" do
    it "text to 3 times" do
      get '/clone', {:text => "text",
                      :times => "3",
                      :linefeed => "0"}
      last_response.ok? == true
      last_response.body.to_s.should =~ />texttexttext<\/textarea>/
    end
  end
end
