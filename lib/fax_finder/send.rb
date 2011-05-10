require 'nokogiri'
require 'builder'

module FaxFinder
  module SendClassMethods

    def post(recipient_fax, options={})
      super(){
        construct_http_request(recipient_fax, options)
      }
    end

    def construct_xml(recipient_fax, options={})
      xml = ""
      builder = Builder::XmlMarkup.new(:target => xml, :indent => 2 )      
      builder.instruct!(:xml, :version=>'1.0', :encoding=>'UTF-8')
      
      time=options[:schedule_all_at]
      time=time.utc if time && !time.utc?
      formatted_time=time ? time.strftime(Request::TIME_FORMAT) : nil
      
      external_url=options[:external_url]
      
      builder.schedule_fax {
        builder.cover_page do
          builder.subject(options[:subject])
          builder.comment(options[:comment])
          builder.enabled('false')
        end

        builder.recipient do
          builder.fax_number(recipient_fax)
          builder.organization(options[:recipient_organization])
          builder.phone_number(options[:recipient_phone_number])          
          builder.name(options[:recipient_name])
        end
      
        builder.sender do
          builder.fax_number(options[:sender_fax_number])
          builder.phone_number(options[:sender_phone_number])
          builder.organization(options[:sender_organization])
          builder.name(options[:sender_name])
        end

        builder.attachment do
          builder.location('external')
          builder.url(external_url)
        end
        builder.schedule_all_at(formatted_fax_finder_time(options[:schedule_all_at]))
      }
      xml
    end
    
    def construct_http_request(recipient_fax, options={})
      request = Net::HTTP::Post.new(Request::BASE_PATH)
      request.body=construct_xml(recipient_fax, options)
      request
    end

  end

  class Send < Request
  end
  
end

FaxFinder::Send.send(:extend, FaxFinder::SendClassMethods)
