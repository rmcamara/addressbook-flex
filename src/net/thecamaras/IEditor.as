package net.thecamaras
{
    public interface IEditor
    {
        function get dirty():Boolean;
        function set dirty(arg:Boolean):void;
        function validate():String;
    }
}