package net.thecamaras.models
{
    public class Place
    {
        public static const NEW_ID:int = -1;
        
        private var _id:int;
        private var _name:String;
        private var _address:String;
        private var _address2:String;
        private var _city:String;
        private var _state:String;
        private var _zipcode:int;
        private var _phone:String;
        private var _details:String;
        private var _lastUpdate:Date;
        
        public function Place(){
            this._id = NEW_ID;
        }
        
        public function Place(root:XML){
            this._id = Int(root.@id);
            this._name = String(root.@name);
            this._address = String(root.@address);
            this._address2 = String(root.@address2);
            this._city = String(root.@city);
            this._state = String(root.@state);
            this._zipcode = Int(root.@zipcode);
            this._phone = String(root.@phone);
            this._details = String(root.@details);
            this._lastUpdate = new Date(root.attribute("last-update"));
        }
        
        /** Getters for place properties. */
        public function get id():int{
            return _id;
        }
        
        public function get name():String {
            return _name;
        }
        
        public function get address():String{
            return _address;
        }
        
        public function get address2():String{
            return _address2;    
        }
        
        public function get city():String{
            return _city;    
        }
        
        public function get state():String{
            return _state;    
        }
        
        public function get zipcode():int{
            return _zipcode;    
        }
        public function get phone():String{
            return _phone;    
        }
        public function get details():String{
            return _details;    
        }
        public function get lastUpdate():Date{
            return _lastUpdate;    
        }
    }
}