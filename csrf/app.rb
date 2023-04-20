require 'sinatra'
require 'erb'
require 'tzinfo'

before do
  headers 'Access-Control-Allow-Origin' => 'gambiarrabank.com',
          'Access-Control-Allow-Methods' => %w[OPTIONS GET POST],
          'Access-Control-Allow-Headers' => 'Content-Type'
end

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
      <input type="submit" value="Submit">
    </form>
  HTML
end

get '/signin' do
  expiration_time = TZInfo::Timezone.get('America/Sao_Paulo').now + 3600
  pp expiration_time
  # response.set_cookie('some-random-cookie', value: 'some-random-value', http_only: true, same_site: 'Strict')
  # response.set_cookie('sessid', value: 'somerandomstring', http_only: true, same_site: 'Strict')

  response.set_cookie('some-random-cookie', value: 'some-random-value', http_only: true, expires: expiration_time)
  response.set_cookie('sessid', value: 'somerandomstring', http_only: true, expires: expiration_time)
end

# Handle the POST request
post '/submit' do
  # pp request.env['HTTP_REFERER']
  response.headers['Access-Control-Allow-Origin'] = 'http://gambiarrabank.com'

  "$#{params[:amount]} transferred to <b>account:urn:#{ERB::Util.html_escape params['destination-account']} </b> successfully!"
end
