package game.module.formation.formationManage {
	import flash.utils.Dictionary;
	import game.core.item.prop.ItemProp;
	import game.core.item.prop.ItemPropManager;
	/**
	 * @author Lv
	 */
	public class FmmPropManage {
		private static var _instance:FmmPropManage;
		public function FmmPropManage(control:Control):void{}
		public static function get instance():FmmPropManage{
			if(_instance == null)
				_instance = new FmmPropManage(new Control());
			return _instance;
		}
		public static var fmProDic:Dictionary = new Dictionary(); 
		public function getFmmTip():void{
//			var 
			
			
			
			
			
			
//			var id:int = prop.id;
//			if((id<110106)&&(id>141022))return;
//			var vec:Vector.<FMMProp> = new Vector.<FMMProp>();
//			var propItem : ItemProp = ItemPropManager.instance.getProp(id);
//			for each (var key:String in ItemProp)
//			{
//				if (propItem[key] > 0)
//				{
//					var fmProp:FMMProp = new FMMProp();
//					fmProp.parse([key,propItem[key]]);
//					vec.push(fmProp);
//				}
//			}
//			fmProDic[id] = vec;





			var dict : Dictionary = new Dictionary();
			var ids : Array = [];
			for each (var id:uint in ids)
			{
				var prop : ItemProp = ItemPropManager.instance.getProp(id);
				var values : Array = [];
				for each (var key:String in ItemProp)
				{
					if (prop[key] > 0)
					{
						values.push({"key":key, "value":prop[key]});
					}
				}

				dict[id] = values;
			}
		}
	}
}
class Control{}