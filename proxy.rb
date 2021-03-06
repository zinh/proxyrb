require 'sinatra'
require 'open-uri'

use Rack::Auth::Basic do |username, password|
  username == ENV['basic_auth_username'] && password == ENV['basic_auth_password']
end

get '/' do
  url = params[:path]
  user_agent = request.env['HTTP_USER_AGENT']
  ProxyHandler.http(url, {'User-Agent' => user_agent, redirect: false})
end

class ProxyHandler
  def self.http(url, options = {})
    open(url, options)
  rescue OpenURI::HTTPRedirect => e
    url = e.uri
    retry
  end
end
