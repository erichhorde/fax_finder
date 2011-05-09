require 'net/http'
require 'net/https'

module FaxFinder
  module Constants
    BASE_PATH='/ffws/v1/ofax'
    DEFAULT_PORT=80
    DEFAULT_SSL=false
  end
  
  module RequestClassMethods
    attr_reader :host, :user, :password, :port, :ssl
    def configure(_host, _user, _password, _port=Request::DEFAULT_PORT, _ssl=Request::DEFAULT_SSL)
      @host, @user, @password, @port, @ssl=_host, _user, _password, _port, _ssl
    end

    def reset
      @host=@user=@password=nil
      @port=Request::DEFAULT_PORT
      @ssl=Request::DEFAULT_SSL
    end

    def post
      response_body=nil

      begin
        Net::HTTP.start(Request.host, Request.port) { |http|  
          http.use_ssl=Request.ssl
          http_request = yield
          http_request.basic_auth Request.user, Request.password
          http_request.set_content_type(Request::CONTENT_TYPE)
          http_response = http.request(http_request)
          response_body=http_response.body
        }
      rescue Errno::ECONNREFUSED => e
        response_body=Responses::NO_CONNECTION
      rescue RuntimeError => e
        response_body=Responses::APPLICATION_ERROR.gsub(Responses::ERROR_GSUB, e.message)
      end
      Response.new(Nokogiri::XML(response_body))
    end

    # def proces_http_response(http_response)
    #   return 
    # end
    # 
    def formatted_fax_finder_time(time)
      result=nil
      if time
        result=(time.utc? ? time : time.utc).strftime(Request::TIME_FORMAT)
      end
      result
    end
    
  end
  
  class Request
    include Constants
    TIME_FORMAT="%Y-%m-%dT%H:%M:%S"
    CONTENT_TYPE='text/xml'
  end    

end

FaxFinder::Request.send(:extend, FaxFinder::RequestClassMethods)
