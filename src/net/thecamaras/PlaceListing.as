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

import net.thecamaras.events.EditorEvent;

    
// -----------------------------------------------------------------------------
//
//  MetaData
//
// -----------------------------------------------------------------------------


public class PlaceListing extends AbstractListing
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
    public function PlaceListing()
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
    
    // -------------------------------------------------------------------------
    // 
    //  Methods
    //
    // -------------------------------------------------------------------------
    override public function refreshModels():void 
    {
        super.refreshModels();
        var args:Object = new Object();
        args.method = "ListPlaces";
        Connection.instance.send("address.php", args, populate); 
    }
    
    override protected function populate(xml:XML):void 
    {
        super.populate(xml);
        modelList.childrenField = "People";
    }
    
    override protected function newItemRequest(event:Event):void
    {
        dispatchEvent(new EditorEvent(EditorEvent.EDITOR_CREATE_EVENT, TYPE_PLACE));
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
        
        col = new AdvancedDataGridColumn("Location Name");
        col.labelFunction = displayName;
        col.dataField = "@name";
        col.sortCompareFunction = sortByName;
        col.sortable = true;
        columns.push(col);
        
        col = new AdvancedDataGridColumn("City");
        col.dataField = "@city";
        col.setStyle("textAlign", "center");
        columns.push(col);
        
        col = new AdvancedDataGridColumn("State");
        col.dataField = "@state";
        col.setStyle("textAlign", "center");
        columns.push(col);
        
        col = new AdvancedDataGridColumn("Zipcode");
        col.dataField = "@zipcode";
        col.setStyle("textAlign", "center");
        columns.push(col);
        
        col = new AdvancedDataGridColumn("Details");
        col.dataField = "@details";
        col.dataTipField = "@details";
        columns.push(col);
         
        var width:Number;
        width = listingTable.width;
        columns[0].width = 45;
        width -= columns[0].width;
        columns[1].width = width * .25;
        columns[2].width = width * .15;
        columns[3].width = width * .08;
        columns[4].width = width * .10;
        columns[5].width = width * .42;
        
        listingTable.columns = columns;
        listingTable.treeColumn = columns[0];
        listingTable.invalidateSize();
    }
    
    private function preInitializeHandler(event:FlexEvent):void
    {
        addLabel = "New Place";
    }
}
}