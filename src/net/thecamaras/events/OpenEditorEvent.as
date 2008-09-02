package net.thecamaras.events
{
    import flash.events.Event;

    public class OpenEditorEvent extends Event
    {
        public static const OPEN_EDITOR_EVENT:String = "EditorEvent";
        
        /** The XML Model that should be opened. */
        private var _xml:XML;
        
        public function OpenEditorEvent(model:XML, bubbles:Boolean=false, cancelable:Boolean=false){
            super(OPEN_EDITOR_EVENT, bubbles, cancelable);
            this._xml = model;
        }
        
        public function get model ():XML{
            return _xml;
        }
    }
}