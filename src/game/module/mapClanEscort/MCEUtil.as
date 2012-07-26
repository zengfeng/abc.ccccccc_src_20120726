package game.module.mapClanEscort
{
    /**
     * @author ZengFeng (Email:zengfeng75[AT]163.com) 2012-2-23   ����2:25:23 
     */
    public class MCEUtil
    {
        /** 
         * 获取地点Id (id = pathId * 100 + index)
         * @param pathId 路线Id
         * @param index 路线中的第几个位置
         */
        public static function getPlaceId(pathId:int, index:int):int
        {
            return pathId * 100 + index;
        }
        
        /** 获取路线ID */
        public static function getPathIdByDrayId(drayId:int):int
        {
            return drayId >> 4;
        }
        
        /** 获取路线ID */
        public static function getPathIdByPlaceId(placeId:int):int
        {
            return Math.floor(placeId / 100);
        }
        
        
    }
}
