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

package net.thecamaras
{
import flash.text.TextLineMetrics;

import mx.binding.utils.BindingUtils;
import mx.controls.Text;
import mx.events.FlexEvent;

import net.thecamaras.models.Person;

    
// -----------------------------------------------------------------------------
//
//  MetaData
//
// -----------------------------------------------------------------------------
public class PlaceRenderer extends Text
{
    // -------------------------------------------------------------------------
    //  Static methods/constants
    // -------------------------------------------------------------------------
    private static const SPACE:String = " ";
    private static const NEWLINE:String = "<br>";
    
    // -------------------------------------------------------------------------
    //  Constructor
    // -------------------------------------------------------------------------
    public function PlaceRenderer()
    {
        super();
        percentWidth = 100;
        addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
    }

    // -------------------------------------------------------------------------
    // 
    //  Variables
    //
    // -------------------------------------------------------------------------
    private var _source:XML = null;   
    
    // -------------------------------------------------------------------------
    //  Properties
    // -------------------------------------------------------------------------
    [Bindable]
    public function get source():XML
    {
        return _source;
    }
    
    public function set source(arg:XML):void
    {
        if (arg.name() != 'Place')
        {
            trace(arg);
            throw new Error("Not a valid xml snippet");
        }
        this._source = arg;
    }
    
    // -------------------------------------------------------------------------
    // 
    //  Methods
    //
    // -------------------------------------------------------------------------
    private function updateText(value:String):void
    {
        if (source == null)
        {
            return;
        }
        
        var results:String = "";
        var linecount:int = 1;
        
        results += source.@address + NEWLINE;
        if (source.@address2 != "")
        {
            results += source.@address2 + NEWLINE;
            linecount++;   
        }
        results += source.@city + ", " + source.@state + SPACE + source.@zipcode + NEWLINE;
        linecount++;
        if (source.@phone != "")
        {
            results += Person.PHONE_DISPLAY_FORMATER.format(source.@phone)
            linecount++; 
        }

        this.htmlText = results;
        
        var tdim:TextLineMetrics = determineTextFormatFromStyles().measureText(results);
        var lineHeight:Number = tdim.height;                
        this.height = linecount * lineHeight + tdim.leading*linecount + 20;
    }
    
    // -------------------------------------------------------------------------
    // 
    //  Event Handlers
    //
    // -------------------------------------------------------------------------
    private function creationCompleteHandler(event:FlexEvent):void
    {
        BindingUtils.bindSetter(updateText, this, "source");
    }
}
}