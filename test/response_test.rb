require File.dirname(__FILE__) + '/test_helper'

module FaxFinder
  class ResponseConstructorTest<Test::Unit::TestCase
    def setup
      @response=Response.new(Nokogiri::XML(File.open('test/fixtures/send_response_success.xml')))
    end
    
    def test_handles_nil
      assert_nothing_thrown { Response.new(nil) }
    end

    def test_sets_state
      assert_equal('preprocessing', @response.state)
    end
    
    def test_set_fax_key
      assert_equal('0000001B', @response.fax_key)
    end
    
    def test_set_entry_key
      assert_equal('0000', @response.entry_key)
    end
    
    def test_set_fax_entry_url
      assert_equal('https://192.168.2.1/ffws/v1/ofax/0000001B/0000', @response.fax_entry_url)
    end

    def test_set_try_number
      assert_equal(1, @response.try_number)
    end
    
    def test_set_message
      assert_equal('Success', @response.message)
    end
  end
  
  class ResponseMethodsTest<Test::Unit::TestCase
    def setup
      @response=Response.new#(Nokogiri::XML(File.open('test/fixtures/send_response_success.xml')))
    end
    
    def extract_fax_and_entry_key_handles_nil
      assert_nothing_thrown { 
        assert_equal([nil, nil], @response.extract_fax_and_entry_key(nil) )
      }
    end

    def extract_fax_and_entry_key_handles_parses_url
      assert_nothing_thrown { @response.extract_fax_and_entry_key(nil) }
    end
    
    def extract_fax_and_entry_key_handles_parses_url
      assert_equal(['0000001B','0000'], @response.extract_fax_and_entry_key('https://192.168.2.1/ffws/v1/ofax/0000001B/0000'))
    end
   
  end
end