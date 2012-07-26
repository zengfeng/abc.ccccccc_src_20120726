package worlds.apis
{
	import worlds.maps.layers.LayerContainer;
	import worlds.WorldStartup;

	import flash.display.Sprite;

	import worlds.mediators.MapMediator;

	import flash.display.BitmapData;

	/** 
	* @author ZengFeng (zengfeng75[AT]163.com) 2012-6-15
	*/
	public class MLand
	{
		/** 是否绑定卷动频幕 */
		public static function get bindScorll() : Boolean
		{
			return  MapMediator.cbBindScorll.call();
		}

		public static function set bindScorll(value : Boolean) : void
		{
			MapMediator.cBindScorll.call(value);
		}

		/** 频幕截图 */
		public static function printScreen(centerX : int, centerY : int, width : uint = 0, height : uint = 0) : BitmapData
		{
			return  MapMediator.cbPrintScreen.call(centerX, centerY, width, height);
		}

		/** 获取地图容器 */
		public static function get mapContainer() : Sprite
		{
			return WorldStartup.mapContainer;
		}
		
		/** 设置地图位置 */
		public static function setPosition(x:int, y:int):void
		{
			LayerContainer.instance.updatePosition(x, y);
		}
	}
}
