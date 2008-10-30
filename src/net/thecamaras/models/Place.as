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
    import mx.formatters.PhoneFormatter;
    import mx.formatters.ZipCodeFormatter;
    
    public class Place extends BaseModel{   
        public static const PLACE_TYPE:String = "Place";
            
        private var _name:String;
        private var _address:String;
        private var _address2:String;
        private var _city:String;
        private var _state:String;
        private var _zipcode:String;
        private var _phone:uint;
        private var _details:String;
        
        public static var TELEPHONE_FORMATER:PhoneFormatter = new PhoneFormatter();
        TELEPHONE_FORMATER.formatString = "(###) ###-####";
        
        public static var ZIPCODE_FORMATER:ZipCodeFormatter = new ZipCodeFormatter();
        
        public function Place(root:XML){
            super(root);
            if (root == null) { return; }
            
            this._name = String(root.@name);
            this._address = String(root.@address);
            this._address2 = String(root.@address2);
            this._city = String(root.@city);
            this._state = String(root.@state);
            this._zipcode = String(root.@zipcode);
            this._phone = parseInt(root.@phone);
            this._details = String(root.@details);
        }
        
        override public function toObject():Object{
            var result:Object = super.toObject();
            return result;
        }
        
        /** Getters for place properties. */
        [Bindable]
        public function get name():String {
            return _name;
        }
        
        [Bindable]
        public function get address():String{
            return _address;
        }
        
        [Bindable]
        public function get address2():String{
            return _address2;    
        }
        
        [Bindable]
        public function get city():String{
            return _city;    
        }
        
        [Bindable]
        public function get state():String{
            return _state;    
        }
        
        [Bindable]
        public function get zipcode():String{
            return ZIPCODE_FORMATER.format(_zipcode);
        }
        
        [Bindable]
        public function get phone():String{
            return TELEPHONE_FORMATER.format(_phone);    
        }
        
        [Bindable]
        public function get details():String{
            return _details;    
        }
        
        public function set name(arg:String):void {
            this._name = arg;
            this.dirty = true;
        }
        
        public function set address(arg:String):void{
            this._address = arg;
            this.dirty = true;
        }
        
        public function set address2(arg:String):void{
            this._address2 = arg;
            this.dirty = true;
        }
        
        public function set city(arg:String):void{
            this._city = arg;
            this.dirty = true;
        }
        
        public function set state(arg:String):void{
            this._state = arg;
            this.dirty = true;
        }
        
        public function set zipcode(arg:String):void{
            this._zipcode = arg;
            this.dirty = true;
        }
        
        public function set phone(arg:String):void{
            this._phone = parseInt(arg);
            this.dirty = true;
        }
        
        public function set details(arg:String):void{
            this._details = arg;
            this.dirty = true;
        }
    }
}