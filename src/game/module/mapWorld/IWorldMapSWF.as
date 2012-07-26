package game.module.mapWorld
{
    import flash.geom.Point;
    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-3-26 ����3:44:27
     */
    public interface IWorldMapSWF
    {
        function set leaveClickCall(fun : Function) : void;

        function get leaveClickCall() : Function;

        function set toMapCall(fun : Function) : void;

        function get toMapCall() : Function;

        /** 开放某个地图 */
        function mapOn(mapId : int) : void;

        /** 封印某个地图 */
        function mapOff(mapId : int) : void;

        /** 设置是否显示 */
        function mapSwitch(mapId : int, on : Boolean) : void;

        /** 获取地图位置 */
        function getMapPosition(mapId : int) : Point;
    }
}
