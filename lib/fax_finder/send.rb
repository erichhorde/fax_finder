module FaxFinder
  module SendClassMethods
    def post
      return Response.new(nil)      
    end
    
    def construct_xml(recipient_fax, external_url, options={})
      xml = ""
      builder = Builder::XmlMarkup.new(:target => xml, :indent => 2 )      
      builder.instruct!(:xml, :version=>'1.0', :encoding=>'UTF-8')
      
      builder.schedule_fax {
        builder.cover_page do
          builder.subject(options[:subject])
          builder.comment(options[:comment])
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
        time=options[:schedule_all_at]
        time=time.utc if time && !time.utc?
        builder.schedule_all_at(time.strftime(Request::TIME_FORMAT)) if time
      }
      xml
    end
  end
  class Send < Request
  end
end

FaxFinder::Send.send(:extend, FaxFinder::SendClassMethods)
