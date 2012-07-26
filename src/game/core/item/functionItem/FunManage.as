package game.core.item.functionItem {
	import flash.utils.Dictionary;
	/**
	 * @author Lv
	 */
	public class FunManage {
		private static var _instance:FunManage;
		public function FunManage():void{
			if (_instance) throw (Error("单例错误！"));
		}
		
		public static function get instance():FunManage{
			if(_instance == null)
				_instance = new FunManage();
			return _instance;
		}


		private var sutraStepDic:Dictionary = new Dictionary();
		private var sutraLeveDic:Dictionary = new Dictionary();
		private var indexStep:Number = -1;
		
		public function funVo(vo:FunItem):void{
			var leve:int = vo.level;
			var step:int = vo.sutraStepUp;
			
			setSuta(leve, step);
			setSutaLeve(leve, step);
		}
		
		private function setSuta(level:int,sutrStepLeve:int):void{
			sutraStepDic[level] = sutrStepLeve;
		}
		
		private function setSutaLeve(level:int,sutrStepLeve:int):void{
			if(indexStep == sutrStepLeve)return;
			indexStep = sutrStepLeve;
			sutraLeveDic[indexStep] = level;
		}
		
		/**
		 * 通过将领等级 获取相应等级的法宝上线
		 * leve: 主将等级
		 */
		public function getSutraUp(leve:int):int{
			return sutraStepDic[leve];
		}
		/**
		 * 通过当前法宝阶数获取下一阶升级的主将等级
		 */
		public function getSutraLeve(step:int):int{
			var nowStep:int = (Math.ceil(step/10)) * 10;
			if(sutraLeveDic[nowStep] == null)return -1;
			return sutraLeveDic[nowStep];
		}
		
	}
}
