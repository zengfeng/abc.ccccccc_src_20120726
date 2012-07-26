package game.core.item.prof {
	import flash.utils.Dictionary;
	/**
	 * @author Lv
	 */
	public class ProfItemManage {
		private static var _instance:ProfItemManage;
		
		
		
		public function ProfItemManage():void{
			if (_instance) throw (Error("单例错误！"));
		}
		public static function get instance():ProfItemManage{
			if(_instance == null)
				_instance = new ProfItemManage();
			return _instance;
		}
		
		private var proDic:Dictionary = new Dictionary();
		public function profVo(vo:ProfItem):void{
			var setp:int = vo.step;
			proDic[setp] = vo;
		}
		
		public function getNowSetpProfExp(step:int):Number{
			return (proDic[step] as ProfItem).proValue;
		}
		
		public function getNextSetpProfExp(step:int):Number{
			if(proDic[step+1] == null) return -1;
			return (proDic[step+1] as ProfItem).proValue;
		}
		
		public function getNowSetpProfTotalExp(step:int):Number{
			return (proDic[step] as ProfItem).totalProValue;
		}
		
		public function getNextSetpProfTotalExp(step:int):Number{
			if(proDic[step+1]) return -1;
			return (proDic[step+1] as ProfItem).totalProValue;
		}
	}
}
