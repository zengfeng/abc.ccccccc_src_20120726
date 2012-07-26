package game.core.item
{
	import flash.utils.Dictionary;
	import model.ListModel;
	/**
	 * @author jian
	 */
	public class IndexListModel
	{
		// =====================
		// Attribute
		// =====================
		private var _model:ListModel;
		private var _indexDict:Dictionary;
		
		// =====================
		// Setter/Getter
		// =====================
		public function get source ():Array
		{
			return _model.source;
		}
		
		public function set source (value:Array):void
		{
			_model.source = value;
			_indexDict = new Dictionary();
			
			var index:uint = 0;
			for each (var item:Object in value)
			{
				_indexDict[item] = index;
				index++;
			}
		}

		public function get itemNums ():int
		{
			var nums:int = 0;
			
			for each (var item:Object in _model.source)
			{
				if (item)
					nums++;
			}
			
			return nums;
		}
		
		// =====================
		// Method
		// =====================
		public function IndexListModel (model:ListModel =null)
		{
			if (!model)
				model = new ListModel(true);
			
			_model = model;
			_model.fireEvent = false;
			_indexDict = new Dictionary(true);
		}

		
		public function removeAt (index:int):void
		{
			delete _indexDict[_model.getAt(index)];
			_model.removeAt(index);
		}
		
		public function setAt (index:int, item:Object):void
		{
			if (index < 0)
			{
				return;
			}
			
			remove(item);
				
			_model.setAt(index, item);
			_indexDict[item] = index;
		}
		
		public function add (item:Object):void
		{
			setAt(_model.findFree(), item);
		}
		
		public function remove (item:Object):void
		{
			if (_indexDict[item] !== undefined)
				removeAt(_indexDict[item]);
		}
		
		public function toTrimArray():Array
		{
			return _model.toTrimArray();
		}
		
		public function indexOfItem(item:Object):int
		{
			var index:* = _indexDict[item];
			if (index !== undefined)
				return index;
			else
				return -1;
		}
		

	}
}
