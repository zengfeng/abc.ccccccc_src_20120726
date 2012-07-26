package game.dothings
{
    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-4-25 ����7:34:31
     */
    public class AbstractThing
    {
        public var unList:Vector.<uint>;
        public var yesCall:Function;
		public var args:Array;
        function AbstractThing()
        {
            
        }
        
        public function doStart():void
        {
            
        }
        
        public function doEnd():void
        {
            
        }
        
        public function doContinue():void
        {
            
        }
        
        public function checkEnable():Boolean
        {
            if(unList == null || unList.length == 0) return true;
//            for()
//            {
//                
//            }
            return true;
        }
        
        
        
        
        
    }
}
