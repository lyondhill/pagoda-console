require 'spec_helper'
require 'webmock'

include WebMock::API

def stub_api_request(method, path, body=nil)
  if body
    stub_request(method, "http://baker.pagodabox.com:3000#{path}").with(body: body)
  else
    stub_request(method, "http://baker.pagodabox.com:3000#{path}")
  end
end


describe Pagoda::Client do
  
  before :all do
    client = Pagoda::Client.new(nil,nil)
  end

  it "doesnt test anything yet" do
    
  end



end