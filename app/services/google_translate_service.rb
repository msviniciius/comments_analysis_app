require 'httparty'
require 'uri'

class GoogleTranslateService
  include HTTParty
  base_uri 'https://translate.googleapis.com'

  def self.translate(text, from: 'auto', to: 'pt')
    encoded_text = URI.encode_www_form_component(text)
    url = "/translate_a/single?client=gtx&sl=#{from}&tl=#{to}&dt=t&q=#{encoded_text}"

    response = get(url)
    if response.success?
      translations = response.parsed_response
      translations[0][0][0]
    else
      nil
    end
  end
end
