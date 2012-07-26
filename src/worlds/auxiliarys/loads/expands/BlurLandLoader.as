package worlds.auxiliarys.loads.expands
{
    import flash.display.Loader;
    import flash.net.URLRequest;
    import com.utils.UrlUtils;
    import worlds.auxiliarys.loads.core.ImageLoader;
    import worlds.auxiliarys.loads.core.LoaderCore;


    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-17
     */
    public class BlurLandLoader extends ImageLoader
    {
        /** 单例对像 */
        private static var _instance : BlurLandLoader;

        /** 获取单例对像 */
        static public function get instance() : BlurLandLoader
        {
            if (_instance == null)
            {
                _instance = new BlurLandLoader(new Singleton());
            }
            return _instance;
        }

        public var mapId : int;

        public function BlurLandLoader(singleton : Singleton)
        {
            singleton;
            super();
			urlRequest = new URLRequest();
			loader = new Loader();
        }

        override public function generateLoader() : LoaderCore
        {
			url = UrlUtils.getMapThumbnail(mapId);
			urlRequest.url = url;
            return this;
        }

        override public function unloadAndStop(gc : Boolean, recoverLoader : Boolean = true) : void
        {
            super.unloadAndStop(gc, false);
			loader.unloadAndStop(false);
            mapId = NaN;
        }
    }
}
class Singleton
{
}