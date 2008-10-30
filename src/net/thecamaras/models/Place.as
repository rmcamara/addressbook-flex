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

import mx.formatters.PhoneFormatter;
import mx.formatters.ZipCodeFormatter;

// -----------------------------------------------------------------------------
//
//  MetaData
//
// -----------------------------------------------------------------------------

/**
 * A class that represents a physical location. It is popualted by an xml object. 
 * 
 * @author Ross Camara
 * 
 */
public class Place extends BaseModel
{   
    // -------------------------------------------------------------------------
    //  Static methods/constants
    // -------------------------------------------------------------------------
    /** String Constant used to identiy a Place. */
    public static const PLACE_TYPE:String = "Place";

    /** Formatter to handle zipcodes. */    
    public static var ZIPCODE_FORMATER:ZipCodeFormatter = new ZipCodeFormatter();
    
    // -------------------------------------------------------------------------
    //  Constructor
    // -------------------------------------------------------------------------
    /**
     * Create a new Place model. 
     *  
     * @param root XML source. 
     */
    public function Place(root:XML)
    {
        super(root);
        if (root == null) { return; }
        
        this._name = String(root.@name);
        this._address = String(root.@address);
        this._address2 = String(root.@address2);
        this._city = String(root.@city);
        this._state = String(root.@state);
        this._zipcode = String(root.@zipcode);
        this._phone = parseInt(root.@phone);
    }
    
    // -------------------------------------------------------------------------
    // 
    //  Variables
    //
    // -------------------------------------------------------------------------
    /** Location name. */
    private var _name:String;
    
    /** First line of address. */
    private var _address:String;
    
    /** Optional second address line. */
    private var _address2:String;
    
    /** City. */
    private var _city:String;
    
    /** State. */
    private var _state:String;
    
    /** Zipcode. */
    private var _zipcode:String;
    
    /** Home phone number. */
    private var _phone:uint;
    
    // -------------------------------------------------------------------------
    // 
    //  Properties
    //
    // -------------------------------------------------------------------------
    /**
     * Gets the name.
     *  
     * @return name.
     */
    [Bindable]
    public function get name():String 
    {
        return _name;
    }
    
    /**
     * Sets the name.
     * 
     * @param value name. 
     */
    public function set name(value:String):void 
    {
        this._name = value;
        this.dirty = true;
    }
    
    /**
     * Gets the address.
     *  
     * @return address.
     */
    [Bindable]
    public function get address():String
    {
        return _address;
    }
    
    /**
     * Sets the address.
     * 
     * @param value address. 
     */
    public function set address(value:String):void
    {
        this._address = value;
        this.dirty = true;
    }
    
    /**
     * Gets the optional second line of the address.
     *  
     * @return address 2nd line.
     */
    [Bindable]
    public function get address2():String
    {
        return _address2;    
    }
    
    /**
     * Sets the address2.
     * 
     * @param value address2. 
     */
    public function set address2(value:String):void
    {
        this._address2 = value;
        this.dirty = true;
    }
    
    /**
     * Gets the city.
     *  
     * @return city.
     */
    [Bindable]
    public function get city():String
    {
        return _city;    
    }
    
    /**
     * Sets the city.
     * 
     * @param value city. 
     */
    public function set city(value:String):void
    {
        this._city = value;
        this.dirty = true;
    }
    
    /**
     * Gets the State.
     *  
     * @return state.
     */
    [Bindable]
    public function get state():String
    {
        return _state;    
    }
    
    /**
     * Sets the state.
     * 
     * @param value state. 
     */
    public function set state(value:String):void
    {
        this._state = value;
        this.dirty = true;
    }
    
    /**
     * Gets the zipcode.
     *  
     * @return zipcode.
     */
    [Bindable]
    public function get zipcode():String
    {
        return ZIPCODE_FORMATER.format(_zipcode);
    }
    
    /**
     * Sets the zipcode.
     * 
     * @param value zipcode. 
     */
    public function set zipcode(value:String):void
    {
        this._zipcode = value;
        this.dirty = true;
    }
    
    /**
     * Gets the phone number.
     *  
     * @return phone number.
     */
    [Bindable]
    public function get phone():String
    {
        return PHONE_FORMATER.format(_phone);    
    }
    
    /**
     * Sets the phone number.
     * 
     * @param value phone number. 
     */
    public function set phone(value:String):void
    {
        this._phone = parseInt(value);
        this.dirty = true;
    }
}
}