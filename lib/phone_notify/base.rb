module PhoneNotify
	class Base
    attr_reader :api

    @@wsdl = 'http://ws.cdyne.com/NotifyWS/PhoneNotify.asmx?wsdl'
    FATAL_ERROR_CODES = [3,4,5,6,7,9,10,11,13,14,15,16,17,22,23,25,26,28,32,33,35,36,37,38,39,40]
    
    def initialize(license_key)
      @api = SOAP::WSDLDriverFactory.new(@@wsdl).create_rpc_driver
      @license_key = license_key
    end

    def get_voices()
      response = @api.getVoices('')
      soap_mapping_objects = response.getVoicesResult
      voices = soap_mapping_objects["Voice"]
      voices.collect {|v| { :id => v["VoiceID"],
                            :name => v["VoiceName"],
                            :gender => v["VoiceGender"],
                            :age => v["VoiceAge"],
                            :language => v["VoiceLanguage"],
                            :summary => v["VoiceSummary"]}
        }
    end

    def get_version()
      response = @api.GetVersion('')
      response.getVersionResult
    end

    def create_basic_message(phone_number, message, options={})
      #validate phone number
      { :PhoneNumberToDial  => phone_number,
        :TextToSay          => message,
        :LicenseKey         => @license_key,
        :CallerID           => options[:caller_id_number] || '1-866-665-4386',
        :CallerIDname       => options[:caller_id_name] || 'CDYNE Notify',
        :VoiceID            => options[:voice_id] || 2 }
    end

    def send_basic_message(data)
      response = @api.NotifyPhoneBasic(data)
      result = response.notifyPhoneBasicResult

      # TODO - Not returning a boolean or
      # nil on failure makes checking for failure
      # difficult but not having a response code
      # makes it impossible to know why the request
      # failed, want to satisfy both needs
      unless is_error?(result.responseCode)
        result.queueID
      else
        result.responseCode.to_i
      end
    end

    def is_error?(response_code)
      response_code = response_code.to_i if response_code.is_a?(String)
      FATAL_ERROR_CODES.include?(response_code)
    end

    def get_queue_id_status(queue_id)
      response = @api.GetQueueIDStatus({
              :QueueID => queue_id,
              :LicenseKey => @license_key })
      result = response.getQueueIDStatusResult

      {	:response_code 			=> result.responseCode,
        :response_text			=> result.responseText,
        :call_answered			=> result.callAnswered,
        :queue_id						=> result.queueID,
        :try_count					=> result.tryCount,
        :demo								=> result.demo,
        # TODO - Not sure how to break down a object
        # of SOAP::Mapping::Object without a method
        # from the API so leave it out for now
        #:digits_pressed			=> resp.digitsPressed,
        :machine_detection	=> result.machineDetection,
        :duration						=> result.duration,
        :start_time					=> result.startTime,
        :end_time						=> result.endTime,
        :minute_rate				=> result.minuteRate,
        :call_complete			=> result.callComplete }
    end

    def get_response_codes
      @response_codes = {}
      soap_map_obj_array = @api.getResponseCodes('').getResponseCodesResult["Response"]
      soap_map_obj_array.each do |map_obj|
        @response_codes.merge!( map_obj["ResponseCode"].to_i =>  map_obj["ResponseText"] )
      end
      @response_codes
    end

    def upload_sound_file(data, name)
      resp = @api.UploadSoundFile({
              :FileBinary => data,
              :SoundFileID => name,
              :LicenseKey => @license_key })
      resp.UploadSuccessful == 'true' ? true : resp.ErrorResponse
    end

    def return_sound_file_ids()
      resp = @api.ReturnSoundFileIDs({:LicenseKey => @license_key})
      soap_mapping_object = resp.returnSoundFileIDsResult
      soap_mapping_object["string"].to_a
    end

    def remove_sound_file(sound_file_id)
      resp = @api.RemoveSoundFile({
        :SoundFileID => sound_file_id,
        :LicenseKey => @license_key })

      resp.removeSoundFileResult	== 'true' ? true : false
    end
	end
end
