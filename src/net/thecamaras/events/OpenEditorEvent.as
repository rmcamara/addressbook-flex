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

// -----------------------------------------------------------------------------
//
//  MetaData
//
// -----------------------------------------------------------------------------

/**
 * A flex event used to trigger the opening of a new editor. 
 * 
 * @author Ross Camara
 */
public class OpenEditorEvent extends Event
{
    // -------------------------------------------------------------------------
    //  Static methods/constants
    // -------------------------------------------------------------------------
    
    public static const OPEN_EDITOR_EVENT:String = "EditorEvent";
    
    // -------------------------------------------------------------------------
    //  Constructor
    // -------------------------------------------------------------------------
    
    /**
     * Create a new instance of the OpenEditorEvent.
     * 
     * @param model XML encoding of the model to be opened. 
     * @param bubbles
     * @param cancelable
     * 
     */
    public function OpenEditorEvent(model:XML, bubbles:Boolean=false, cancelable:Boolean=false)
    {
        super(OPEN_EDITOR_EVENT, bubbles, cancelable);
        this._xml = model;
    }
    
    // -------------------------------------------------------------------------
    // 
    //  Variables
    //
    // -------------------------------------------------------------------------
    /** The XML Model that should be opened. */
    private var _xml:XML;
    
    
    // -------------------------------------------------------------------------
    // 
    //  Properties
    //
    // -------------------------------------------------------------------------
    
    /**
     * Gets the XML model.
     * 
     * @return the xml.
     */
    public function get model ():XML
    {
        return _xml;
    }
}
}