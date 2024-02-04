# tests/tests.rb

require 'minitest/autorun'
require './geppetto'

class TestGeppetto < Minitest::Test
  def test_start_chat
    brain_bot = BrainBot.new
    @user_input = URI.encode_www_form_component("Hello")
    response = brain_bot.get_bot_response
    assert_equal response.split[0], "Hello", "Check your API info"
  end
end


  
