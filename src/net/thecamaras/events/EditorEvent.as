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

import net.thecamaras.models.Person;
import net.thecamaras.models.Place;

// -----------------------------------------------------------------------------
//
//  MetaData
//
// -----------------------------------------------------------------------------

/**
 * Generic address type event. Contains a property indicating if this was based 
 * on a Place or a Person.
 * 
 * @author Ross Camara 
 */
public class EditorEvent extends Event
{
    // -------------------------------------------------------------------------
    //  Static methods/constants
    // -------------------------------------------------------------------------
    /** Event type used to indicate that the picker needs to switch modes. */
    public static const LISTING_SWITCH_EVENT:String = "SwitchPicker";
    
    /** Event type used to request a new Person/Place. */
    public static const EDITOR_CREATE_EVENT:String = "CreateEditor";
    
    /** Constant used for person based events. */
    public static const PERSON:String = Person.PERSON_TYPE;
    
    /** Constant used for location based events. */
    public static const LOCATION:String = Place.PLACE_TYPE;
    
    // -------------------------------------------------------------------------
    //  Constructor
    // -------------------------------------------------------------------------
    /**
     * 
     * @param type Event type
     * @param mode person or place based. 
     * @param bubbles 
     * @param cancelable
     * 
     */
    public function EditorEvent(type:String, mode:String, 
                                bubbles:Boolean=false, cancelable:Boolean=false)
    {
        super(type, bubbles, cancelable);
        this._mode = mode;
    }
    
    // -------------------------------------------------------------------------
    // 
    //  Variables
    //
    // -------------------------------------------------------------------------
    private var _mode:String;
    
    // -------------------------------------------------------------------------
    // 
    //  Properties
    //
    // -------------------------------------------------------------------------
    /**
     * Gets the mode of the event. 
     * 
     * @return the mode 
     */
    public function get mode():String
    {
        return _mode;
    }
}
}