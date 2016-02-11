require 'sinatra'
require 'httparty'
require 'json'
require 'net/http'
require 'uri'
require 'dotenv'
Dotenv.load

get '/' do
 "Hello, I'm Sasaki."
end

get '/:username/entered' do
  post_message "#{params[:username]} entered the office."
end

get '/:username/exited' do
  post_message "#{params[:username]} exited the office."
end

def post_message(text)
  uri = URI.parse(ENV['WEBHOOK_URL'])
  https = Net::HTTP.new(uri.host, uri.port)

  https.use_ssl = true
  req = Net::HTTP::Post.new(uri.request_uri)

  req['Content-Type'] = 'application/json' # httpリクエストヘッダの追加
  payload = {
    username: ENV['USER_NAME'],
    text: text
  }.to_json
  req.body = payload # リクエストボデーにJSONをセット
  res = https.request(req)
end