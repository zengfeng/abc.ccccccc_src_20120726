package game.module.notification.battleReport {
	/**
	 * @author Lv
	 */
	public class BattleReportControl {
		private static var _instance:BattleReportControl;
		public function BattleReportControl(contr:Contral):void{
		}
		
		public static function get instance():BattleReportControl{
			if(_instance  == null)
				_instance = new BattleReportControl(new Contral());
			return _instance;
		}
		
		
	}
}
class Contral{}
