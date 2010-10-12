// Set URL of your WebSocketMain.swf here:
WEB_SOCKET_SWF_LOCATION = "/javascripts/socky/WebSocketMain.swf";
// Set this to dump debug message from Flash to console.log:
WEB_SOCKET_DEBUG = false;

Socky = function(host, port, params) {
  this.host = host;
  this.port = port;
  this.params = params;
  this.connect();
};

// Socky states
Socky.CONNECTING = 0;
Socky.AUTHENTICATING = 1;
Socky.OPEN = 2;
Socky.CLOSED = 3;
Socky.UNAUTHENTICATED = 4;

Socky.prototype.connect = function() {
  var instance = this;
  instance.state = Socky.CONNECTING;

  var ws = new WebSocket(this.host + ':' + this.port + '/?' + this.params);
  ws.onopen    = function()    { instance.onopen(); };
  ws.onmessage = function(evt) { instance.onmessage(evt); };
  ws.onclose   = function()    { instance.onclose(); };
  ws.onerror   = function()    { instance.onerror(); };
};



// ***** Private methods *****
// Try to avoid any modification of these methods
// Modification of these methods may cause script to work invalid
// Please see 'public methods' below
// ***************************

// Called when connection is opened
Socky.prototype.onopen = function() {
  this.state = Socky.AUTHENTICATING;
	this.respond_to_connect();
};

// Called when socket message is received
Socky.prototype.onmessage = function(evt) {
  try {
    var request = JSON.parse(evt.data);
    switch (request.type) {
      case "message":
        this.respond_to_message(request.body);
        break;
      case "authentication":
        if(request.body == "success") {
					this.state = Socky.OPEN;
          this.respond_to_authentication_success();
        } else {
					this.state = Socky.UNAUTHENTICATED;
          this.respond_to_authentication_failure();
        }
        break;
    }
  } catch (e) {
    console.error(e.toString());
  }
};

// Called when socket connection is closed
Socky.prototype.onclose = function() {
  if(this.state != Socky.CLOSED && this.state != Socky.UNAUTHENTICATED) {
    this.respond_to_disconnect();
  }
};

// Called when error occurs
// Currently unused
Socky.prototype.onerror = function() {};



// ***** Public methods *****
// These methods can be freely modified.
// The change should not affect the normal operation of the script.
// **************************

// Called after connection but before authentication confirmation is received
// At this point user is still not allowed to receive messages
Socky.prototype.respond_to_connect = function() {
};

// Called when authentication confirmation is received.
// At this point user will be able to receive messages
Socky.prototype.respond_to_authentication_success = function() {
};

// Called when authentication is rejected by server
// This usually means that secret is invalid or that authentication server is unavailable
// This method will NOT be called if connection with Socky server will be broken - see respond_to_disconnect
Socky.prototype.respond_to_authentication_failure = function() {
};

// Called when new message is received
// Note that msg is not sanitized - it can be any script received.
Socky.prototype.respond_to_message = function(msg) {
  eval(msg);
};

// Called when connection is broken between client and server
// This usually happens when user lost his connection or when Socky server is down.
// At default it will try to reconnect after 1 second.
Socky.prototype.respond_to_disconnect = function() {
	setTimeout(function(instance) { instance.connect(); }, 1000, this);
};