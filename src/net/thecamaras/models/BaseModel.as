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