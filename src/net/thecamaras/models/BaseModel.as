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
package net.thecamaras.models
{

import mx.formatters.DateFormatter;
import mx.formatters.PhoneFormatter;

// -----------------------------------------------------------------------------
//
//  MetaData
//
// -----------------------------------------------------------------------------

/**
 * A model class that contains the information that is common to both the Person and Place
 * models. 
 * 
 * @author Ross Camara
 * 
 */
public class BaseModel 
{
    // -------------------------------------------------------------------------
    //  Static methods/constants
    // -------------------------------------------------------------------------
    /** Contstant that indicates this is a new model and not yet in the database. */
    public static const NEW_ID:int = -1;
    
    /** Date formater for YYYY-MM-DD */
    public static var DATE_FORMATER:DateFormatter = new DateFormatter();
    DATE_FORMATER.formatString = "YYYY-MM-DD";
    
    /** Formater for displaying Phone numbers. */
    public static var PHONE_FORMATER:PhoneFormatter = new PhoneFormatter();
    PHONE_FORMATER.formatString = "(###) ###-####";
    
    // -------------------------------------------------------------------------
    //  Constructor
    // -------------------------------------------------------------------------
    /**
     * Create a new base model.
     * 
     * @param root XML representation of the model.
     * 
     */
    public function BaseModel(root:XML)
    {
        if (root == null)
        {
            this._id = NEW_ID;
            this._lastUpdate = new Date();
            this.dirty = true;
        }
        else 
        {
            this._id = int(root.@id);
            this._lastUpdate = new Date(Date.parse(root.attribute("last-update")[0]));
            this._details = String(root.@details); 
        }
    }
    
    // -------------------------------------------------------------------------
    // 
    //  Variables
    //
    // -------------------------------------------------------------------------
    /** unique id of the model. */
    private var _id:int;
    
    /** The date of teh last update. */
    private var _lastUpdate:Date;
    
    /** dirty state. */
    private var _dirty:Boolean = false;
    
    /** Additional details. */
    private var _details:String;
    
    // -------------------------------------------------------------------------
    // 
    //  Properties
    //
    // -------------------------------------------------------------------------
    /**
     * Gets the Dirty state.
     *  
     * @return dirty state
     */
    [Bindable]
    public function get dirty():Boolean
    {
        return _dirty;
    }
    
    /**
     * Sets the dirty state.
     *  
     * @param value dirty state
     */
    public function set dirty(value:Boolean):void
    {
        this._dirty = value;
    }
        
    /**
     * Gets the unique id.
     * 
     * @return model id.
     */
    public function get id():int
    {
        return _id;
    }
    
    /**
     * Returns the date of the last update. 
     *  
     * @return date of last update.  
     */
    public function get lastUpdate():Date
    {
        return _lastUpdate;    
    }
    
    /**
     * Gets the details.
     *  
     * @return details.
     */
    [Bindable]
    public function get details():String
    {
        return _details;    
    }
    
    /**
     * Returns the details text. 
     *  
     * @return details.  
     */
    public function set details(value:String):void
    {
        this._details = value;
        this.dirty = true;
    }
    // -------------------------------------------------------------------------
    // 
    //  Methods
    //
    // -------------------------------------------------------------------------          
}
}