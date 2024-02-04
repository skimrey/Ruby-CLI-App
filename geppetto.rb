require 'net/http'
require 'uri'
require 'action_view'

class BrainBot
  include ActionView::Helpers::SanitizeHelper

  attr_accessor :exit_flag

  def initialize
    @exit_flag = false
  end

  def start_chat
    puts "Hi, I'm Brainbot. Pleased to conquer you. Type 'exit' at any time to leave the chat."

    while !@exit_flag
      prompt_user
      get_bot_response
    end
  end

  

  def prompt_user
    prompt = gets.chomp
    @exit_flag = true if prompt.downcase == 'exit'
    @user_input = URI.encode_www_form_component(prompt)
  end

  def get_bot_response
    url = URI.parse("https://botlibre.com/rest/api/form-chat?instance=46893897&message=#{@user_input}&application=6410829901268491461")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port, use_ssl: url.scheme == 'https') {|http|
      http.request(req)
    }

    plain_text_response = strip_tags(res.body)
    plain_text_response = plain_text_response.gsub("&lt;button&gt;", '')
    plain_text_response = plain_text_response.gsub("&lt;/button&gt;", '')
    plain_text_response = plain_text_response.gsub("Brain Bot: ", '')

    puts "#{plain_text_response}"
    return plain_text_response
  end
end

if __FILE__ == $0
  brain_bot = BrainBot.new
  brain_bot.start_chat
end
