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
      if external_url.nil? && _content=options[:content]
        if _content.is_a?(String)
          content=_content
        else
          _content.rewind
          _content.binmode
          attachment_name = options[:attachment_name] || File.basename(_content.path)
          content=Base64.encode64(_content.read).gsub(/\n/, '')
        end
      else
        content=nil
      end
      
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
          if external_url
            builder.location('external')
            builder.url(external_url)
          elsif content
            builder.content(content)
            builder.name(options[:filename])
            builder.attachment_name(attachment_name)
            builder.content_transfer_encoding('base64')
            builder.location('inline')
            builder.name(attachment_name)
            builder.content_type(options[:content_type])
          end
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
