require File.dirname(__FILE__) + '/test_helper'

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
      assert_instance_of(FaxFinder::Response, Send.post(nil, nil))
    end
  end

  class SendConstructXMLTest<Test::Unit::TestCase
    def setup
      @doc=Nokogiri::XML(Send.construct_xml('1234567890', 'https://localhost/something', OPTIONS))
    end
    
    def test_returns_string_and_doesnt_blow_up
      assert_nothing_thrown { assert_instance_of(String, Send.construct_xml(nil, nil)) }
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
      @doc=Nokogiri::XML(Send.construct_xml('1234567890', 'https://localhost/something', OPTIONS.merge(:schedule_all_at=>Time.now)))
      assert_equal(Time.now.utc.strftime(Request::TIME_FORMAT), @doc.xpath('//schedule_fax/schedule_all_at').text)
    end

  end
  
  class SendConstructHttpRequestTest<Test::Unit::TestCase
    def setup
      Request.configure('example.com', 'user', 'password')
      @http_request=Send.construct_http_request('1234567890', 'https://localhost/something', OPTIONS)
    end

    def test_returns_a_post
      assert_instance_of(Net::HTTP::Post, @http_request)
    end
    
    def test_sets_body
      assert_equal(Send.construct_xml('1234567890', 'https://localhost/something', OPTIONS), @http_request.body)
    end
    
    def test_sets_path
      assert_equal(Request::BASE_PATH, @http_request.path)
    end
    
  end

end
