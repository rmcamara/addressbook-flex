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