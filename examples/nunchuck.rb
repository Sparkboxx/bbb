require 'sinatra'
require 'sinatra-websocket'

require 'BBB'

class Circuit < BBB::Circuit
  def initialize
    attach BBB::Components::Nunchuck, pin: "/dev/i2c-2", as: :nunchuck
  end
end

class NunchuckService < BBB::Application
  circuit Circuit.new

  def start
    Thread.new do
      loop do
        nunchuck.update
      end
    end
    self
  end

  def add_socket(socket)
    pressed = lambda { |value| socket.send("{c: 'pressed'}") }
    released = lambda { |value| socket.send("{c: 'released'}") }

    nunchuck.c.release_callbacks << pressed
    nunchuck.c.press_callbacks << released
  end

end

class NunchuckServer < Sinatra::Base
  set :server, 'thin'
  set :sockets, []
  set :nunchuck, NunchuckService.new.start
  enable :inline_templates

  get '/test' do
    "Testing 234"
  end

  get '/' do
    if !request.websocket?
      erb :index
    else
      request.websocket do |ws|
        ws.onopen do
          ws.send("Hello World!")
          settings.sockets << ws
          settings.nunchuck.add_socket(ws)
        end

        ws.onclose do
          warn("wetbsocket closed")
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

