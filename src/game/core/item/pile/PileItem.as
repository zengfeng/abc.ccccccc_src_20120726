package game.core.item.pile
{
	import game.core.item.Item;
	import game.core.item.config.ItemConfig;

	/**
	 * @author jian
	 */
	public class PileItem extends Item implements IPileGroup, IPileElement
	{
		// =====================
		// @属性
		// =====================
		private var _group:IPileGroup;
		private var _elements:Array /* of IPileElement */;
		private var _selected:Boolean;
				
		// =====================
		// @接口
		// =====================
		public function get group():IPileGroup
		{
			return _group;
		}
		
		public function set group(value:IPileGroup):void
		{
			_group = value;
		}
		
		public function get elements():Array
		{
			if (!_elements)
				splitPile();
			return _elements;
		}
		
		public function set selected (value:Boolean):void
		{
			_selected = value;
			
			if (_elements)
			{
				for each (var element:PileItem in _elements)
				{
					element.selected = value;
				}
			}
		}
		
		public function get selected ():Boolean
		{
			return _selected;
		}
		
		override public function set nums (value:uint):void
		{
			super.nums = value;
			
			_elements = null;
		}
		
		
		// =====================
		// @方法
		// =====================
		static public function create (config:ItemConfig, binding:Boolean):PileItem
		{
			var item:PileItem = new PileItem();
			item.config = config;
			item.binding = binding;
			
			return item;
		}
		
		override protected function parse (source : *):void
		{
			super.parse(source);
			
			var item:PileItem = source as PileItem;
			item.group = group;
		}
		
		private function splitPile() : void
		{
			_elements = [];
			
			if (nums == 0) return;

			var total : int = nums;
			var limit : int = config.stackLimit;

			while (total > 0)
			{
				var pile : PileItem = this.clone();
				
				pile.nums = (total > limit) ? limit : total;
				pile.group = this;
				pile.selected = selected;
				_elements.push(pile);
				total -= limit;
			}
		}
	}
}
