require 'sinatra'

set :cache, Dalli::Client.new

get '/' do
  settings.cache.set('color', 'blue')
  settings.cache.get('color')
end
