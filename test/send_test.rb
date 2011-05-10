require File.dirname(__FILE__) + '/test_helper'
require "base64"
module FaxFinder
  OPTIONS={:subject=>'Something',
    :comment=>'Comment',
    :recipient_name=>'recipient_name',
    :recipient_organization=>'recipient_organization',
    :recipient_phone_number=>'5647382910',
    :sender_fax_number=>'0123456789',
    :sender_name=>'sender_name',
    :sender_organization=>'sender_organization',
    :sender_phone_number=>'0987654321',
    :schedule_all_at=>Time.now.utc
  }
  
  class SendPostTest<Test::Unit::TestCase
    def setup
      Request.configure('example.com', 'user', 'password')
    end
    
    def test_post
      Send.post('user', 'password')
    end
    
    def test_posts_returns_response
      assert_instance_of(FaxFinder::Response, Send.post(nil))
    end
  end

  class SendConstructXMLTest<Test::Unit::TestCase
    def setup
      @doc=Nokogiri::XML(Send.construct_xml('1234567890', OPTIONS.merge(:external_url=>'https://localhost/something')))
    end
    
    def test_returns_string_and_doesnt_blow_up
      assert_nothing_thrown { assert_instance_of(String, Send.construct_xml(nil)) }
    end

    def test_includes_subject
      assert_equal('Something', @doc.xpath('//schedule_fax/cover_page/subject').text)
    end

    def test_includes_comment
      assert_equal('Comment', @doc.xpath('//schedule_fax/cover_page/comment').text)
    end

    def test_includes_recipient_name
      assert_equal('recipient_name', @doc.xpath('//schedule_fax/recipient/name').text)
    end

    def test_includes_recipient_organization
      assert_equal('recipient_organization', @doc.xpath('//schedule_fax/recipient/organization').text)
    end

    def test_includes_recipient_fax_number
      assert_equal('1234567890', @doc.xpath('//schedule_fax/recipient/fax_number').text)
    end

    def test_includes_recipient_phone_number
      assert_equal('5647382910', @doc.xpath('//schedule_fax/recipient/phone_number').text)
    end

    def test_includes_sender_fax
      assert_equal('0123456789', @doc.xpath('//schedule_fax/sender/fax_number').text)
    end

    def test_includes_sender_organization
      assert_equal('sender_organization', @doc.xpath('//schedule_fax/sender/organization').text)
    end

    def test_includes_sender_fax_number
      assert_equal('0123456789', @doc.xpath('//schedule_fax/sender/fax_number').text)
    end

    def test_includes_sender_phone_number
      assert_equal('0987654321', @doc.xpath('//schedule_fax/sender/phone_number').text)
    end

    def test_includes_attachment_location
      assert_equal('external', @doc.xpath('//schedule_fax/attachment/location').text)
    end

    def test_includes_attachment_url
      assert_equal('https://localhost/something', @doc.xpath('//schedule_fax/attachment/url').text)
    end

    def test_includes_schedule_all_at
      assert_equal(Time.now.utc.strftime(Request::TIME_FORMAT), @doc.xpath('//schedule_fax/schedule_all_at').text)
    end

    def test_converts_to_utc
      @doc=Nokogiri::XML(Send.construct_xml('1234567890', OPTIONS.merge(:schedule_all_at=>Time.now, :external_url=>'https://localhost/something')))
      assert_equal(Time.now.utc.strftime(Request::TIME_FORMAT), @doc.xpath('//schedule_fax/schedule_all_at').text)
    end

  end
  
  class SendConstructXMLTestEmbedDocument<Test::Unit::TestCase
    def setup
      @file=File.open(File.join('test', 'fixtures', 'test.pdf'))
      @options=OPTIONS.merge(
        :content=>@file,
        :content_type=>'application/pdf'
      )
      @doc=Nokogiri::XML(Send.construct_xml('1234567890', @options))
    end
    
    def test_encodes_files
      @file.rewind
      @file.binmode
      encoded=Base64.encode64(@file.read).gsub(/\n/, '')
      assert_equal(encoded, @doc.xpath('//schedule_fax/attachment/content').text)
    end
    
    def test_should_call_rewind_on_the_file
      @file.rewind
      @file.binmode
      encoded=Base64.encode64(@file.read).gsub(/\n/, '')
      @doc=Nokogiri::XML(Send.construct_xml('1234567890', @options.merge(:content=>@file)))
      assert_equal(encoded, @doc.xpath('//schedule_fax/attachment/content').text)
    end
  
    def test_including_an_external_url_will_override_embedded_document
      @doc=Nokogiri::XML(Send.construct_xml('1234567890', @options.merge(:external_url=>'https://localhost/something')))
      assert_empty(@doc.xpath('//schedule_fax/attachment/content'))
    end

    def test_supports_passing_in_a_base64_string_directly
      @file.rewind
      @file.binmode
      encoded=Base64.encode64(@file.read).gsub(/\n/, '')
      
      @doc=Nokogiri::XML(Send.construct_xml('1234567890', @options.merge(:content=>encoded)))
      assert_equal(encoded, @doc.xpath('//schedule_fax/attachment/content').text)
    end
    
    def test_sets_the_content_type
      assert_equal('application/pdf', @doc.xpath('//schedule_fax/attachment/content_type').text)      
    end
    
    def test_sets_location_as_inline
      assert_equal('inline', @doc.xpath('//schedule_fax/attachment/location').text)      
    end
    
    def test_sets_the_filename_from_the_file_path
      assert_equal(File.basename(@file.path), @doc.xpath('//schedule_fax/attachment/name').text)
    end

    def test_sets_the_content_transfer_encoding
      assert_equal('base64', @doc.xpath('//schedule_fax/attachment/content_transfer_encoding').text)
    end
    
    def test_supports_overrding_filename
      @doc=Nokogiri::XML(Send.construct_xml('1234567890', @options.merge(:attachment_name=>'attachment.name')))
      assert_equal('attachment.name', @doc.xpath('//schedule_fax/attachment/name').text)
    end
    
  end
  
  class SendConstructHttpRequestTest<Test::Unit::TestCase
    def setup
      Request.configure('example.com', 'user', 'password')
      @http_request=Send.construct_http_request('1234567890', OPTIONS.merge(:external_url=>'https://localhost/something'))
    end

    def test_returns_a_post
      assert_instance_of(Net::HTTP::Post, @http_request)
    end
    
    def test_sets_body
      assert_equal(Send.construct_xml('1234567890', OPTIONS.merge(:external_url=>'https://localhost/something')), @http_request.body)
    end
    
    def test_sets_path
      assert_equal(Request::BASE_PATH, @http_request.path)
    end
    
  end

end
