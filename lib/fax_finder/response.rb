module FaxFinder
  module Responses
    ERROR_GSUB='####MESSAGE#####'
    
    APPLICATION_ERROR =<<-EOXML
    <response>
      <message>####MESSAGE#####</message>
      <fax_entry>
        <state>error</state>
      </fax_entry>
    </response>    
    EOXML
        
    NO_CONNECTION = APPLICATION_ERROR.gsub('####MESSAGE#####', 'No connection to fax server')

    UNAUTHORIZED = APPLICATION_ERROR.gsub('####MESSAGE#####', 'Unauthorized to communicate with fax server.')

    BAD_SSL_CONFIG = APPLICATION_ERROR.gsub('####MESSAGE#####', 'Your connection is not configured correctly.  If you are using SSL, make sure the port is is set to 443.')
    
  end

  class Response
    attr_reader :doc, :state, :fax_entry_url, :fax_key, :entry_key, :try_number, :message, :schedule_message
    REGEXP_KEYS=/([0-9A-F]+)\/([0-9A-F]+)$/
    XPATH_STATE='//fax_entry/state'
    XPATH_FAX_ENTRY_URL='//fax_entry/fax_entry_url'
    XPATH_TRY_NUMBER='//fax_entry/try_number'
    XPATH_MESSAGE='//response/message'
    XPATH_SCHEDULE_MESSAGE='//fax_entry/schedule_message'
    
    def initialize(_doc)
      @doc=_doc
      if self.doc
        @message=self.doc.xpath(XPATH_MESSAGE).text
        @state=self.doc.xpath(XPATH_STATE).text
        if @state != 'error'
          @fax_entry_url=self.doc.xpath(XPATH_FAX_ENTRY_URL).text
          @fax_key, @entry_key=self.extract_fax_and_entry_key(self.fax_entry_url)
          @try_number=self.doc.xpath(XPATH_TRY_NUMBER).text.to_i
          @schedule_message=self.doc.xpath(XPATH_SCHEDULE_MESSAGE).text
        end
      end
    end

    def extract_fax_and_entry_key(_url)
      match=REGEXP_KEYS.match(_url)
      match[1,2] if match
    end

  end
  
end