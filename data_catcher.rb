require 'sinatra'

set :cache, Dalli::Client.new

get '/log/:data' do |data|
  written = false
  settings.cache.add 'log', ''
  until written do
    written = settings.cache.cas('log') { log + data }
  end
end

get '/reset' do
  settings.cache.delete 'log'
  'cleaned'
end