package game.core.item.prop
{
	import com.utils.StringUtils;
	import com.utils.ColorUtils;
	import game.core.prop.PropManager;
	/**
	 * @author jian
	 */
	public class ItemPropUtils
	{
		public static function getPropDescription(prop:ItemProp):String
		{
			var desc:String = "";
			
			for each (var key:String in prop.allKeys)
			{
				if (prop[key] > 0)
				{
					desc += PropManager.instance.getPropByKey(key).name + " +" + StringUtils.addColor(prop[key], ColorUtils.GOOD);
				}
			}
			
			return desc;
		}
	}
}
