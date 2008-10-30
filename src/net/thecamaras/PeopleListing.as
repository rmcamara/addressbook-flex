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
import flash.events.Event;

import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
import mx.events.FlexEvent;
import mx.formatters.DateFormatter;
import mx.utils.ObjectUtil;

import net.thecamaras.events.EditorEvent;
import net.thecamaras.models.Person;

    
// -----------------------------------------------------------------------------
//
//  MetaData
//
// -----------------------------------------------------------------------------


public class PeopleListing extends AbstractListing
{
    // -------------------------------------------------------------------------
    //  Static methods/constants
    // -------------------------------------------------------------------------
    private static const DATE_FORMAT:DateFormatter = new DateFormatter();
    DATE_FORMAT.formatString = "MMM DD, YYYY";
    
    private static const COMPARE_DATE_FORMAT:DateFormatter = new DateFormatter();
    COMPARE_DATE_FORMAT.formatString = "MMDDYYYY";
    
    // -------------------------------------------------------------------------
    //  Constructor
    // -------------------------------------------------------------------------
    public function PeopleListing()
    {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
        addEventListener(FlexEvent.PREINITIALIZE, preInitializeHandler);
    }

    // -------------------------------------------------------------------------
    // 
    //  Variables
    //
    // -------------------------------------------------------------------------   
    
    // -------------------------------------------------------------------------
    //  Properties
    // -------------------------------------------------------------------------
    override public function get mode():String
    {
        return Person.PERSON_TYPE;
    }
    
    // -------------------------------------------------------------------------
    // 
    //  Methods
    //
    // -------------------------------------------------------------------------
    override public function refreshModels():void 
    {
        super.refreshModels();
        var args:Object = new Object();
        args.method = "ListPeople";
        Connection.instance.send("address.php", args, populate); 
    }
    
    override protected function populate(xml:XML):void 
    {
        super.populate(xml);
        modelList.childrenField = "Places";
    }
    
    override protected function newItemRequest(event:Event):void
    {
        dispatchEvent(new EditorEvent(EditorEvent.EDITOR_CREATE_EVENT, TYPE_PERSON));
    }
    
    override protected function displayName(item:Object, column:AdvancedDataGridColumn):String
    {
        var xml:XML = XML(item);
        
        if (xml.name() == TYPE_PERSON){
            return xml.@firstname;
        }
        return super.displayName(item, column);
    }
    
    protected function cellDisplay(item:Object, column:AdvancedDataGridColumn):String
    {
        var xml:XML = XML(item);
        
        if (xml.name() == TYPE_PLACE){
            return "";
        }
            
        if (xml.@cell == ""){
            return "";
        }
    
        return Person.PHONE_FORMATER.format(xml.@cell);
    }

    
    protected function dateDisplay(item:Object, column:AdvancedDataGridColumn):String
    {
        var xml:XML = XML(item);
        
        if (xml.name() == TYPE_PLACE){
            return "";
        }
            
        if (xml.@birth == ""){
            return "";
        }
    
        return DATE_FORMAT.format(new Date(Date.parse(xml.@birth)));
    }

    protected function birthSort(obj1:Object, obj2:Object): int 
    {
        var xml:XML = XML(obj1);
        var xml2:XML = XML(obj2);
        var d1:Date;
        var d2:Date;
       
        if (xml.name() == TYPE_PLACE){
            if (xml2.name() == TYPE_PLACE){
                // string compare the location name
                return ObjectUtil.stringCompare(xml.@name, xml2.@name, true);                   
            }          
            return 1; // item2 is a person
        }
        else {
            if (xml2.name() == TYPE_PLACE){
                return -1;// item2 is a location                        
            }
            // String compare the first name of the two people
            
            if (xml.@birth == "" && xml2.@birth == ""){
                return 0;
            }
            
            if (xml.@birth == "" || xml2.@birth == ""){
                ObjectUtil.stringCompare(xml.@birth, xml2.@birth, true);
            }
            
            d1 = new Date(Date.parse(xml.@birth));
            d2 = new Date(Date.parse(xml2.@birth));
            
            return ObjectUtil.stringCompare(COMPARE_DATE_FORMAT.format(d1), 
                                            COMPARE_DATE_FORMAT.format(d1),
                                            true);
        }
    }
    
    // -------------------------------------------------------------------------
    // 
    //  Event Handlers
    //
    // -------------------------------------------------------------------------
    private function creationCompleteHandler(event:FlexEvent):void
    {
        var columns:Array = new Array();                
        var col:AdvancedDataGridColumn;
        
        col = new AdvancedDataGridColumn("");
        col.resizable = false;
        col.sortable = false;
        columns.push(col);
        
        col = new AdvancedDataGridColumn("First Name");
        col.wordWrap = false;
        col.labelFunction = displayName;
        col.dataField = "@firstname";
        col.sortCompareFunction = sortByName;
        col.sortable = true;
        columns.push(col);
        
        col = new AdvancedDataGridColumn("Last Name");
        col.wordWrap = false;
        col.dataField = "@lastname";
        columns.push(col);
        
        col = new AdvancedDataGridColumn("Birth Date");
        col.wordWrap = false;
        col.dataField = "@birth";
        col.labelFunction = dateDisplay;
        col.sortCompareFunction = birthSort;
        col.setStyle("textAlign", "center");
        columns.push(col);
        
        col = new AdvancedDataGridColumn("Cell Phone");
        col.dataField = "@cell";
        col.labelFunction = cellDisplay;
        col.setStyle("textAlign", "center");
        columns.push(col);
        
        col = new AdvancedDataGridColumn("Comments");
        col.wordWrap = false;
        col.dataField = "@details";
        col.dataTipField = "@details";
        columns.push(col);
         
        var width:Number;
        width = listingTable.width;
        columns[0].width = 50;
        width -= columns[0].width;
        columns[1].width = width * .20;
        columns[2].width = width * .20;
        columns[3].width = width * .15;
        columns[4].width = width * .15;
        columns[5].width = width * .30;
        
        listingTable.columns = columns;
        listingTable.treeColumn = columns[0];
        listingTable.invalidateSize();
    }
    
    private function preInitializeHandler(event:FlexEvent):void
    {
        addLabel = "New Person";
    }
}
}