require 'sinatra'

set :cache, Dalli::Client.new

get '/log' do
  settings.cache.add 'log', ''
  @log_data = settings.cache.get('log')
  erb :log
end

get '/log/:data' do |data|
  written = false
  ensure_key_exists
  until written do
    written = settings.cache.cas('log') { |log| log + data }
  end
  settings.cache.get 'log'  
end

get '/reset' do
  settings.cache.delete 'log'
  'cleaned'
end

def ensure_key_exists
  settings.cache.add 'log', ''
end