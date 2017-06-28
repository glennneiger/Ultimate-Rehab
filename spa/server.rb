require 'yaml'
require 'sinatra'
require 'sinatra/reloader'

MODE = ENV['UR_MODE'] || 'dev'
CONFIG = YAML.load(File.read(File.join(File.dirname(__FILE__), "..", "config.yaml")))[MODE]

set :bind, CONFIG['frontend_private_ip']
set :port, CONFIG['frontend_private_port']

get "/static/js/:jsfile" do |jsfile|
  return send_file File.join(File.dirname(__FILE__), "js", jsfile)
end

get "/static/css/:cssfile" do |cssfile|
  return send_file File.join(File.dirname(__FILE__), "css", cssfile)
end

get "/static/fonts/:fontsfile" do |fontsfile|
  return send_file File.join(File.dirname(__FILE__), "fonts", fontsfile)
end

get "/static/images/:imagefile" do |imagefile|
  return send_file File.join(File.dirname(__FILE__), "images", imagefile)
end

get "/*" do
  return send_file File.join(File.dirname(__FILE__), "html", "index.html")
end
