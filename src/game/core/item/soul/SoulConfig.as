package game.core.item.soul
{
	/**
	 * @author jian
	 */
	public class SoulConfig
	{	
		public var id:uint;
		public var exp:uint;
		public var level:uint;
		public var totemName:String;
		public var flameId:String;
		
		public function parse (arr:Array):void
		{
			id = arr[0];
			// 跳过名字
			exp = arr[2];
			level = arr[3];
			totemName = arr[4];
			flameId = arr[5];
		}
	}
}
