package net.thecamaras.models
{
    public class Place extends BaseModel
    {
        public static const NEW_ID:int = -1;
        
        private var _name:String;
        private var _address:String;
        private var _address2:String;
        private var _city:String;
        private var _state:String;
        private var _zipcode:int;
        private var _phone:int;
        private var _details:String;
        
        public function Place(){
            super();
        }
        
        public function Place(root:XML){
            super(root);
            this._name = String(root.@name);
            this._address = String(root.@address);
            this._address2 = String(root.@address2);
            this._city = String(root.@city);
            this._state = String(root.@state);
            this._zipcode = Int(root.@zipcode);
            this._phone = Int(root.@phone);
            this._details = String(root.@details);
        }
        
        /** Getters for place properties. */
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
            this._phone = arg;
            this.dirty = true;
        }
        
        public function set details(arg:String):void{
            this._details = arg;
            this.dirty = true;
        }
    }
}