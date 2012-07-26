package game.module.chat.config
{
	import com.utils.ColorUtils;
	import flash.utils.Dictionary;

	/**
	 * 玩家颜色配置
	 * */
	public class PlayerColor
	{
		/** 颜色字典 */
		private static var _colorDic:Dictionary;
		private static var _colorLevelDic:Array;
		public function PlayerColor()
		{
		}
		
		
		///////////////////////////////////////////
		/** 颜色字典 */
		public static function get colorDic():Dictionary
		{
			if(_colorDic == null)
			{
//				var arr:Array = [0xFFFFFF, 0x04CECC, 0xCC02CC, 0x0402CC, 0xCCCE04, 0x04CE04, 0xCC0204];
                var arr:Array = ColorUtils.TEXTCOLOROX;
				_colorDic = new Dictionary();
				for(var i:int = 0; i < arr.length; i++)
				{
					_colorDic[i] = arr[i];
				}
			}
			return _colorDic;
		}

		/**
		 * @private
		 */
		public static function set colorDic(value:Dictionary):void
		{
			_colorDic = value;
		}
		
		///////////////////////////////////////////

		/** 颜色级别字典 */
		public static function get colorLevelDic():Array
		{
			if(_colorLevelDic == null)
			{
                //90-109绿色，110-129蓝色，130-149紫色，150-169橙色
				_colorLevelDic = [
					[-1,-1],
					[0,89],
					[90,109],
					[110,129],
					[130,149],
					[150,169],
                    [170,300]
				];
			}
			
			return _colorLevelDic;
		}

		/**
		 * @private
		 */
		public static function set colorLevelDic(value:Array):void
		{
			_colorLevelDic = value;
		}
		///////////////////////////////////////////
		
		/** 获取颜色级别 */
		public static function getColorLevel(value:Number):uint
		{
            if(value < 10) return value;
			var level:int = 0;
			var arr:Array;
			//超过最小时
			arr = colorLevelDic[0];
			if(value <= arr[0])
			{
				level = 0;
				return level;
			}
			//超过最大时
			arr = colorLevelDic[colorLevelDic.length - 1];
			if(value >= arr[1])
			{
				level = colorLevelDic.length - 1;
				return level;
			}
			
			for(var i:int = 0; i < colorLevelDic.length; i++)
			{
				arr = colorLevelDic[i];
				if(value >= arr[0] && value <= arr[1])
				{
					level = i;
					break;
				}
			}
			
			return level;
		}
		
		/** 获取颜色 */
		public static function getColor(value:Number):uint
		{
			var level:uint = getColorLevel(value);
			return colorDic[level];
		}

	}
}