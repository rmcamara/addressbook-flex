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

package net.thecamaras.models
{
    import mx.formatters.DateFormatter;
    
    public class BaseModel 
    {
        public static const NEW_ID:int = -1;
        
        protected var _id:int;
        protected var _lastUpdate:Date;
        
        [Bindable]
        public var root:XML;
        
        [Bindable]
        public var dirty:Boolean = false;
        
        public static var DATE_FORMATER:DateFormatter = new DateFormatter();
        DATE_FORMATER.formatString = "YYYY-MM-DD";
        
        public function BaseModel(root:XML){
            this.root = root;
            if (root == null){
                this._id = NEW_ID;
                this.dirty = true;
            }
            else {
                this._id = int(root.@id);
                this._lastUpdate = new Date(Date.parse(root.attribute("last-update")[0]));    
            }
        }
        
        public function toObject():Object{
            var result:Object = new Object();
            result.id = _id;
            return result;
        }
        
        /** Getters for place properties. */
        public function get id():int{
            return _id;
        }
        
        public function get lastUpdate():Date{
            return _lastUpdate;    
        }
    }
}