package net.thecamaras
{
    public class User
    {
    	public static var instance:User;
    	
        private var _user:String;
        private var _pass:String;
                
        [Bindable]
        public var authenticated:Boolean = false;
        
        public function User(user:String, password:String)
        {
            this._user = user;
            this._pass = password;
        }
        
        public function get user():String{
            return this._user;
        }
        
        public function get password():String{
            return this._pass;
        }
    }
}