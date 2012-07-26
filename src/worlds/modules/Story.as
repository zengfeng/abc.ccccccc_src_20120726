package worlds.modules
{
	import worlds.maps.layers.lands.LandLayer;
	import worlds.apis.MLand;
	import worlds.apis.MMouse;
	import worlds.maps.layers.LayerContainer;

	/** 
	* @author ZengFeng (zengfeng75[AT]163.com) 2012-6-26
	*/
	public class Story
	{
		/** 单例对像 */
		private static var _instance : Story;

		/** 获取单例对像 */
		static public function get instance() : Story
		{
			if (_instance == null)
			{
				_instance = new Story(new Singleton());
			}
			return _instance;
		}

		function Story(singleton : Singleton) : void
		{
			singleton;
			layerContainer = LayerContainer.instance;
			landLayer = LandLayer.instance;
		}

		private var mapX : int;
		private var mapY : int;
		private var bindScorll : Boolean;
		private var enableWalk : Boolean;
		private  var layerContainer : LayerContainer;
		private var landLayer:LandLayer;

		public function enter() : void
		{
			mapX = layerContainer.mapX;
			mapY = layerContainer.mapY;
			bindScorll = MLand.bindScorll;
			enableWalk = MMouse.enableWalk;
			MLand.bindScorll = false;
			MMouse.enableWalk = false;
			if (layerContainer.roleLayer.parent) layerContainer.roleLayer.parent.removeChild(layerContainer.roleLayer);
//			landLayer.cacheAsBitmap = false;
		}

		public function exit() : void
		{
			layerContainer.container.addChildAt(layerContainer.roleLayer, layerContainer.gateLayer.numChild + 1);
			MLand.bindScorll = bindScorll;
			MMouse.enableWalk = enableWalk;
			layerContainer.initPosition(mapX, mapY);
//			landLayer.cacheAsBitmap = true;
		}
	}
}
class Singleton
{
}