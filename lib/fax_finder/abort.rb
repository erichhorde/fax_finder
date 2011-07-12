require 'nokogiri'
require 'builder'

module FaxFinder

  class Abort < Request
    def self.delete(fax_key, entry_key)
      self.post(){
        construct_http_request(fax_key, entry_key)
      }
    end

    def self.construct_http_request(fax_key, entry_key)
      request = Net::HTTP::Delete.new(self.path(fax_key, entry_key))
      request.basic_auth self.user, self.password
      request.set_content_type(Request::CONTENT_TYPE)
      request
    end

    def self.path(fax_key, entry_key)
      params=[BASE_PATH, fax_key, entry_key].reject{ |p| p.nil? }
      File.join(*params)
    end

  end
  
end

