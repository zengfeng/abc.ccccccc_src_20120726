package game.core.item.config
{
	/**
	 * @author jian
	 */
	public class SutraConfig extends ItemConfig
	{
		public var skill : String;
		public var range : String;
		public var storyStat:String;
		public var skillUpDes:String;

		override public function parse(arr : Array) : void
		{
			super.parse(arr);
			
			skill = arr.length > count ? arr[count++] : "";
			range = arr.length > count ? arr[count++] : "";	
			storyStat = arr.length > count ? arr[count++] : "";
			skillUpDes= arr.length > count ? arr[count++] : "";
		}
	}
}
