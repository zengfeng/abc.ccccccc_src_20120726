package game.module.mapClanEscort
{
    import flash.utils.Dictionary;

    /**
     * @author ZengFeng (Email:zengfeng75[AT]163.com) 2012-2-23   ����2:17:41 
     */
    public class MCEConfig
    {
		/** 快速复活花费 */
		public static var faseReviveGold:int = 10;
        /** 地点字典 */
        public static var placeDic : Dictionary = new Dictionary();

        /** 获取地点 */
        public static function getPlace(placeId : int) : MCEPlaceStruct
        {
            return placeDic[placeId];
        }

        /** 路线终点地点ID */
        private static var pathEndIdDic : Dictionary = new Dictionary();

        /** 获取路线终点地点ID */
        public static function getPathEndId(pathId : int) : int
        {
            return pathEndIdDic[pathId];
        }

        /** 解析地点配置 */
        public static function parsePlace(arr : Array) : void
        {
            if (arr[0] == null || arr[0] == "") return;
            var placeId : int = arr[0];
            var x : int = arr[1];
            var y : int = arr[2];
            var time : Number = arr[3];
            var monsterId : int = arr[4];
            placeDic[placeId] = new MCEPlaceStruct(placeId, x, y, time, monsterId);

            var pathId : int = MCEUtil.getPathIdByPlaceId(placeId);
            var endId : int = 0;
            if (pathEndIdDic[pathId]) endId = pathEndIdDic[pathId];
            if (placeId > endId) endId = placeId;
            pathEndIdDic[pathId] = endId;
        }

        /** 路线Avatar配置 */
        private static var _drayAvatarDic : Dictionary ;

        /** 路线Avatar配置 */
        private static function get drayAvatarDic() : Dictionary
        {
            if (_drayAvatarDic == null)
            {
                _drayAvatarDic = new Dictionary();
//                _pathAvatarDic[0] = 4150;
//                _pathAvatarDic[1] = 4154;
                _drayAvatarDic[0] = 3005;
                _drayAvatarDic[16] = 3006;
            }
            return _drayAvatarDic;
        }

        /** 获取AvatarID */
        public static function getAvatarId(drayId : int) : int
        {
            return drayAvatarDic[drayId];
        }
    }
}
