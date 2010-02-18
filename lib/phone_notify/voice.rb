module PhoneNotify
  class Voice
    attr_accessor :id, :gender, :age, :language, :summary
    attr_writer :id, :gender, :age, :language, :summary

    def initialize(attrs)
      @id = attrs[:id]
      @gender = attrs[:gender]
      @age = attrs[:age]
      @language = attrs[:language]
      @summary = attrs[:summary]
    end

    class << self
      def all(api)
        api.getVoices('').getVoicesResult["Voice"].collect { |v| new(api_attrs_to_h(v)) }
      end

      private
      def api_attrs_to_h(api_voice)
        { :id => api_voice["VoiceID"].to_i,
          :gender => api_voice["VoiceGender"],
          :age => api_voice["VoiceAge"],
          :language => api_voice["VoiceLanguage"],
          :summary => api_voice["VoiceSummary"]
        }
      end
    end
  end
end
