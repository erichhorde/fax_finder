require File.dirname(__FILE__) + '/test_helper'

module FaxFinder

    class RequestSetupTest<Test::Unit::TestCase
      def setup
        Request.configure('example.com', 'user', 'password', 123, true)
      end

      def test_setup_host
        assert_equal('example.com', Request.host)
      end

      def test_setup_user
        assert_equal('user', Request.user)
      end

      def test_setup_password
        assert_equal('password', Request.password)
      end

      def test_setup_port
        assert_equal(123, Request.port)
      end

      def test_setup_ssl
        assert_equal(true, Request.ssl)
      end

    end

    class RequestResetTest<Test::Unit::TestCase
      def setup
        Request.configure('example.com', 'user', 'password', 123, true)
        Request.reset
      end

      def test_resets_host
        assert_nil(Request.host)
      end

      def test_resets_user
        assert_nil(Request.user)
      end

      def test_resets_port
        assert_nil(Request.port)
      end

      def test_resets_password
        assert_nil(Request.password)
      end
      
      def test_resets_port
        assert_equal(80, Request.port)
      end

      def test_resets_ssl
        assert_equal(false, Request.ssl)
      end

    end

    class MockRequest<FaxFinder::Request
      def self.post
        super(){
          construct_http_request
        }
      end

      def self.construct_http_request
        request = Net::HTTP::Get.new('/ffws/v1/ofax')
        request.basic_auth self.user, self.password
        request.set_content_type(Request::CONTENT_TYPE)
        request
      end
    end
    
    class RequestPostConnectionFailureTest<Test::Unit::TestCase
      def setup
        @response=nil
        Request.configure(nil, 'user', 'password', 123, true)
        @post=lambda{
          @response=MockRequest.post
        }
      end
      
      def test_handles_connection_failure
        @host=nil
        assert_nothing_thrown { @post.call }
      end
      
      def test_returns_a_response
        @post.call
        assert_instance_of(FaxFinder::Response, @response)
      end
      
      def test_sets_the_state
        @post.call
        assert_equal('error', @response.state)        
      end

      def test_sets_the_message
        @post.call
        assert_equal('No connection to fax server', @response.message)        
      end
      
    end
    
end
