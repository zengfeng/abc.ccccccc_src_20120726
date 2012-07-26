// // // // // // // // // // ///////////////////////////////////////
// BitmapDataPool.as
// Macromedia ActionScript Implementation of the Class BitmapDataPool
// Generated by Enterprise Architect
// Created on:      11-五月-2012 15:20:01
// Original author: ZengFeng
// // // // // // // // // // ///////////////////////////////////////
package worlds.maps.layers.lands.pools
{
	import flash.display.BitmapData;

	import worlds.maps.configs.LandConfig;

	/**
	 * 固定大小的区块可以从这个池中获取
	 * @author ZengFeng
	 * @version 1.0
	 * @updated 11-五月-2012 15:22:38
	 */
	public class BitmapDataPool
	{
		/** 单例对像 */
		private static var _instance : BitmapDataPool;

		/** 获取单例对像 */
		static public function get instance() : BitmapDataPool
		{
			if (_instance == null)
			{
				_instance = new BitmapDataPool(new Singleton());
			}
			return _instance;
		}

		public var WIDTH : int;
		public var HEIGHT : int;
		private var list : Vector.<BitmapData> = new Vector.<BitmapData>();

		function BitmapDataPool(singleton : Singleton)
		{
			singleton;
			// WIDTH = LandConfig.GRID_ITEM_WIDTH ;
			// HEIGHT = LandConfig.GRID_ITEM_HEIGHT ;
			WIDTH = 4096 ;
			HEIGHT = 3840 ;
		}

		public function getObject() : BitmapData
		{
			if (list.length > 0)
			{
				return list.pop();
			}
			return new BitmapData(WIDTH, HEIGHT, false, 0);
		}

		/**
		 * 
		 * @param bitmapData
		 */
		public function destoryObject(bitmapData : BitmapData) : void
		{
			if (bitmapData == null) return;
			if (list.indexOf(bitmapData) != -1) return;
			// bitmapData.dispose();
			list.push(bitmapData);
		}
	}
	// end BitmapDataPool
}
class Singleton
{
}