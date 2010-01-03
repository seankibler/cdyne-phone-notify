class PhoneNotify
  require 'soap/wsdlDriver'
	require 'yaml'

  attr_reader :api

	config = YAML.load_file("#{RAILS_ROOT}/config/phone_notify.yml")[RAILS_ENV]
	PHONE_NOTIFY_WSDL=config['phone_notify_wsdl']
	LICENSE_KEY=config['license_key']

  def initialize()
    @api = SOAP::WSDLDriverFactory.new(PHONE_NOTIFY_WSDL).create_rpc_driver
  end

  def get_voices()
    response = @api.getVoices('')
		response.getVoicesResult
  end

  def get_version()
    response = @api.GetVersion('')
		response.getVersionResult
  end

  def create_basic_message(phone_number, message, options={})
		#validate phone number
    { :PhoneNumberToDial  => phone_number,
      :TextToSay          => message,
      :LicenseKey         => LICENSE_KEY,
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
		if result.responseCode ==  '0'
			result.queueID
		else
			result.responseCode
		end
  end

	def get_queue_id_status(queue_id)
		response = @api.GetQueueIDStatus({	
						:QueueID => queue_id,
						:LicenseKey => LICENSE_KEY })
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

  def upload_sound_file(data, name)
  	resp = @api.UploadSoundFile({ 
						:FileBinary => data, 
						:SoundFileID => name, 
						:LicenseKey => LICENSE_KEY })
		resp.UploadSuccessful == 'true' ? true : resp.ErrorResponse
  end
 
	def return_sound_file_ids()
		resp = @api.ReturnSoundFileIDs({:LicenseKey => LICENSE_KEY})	
		resp.returnSoundFileIDsResult
	end 

	def remove_sound_file(sound_file_id)
		resp = @api.RemoveSoundFile({
			:SoundFileID => sound_file_id,
			:LicenseKey => LICENSE_KEY })

		resp.removeSoundFileResult	== 'true' ? true : false
	end
end
