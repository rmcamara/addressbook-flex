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
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import mx.collections.HierarchicalData;
import mx.collections.IHierarchicalCollectionView;
import mx.containers.VBox;
import mx.controls.AdvancedDataGrid;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.TextInput;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
import mx.events.FlexEvent;
import mx.utils.ObjectUtil;

import net.thecamaras.events.EditorEvent;
import net.thecamaras.events.OpenEditorEvent;
import net.thecamaras.models.Person;
import net.thecamaras.models.Place;
    
// -----------------------------------------------------------------------------
//
//  MetaData
//
// -----------------------------------------------------------------------------


public class AbstractListingClass extends VBox
{
    // -------------------------------------------------------------------------
    //  Static methods/constants
    // -------------------------------------------------------------------------
    protected static const TYPE_PLACE:String = Place.PLACE_TYPE;
    protected static const TYPE_PERSON:String =  Person.PERSON_TYPE;
    
    [Bindable]
    protected var modelList:HierarchicalData; // XML list of places
    
    [Embed(source="assets/person.png")]
    protected static const PERSON_ICON:Class;
    
    [Embed(source="assets/place.png")]
    protected static const PLACE_ICON:Class;
    
    [Embed(source="assets/refresh.jpg")]
    protected static const REFRESH_ICON:Class;
    
    [Embed(source="assets/expandall.png")]
    protected static const EXPAND_ICON:Class;
    
    // -------------------------------------------------------------------------
    //  Constructor
    // -------------------------------------------------------------------------
    public function AbstractListingClass()
    {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
    }

    // -------------------------------------------------------------------------
    // 
    //  Variables
    //
    // -------------------------------------------------------------------------
    [Bindable]
    protected var addLabel:String = "New thing";
    
    public var nameTxt:TextInput;
    public var search:Button;
    public var refresh:Button;
    public var expand:Button;
    public var addBtn:Button;
    
    public var listingTable:AdvancedDataGrid;
    
    // -------------------------------------------------------------------------
    //  Properties
    // -------------------------------------------------------------------------
    public function get mode():String
    {
        return TYPE_PLACE;
    }
    
    // -------------------------------------------------------------------------
    // 
    //  Methods
    //
    // -------------------------------------------------------------------------
    public function refreshModels():void 
    {
        this.enabled=false;
    }
    
    protected function populate(xml:XML):void 
    {
        this.enabled=true;
        var data:HierarchicalData = new HierarchicalData(xml.data.children())
        modelList = data;
    }
    
    protected function searchGrid():void 
    {
        var provider:IHierarchicalCollectionView = 
            IHierarchicalCollectionView(listingTable.dataProvider);
        provider.filterFunction = filterText;
        provider.refresh();
    }
    
    protected function filterText(item:Object, recrusive:Boolean = true):Boolean
    {
        var xitem:XML = XML(item);
        
        if (nameTxt.text == "" ){
            return true;
        }
        
        var filterKey:String;
        filterKey = nameTxt.text.toLocaleLowerCase();
        for each (var x:XML in xitem.attributes())
        {
            if (x.toString().toLocaleLowerCase().indexOf(filterKey) > -1){
                return true;
            }
        }
        
        // Check the children
        for each (var i:XML in xitem.children())
        {
            if (filterText(i, false))
            {
                return true;
            }
        }
        
        // leaf nodes are always included
        if (xitem.children().length() == 0)
        {
            return recrusive;
        }
        
        return false;
    }
    
    /** 
     * Label handler for the name column. 
     **/
    protected function displayName(item:Object, column:AdvancedDataGridColumn):String
    {
        var xml:XML = XML(item);
        
        if (xml.name() == TYPE_PLACE){
            return xml.@name;
        }
        else{
            return xml.@firstname + " " + xml.@lastname;
        }
    }
    
    /**
     * Sort two xml objects. Compare is performed on the name and first name. 
     * 
     * @param obj1 base object.
     * @param obj2 object to compare to.
     **/ 
    protected function sortByName(obj1:Object, obj2:Object): int 
    {
        var xml:XML = XML(obj1);
        var xml2:XML = XML(obj2);
       
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
            return ObjectUtil.stringCompare(xml.@firstname, xml2.@firstname, true);
        }
    }
    
    protected function groupIconChooser(item:Object, depth:int):Class
    {
        return iconChooser(item);
    }
    
    protected function iconChooser(item:Object):Class
    {
        var model:XML = XML(item);
        if (model.name() == TYPE_PERSON){
            return PERSON_ICON;
        }
        else{
            return PLACE_ICON;
        }
    }
    
    protected function openEditor(event:Event):void
    {
        var selected:XML = XML(listingTable.selectedItem);
        if (selected == null){
            Alert.show("Nothing selected. Please select something to open");
        }
        this.dispatchEvent(new OpenEditorEvent(selected));
    }
    
    protected function newItemRequest(event:Event):void
    {
        
    }
    
    // -------------------------------------------------------------------------
    // 
    //  Event Handlers
    //
    // -------------------------------------------------------------------------
    private function creationCompleteHandler(event:FlexEvent):void
    {
        refreshModels();
        
        listingTable.doubleClickEnabled=true;
        listingTable.addEventListener(MouseEvent.DOUBLE_CLICK, openEditor);
        listingTable.addEventListener(KeyboardEvent.KEY_DOWN, 
            function(e:KeyboardEvent):void{if (e.keyCode == 13) openEditor(e);});
        listingTable.setFocus();
        
        addBtn.addEventListener(MouseEvent.CLICK, newItemRequest);
        addBtn.addEventListener(KeyboardEvent.KEY_DOWN, newItemRequest);
    }
    
    protected function switchMode_clickHandler():void
    {
        dispatchEvent(new EditorEvent(EditorEvent.LISTING_SWITCH_EVENT, mode));
    }
}
}