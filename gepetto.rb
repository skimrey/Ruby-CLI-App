require 'net/http'
require 'uri'
require 'action_view'

include ActionView::Helpers::SanitizeHelper
puts "Hi, I'm Brainbot. Pleased to conquer you."
x = ""
while x != "exit\n"
  prompt = gets
  message = URI.encode_www_form_component(prompt)
  url = URI.parse("https://botlibre.com/rest/api/form-chat?instance=46893897&message=#{message}&application=6410829901268491461")
  req = Net::HTTP::Get.new(url.to_s)
  res = Net::HTTP.start(url.host, url.port, use_ssl: url.scheme == 'https') {|http|
    http.request(req)
}

# Get plain text response and remove HTML-like elements (buttons)
  
  plain_text_response = strip_tags(res.body)
  plain_text_response = plain_text_response.gsub("&lt;button&gt;", '')
  plain_text_response = plain_text_response.gsub("&lt;/button&gt;", '')
  plain_text_response = plain_text_response.gsub("Brain Bot: ", '')
  puts "#{plain_text_response}"
  x = prompt
end
