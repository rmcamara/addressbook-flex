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
		
		public function send(url:String, parameters:Object, handler:Function):void {
		    connection.cancel();
		    
		    var handleResults:Function = function(e:ResultEvent):void
		    {
		        connection.removeEventListener(ResultEvent.RESULT, handleResults);
		        handler(e.result);
		    };
		    
		    connection.url = connection.rootURL + url;
		    connection.addEventListener(ResultEvent.RESULT, handleResults);
		    connection.addEventListener(FaultEvent.FAULT, displayError);
		    connection.send(parameters);
		}
		
		private function displayError(e:FaultEvent):void {
		    var msg:IMessage = IMessage(e.message);
	        Alert.show(msg.toString(), "Error Connecting to Server");
		}
	}
}