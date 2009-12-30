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
    resp = @api.getVoices('')
		resp.getVoicesResult
  end

  def get_version()
    resp = @api.GetVersion('')
		resp.getVersionResult
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
    resp = @api.NotifyPhoneBasic(data)

		if resp.ResponseCode ==  0
			resp.QueueID
		else
			resp.ResponseCode
		end
  end

	def get_queue_id_status(queue_id)
		resp = @api.GetQueueIDStatus({	
						:QueueID => queue_id,
						:LicenseKey => LICENSE_KEY })

		{	:response_code 			=> resp.ResponseCode,
			:response_text			=> resp.ResponseText,
			:call_answered			=> resp.CallAnswered,
			:queue_id						=> resp.QueueID,
			:try_count					=> resp.TryCount,
			:demo								=> resp.Demo,
			:digits_pressed			=> resp.DigitsPressed,
			:machine_detection	=> resp.MachineDetection,
			:duration						=> resp.Duration,
			:start_time					=> resp.StartTime,
			:end_time						=> resp.EndTime,
			:minute_rate				=> resp.MinuteRate,
			:country						=> resp.Country,
			:call_complete			=> resp.CallComplete }
	end

  def upload_sound_file(data, name)
  	resp = @api.UploadSoundFile({ 
						:FileBinary => data, 
						:SoundFileID => name, 
						:LicenseKey => LICENSE_KEY })
		if resp.UploadSuccessful
			resp.UploadSuccessful
		else
			resp.ErrorResponse
		end
  end
 
	def return_sound_file_ids()
		resp = @api.ReturnSoundFileIDs({:LicenseKey => LICENSE_KEY})	
		resp.returnSoundFileIDsResult
	end 

	def remove_sound_file(sound_file_id)
		resp = @api.RemoveSoundFile({
			:SoundFileID => sound_file_id,
			:LicenseKey => LICENSE_KEY })
		resp.ReturnSoundFileResult	
	end
end
