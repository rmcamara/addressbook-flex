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
import mx.binding.utils.BindingUtils;
import mx.containers.HBox;
import mx.containers.VBox;
import mx.controls.Alert;
import mx.controls.Button;
import mx.events.CloseEvent;
import mx.managers.PopUpManager;
import mx.messaging.messages.IMessage;
import mx.rpc.events.FaultEvent;
import mx.utils.ObjectUtil;

    
// -----------------------------------------------------------------------------
//
//  MetaData
//
// -----------------------------------------------------------------------------


public class CommonEditorClass extends VBox
{
    // -------------------------------------------------------------------------
    //  Static methods/constants
    // -------------------------------------------------------------------------
    
    // -------------------------------------------------------------------------
    //  Constructor
    // -------------------------------------------------------------------------
    public function CommonEditorClass()
    {
        super();
        label = "New";
    }

    // -------------------------------------------------------------------------
    // 
    //  Variables
    //
    // -------------------------------------------------------------------------
    [Bindable]
    protected var editor:IEditor;
    
    [Bindable] 
    protected var titleText:String = "New Thing";
    
    [Bindable]
    protected var childText:String = "Assocaited Stuff";   
    
    public var busyContainer:HBox;
    public var saveBtn:Button;
    public var altBtnBar:HBox;
    
    // -------------------------------------------------------------------------
    //  Properties
    // -------------------------------------------------------------------------
    
    // -------------------------------------------------------------------------
    // 
    //  Methods
    //
    // -------------------------------------------------------------------------
    public function init (id:int):void
    {
        if (!initialized)
        {
            this.busyContainer.enabled = false;
        }
        this.label = "loading..";
        
        BindingUtils.bindProperty(saveBtn, "enabled", editor, "dirty");
        saveBtn.enabled = false; 
    }
    
    protected function loadModel (xml:XML):void
    {
        this.busyContainer.enabled = true;
        altBtnBar.enabled = true;
    }
    
    protected function close(event:CloseEvent):void
    {
        if (event.detail != Alert.OK)
        {
            return;
        }
            
        // Should probally fire an event requesting close
        this.parent.removeChild(this);
    }
      
    /**
     * User has requested a save to happen. Reads out all the values from the person
     * editor and sends them to the service call. 
     */  
    protected function save():void
    {
        var validation:String;
        validation = editor.validate();
        if (validation != ""){
            Alert.show("Unable to save: Invalid values in the detail fields\n\n" + validation, 
                       "Error Saving..."); 
            return;
        }
        var args:Object = new Object();
        args = buildSaveRequest();
        Connection.instance.send2("address.php", args, save_resultHandler, save_FaultHandler);
        this.busyContainer.enabled = false;
        altBtnBar.enabled = false;
    }
    
    protected function buildSaveRequest():Object
    {
        throw new Error("This method should have een overwritten");
    }
    
    protected function createLinkDialog():LinkDialog
    {
        throw new Error("The createLinkWindow was not implemented");
    }
    
    protected function deleteModelCheck():void
    {
        Alert.show("Are you sure you want to delete this item. It cannot be recovered.?", "Delete", 
                    Alert.YES | Alert.NO, this, delete_closeHandler, null, Alert.NO);
    }
    
    protected function buildDeleteRequest():Object
    {
        throw new Error("This method should have een overwritten");
    }
    
    // -------------------------------------------------------------------------
    // 
    //  Event Handlers
    //
    // -------------------------------------------------------------------------
    protected function link_clickHandler():void
    {
        if (editor.isNew())
        {
            Alert.show("This is an unsaved item. Please save it before trying to link.", 
                        "Link Items", Alert.OK, this);    
            return; 
        }

        var dialog:LinkDialog = createLinkDialog();
        dialog.addEventListener(CloseEvent.CLOSE, function(event:CloseEvent):void
        {
            PopUpManager.removePopUp(dialog);
            init(dialog.modelId);
        });
        PopUpManager.addPopUp(dialog, this, true);
        PopUpManager.centerPopUp(dialog);
    }
    
    /**
     * User requests the closing of this people editor. 
     */ 
    protected function close_clickHandler():void
    {
        if (editor.dirty)
        {
            Alert.show("You have unsaved changes. Do you wish to close?", "Close", 
                        Alert.OK | Alert.CANCEL, this, close, null, Alert.CANCEL);     
        }
        else{
            close(new CloseEvent(CloseEvent.CLOSE, false, false, Alert.OK));
        }
    }
            
    /**
     * Handle a succesfull save completion request. 
     */  
    protected function save_resultHandler(result:XML):void
    {
        loadModel(result);
        editor.dirty = false;
        saveBtn.enabled = false;
    }
    
    /**
     * Custom handler to handle a failed save attempt. 
     */  
    protected function save_FaultHandler(event:FaultEvent):void
    {
        var msg:IMessage = IMessage(event.message);
        Alert.show(ObjectUtil.toString(msg.body), "Error saving");
    }
    
    private function delete_closeHandler(e:CloseEvent):void
    {
        if (e.detail != Alert.YES){
            return;
        }
        
        var args:Object = new Object();
        args = buildDeleteRequest();
        Connection.instance.send2("address.php", args, close_resultHandler,  close_faultHandler);
        this.busyContainer.enabled = false;
    }
    
    private function close_faultHandler(event:FaultEvent):void
    {
        this.busyContainer.enabled = true;
        Alert.show("Problem performing the delete\n " + ObjectUtil.toString(event.message), 
                   "Delete Error");
    }
    
    private function close_resultHandler(result:XML):void
    {
         this.parent.removeChild(this);
    }
}
}