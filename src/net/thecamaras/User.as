package net.thecamaras
{
    import com.hurlant.crypto.Crypto;
    import com.hurlant.crypto.hash.IHash;
    import com.hurlant.util.Hex;
    
    public class User
    {
    	public static var instance:User;
    	private static var HASHER:IHash = Crypto.getHash('md5');
    	
        private var _user:String;
        private var _pass:String;
                
        [Bindable]
        public var authenticated:Boolean = false;
        
        public function User(user:String, password:String)
        {
            this._user = user;
            this._pass = Hex.fromArray(HASHER.hash(Hex.toArray(Hex.fromString(password))));
        }
        
        public function get user():String{
            return this._user;
        }
        
        public function get password():String{
            return this._pass;
        }
    }
}