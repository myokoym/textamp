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

  context "amplify (HTTP POST)" do
    it "text to 3 volume" do
      post '/amplify', {:text => "text",
                      :volume => "3",
                      :linefeed => "0"}
      last_response.ok? == true
      last_response.body.to_s.should =~ />texttexttext<\/textarea>/
    end

    it "add linefeed" do
      post '/amplify', {:text => "text",
                      :volume => "3",
                      :linefeed => "1"}
      last_response.ok? == true
      last_response.body.to_s.should =~ />text&#x000A;text&#x000A;text<\/textarea>/
    end

    it "increment option" do
      post '/amplify', {:text => "text_?;",
                      :volume => "3",
                      :linefeed => "0",
                      :increment => "1",
                      :increment_sign => "?",
                      :increment_start => "1",
                      :increment_digit => "3"}
      last_response.ok? == true
      last_response.body.to_s.should =~ />text_001;text_002;text_003;<\/textarea>/
    end

    it "increment option and '%' into textarea" do
      post '/amplify', {:text => "?%;",
                      :volume => "3",
                      :linefeed => "0",
                      :increment => "1",
                      :increment_sign => "?",
                      :increment_start => "100",
                      :increment_digit => "3"}
      last_response.ok? == true
      last_response.body.to_s.should =~ />100%;101%;102%;<\/textarea>/
    end

    it "template option" do
      post '/amplify', {:text => "text_@@@;",
                      :volume => "3",
                      :linefeed => "0",
                      :template => "1",
                      :template_sign => "@@@",
                      :template_text => "aaa\nbbb\nccc"}
      last_response.ok? == true
      last_response.body.to_s.should =~ />text_aaa;text_bbb;text_ccc;<\/textarea>/
    end

    it "print HTTP GET URL" do
      post '/amplify', {:text => "text",
                      :volume => "3",
                      :linefeed => "0",
                      :increment => "1",
                      :increment_sign => "?",
                      :increment_start => "1",
                      :increment_digit => "3"}
      last_response.ok? == true
      last_response.body.to_s.should =~ /text=text/
      last_response.body.to_s.should =~ /volume=3/
      last_response.body.to_s.should =~ /linefeed=0/
      last_response.body.to_s.should =~ /increment=1/
      last_response.body.to_s.should =~ /increment_sign=%3F/
      last_response.body.to_s.should =~ /increment_start=1/
      last_response.body.to_s.should =~ /increment_digit=3/
    end

    it "save params" do
      post '/amplify', {:volume          => "3",
                        :linefeed        => "1",
                        :increment       => "1",
                        :increment_sign  => "$",
                        :increment_start => "1",
                        :increment_digit => "5",
                        :template        => "1",
                        :template_sign   => "@@@",
                        :template_text   => "aaa\nbbb\nccc",
                        :text            => "text-@@@_$"}
      last_response.ok? == true
      last_response.body.to_s.should =~ /selected.*>3</
      last_response.body.to_s.should =~ /checked.*>line feed</
      last_response.body.to_s.should =~ /checked.*>increment</
      last_response.body.to_s.should =~ /selected.*>\$</
      last_response.body.to_s.should =~ /selected.*>1</
      last_response.body.to_s.should =~ /selected.*>5</
      last_response.body.to_s.should =~ /checked.*>template</
      last_response.body.to_s.should =~ /value=['"]@@@['"]/
      last_response.body.to_s.should =~ />text-aaa_00001&#x000A;text-bbb_00002&#x000A;text-ccc_00003<\/textarea>/
      last_response.body.to_s.should =~ />text-@@@_\$<\/textarea>/
    end
  end

  context "amplify (HTTP GET)" do
    it "text to 3 volume" do
      get '/amplify', {:text => "text",
                      :volume => "3",
                      :linefeed => "0"}
      last_response.ok? == true
      last_response.body.to_s.should =~ />texttexttext<\/textarea>/
    end
  end
end
