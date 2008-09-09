package net.thecamaras
{
	import mx.controls.Alert;
	import mx.messaging.messages.IMessage;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class Connection
	{
		public static const SERVER:String = "localhost";
		
		private static var _instance:Connection;
		
		public static function get instance():Connection{
		    if (_instance == null)
		    {
		        _instance = new Connection();
		    }
			return _instance;
		}
		
		private var connection:HTTPService = null;
		
		public function Connection(){
			this.connection = new HTTPService();
			this.connection.resultFormat = HTTPService.RESULT_FORMAT_E4X;
			this.connection.rootURL = "http://"+Connection.SERVER + "/addressbook/service/";
		}

		private static function displayError(event:FaultEvent):void {
            var msg:IMessage = IMessage(event.message);
            Alert.show(msg.toString(), "Error Connecting to Server");
        }
		
		public function send(url:String, parameters:Object, handler:Function):void {
		    send2(url, parameters, handler, displayError);
		}
		
		public function send2(url:String, parameters:Object, handler:Function, errorHandler:Function):void {
		    var handleResults:Function;
		    var errorResults:Function
		    
		    connection.cancel();
            
            if (User.instance != null && User.instance.authenticated)
            {
                parameters.user = User.instance.user;
                parameters.pass = User.instance.password;
            }
            
            handleResults = function(e:ResultEvent):void
            {
                connection.removeEventListener(ResultEvent.RESULT, handleResults);
                connection.removeEventListener(FaultEvent.FAULT, errorResults);
                handler(e.result);
            };
            
            errorResults = function(e:FaultEvent):void
            {
                connection.removeEventListener(ResultEvent.RESULT, handleResults);
                connection.removeEventListener(FaultEvent.FAULT, errorResults);
                errorHandler(e);
            };
            
            connection.url = connection.rootURL + url;
            connection.addEventListener(ResultEvent.RESULT, handleResults);
            connection.addEventListener(FaultEvent.FAULT, errorResults);
            connection.send(parameters);
		}
	}
}