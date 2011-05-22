require 'sinatra'

set :cache, Dalli::Client.new

get '/:data' do |data|
  log = settings.cache.get 'log'
  log << data
  settings.cache.set 'log', log
  log
end
