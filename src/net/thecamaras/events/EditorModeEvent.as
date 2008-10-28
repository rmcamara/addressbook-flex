package net.thecamaras.events
{
    import flash.events.Event;

    public class EditorModeEvent extends Event
    {
        public static const EDITOR_MODE_EVENT:String = "EditorMode";
        
        private var _mode:String;
        
        public function EditorModeEvent(mode:String, bubbles:Boolean=false, cancelable:Boolean=false){
            super(EDITOR_MODE_EVENT, bubbles, cancelable);
            this._mode = mode;
        }
        
        public function get mode():String
        {
            return _mode;
        }
    }
}