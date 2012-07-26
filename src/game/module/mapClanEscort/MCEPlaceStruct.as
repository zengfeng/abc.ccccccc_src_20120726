package game.module.mapClanEscort
{
    /**
     * @author ZengFeng (Email:zengfeng75[AT]163.com) 2012-2-23   ����7:54:23 
     * 地点数据结束
     */
    public class MCEPlaceStruct
    {
        public var id:int;
        public var x:int;
        public var y:int;
        public var time:Number;
        public var monsterId:int;
        
        function MCEPlaceStruct(id:int, x:int, y:int, time:Number, monsterId:int):void
        {
            this.id = id;
            this.x = x;
            this.y = y;
            this.time = time
            this.monsterId = monsterId;
        }
    }
}
