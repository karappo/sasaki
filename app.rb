require 'sinatra'
require 'httparty'
require 'json'
require 'net/http'
require 'uri'

post '/gateway' do
  message = params[:text].gsub(params[:trigger_word], '').strip

  action, repo = message.split('_').map {|c| c.strip.downcase }
  repo_url = "https://api.github.com/repos/#{repo}"

  case action
    when 'issues'
      resp = HTTParty.get(repo_url)
      resp = JSON.parse resp.body
      # respond_message "There are #{resp['open_issues_count']} open issues on #{repo} (2)"
      respond_message "#{params}"
  end
end

get '/terada/entered' do
  post_message
end

def respond_message message
  content_type :json
  {text: message, username: ENV['USER_NAME']}.to_json
end

def post_message
  uri = URI.parse(ENV['WEBHOOK_URL'])
  https = Net::HTTP.new(uri.host, uri.port)

  https.use_ssl = true
  req = Net::HTTP::Post.new(uri.request_uri)

  req['Content-Type'] = 'application/json' # httpリクエストヘッダの追加
  payload = {
    'username' => ENV['USER_NAME'],
    'text' => 'terada entered the office.'
  }.to_json
  req.body = payload # リクエストボデーにJSONをセット
  res = https.request(req)
end