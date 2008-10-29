package net.thecamaras.events
{
    import flash.events.Event;

    public class EditorEvent extends Event
    {
        public static const LISTING_SWITCH_EVENT:String = "SwitchPicker";
        public static const EDITOR_CREATE_EVENT:String = "CreateEditor";
        
        private var _mode:String;
        
        public function EditorEvent(type:String, mode:String, bubbles:Boolean=false, cancelable:Boolean=false){
            super(type, bubbles, cancelable);
            this._mode = mode;
        }
        
        public function get mode():String
        {
            return _mode;
        }
    }
}