package net.thecamaras
{
    public class User
    {
        private var user:String;
        private var pass:String;
        
        [Bindable]
        var valid:Boolean = false;
        
        [Bindable]
        var authenticated:Boolean = false;
        
        public function User(user:String, password:String)
        {
            this.user = user;
            this.pass = password;
        }
        
        public function getUser():String{
            return this.user;
        }
        
        public function getPassword():String{
            return this.pass;
        }
    }
}