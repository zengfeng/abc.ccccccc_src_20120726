package game.core.hero
{
	import game.core.item.prop.ItemProp;
	import game.core.prop.Prop;
	import game.core.prop.PropManager;

	/**
	 * @author yangyiqiang
	 * 潜力成长
	 */
	public class PotentialGrowth
	{
		
		/** 职业 **/
		public var job : int;

		/** 潜力 **/
		public var potential : int;

		private var _prop : ItemProp = new ItemProp();
		
		public function get id():int
		{
			return job+potential;
		}

		public function addProperty(propId : int, value : Number) : void
		{
			var prop : Prop = PropManager.instance.getPropByID(propId);
			if (!prop) return;
			_prop[prop.key] += value;
		}
		
		public function get prop():ItemProp
		{
			return _prop;
		}
		private var count : int = 0;
		public function parse(arr:Array):void
		{
			count++;
			job = arr.length > count ? arr[count++] : 0;
			potential=arr.length > count ? arr[count++] : 0;
			for (var i:int=0;i<9;i++){
				addProperty(arr[count++],arr[count++]);
			}
		}
	}
}
