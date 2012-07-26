package game.manager
{
    import com.signalbus.Signal;
    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-4-25 ����3:00:12
     */
    public class EnWalkManager
    {
        /** 点击地图走路 */
        public static var CLICK_MAP_WALK:int = 1;
        /** 去NPC */
        public static var TO_NPC:int = 2;
        /** 去地图某个位置 */
        public static var TO_MAP:int = 3;
        /** 去某个AVATAR附近 */
        public static var TO_AVATAR_POSITION:int = 4;
        /** 去传送阵 */
        public static var TO_GATE:int = 5;
        /** 去副本 */
        public static var TO_DUPL_MAP:int = 6;
        /** 传送 */
        public static var TRANSPORT_TO:int = 7;
        /** 打开世界地图 */
        public static var OPEN_WORLD_MAP:int = 8;
        /** 去国战 */
        public static var TO_GROUP_BATTLE:int = 9;
        
        public static var continueWalk : Signal = new Signal();
        public static var checkEnWalkList : Vector.<Function> = new Vector.<Function>();

        public static function checkEnWalk(doWhat:int = 0) : Boolean
        {
            var value : Boolean = true;
            var fun : Function;
            for (var i : int = 0; i < checkEnWalkList.length; i++)
            {
                fun = checkEnWalkList[i];
                value = fun.apply(null, [doWhat]);
                if (value == false)
                {
                    return false;
                }
            }
            return value;
        }

        public static function addCheckEnWalk(fun : Function) : void
        {
            var index : int = checkEnWalkList.indexOf(fun);
            if (index == -1)
            {
                checkEnWalkList.push(fun);
            }
        }

        public static function removeCheckEnWalk(fun : Function) : void
        {
            var index : int = checkEnWalkList.indexOf(fun);
            if (index != -1)
            {
                checkEnWalkList.splice(index, 1);
            }
        }
    }
}
