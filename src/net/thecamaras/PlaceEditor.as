package net.thecamaras
{
    import flash.events.Event;
    
    import mx.binding.utils.BindingUtils;
    import mx.containers.Form;
    import mx.containers.FormItem;
    import mx.containers.VBox;
    import mx.controls.ComboBox;
    import mx.controls.Label;
    import mx.controls.TextArea;
    import mx.controls.TextInput;

    public class PlaceEditor extends VBox
    {
        private var model:XML;
        private var form:Form;
        private var placeName:FormItem;
        private var address:FormItem;
        private var address2:FormItem;
        private var city:FormItem;
        private var state:FormItem;
        private var zipcode:FormItem;
        private var phone:FormItem;
        private var details:FormItem;
        
        private static const INPUT_WIDTH:int = 200;
        
        public function PlaceEditor(root:XML)
        {
            super();
            
            model = root;
            this.label = model.@name;
            this.setStyle("horizontalAlign", "center");
            
            var currentValue:Label;
            currentValue = new Label();
            
            form = setupForm();
            addChild(form);
        }
        
        private function setupForm():Form{
            var form:Form = new Form();
            form.setStyle("textAlign", "left");
                        
            placeName = new FormItem();
            address = new FormItem();
            address2 = new FormItem();
            city = new FormItem();
            state = new FormItem();
            zipcode = new FormItem();
            phone = new FormItem();
            details = new FormItem();
            
            form.addChild(placeName);
            form.addChild(address);
            form.addChild(address2);
            form.addChild(city);
            form.addChild(state);
            form.addChild(zipcode);
            form.addChild(phone);
            form.addChild(details);
            
            placeName.label = "Name:";
            var nameTxt:TextInput = new TextInput();
            placeName.addChild(nameTxt);
            nameTxt.text = model.@name;
            nameTxt.width = INPUT_WIDTH;
            
            address.label = "Address:";
            var addressTxt:TextInput = new TextInput();
            address.addChild(addressTxt);
            addressTxt.text = model.@address;
            addressTxt.width = INPUT_WIDTH;
            
            address2.label = "Address2:";
            var address2Txt:TextInput = new TextInput();
            address2.addChild(address2Txt);
            address2Txt.text = model.@address2;
            address2Txt.width = INPUT_WIDTH;
            
            city.label = "City:";
            var cityTxt:TextInput = new TextInput();
            city.addChild(cityTxt);
            cityTxt.text = model.@city;
            cityTxt.width = INPUT_WIDTH;
            
            state.label = "State:";
            var stateCmb:ComboBox = new ComboBox();
            state.addChild(stateCmb);
            stateCmb.dataProvider = Constants.STATE_LIST;
            var i:int;
            i = 0;
            for each (var x:Object in stateCmb.dataProvider){
                if (x.data == model.@state){
                    stateCmb.selectedIndex = i;
                    break;
                }
                i++;
            }
            stateCmb.text = model.@state;
            stateCmb.addEventListener(Event.CHANGE, function(event:Event):void{
                model.@state = stateCmb.selectedItem.data;
            });
            
            zipcode.label = "Zipcode";
            var zipcodeTxt:TextInput = new TextInput();
            zipcode.addChild(zipcodeTxt);
            zipcodeTxt.text = model.@zipcode;
            zipcodeTxt.width = INPUT_WIDTH;
            
            phone.label = "Phone:";
            var phoneTxt:TextInput = new TextInput();
            phone.addChild(phoneTxt);
            phoneTxt.text = model.@phone;
            phoneTxt.width = INPUT_WIDTH;
            
            details.label = "Details:";
            var detailsTxt:TextArea = new TextArea();
            detailsTxt.height = 40;
            details.addChild(detailsTxt);
            detailsTxt.text = model.@details;
            

            // Bind the ui to the model.
            BindingUtils.bindProperty(model, "@name", nameTxt, "text");
            BindingUtils.bindProperty(model, "@address", addressTxt, "text");
            BindingUtils.bindProperty(model, "@address2", address2Txt, "text");
            BindingUtils.bindProperty(model, "@city", cityTxt, "text");
            BindingUtils.bindProperty(model, "@zipcode", zipcodeTxt, "text");
            BindingUtils.bindProperty(model, "@phone", phoneTxt, "text");
            BindingUtils.bindProperty(model, "@details", detailsTxt, "text");
            
            return form;
        }
        
    }
}