package game.module.mapWorld
{
	import game.manager.GetValManager;
	import game.manager.SignalBusManager;

	import worlds.apis.MWorld;

    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-3-26 ����1:58:32
     */
    public class WorldMapController
    {
        public function WorldMapController(singleton : Singleton)
        {
            singleton;
            init();
        }

        /** 单例对像 */
        private static var _instance : WorldMapController;

        /** 获取单例对像 */
        static public function get instance() : WorldMapController
        {
            if (_instance == null)
            {
                _instance = new WorldMapController(new Singleton());
            }
            return _instance;
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        private function init() : void
        {
            SignalBusManager.mapWorldOpen.add(signalOpen);
            SignalBusManager.mapWorldClose.add(signalClose);
        }

        private function signalOpen() : void
        {
            open();
        }

        private function signalClose() : void
        {
            close();
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        private var _worldMapView : WorldMapView;

        private function get worldMapView() : WorldMapView
        {
            if (_worldMapView == null)
            {
                _worldMapView = WorldMapView.instance;
                _worldMapView.showEndCall = viewShowEndCall;
            }
            return _worldMapView;
        }

        public function get currentMapId() : int
        {
            return WorldMapUtil.getWorldMapId();
        }

        public function checkEnOpen() : Boolean
        {
            var list : Vector.<Function> = GetValManager.checkEnOpenMapWorldList;
            var value : Boolean = true;
            for each (var fun:Function in list)
            {
                value = fun.apply();
                if (value == false)
                {
                    return value;
                }
            }
            return value;
        }

        /** 打开 */
        public function open(isAuto : Boolean = false) : void
        {
            if (checkEnOpen() == false) return;
            if (isAuto == false)
            {
                if (checkEnOpen() == false) return;
                toMapId = 0;
            }
            worldMapView.show();
            this.isAuto = isAuto;
        }

        /** 关闭 */
        public function close() : void
        {
            worldMapView.hide();
            toMapId = 0;
        }

        public function viewShowEndCall() : void
        {
            if (toMapId > 0)
            {
                toMap(toMapId);
            }
        }

        public var toMapId : int = 0;
        private var _isAuto : Boolean = false;

        public function get isAuto() : Boolean
        {
            return _isAuto;
        }

        public function set isAuto(value : Boolean) : void
        {
            _isAuto = value;
//            worldMapView.mouseChildren = !_isAuto;
//            worldMapView.mouseEnabled = !_isAuto;
        }

        /** 去某个地图 */
        public function toMap(mapId : int, isAuto : Boolean = false) : void
        {
            toMapId = mapId;
            if (worldMapView.isShow == false)
            {
                open(isAuto);
                return;
            }
            mapId = WorldMapUtil.getWorldMapId(mapId);
            toMapId = mapId;
            if (currentMapId == mapId)
            {
                // mapProto.cs_transport(0, 0, currentMapId);
                // return;
            }
            worldMapView.toMap(mapId);
        }

        /** 到达 */
        public function playerMoveComplete() : void
        {
            MWorld.csChangeMap(toMapId);
            close();
        }
    }
}
class Singleton
{
}