require 'net/http'

desc "This task is called by Heroku Scheduler add-on for prevent Heroku idling"
# usage: rake 'ping[k-sasaki-bot.herokuapp.com]'
task :ping, :url do |task, args|
  url = args[:url]
  Net::HTTP.start(url) {|http|
    p "ping? (#{url})"
    req = Net::HTTP::Get.new('/')
    # req.basic_auth 'username', 'password'
    response = http.request(req)
    p "pong! (#{response.header})"
  }
end