package game.manager
{
    /**
     *  @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-4-20
     */
    public class GetValManager
    {
        /** 引导--是否在副本打BOSS */
        public static var guide_inDuplDefeatBossReturnCall : Function;

        public static function guide_inDuplDefeatBoss() : Boolean
        {
            if (guide_inDuplDefeatBossReturnCall != null)  return guide_inDuplDefeatBossReturnCall.apply();
            return false;
        }

        // ==============
        // 验证是否能打开世界地图
        // ==============
        public static var checkEnOpenMapWorldList : Vector.<Function> = new Vector.<Function>();

        public static function addCheckEnOpenMapWorld(fun : Function) : void
        {
            var index : int = checkEnOpenMapWorldList.indexOf(fun);
            if (index == -1)
            {
                checkEnOpenMapWorldList.push(fun);
            }
        }

        public static function removeCheckEnOpenMapWorld(fun : Function) : void
        {
            var index : int = checkEnOpenMapWorldList.indexOf(fun);
            if (index != -1)
            {
                checkEnOpenMapWorldList.splice(index, 1);
            }
        }
    }
}
