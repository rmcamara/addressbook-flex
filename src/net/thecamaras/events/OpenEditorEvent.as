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