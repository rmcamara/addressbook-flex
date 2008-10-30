///////////////////////////////////////////////////////////////////////////////
//    
//    Copyright 2008 Ross Camara
//
//    This file is part of Addressbook.
//
//    Foobar is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    AddressBook is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
//
///////////////////////////////////////////////////////////////////////////////

package net.thecamaras
{
import mx.controls.Alert;
import mx.core.Application;
import mx.messaging.messages.IMessage;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

// -----------------------------------------------------------------------------
//
//  MetaData
//
// -----------------------------------------------------------------------------

/**
 * Connection class that is used as a wrapper to the HTTPService. 
 * 
 * @author Ross Camara 
 */
public class Connection
{	
    // -------------------------------------------------------------------------
    //  Static methods/constants
    // -------------------------------------------------------------------------
    
	/** Reference to a static instance. */
	private static var _instance:Connection;
	
	/**
	 * Getter for the Singelton of the Connection object. 
	 *  
	 * @return Connection singelton. 
	 */
	public static function get instance():Connection
	{
	    if (_instance == null)
	    {
	        _instance = new Connection(Application.application.loaderInfo.url);
	    }
		return _instance;
	}
	
	/**
	 * Helper method that will display an fault event in an alert window. 
	 *  
	 * @param event Fault event. 
	 */
	private static function displayError(event:FaultEvent):void 
    {
        var msg:IMessage = IMessage(event.message);
        Alert.show(msg.body.toString(), "Error Connecting to Server");
    }

    // -------------------------------------------------------------------------
    //  Constructor
    // -------------------------------------------------------------------------
	/**
	 * @param rootURL URL used to load the application. 
	 */
	public function Connection(rootURL:String)
	{
		var lastForwardSlashIndex:int = rootURL.lastIndexOf("/");
        var lastBackSlashIndex:int = rootURL.lastIndexOf("\\");
        rootURL = rootURL.slice(0,Math.max(lastForwardSlashIndex, lastBackSlashIndex) + 1);
		
		this.connection = new HTTPService();
		this.connection.resultFormat = HTTPService.RESULT_FORMAT_E4X;
		this.connection.rootURL = rootURL + "/service/";
	}
	
    // -------------------------------------------------------------------------
    // 
    //  Variables
    //
    // -------------------------------------------------------------------------
	/** HTTP service object used to talk to the server. */
	private var connection:HTTPService = null;

	// -------------------------------------------------------------------------
    // 
    //  Methods
    //
    // -------------------------------------------------------------------------
	/**
	 * Transmits a request to the server.
	 * 
	 * @depricated Use Connection#send2 
	 * 
	 * @param url name of the service API
	 * @param parameters parameters of the rest call.
	 * @param handler handler to be called on succes. 
	 */
	public function send(url:String, parameters:Object, handler:Function):void 
	{
	    send2(url, parameters, handler, displayError);
	}
	
	/**
	 * Transmits a request to the server. 
	 * 
	 * The success handler should have a method signature of function(XML). The fault handler
	 * expects a method signature of function(FaultEvent). 
	 * 
     * @param url name of the service API
     * @param parameters parameters of the rest call.
     * @param handler handler to be called on succes. 
	 * @param errorHandler handler to be called on failure. 
	 * 
	 */
	public function send2(url:String, parameters:Object, handler:Function, errorHandler:Function):void 
	{
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