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
    
    public class Person extends BaseModel
    {
        public static const PERSON_TYPE:String = "Person";
        
        private var _firstname:String;
        private var _lastname:String;
        private var _title:String;
        private var _birthdate:Date;
        private var _email:String;
        private var _cell:Number;
        private var _details:String;
        private var _places:XMLList;
        
        public static var PHONE_DISPLAY_FORMATER:PhoneFormatter = new PhoneFormatter();
        PHONE_DISPLAY_FORMATER.formatString = "(###) ###-####";
        
        public static var PHONE_FORMATER:PhoneFormatter = new PhoneFormatter();
        PHONE_FORMATER.formatString = "##########";
        
        public function Person(root:XML){
            super(root);
            if (root == null) { return; }
            
            this._firstname = String(root.@firstname);
            this._lastname = String(root.@lastname);
            this._title = String(root.@title);
            
            if (root.@birth == ""){
                this._birthdate = null;
            }
            else{
                this._birthdate = new Date(Date.parse(root.@birth));
            }
            
            this._email = String(root.@email);
            this._cell = parseFloat(root.@cell);
            this._details = String(root.@details);
            this._places = root.Places;
        }
        
        override public function toObject():Object{
            var result:Object = super.toObject();
            return result;
        }
        
        /** Getters for place properties. */
        [Bindable]
        public function get firstname():String {
            return _firstname;
        }
        
        [Bindable]
        public function get lastname():String{
            return _lastname;
        }
        
        [Bindable]
        public function get title():String{
            return _title;    
        }
        
        [Bindable]
        public function get birthdate():Date{
            return _birthdate;    
        }
        
        public function get email():String{
            return _email;    
        }
        
        [Bindable]
        public function get cell():String{
            return PHONE_DISPLAY_FORMATER.format(_cell);    
        }
        
        [Bindable]
        public function get details():String{
            return _details;    
        }
        
        public function set firstname(arg:String):void {
            this._firstname = arg;
            this.dirty = true;
        }
        
        public function set lastname(arg:String):void{
            this._lastname = arg;
            this.dirty = true;
        }
        
        public function set title(arg:String):void{
            this._title = arg;
            this.dirty = true;
        }
        
        public function set birthdate(arg:Date):void{
            this._birthdate = arg;
            this.dirty = true;
        }
        
        [Bindable]
        public function set email(arg:String):void{
            this._email = arg;
            this.dirty = true;
        }
        
        public function set cell(arg:String):void{
            this._cell = parseFloat(PHONE_FORMATER.format(arg));
            this.dirty = true;
        }

        public function set details(arg:String):void{
            this._details = arg;
            this.dirty = true;
        }
    }
}