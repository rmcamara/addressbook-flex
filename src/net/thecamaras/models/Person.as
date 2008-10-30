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

// -----------------------------------------------------------------------------
//
//  MetaData
//
// -----------------------------------------------------------------------------

/**
 * Class that is used to represent a Person. This model is populated from
 * an XML description. 
 * 
 * @author Ross Camara
 * 
 */
public class Person extends BaseModel
{
    // -------------------------------------------------------------------------
    //  Static methods/constants
    // -------------------------------------------------------------------------
    /** String Constant used to identiy a Person Model. */
    public static const PERSON_TYPE:String = "Person";
    
    /** Convert phone numbers to a string of digits. */
    public static var PARSE_PHONE_FORMATER:PhoneFormatter = new PhoneFormatter();
    PARSE_PHONE_FORMATER.formatString = "##########";
    
    // -------------------------------------------------------------------------
    //  Constructor
    // -------------------------------------------------------------------------
    /**
     * Create a new instance of a person.
     *  
     * @param root XML representation of a person.
     */
    public function Person(root:XML)
    {
        super(root);
        if (root == null) { return; }
        
        this._firstname = String(root.@firstname);
        this._lastname = String(root.@lastname);
        this._title = String(root.@title);
        this._birthdate = root.@birth == "" ? null : new Date(Date.parse(root.@birth));
        this._email = String(root.@email);
        this._cell = parseFloat(root.@cell);
        this._places = root.Places;
    }
    
    // -------------------------------------------------------------------------
    // 
    //  Variables
    //
    // -------------------------------------------------------------------------
    /** First name. */  
    private var _firstname:String;
    
    /** Last name. */
    private var _lastname:String;
    
    /** Title used to address them. */
    private var _title:String;
    
    /** Date of birth. */
    private var _birthdate:Date;
    
    /** email address. */
    private var _email:String;
    
    /** Cellphone number. */
    private var _cell:Number;
    
    /** List of places the person lives at. */
    private var _places:XMLList;
    
    // -------------------------------------------------------------------------
    // 
    //  Properties
    //
    // -------------------------------------------------------------------------
    /**
     * Gets the first name.
     *  
     * @return first name.
     */
    [Bindable]
    public function get firstname():String 
    {
        return _firstname;
    }
    
    /**
     * Sets the first name.  
     * 
     * @param value first name. 
     */
    public function set firstname(value:String):void 
    {
        this._firstname = value;
        this.dirty = true;
    }
    
    /**
     * Gets the last name.
     *  
     * @return last name.
     */
    [Bindable]
    public function get lastname():String
    {
        return _lastname;
    }
    
    /**
     * Sets the last name.  
     * 
     * @param value last name. 
     */
    public function set lastname(arg:String):void
    {
        this._lastname = arg;
        this.dirty = true;
    }
    
    /**
     * Gets the title.
     *  
     * @return title.
     */
    [Bindable]
    public function get title():String
    {
        return _title;    
    }
    
    /**
     * Sets the title.  
     * 
     * @param value title. 
     */
    public function set title(value:String):void
    {
        this._title = value;
        this.dirty = true;
    }
    
    /**
     * Gets the birth date.
     *  
     * @return birth date.
     */
    [Bindable]
    public function get birthdate():Date
    {
        return _birthdate;    
    }
    
    /**
     * Sets the birthdate.  
     * 
     * @param value birthdate. 
     */
    public function set birthdate(value:Date):void
    {
        this._birthdate = value;
        this.dirty = true;
    }
    
    /**
     * Gets the email address.
     *  
     * @return email address.
     */
    [Bindable]
    public function get email():String
    {
        return _email;    
    }
    
    /**
     * Sets the email address.  
     * 
     * @param value email address. 
     */
    public function set email(value:String):void
    {
        this._email = value;
        this.dirty = true;
    }
    
    /**
     * Gets the cell phone number.
     *  
     * @return cell number.
     */
    [Bindable]
    public function get cell():String
    {
        return PHONE_FORMATER.format(_cell);    
    }
    
    /**
     * Sets the cell phone.  
     * 
     * @param value cell phone. 
     */
    public function set cell(value:String):void
    {
        this._cell = parseFloat(PARSE_PHONE_FORMATER.format(value));
        this.dirty = true;
    }    
    // -------------------------------------------------------------------------
    // 
    //  Methods
    //
    // -------------------------------------------------------------------------  
}
}