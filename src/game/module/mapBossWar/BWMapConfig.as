package game.module.mapBossWar
{
    import com.utils.Ellipse;

    import flash.geom.Rectangle;

    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-2-13 ����2:29:55
     * BOSS战地图配置
     */
    public class BWMapConfig
    {
        /** 地图区域 */
        public static const area : Rectangle = new Rectangle(0, 0, 2615, 2900);
        /** 开放国战关卡颜色 */
        public static const openPassColor : uint = 100;
        /** 死亡活动区域关卡颜色 */
        public static const diePassColor : uint = 100;
        /** 死亡区域 */
        private static var _dieArea : Ellipse;

        /** 死亡区域 */
        public static function get dieArea() : Ellipse
        {
            if (_dieArea == null)
            {
                _dieArea = new Ellipse(370, 210, 2944,1712);
            }
            return _dieArea;
        }
        
        /** 复活区域 */
        private static var _reviveArea : Ellipse;
        public static function get reviveArea() : Ellipse
        {
            if (_reviveArea == null)
            {
                _reviveArea = new Ellipse(700, 350, 2944,1712);
            }
            return _reviveArea;
        }
    }
}
