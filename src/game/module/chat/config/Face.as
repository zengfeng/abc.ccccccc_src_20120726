package game.module.chat.config
{
    import com.utils.Download;
    import com.utils.DrawUtils;
    import com.utils.StringUtils;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import game.config.StaticConfig;



	/**
	 * 表情
	 * */
	public class Face
	{
		private static var _images:Array;
		public function Face()
		{
		}
		
		public static function get images():Array
		{
			if(_images)
			{
				return _images;
			}
			
			load();
			return _images;
		}
		
		/** 加载表情文件 */
		public static function load():void
		{
			Download.load(StaticConfig.cdnRoot + "assets/swf/face.swf", faceLoadComplete, [Download.SELF]);
		}
		
		/** 加载完表情文件 */
		public static function faceLoadComplete(loader:Loader):void
		{
			_images = new Array();
			var faceName:String;
			var frameName:String;
			var className:String;
			var TmpClass:Class;
			for(var i:int = 0; i <= 35; i++)
			{
				if(i == 17) continue;
				faceName = StringUtils.fillStr(i.toString(), 2, "0");
				className = "Face_" + faceName + "_00";
				if(loader.contentLoaderInfo.applicationDomain.hasDefinition(className) == false)
				{
					continue;
				}
				
				TmpClass = loader.contentLoaderInfo.applicationDomain.getDefinition(className) as Class;
				if(!TmpClass)
				{
					continue;
				}
				
				var classs:Array = new Array();
				for(var j:int = 0; j <= 29; j++)
				{
					frameName = StringUtils.fillStr(j.toString(), 2, "0");
					className = "Face_" + faceName + "_" + frameName;
					if(loader.contentLoaderInfo.applicationDomain.hasDefinition(className) == false)
					{
						break;
					}
					
					TmpClass = loader.contentLoaderInfo.applicationDomain.getDefinition(className) as Class;
					if(!TmpClass)
					{
						break;
					}
					
					var mc:MovieClip = new TmpClass();
					var bitmapData:BitmapData = new BitmapData(23, 23, true, 0x00000000);
					bitmapData.draw(mc, null, null, null, null, true);
					classs.push(bitmapData);
					
				}
				_images.push(classs);
			}
		}

		
		/**
		 * 获取表情
		 * */
		public static function getFace(id:int):DisplayObject
		{
			if(!images || !images[id])
			{
				return null;
			}
			var faceAnimation:FaceAnimation = new FaceAnimation(id);
//			faceAnimation.y = 1;
			var sprite:Sprite = DrawUtils.roundRect(null , 23, 23, 0, 0, 0, 0, 0, 0) as Sprite;
			sprite.addChild(faceAnimation);
			return sprite;
		}

	}
}