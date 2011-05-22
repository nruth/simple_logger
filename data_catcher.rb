require 'sinatra'

set :cache, Dalli::Client.new

get '/log' do
  @log_data = settings.cache.get('log')
  erb :log
end

get '/log/:data' do |data|
  written = false
  settings.cache.add 'log', ''
  until written do
    written = settings.cache.cas('log') { |log| log + data }
  end
  settings.cache.get 'log'  
end

get '/reset' do
  settings.cache.delete 'log'
  'cleaned'
end
