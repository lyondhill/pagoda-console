# require 'pagoda-client/clients/app'

class Pagoda::Client
  # include Pagoda::Client::App

  # include Pagoda::Auth

  attr_reader :user, :password

  def initialize(user, password)
    @user       = user
    @password   = password
  end

  class << self
    def version
      Pagoda::VERSION
    end
    
    def gem_version_string
      "pagoda-gem/#{version}"
    end
  end

  def on_warning(&blk)
    @warning_callback = blk
  end

  def poke
    #will poke pagoda and validate credentials
  end

protected


  def get(uri, extra_headers={})
    json(process(:get, uri, extra_headers))
  end

  def post(uri, payload="", extra_headers={})    
    process(:post, uri, extra_headers, payload)
  end

  def put(uri, payload="", extra_headers={})
    process(:put, uri, extra_headers, payload)
  end

  def delete(uri, extra_headers={})    
    process(:delete, uri, extra_headers)
  end

  
  def resource(uri)
    RestClient.proxy = ENV['HTTP_PROXY'] || ENV['http_proxy']
    if uri =~ /^https?/
      RestClient::Resource.new(uri, @user, @password)
    else
      # RestClient::Resource.new("http://127.0.0.1:3000#{uri}", @user, @password)
      RestClient::Resource.new("https://dashboard.pagodabox.com#{uri}", @user, @password)
    end
  end

  def process(method, uri, extra_headers={}, payload=nil)
    headers  = pagoda_headers.merge(extra_headers)
    args     = [method, payload, headers].compact
    response = resource(uri).send(*args)
  end
  
  def pagoda_headers
    {
      'User-Agent'           => self.class.gem_version_string,
      'X-Ruby-Version'       => RUBY_VERSION,
      'X-Ruby-Platform'      => RUBY_PLATFORM,
    }
  end

  def json(content)
        JSON.parse(content, symbolize_names: true)
  end


end