package game.module.wordDonate.donateManage {
	import flash.utils.Dictionary;
	/**
	 * @author 1
	 */
	public class DonateRewardManager {
		private static var _instance:DonateRewardManager;
		public static var saveDonateRewardMaxRank:int;
		//K：排名
		public static var saveDonateRewardDic:Dictionary = new Dictionary();
		
		//tips显示开天斧奖励
		public static var saveDonateRewardTipsVec:Vector.<String> = new Vector.<String>();
		public function DonateRewardManager(control:Control):void{
		}
		public static function get instance():DonateRewardManager{
			if(_instance == null){
				_instance = new DonateRewardManager(new Control());
			}
			return _instance;
		}
	}
}
class Control{}
