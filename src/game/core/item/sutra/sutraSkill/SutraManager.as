package game.core.item.sutra.sutraSkill {
	import game.core.hero.VoHero;
	import game.core.item.sutra.Sutra;

	import flash.utils.Dictionary;

	/**
	 * @author Lv
	 */
	public class SutraManager {
		private static var _instance : SutraManager;

		public function SutraManager() : void {
			if (_instance) throw (Error("单例错误！"));
		}

		public static function get instance() : SutraManager {
			if (_instance == null)
				_instance = new SutraManager();
			return _instance;
		}

		private var marksSutraSkillDic : Dictionary = new Dictionary();
		private var sutraSkillDic : Dictionary = new Dictionary();
		private var marksDic : Dictionary = new Dictionary();
		private var openStepDic : Dictionary = new Dictionary();

		public function setSutraSkillVo(vo : SutraSkillItem) : void {
			var id : int = vo.heroID;
			var step : int = vo.openStep;
			var runetotemID : int = vo.runetotemID;
			var skillID : int = vo.skillID;

			getOpenSkillItem(id, step, vo);
			getMarksItem(skillID, vo);
			// getOpenStep(id,vo);
			getMarksSkillItem(id, runetotemID, vo);
		}

		private function getMarksSkillItem(id : int, runetotemID : int, vo : SutraSkillItem) : void {
			if (runetotemID == 0) return;
			marksSutraSkillDic[id + "_" + runetotemID] = vo;
		}

		private function getMarksItem(skillID : int, vo : SutraSkillItem) : void {
			marksDic[skillID] = vo;
		}

		private function getOpenSkillItem(id : int, step : int, vo : SutraSkillItem) : void {
			if (step == 0) return;
			sutraSkillDic[id + "_" + step] = vo;
		}

		/**
		 * 通过技能id获取vo
		 * 如果不错这个技能ID则返回null
		 */
		public function getMarksVo(skillID : int) : SutraSkillItem {
			if (marksDic[skillID] == null) return null;
			return marksDic[skillID];
		}

		/**
		 * 获取符文开放阶数 数组
		 * heroID
		 */
		public function geOpenStepArr(heroID : int) : Array {
			return openStepDic[heroID];
		}

		/**
		 * 通过将领id和符文编号获取数据
		 */
		public function getMardsData(heroID : int, runetotemID : int) : SutraSkillItem {
			if (marksSutraSkillDic[heroID + "_" + runetotemID] == null) return null;
			return marksSutraSkillDic[heroID + "_" + runetotemID];
		}

		public function  getNowSkillID(vohero : VoHero) : Number {
			var stura : Sutra = vohero.sutra;
			var heroID : int = vohero.id;
			var skillId:int=vohero.id + 100;
			if (stura.runetotemID != 0) {
				skillId=(marksSutraSkillDic[heroID + "_" + stura.runetotemID] as SutraSkillItem).skillID;
			}
			return skillId;
		}
	}
}
