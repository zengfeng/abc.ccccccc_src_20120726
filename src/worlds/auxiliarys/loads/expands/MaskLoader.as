package worlds.auxiliarys.loads.expands
{
	import flash.display.Loader;
	import flash.net.URLRequest;
	import worlds.auxiliarys.loads.core.ImageLoader;
	import worlds.auxiliarys.loads.core.LoaderCore;

	import com.utils.UrlUtils;

	/** 
	* @author ZengFeng (zengfeng75[AT]163.com) 2012-6-20
	*/
	public class MaskLoader extends ImageLoader
	{
        /** 单例对像 */
        private static var _instance : MaskLoader;

        /** 获取单例对像 */
        static public function get instance() : MaskLoader
        {
            if (_instance == null)
            {
                _instance = new MaskLoader(new Singleton());
            }
            return _instance;
        }

        public var mapId : int;

        public function MaskLoader(singleton : Singleton)
        {
            singleton;
            super();
			urlRequest = new URLRequest();
			loader = new Loader();
        }

        override public function generateLoader() : LoaderCore
        {
			url = UrlUtils.getMapMask(mapId);
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