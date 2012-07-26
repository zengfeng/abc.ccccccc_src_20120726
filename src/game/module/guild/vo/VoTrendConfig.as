package game.module.guild.vo {
	import game.core.item.config.ItemConfig;
	import game.core.item.config.ItemConfigManager;

	import com.utils.PotentialColorUtils;
	import com.utils.StringUtils;

	import flash.utils.Dictionary;
	/**
	 * @author 1
	 */
	public class VoTrendConfig {
		public var trendId:uint = 0 ;
		public var trendText:String = "" ;
		public var trendType:uint = 0 ;
		
		public static const TREND_HR:uint = 0 ;	//人事动态
		public static const TREND_XP:uint = 1 ;	//经验动态
		
		public function parse(xml:XML):void
		{
			trendId = xml.@id ;
			trendType = xml.@type ;
			trendText = xml.@text ;
		}

		public function getTrendColorString(param : Vector.<uint>, source : Dictionary) : String {

			var str : String = trendText ;
			var ptn : RegExp = /[P|I|X]\d+/g ;
			var mtch : Array = str.match(ptn) ;
			if (mtch != null && mtch.length > 0)
			{
				for each ( var arr:String in mtch )
				{
					var n : uint = uint(arr.substr(1)) - 1 ;
					if ( n > param.length )
					{
						continue ;
					}
					if ( arr.charAt(0) == 'P' )
					{
						var gm:Object = source[param[n]];
						if( gm != null )
							str = str.replace(arr, StringUtils.addColorById( gm["name"], PotentialColorUtils.getColorLevel(gm["potential"])));
					}
					else if ( arr.charAt(0) == 'I' )
					{
						var it : ItemConfig = ItemConfigManager.instance.getConfig(param[n]);
						if ( it != null )
						{
							str = str.replace(arr, StringUtils.addColorById(it.name, it.color));
						}
					}
					else
					{
						str = str.replace(arr, StringUtils.addColorById(param[n].toString(), 2));
					}
				}
			}
			return str ;
		}
		
		public function getTrendString( param:Vector.<uint>,source:Dictionary ):String
		{
			var str : String = trendText ;
			var ptn : RegExp = /[P|I|X]\d+/g ;
			var mtch : Array = str.match(ptn) ;
			if (mtch != null && mtch.length > 0)
			{
				for each ( var arr:String in mtch )
				{
					var n : uint = uint(arr.substr(1)) - 1 ;
					if ( n > param.length )
					{
						continue ;
					}
					if ( arr.charAt(0) == 'P' )
					{
						var gm:Object = source[param[n]];
						if( gm != null )
							str = str.replace(arr, gm["name"]);
					}
					else if ( arr.charAt(0) == 'I' )
					{
						var it : ItemConfig = ItemConfigManager.instance.getConfig(param[n]);
						if ( it != null )
						{
							str = str.replace(arr, it.name);
						}
					}
					else
					{
						str = str.replace(arr, param[n].toString());
					}
				}
			}
			return str ;
		}
	}
}

