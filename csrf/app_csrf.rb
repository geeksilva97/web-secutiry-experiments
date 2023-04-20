require 'sinatra'
require 'erb'

csrf_token = 'pretend-i-am-generated-and-saved-in-DB'

get '/' do
  response.headers['myheader'] = 'thats-my-header'

  <<-HTML
    <h1>Transfer Money</h1>
    <form method="POST" action="/submit">
      <label for="name">Amount ($):</label>
      <input type="number" name="amount" id="amount">
      <br>
      <label for="name">Destination account:</label>
      <input type="number" name="destination-account" id="destination-account">
      <br>

      <input type="hidden" value="#{csrf_token}" name="csrf_token" />
      <input type="submit" value="Submit">
    </form>
  HTML
end

get '/signin' do
  response.set_cookie('some-random-cookie', value: 'some-random-value', http_only: true)
  response.set_cookie('sessid', value: 'somerandomstring', http_only: true)
end

post '/submit' do
  return 'Unable to transfer money. Invalid csrf token' if params['csrf_token'] != csrf_token

  "$#{params[:amount]} transferred to <b>account:urn:#{ERB::Util.html_escape params['destination-account']} </b> successfully!"
end
