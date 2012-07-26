package game.module.formation.formationManage
{
	import flash.utils.Dictionary;

	/**
	 * @author Lv
	 */
	public class FMManager
	{
		private static var _instance : FMManager;
		public static var formationKindsDic : Dictionary = new Dictionary();
		// 开放等级限制
		public static var formationShowLevelArr : Array = new Array();
		public static var formationVec : Vector.<VoFM> = new Vector.<VoFM>();
		// 等级所需要的银币
		public static var formationSilverLevelVec : Array = new Array();
		public static var formationLeveLimitVec : Array = new Array();
		public static var _formationStepTipDic : Dictionary;
		

		public function FMManager(control : Controller) : void
		{
		}

		public static function get instance() : FMManager
		{
			if (_instance == null)
			{
				_instance = new FMManager(new Controller());
			}
			return _instance;
		}

		public function fmToVo(vo : VoFM) : void
		{
			var id : int = vo.fm_id;
			FMManager.formationKindsDic[id] = vo;
			formationShowLevelArr.push(vo.fm_shwoLevel);
			formationVec.push(vo);
		}

		public function changeUpgradeXml(xml : XML) : void
		{
			var upgradeStr : String = xml.@level;
			var silverStr : String = xml.@needSilver;
			formationSilverLevelVec = changeStrToArr(silverStr, formationSilverLevelVec);
			formationLeveLimitVec = changeStrToArr(upgradeStr, formationLeveLimitVec);
		}

		private function changeStrToArr(str : String, Arr : Array) : Array
		{
			var n : int = str.split(",").length;
			Arr = str.split(",", n);
			return Arr;
		}

		static public function get formationStepTipDic() : Dictionary
		{
			if (!_formationStepTipDic)
			{
				_formationStepTipDic = new Dictionary();
				
				var arr11 : Array = [6, 8, 12, 17, 22];
				var arr12 : Array = [2, 7, 12, 17, 22];
				var arr13 : Array = [6, 8, 18, 16, 12];
				var arr14 : Array = [7, 11, 13, 17, 22];
				_formationStepTipDic[11] = arr11;
				_formationStepTipDic[12] = arr12;
				_formationStepTipDic[13] = arr13;
				_formationStepTipDic[14] = arr14;
			}
			return _formationStepTipDic;
		}
	}
}
class Controller
{
}
