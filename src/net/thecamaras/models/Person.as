package net.thecamaras.models
{
    import mx.formatters.DateFormatter;
    
    public class Person extends BaseModel
    {
        private var _firstname:String;
        private var _lastname:String;
        private var _title:String;
        private var _birthdate:Date;
        private var _email:String;
        private var _cell:int;
        private var _details:String;
        private var _places:XMLList;
        
        protected static var DATE_FORMATER:DateFormatter = new DateFormatter();
        DATE_FORMATER.formatString = "YYYY-MM-DD";
        
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
            this._cell = int(root.@cell);
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
            return PHONE_FORMATER.format(_cell);    
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
            this._cell = parseInt(arg);
            this.dirty = true;
        }

        public function set details(arg:String):void{
            this._details = arg;
            this.dirty = true;
        }
    }
}