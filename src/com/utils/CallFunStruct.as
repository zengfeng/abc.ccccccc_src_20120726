package com.utils
{
    /**
     * @author ZengFeng (Email:zengfeng75[AT]163.com) 2012-2-28   ����2:50:23 
     */
    public class CallFunStruct
    {
        public var fun:Function;
        public var args:Array;
        function CallFunStruct(fun:Function, args:Array = null):void
        {
            this.fun = fun;
            this.args = args;
        }
    }
}
