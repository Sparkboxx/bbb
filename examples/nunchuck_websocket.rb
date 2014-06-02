require 'sinatra'
require 'sinatra-websocket'

require 'BBB'

class NunchuckService < BBB::Application
  attach Nunchuck, as: :nunchuck

  def initialize
    nunchuck.connect("/dev/i2c-2")
  end

  def start
    Thread.new do
      loop do
        nunchuck.update
      end
    end
    return self
  end

  def add_socket(socket)
    nunchuck.c.on_release do
      socket.send("{c: 'released'}")
    end

    nunchuck.c.on_press do
      socket.send("{c: 'pressed'}")
    end
  end

end

class NunchuckServer < Sinatra::Base
  set :server, 'thin'
  set :sockets, []
  set :nunchuck, NunchuckService.new
  enable :inline_templates

  get '/' do
    if !request.websocket?
      erb :index
    else
      request.websocket do |ws|
        ws.onopen do
          ws.send("Hello World!")
          ws.send("Opened the websocket")
          settings.sockets << ws
          settings.nunchuck.add_socket(ws)
        end

        ws.onclose do
          warn("websocket closed")
          settings.sockets.delete(ws)
        end
      end
    end
  end

  run! if app_file == $0
end

__END__
@@ index
<html>
  <body>
     <h1>Simple Echo & Chat Server</h1>
     <form id="form">
       <input type="text" id="input" value="send a message"></input>
     </form>
     <div id="msgs"></div>
  </body>

  <script type="text/javascript">
    window.onload = function(){
      (function(){
        var show = function(el){
          return function(msg){ el.innerHTML = msg + '<br />' + el.innerHTML; }
        }(document.getElementById('msgs'));

        var ws       = new WebSocket('ws://' + window.location.host + window.location.pathname);
        ws.onopen    = function()  { show('websocket opened'); };
        ws.onclose   = function()  { show('websocket closed'); }
        ws.onmessage = function(m) { show('websocket message: ' +  m.data); };

        var sender = function(f){
          var input     = document.getElementById('input');
          input.onclick = function(){ input.value = "" };
          f.onsubmit    = function(){
            ws.send(input.value);
            input.value = "send a message";
            return false;
          }
        }(document.getElementById('form'));
      })();
    }
  </script>
</html>

