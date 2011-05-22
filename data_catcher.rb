require 'sinatra'

set :cache, Dalli::Client.new

get '/log/:data' do |data|
  written = false
  settings.cache.add 'log', ''
  until written do
    written = settings.cache.cas('log') { |log| log + data }
  end
  javascript + settings.cache.get 'log'
end

get '/reset' do
  settings.cache.delete 'log'
  'cleaned'
end

def javascript
<<-JS
<script language="JavaScript"> 
// Configure refresh interval (in seconds) 
var refreshinterval=5 
// Shall the coundown be displayed inside your status bar? Say "yes" 
or "no" below: 
var displaycountdown="yes" 
// Do not edit the code below 
var starttime 
var nowtime 
var reloadseconds=0 
var secondssinceloaded=0 
function starttime() { 
  starttime=new Date() 
  starttime=starttime.getTime() 
  countdown() 
} 
function countdown() { 
  nowtime= new Date() 
  nowtime=nowtime.getTime() 
  secondssinceloaded=(nowtime-starttime)/1000 
  reloadseconds=Math.round(refreshinterval-secondssinceloaded) 
  if (refreshinterval>=secondssinceloaded) { 
    var timer=setTimeout("countdown()",1000) 
    if (displaycountdown=="yes") { 
      window.status="Page refreshing in "+reloadseconds+ " seconds" 
    } 
  } else { 
    clearTimeout(timer) window.location.reload(true) 
  } 
} 
window.onload=starttime 
</script>
JS
end
