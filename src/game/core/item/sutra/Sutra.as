package game.core.item.sutra {
	import game.core.item.sutra.sutraSkill.SutraSkillItem;
	import com.utils.StringUtils;

	import game.core.item.sutra.sutraSkill.SutraManager;
	import game.core.item.prof.ProfItemManage;
	import game.core.hero.VoHero;
	import game.core.item.config.SutraConfig;
	import game.core.item.equipment.Equipment;
	import game.core.item.gem.Gem;
	import game.core.item.prop.ItemProp;

	/**
	 * @author jian
	 */
	public class Sutra extends Equipment {
		// =====================
		// 定义
		// =====================
		public static const MAX_STEP : uint = 80;
		// =====================
		// 属性
		// =====================
		// 法宝阶数
		public var step : uint;
		// 最大筑宝数值
		public var stepValue : uint;
		// 今天筑宝次数
		private var _hero : VoHero;
		// 灵珠
		private var _gems : Array;
//		// 武将法宝当前提交个数
//		public var sutraNowSumbitRate : int;
//		// 武将法宝今日提交个数
//		public var sutraNowDoaySumbit : int;
		
		//符文效果 0： 无符文 1： 符文1 2：符文2
		public var runetotemID:int = 0; 

		// =====================
		// Getter/Setter
		// =====================
		override public function get totalProp() : ItemProp {
			// 基础
			var total : ItemProp = _prop.clone();

			// 升级
			total.plus(stepProp);

			// 灵珠
			for each (var gem:Gem in gems) {
				total.plus(gem.prop);
			}

			// 强化
			total[enhanceProp] += enhanceValue;

			return total;
		}

		override public function get prop() : ItemProp {
			// var prop:ItemProp = _prop.clone();
			// prop.plus(stepProp);

			return _prop;
		}

		// 获取基础属性的key
		public function get propKey() : Array {
			var arr : Array = [];
			for (var i : int = 0 ; i < masterKeys.length; i++) {
				var key : String = masterKeys[i];
				if (prop[key] != 0) {
					arr.push(key);
				}
			}
			return arr;
		}

		// 上一阶属性
		public function get upstepProp() : ItemProp {
			return StepPropManager.instance.getStepProp(hero.config.id, step - 1);
		}

		// 本阶属性
		public function get stepProp() : ItemProp {
			return StepPropManager.instance.getStepProp(hero.config.id, step);
		}

		// 下阶属性
		public function get nextStepProp() : ItemProp {
			return StepPropManager.instance.getStepProp(hero.config.id, nextStep);
		}

		// 返回差值prop
		public function get deltaProp() : ItemProp {
			if(nextStepProp == null)return null;
			var deltaProp : ItemProp = nextStepProp.clone();
			deltaProp.minus(stepProp);
			return deltaProp;
		}

		// 返回当前和 上一阶 差值Key
		public function get getNowDeltaPropKey() : Array {
			var arr : Array = [];
			var deltaProp : ItemProp = stepProp.clone();
			deltaProp.minus(upstepProp);

			for each (var key:String in deltaProp.effectiveKeys) {
				if (deltaProp[key] != 0) {
					arr.push(key);
				}
			}
			return arr;
		}

		// 返回差值key
		public function get getDeltaPropKey() : Array {
			var arr : Array = [];
			if(nextStepProp == null)return [];
			var deltaProp : ItemProp = nextStepProp.clone();
			deltaProp.minus(stepProp);

			for each (var key:String in deltaProp.effectiveKeys) {
				if (deltaProp[key] != 0) {
					arr.push(key);
				}
			}
			return arr;
		}

		// 返回当前key
		public function get getNowPropKye() : Array {
			var arr : Array = [];
			for (var i : int = 0 ; i < masterKeys.length; i++) {
				var key : String = masterKeys[i];
				if (stepProp[key] != 0) {
					arr.push(key);
				}
			}
			return arr;
		}
		
		// 法宝主属性
		override public function get masterKeys():Array
		{
			return prop.allKeys;
		}

		// 获得镶嵌的灵珠
		public function get gems() : Array /* of Gem */
 		{
			if (!_gems)
				return _hero.gems;
			else
				return _gems;
		}

		public function set gems(value : Array) : void {
			_gems = value;
		}

		// 法宝技能
		public function get skill() : String {
			return SutraConfig(config).skill;
		}

		// 法宝攻击距离
		public function get range() : String {
			return SutraConfig(config).range;
		}
		public function sutraTips():String{
			var storyStr : String;
			storyStr = story;
			if(ruentAdd != "")
				 storyStr = storyStr + "\n\n" + ruentAdd + SutraManager.instance.getMardsData(hero.id, this.runetotemID).runetotem;
			if(skillHurt != "")
				storyStr = storyStr + "\n\n" + skillHurt;
			return storyStr;
		}

		// 法宝简介
		public function get story() : String {
			var storyStr : String;
			storyStr = StringUtils.addColor("法宝技能：\n", "#FFFF00") + SutraConfig(config).storyStat;
			return storyStr;
		}
		//技能伤害
		public function get skillHurt():String{
			var storyStr : String = "";
			var item1:SutraSkillItem = SutraManager.instance.getMardsData(hero.id, 1);
			var item2:SutraSkillItem = SutraManager.instance.getMardsData(hero.id, 2);
			if (stepNOwEffect != ""&&(step != item1.openStep)&&(step != item2.openStep)) {
				storyStr =  "伤害：" + stepNOwEffect;
			}
			return storyStr;
		}
		//符印加成
		public function get ruentAdd():String{
			var storyStr : String = "";
			if (this.runetotemID != 0) {
				if (SutraManager.instance.getMardsData(hero.id, this.runetotemID) != null) {
					var namestr : String = SutraManager.instance.getMardsData(hero.id, this.runetotemID).runetotemName;
//					storyStr =   StringUtils.addColor("符印：" + namestr + "\n", "#FFFF00") +SutraManager.instance.getMardsData(hero.id, hero.runetotemID).runetotem;
					storyStr =   StringUtils.addColor("符印：" + namestr + "\n", "#FFFF00") ;
				}
			}
			return storyStr;
		}
		public var  nextOpenRunet:int;
		// 法宝下一阶阶数特效-- 可能为空
		public function get stepEffect() : String {
			var nameStr : String;
			var item1:SutraSkillItem = SutraManager.instance.getMardsData(hero.id, 1);
			var item2:SutraSkillItem = SutraManager.instance.getMardsData(hero.id, 2);
			if (step+1 == item1.openStep) {
				nameStr = item1.runetotemName;
				nextOpenRunet = 1;
				return "开启新的符印 " + nameStr;
			} else if (step+1 == item2.openStep) {
				nameStr = item2.runetotemName;
				nextOpenRunet = 2;
				return "开启新的符印 " + nameStr;
			}
			nextOpenRunet = 3;
			if (deltaProp == null) return "";
			if (deltaProp["magic_per"] == 0) return "";
			var str : String = SutraConfig(config).skillUpDes;
			return str + nextStepProp["magic_per"] + "%";
		}

		// 法宝ben阶数特效-- 可能为空
		public function get stepNOwEffect() : String {
			var nameStr : String;
			var item1:SutraSkillItem = SutraManager.instance.getMardsData(hero.id, 1);
			var item2:SutraSkillItem = SutraManager.instance.getMardsData(hero.id, 2);
			if (step == item1.openStep) {
				nameStr = item1.runetotemName;
				return "开启新的符印 " + nameStr;
			} else if (step == item2.openStep) {
				nameStr = item2.runetotemName;
				return "开启新的符印 " + nameStr;
			}
			if (stepProp["magic_per"] == 0) return "";
			var str : String = SutraConfig(config).skillUpDes;
			return str + StringUtils.addColor(String(stepProp["magic_per"] + "%"), "#00FF00") ;
		}
		
		//是否有技能效果变化
		public function get getstepNowSkillChange():Boolean{
			var boo:Boolean;
			var item1:SutraSkillItem = SutraManager.instance.getMardsData(hero.id, 1);
			var item2:SutraSkillItem = SutraManager.instance.getMardsData(hero.id, 2);
			if(step == item1.openStep || step == item2.openStep)return true;
			if((stepProp["magic_per"] - upstepProp["magic_per"])>0)
				boo = true;
			else
				boo = false;
			return boo;
		}

		/**
		 * 获取符文是否开启 true ：开启　　false:未开启
		 * index：1--符文1  2--符文2
		 */
		public function getIsOpenRunet(index : int) : Boolean {
			var boo : Boolean;
			if (SutraManager.instance.getMardsData(hero.id, index) == null) return false;
			var ste : int = SutraManager.instance.getMardsData(hero.id, index).openStep;
			if (step + 1 > ste)
				boo = true;
			else
				boo = false;
			return boo;
		}

		/**
		 * 获取符文
		 * index:符文编号
		 */
		public function getRunet(index : int) : String {
			if (SutraManager.instance.getMardsData(hero.id, index) == null) return "";
			return SutraManager.instance.getMardsData(hero.id, index).runetotemName;
		}

		public function get nextStep() : uint {
			return Math.min(step + 1, MAX_STEP);
		}

		public function get stepString() : String {
			return step + "阶";
		}

		// 将领
		public function set hero(value : VoHero) : void {
			_hero = value;
		}

		// 当前阶所需经验值
		public function get expSetp() : Number {
			return ProfItemManage.instance.getNowSetpProfExp(step);
		}

		// 当前阶总经验值
		public function get totalExpSetp() : Number {
			return ProfItemManage.instance.getNowSetpProfTotalExp(step);
		}

		// 下一阶所需经验值
		public function get nextSetpExp() : Number {
			return ProfItemManage.instance.getNextSetpProfExp(step);
		}

		public function get hero() : VoHero {
			return _hero;
		}

		public function get stepMaxValue() : uint {
			return _hero.config.sutraValue;
		}

		public function get relic() : uint {
			return _hero.config.relic;
		}

		public function get  sutraValue() : uint {
			return _hero.config.sutraValue;
		}

		// =====================
		// 方法
		// =====================
		public function Sutra() {
			super();
		}

		public static function create(config : SutraConfig, prop : ItemProp) : Sutra {
			var sutra : Sutra = new Sutra();
			sutra.config = config;
			sutra.prop = prop;
			sutra.binding = true;

			return sutra;
		}

		override protected function parse(source : *) : void {
			super.parse(source);

			var sutra : Sutra = source as Sutra;
			sutra.prop = prop;
			sutra.hero = hero;
		}
	}
}
