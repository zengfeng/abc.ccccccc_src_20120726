package test.render.config
{
	/**
	 * @author jian
	 */
	public class MapRenderConfig
	{
		// 移动方式
		public var moveType:String;
		// 渲染方式
		public var renderType:String;
		// 分块方式
		public var tileType:String;
		// 同步方式
		public var syncType:String;
		// 屏幕外裁剪
		public var curling:Boolean;
		// 屏幕尺寸
		public var screenWidth:Number;
		public var screenHeight:Number;
		// 地图尺寸
		public var mapWidth:Number;
		public var mapHeight:Number; 
		// 帧频
		public var frameRate:Number;
		// 速度 pixels = pixels/frame * fps
		public var velocity:Number;
		// 整像素处理
		public var pixelSnapping:String;
		// Dummy UI
		public var dummyUI:String;
	}
}
