require 'sinatra'

set :cache, Dalli::Client.new

get '/log/:data' do |data|
  log = settings.cache.get('log') || ''
  log << data
  settings.cache.set 'log', log
  log
end

get '/reset' do
  settings.cache.clear
  'cleaned'
end