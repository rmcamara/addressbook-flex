package net.thecamaras.events
{
    import flash.events.Event;

    public class CreateEditorEvent extends Event
    {
        public static const CREATE_EDITOR_EVENT:String = "CreateEditorEvent";
        
        private var _mode:String;
        
        public function CreateEditorEvent(mode:String, bubbles:Boolean=false, cancelable:Boolean=false){
            super(CREATE_EDITOR_EVENT, bubbles, cancelable);
            this._mode = mode;
        }
        
        public function get mode ():String{
            return _mode;
        }
    }
}