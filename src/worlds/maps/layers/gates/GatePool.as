package worlds.maps.layers.gates
{
	import flash.utils.Dictionary;
	import flash.display.MovieClip;

	/** 
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-6-18
	 */
	public class GatePool
	{
		/** 单例对像 */
		private static var _instance : GatePool;

		/** 获取单例对像 */
		static public function get instance() : GatePool
		{
			if (_instance == null)
			{
				_instance = new GatePool(new Singleton());
			}
			return _instance;
		}

		public var gateClassDic : Dictionary = new Dictionary();
		public var gateListDic : Dictionary = new Dictionary();

		function GatePool(singleton : Singleton)
		{
			singleton;
			gateListDic[0] = new Vector.<MovieClip>();
			gateListDic[1] = new Vector.<MovieClip>();
			gateListDic[2] = new Vector.<MovieClip>();
			gateListDic[3] = new Vector.<MovieClip>();
		}

		public function getObject(skinId : int) : MovieClip
		{
			var  list : Vector.<MovieClip> = gateListDic[skinId];
			if (list.length > 0)
			{
				return list.pop();
			}
			var gateClass : Class = gateClassDic[skinId];
			return new gateClass();
		}

		/**
		 * 
		 * @param bitmapData
		 */
		public function destoryObject(obj : MovieClip) : void
		{
			if (obj == null) return;
			var skinId : int = obj["skinId"];
			var  list : Vector.<MovieClip> = gateListDic[skinId];
			if (list.indexOf(obj) != -1) return;
			list.push(obj);
		}
	}
}
class Singleton
{
}