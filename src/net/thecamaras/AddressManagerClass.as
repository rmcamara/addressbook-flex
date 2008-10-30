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
import mx.containers.TabNavigator;
import mx.core.Container;
import mx.events.FlexEvent;

import net.thecamaras.events.EditorEvent;
import net.thecamaras.events.OpenEditorEvent;
import net.thecamaras.models.Person;

    
// -----------------------------------------------------------------------------
//
//  MetaData
//
// -----------------------------------------------------------------------------


public class AddressManagerClass extends TabNavigator
{
    // -------------------------------------------------------------------------
    //  Static methods/constants
    // -------------------------------------------------------------------------
    
    // -------------------------------------------------------------------------
    //  Constructor
    // -------------------------------------------------------------------------
    public function AddressManagerClass()
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
    public var picker:AbstractListing;
    
    
    // -------------------------------------------------------------------------
    //  Properties
    // -------------------------------------------------------------------------
    
    // -------------------------------------------------------------------------
    // 
    //  Methods
    //
    // -------------------------------------------------------------------------
    
    
    // -------------------------------------------------------------------------
    // 
    //  Event Handlers
    //
    // -------------------------------------------------------------------------
    private function creationCompleteHandler(event:FlexEvent):void
    {
        picker.addEventListener(OpenEditorEvent.OPEN_EDITOR_EVENT, openEditor);
        picker.addEventListener(EditorEvent.EDITOR_CREATE_EVENT, newEditor);
        picker.addEventListener(EditorEvent.LISTING_SWITCH_EVENT, changePicker);
    }
    
    private function openEditor(event:OpenEditorEvent):void
    {
        var editor:Container;
        if (event.model.name() == Person.PERSON_TYPE){
            editor = new PeopleEditor();
            addChild(editor);
            this.selectedChild = editor;
            PeopleEditor(editor).init(event.model.@id);    
        }
        else{
            editor = new PlaceEditor();
            addChild(editor);
            this.selectedChild = editor;
            PlaceEditor(editor).init(event.model.@id); 
        }
    }
    
    private function newEditor(event:EditorEvent):void
    {
        var editor:Container;
        if (event.mode == Person.PERSON_TYPE){
            editor = new PeopleEditor();
        }
        else{
            editor = new PlaceEditor();
        }
        addChild(editor);
        this.selectedChild = editor;
    }
    
    private function changePicker(event:EditorEvent):void
    {
        removeChild(picker);
        if (event.mode == Person.PERSON_TYPE)
        {
            picker = new PlaceListing();
            picker.label = "Places";            
        }
        else
        {
            picker = new PeopleListing();
            picker.label = "People";
        }
        addChildAt(picker, 0);
        creationCompleteHandler(null);
        selectedChild = picker;
    }
}
}