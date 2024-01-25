require 'sinatra'
require 'net/http'
require 'uri'
require 'action_view'
include ActionView::Helpers::SanitizeHelper

set :chat_history, []

get '/' do
  erb :index, locals: { chat_history: settings.chat_history.reverse }
end

post '/send_message' do
  user_input = params[:user_input]
  message = URI.encode_www_form_component(user_input)
  url = URI.parse("https://botlibre.com/rest/api/form-chat?instance=46893897&message=#{message}&application=6410829901268491461")
  req = Net::HTTP::Get.new(url.to_s)
  res = Net::HTTP.start(url.host, url.port, use_ssl: url.scheme == 'https') { |http|
    http.request(req)
  }

  # Get plain text response and remove HTML-like elements (buttons)
  plain_text_response = strip_tags(res.body)
  plain_text_response = plain_text_response.gsub("&lt;button&gt;", '')
  plain_text_response = plain_text_response.gsub("&lt;/button&gt;", '')
  plain_text_response = plain_text_response.gsub("Brain Bot: ", '')

  settings.chat_history.unshift({ user: user_input, bot: plain_text_response })  # Prepend new entry to chat history

  erb :index, locals: { chat_history: settings.chat_history.reverse }
end

__END__

@@index
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Brainbot Chat</title>
  <style>
    /* Center chat vertically and horizontally */
    body {
      display: flex;
      align-items: center;
      justify-content: center;
      height: 100vh;
      margin: 0;
      background-color: #f0f0f0;
    }

    #chat-container {
      width: 400px; /* Set the width as needed */
      max-height: 500px; /* Set the max height to limit vertical expansion */
      overflow-y: auto; /* Enable vertical scroll when content exceeds max height */
      padding: 16px;
      background-color: white;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }

    /* Style chat messages */
    .message {
      margin-bottom: 8px;
    }

    .user {
      color: #2196F3;
    }

    .bot {
      color: #4CAF50; 
    }
  </style>
</head>
<body>
  <div id="chat-container">
    <% chat_history.each do |entry| %>
      <div class="message">
        <strong class="user">User:</strong> <%= entry[:user] %>
      </div>
      <div class="message">
        <strong class="bot">Bot:</strong> <%= entry[:bot] %>
      </div>
    <% end %>

    <form method="post" action="/send_message">
      <input type="text" name="user_input" placeholder="Type your message...">
      <input type="submit" value="Send">
    </form>
  </div>
</body>
</html>
