package game.module.wordDonate.donateManage {
	import flash.utils.Dictionary;
	/**
	 * @author 1
	 */
	public class DonateManage {
		private static var _instance:DonateManage;
		
		//保存开天斧配置内容  K：是开天斧等级
		public static var getDonateDic:Dictionary = new Dictionary();
		
		public static var getDonateMaxLevel:uint;
		
		public function DonateManage(control:Control):void{
		}
		public static function get instance():DonateManage{
			if(_instance == null){
				_instance = new DonateManage(new Control());
			}
			return _instance;
		}
		public function setProp(vo:DonateVo):void{
			var level:int = vo.level;
			getDonateDic[level] = vo;
		}
	}
}
class Control{}
