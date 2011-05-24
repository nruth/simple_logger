require 'sinatra'

set :cache, Dalli::Client.new

#view the data
get '/log' do
  settings.cache.add 'log', ''
  @log_data = settings.cache.get('log')
  erb :'log.html'
end

#send new data
get '/log/:data' do |data|
  written = false
  ensure_key_exists
  until written do
    written = settings.cache.cas('log') { |log| log << "\n #{data}" }
  end
  settings.cache.get 'log'  
end

#clean out the data to blank
get '/reset' do
  settings.cache.delete 'log'
  settings.cache.add 'log', ''
  'cleaned'
end

def ensure_key_exists
  settings.cache.add 'log', ''
end