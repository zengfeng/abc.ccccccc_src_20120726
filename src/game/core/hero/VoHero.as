package game.core.hero {
	import game.core.avatar.AvatarType;
	import net.RESManager;
	import game.config.StaticConfig;
	import game.core.avatar.AvatarManager;
	import game.core.item.equipable.IEquipableSlot;
	import game.core.item.equipment.Equipment;
	import game.core.item.equipment.EquipmentSlot;
	import game.core.item.gem.GemSlot;
	import game.core.item.prop.ItemProp;
	import game.core.item.prop.ItemPropManager;
	import game.core.item.soul.SoulSlot;
	import game.core.item.sutra.Sutra;
	import game.core.user.ExperienceConfig;
	import game.core.user.UserData;
	import game.manager.VersionManager;

	import com.utils.HeroUtils;
	import com.utils.PotentialColorUtils;
	import com.utils.StringUtils;

	import flash.utils.Dictionary;

	/**
	 * @author yangyiqiang
	 */
	public final class VoHero {
		// =====================
		// 属性
		// =====================
		// ID
		public var id : uint;
		// 名称
		public var _name : String;
		// 潜力
		private var _potential : uint;
		// 配置
		private var _config : HeroConfig;
		//		//  法宝槽
		// private var _sutraSlot : SutraSlot;
		// 发包
		public var sutra : Sutra;
		// 二级属性
		private var _prop : VoHeroProp = new VoHeroProp();
		// 套装
		public var suiteDict : Dictionary;
		// 0:无状态  2:修炼  3:出战
		public var state : int = 0;
		// 招募状态：0：已招募   1：可归队	2: 可招募   3: 可铸炼
		public var recruitState : int = 3;
		// 身上的6件装备
		public var eqSlots : Array;
		// 身上的6个元神
		public var soulSlots : Array;
		// 法宝的6个灵珠
		public var gemSlots : Array;
		// 法宝升阶信息表
		private var sutraStepDic : Dictionary = new Dictionary();
		// 战斗力
		private var _bt : int;
		//		//  符文效果 0： 无符文 1： 符文1 2：符文2
		// public var runetotemID:int = 0;
		//
		private var _privateLevel : int = 0;
		// 属性失效
		public var invalidate : Boolean = true;

		// =====================
		// Getter/Setter
		// =====================
		public function VoHero(level : int = 0) {
			if (level > 0) _privateLevel = level;
		}

		public function get config() : HeroConfig {
			return _config;
		}

		public function set config(value : HeroConfig) : void {
			_config = value;
		}

		public function get potential() : uint {
			return _potential;
		}

		public function set potential(value : uint) : void {
			_potential = value;
		}

		public function get level() : uint {
			return _privateLevel > 0 ? _privateLevel : UserData.instance.level;
		}

		public function get exp() : uint {
			return UserData.instance.exp;
		}

		public function get bt() : int {
			if (invalidate)
				HeroManager.instance.updateHeroProp(this);

			return _bt;
		}

		public function set bt(value : int) : void {
			_bt = value;
		}

		public function get prop() : VoHeroProp {
			if (invalidate)
				HeroManager.instance.updateHeroProp(this);

			return _prop;
		}

		public function set prop(value : VoHeroProp) : void {
			_prop = value;
		}

		// ------------------------------------------------
		// HeroConfig
		// ------------------------------------------------
		public function get recruitLevel() : uint {
			return _config.recruitHeroLevel;
		}

		public function get preRecruitLevel() : uint {
			return _config.preRecruitLevel;
		}

		public function get job() : uint {
			return _prop.job;
		}

		public function get jobName() : String {
			return HeroUtils.getJobName(job);
		}

		public function get name() : String {
			if (_name) return _name;
			_name = config.name;
			return _name;
		}

		public function set name(value : String) : void {
			_name = value;
		}

		public function get color() : uint {
			return PotentialColorUtils.getColorLevel(potential);
		}

		public function get equipments() : Array /* of Equipment */
 		{
			var arr : Array = [];

			for each (var slot:IEquipableSlot in eqSlots) {
				if (slot.equipable)
					arr.push(slot.equipable);
			}
			return arr;
		}

		public function getEquipment(type : uint) : Equipment {
			for each (var slot:IEquipableSlot in eqSlots) {
				var eq : Equipment = slot.equipable as Equipment;

				if (eq && eq.type == type)
					return eq;
			}

			return null;
		}

		public function getEqSlot(type : uint) : EquipmentSlot {
			return eqSlots[type - 81];
		}

		/*
		 * 获得将领身上元神
		 */
		public function get souls() : Array /* of Soul */
 		{
			var arr : Array = [];

			for each (var slot:IEquipableSlot in soulSlots) {
				if (slot.equipable)
					arr.push(slot.equipable);
			}

			return arr;
		}

		/*
		 * 获得将领身上宝石
		 */
		public function get gems() : Array /* of Gem */
 		{
			var arr : Array = [];

			for each (var slot:IEquipableSlot in gemSlots) {
				if (slot.equipable)
					arr.push(slot.equipable);
			}

			return arr;
		}

		// 90-109绿色，110-129蓝色，130-149紫色，150-169橙色
		public function get htmlName() : String {
			return StringUtils.addColorById(name, this.color);
		}

		public function get htmlLevel() : String {
			return StringUtils.addColorById(String(level), this.color);
		}

		public function get upgradeExp() : uint {
			return ExperienceConfig.getUpgradeExperience(level + 1);
		}

		public function get cloth() : int {
			if (id > 10) return 0;
			var value : int;
			for each (var slot:IEquipableSlot in eqSlots) {
				var eq : Equipment = slot.equipable as Equipment;
				if (eq&&eq.id % 10 == 2) {
					value = eq.id;
					break;
				}
			}
			if (value < 10020)
				value = 0;
			else {
				value = ((value + 8 - 10000) / 10);
				switch(value % 3) {
					case 0:
					case 1:
						value /= 3;
						break;
					case 2:
						value = 0;
						break;
					default:
						value = 0;
						break;
				}
			}
			return value;
		}

		/** 角色 
		 * public static const PLAYER_RUN : int = 0;
		 * public static const PLAYER_BATT_FRONT : int = 1;
		 * public static const PLAYER_BATT_BACK : int = 2;
		 */
		public function getAvatarUrl(type : int = 0) : String {
			return StaticConfig.cdnRoot + "assets/avatar/" + AvatarManager.instance.getUUId(id, type, cloth)+".swf";
		}

		public function get heroImage() : String {
			return StaticConfig.cdnRoot + "assets/ico/heroPicture/" + _config.headId + ".png";
		}

		public function get halfIocUrl() : String {
			return VersionManager.instance.getUrl("assets/ico/halfBody/" + id + ".png");
		}

		public function get halfImage() : String {
			return StaticConfig.cdnRoot + "assets/avatar/heroHalfBody/" + id + ".jpg";
		}

		public function get heroSmallHead() : String {
			return StaticConfig.cdnRoot + "assets/ico/heroSmallHead/" + id + ".png";
		}

		public function get fullImage() : String {
			return StaticConfig.cdnRoot + "assets/avatar/heroFullBody/" + ( id < 10 ? AvatarManager.instance.getUUId(id, 0, getCloth()) : id) + ".png";
		}
		
		public function preLoad():void
		{
			RESManager.instance.preLoad(getAvatarUrl(AvatarType.PLAYER_BATT_BACK));
			RESManager.instance.preLoad(heroImage);
			RESManager.instance.preLoad(halfIocUrl);
			RESManager.instance.preLoad(halfImage);
			RESManager.instance.preLoad(heroSmallHead);
			RESManager.instance.preLoad(fullImage);
		}

		public function getCloth() : int {
			var eq : Equipment = getEquipment(82);
			var value : int = eq ? eq.id : 0;
			if (value < 10020)
				value = 0;
			else {
				value = ((value + 8 - 10000) / 10);
				switch(value % 3) {
					case 0:
					case 1:
						value /= 3;
						break;
					case 2:
						value = 0;
						break;
					default:
						break;
				}
			}
			return value;
		}

		// public function get sutra() : Sutra
		// {
		// if (!_sutraSlot.equipable)
		// {
		// _sutraSlot.onEquipped(ItemManager.instance.getSutra(_config.sutraId));
		// }
		// return  _sutraSlot.equipable as Sutra;
		// }
		//
		// public function get sutraSlot() : SutraSlot
		// {
		// return _sutraSlot;
		// }
		// public function set sutraSlot(value : SutraSlot) : void
		// {
		// _sutraSlot = value;
		// }
		// =====================
		// 方法
		// =====================
		// public function refresh() : void
		// {
		// _prop = HeroManager.
		// SignalBusManager.heroPropChange.dispatch(this);
		// }
		/** 获取套装属性ID数组 **/
		public function getSuite(dic : Dictionary = null) : Array {
			var arr : Array = [];
			if (equipments.length < 3) return arr;
			if (dic == null) {
				dic = new Dictionary();
				for each (var eq:Equipment in equipments) {
					if (dic[int(eq.id / 10)]) dic[int(eq.id / 10)]["num"]++;
					else
						dic[int(eq.id / 10)] = {id:int(int(eq.id / 10)), num:1};
				}
			}
			for each (var obj:Object in dic) {
				if (obj["num"] == 6) arr.push((obj["id"] + 1) * 10);
				else if (obj["num"] >= 3) arr.push((obj["id"] + 1) * 10 - 1);
			}
			return arr;
		}

		public function updateSuite() : void {
			var eq : Equipment;
			suiteDict = new Dictionary();

			for each (eq in equipments) {
				if (suiteDict[eq.suiteId])
					suiteDict[eq.suiteId].push(eq);
				else
					suiteDict[eq.suiteId] = [eq];
			}

			for each (eq in equipments) {
				eq.suiteNums = suiteDict[eq.suiteId].length;
			}
		}

		public function getSuiteById(suiteId : uint) : Array {
			if (!suiteDict)
				return null;

			return suiteDict[suiteId];
		}

		public function getSuitePropById(suiteId : uint) : ItemProp {
			var suite : Array = suiteDict[suiteId];

			if (!suite)
				return null;

			var len : int = suite.length;
			if (len == 6)
				return ItemPropManager.instance.getProp(suiteId * 10 + 10);
			else if (len >= 3)
				return ItemPropManager.instance.getProp(suiteId * 10 + 9);

			return null;
		}

		public function clone() : VoHero {
			var vo : VoHero = new VoHero();
			vo.id = id;
			vo.potential = potential;
			vo.config = this.config;
			vo.state = this.state;
			vo.prop = _prop ? _prop.clone() : new VoHeroProp();
			vo.recruitState = this.recruitState;
			vo.state = this.state;

			vo.sutra = this.sutra;
			vo.eqSlots = eqSlots;
			vo.soulSlots = soulSlots;
			vo.gemSlots = gemSlots;
			vo.sutraStepDic = sutraStepDic;
			return vo;
		}

		private function setSutraStep() : void {
			sutraInToDic(10, 0, config.stepRelicLevel10, config.stepRelicLevel10_Num);
			sutraInToDic(20, 10, config.stepRelicLevel20, config.stepRelicLevel20_Num);
			sutraInToDic(30, 20, config.stepRelicLevel30, config.stepRelicLevel30_Num);
			sutraInToDic(40, 30, config.stepRelicLevel40, config.stepRelicLevel40_Num);
			sutraInToDic(50, 40, config.stepRelicLevel50, config.stepRelicLevel50_Num);
			sutraInToDic(60, 50, config.stepRelicLevel60, config.stepRelicLevel60_Num);
		}

		private function sutraInToDic(max : int, Least : int, sutraID : int, sutraNum : int) : void {
			for (Least;Least < max;Least++) {
				var obj : Object = new Object();
				var k : int = Least;
				obj["id"] = sutraID;
				obj["Num"] = sutraNum;
				sutraStepDic[k] = obj;
			}
		}

		/**
		 * 《获取每一阶所需法宝的id和个数》
		 * id:法宝id
		 * Num：法宝个数
		 */
		public function getSutraIDandNum(sutraLevel : int) : Object {
			if (sutraStepDic[sutraLevel])
				return sutraStepDic[sutraLevel];
			else
				return null;
		}

		/*
		 * 初始化插槽
		 */
		public function initSlots() : void {
			var pos : uint;

			// _sutraSlot = new SutraSlot(this);

			eqSlots = [];
			for (pos = 0; pos < 6;pos++) {
				eqSlots.push(new EquipmentSlot(this, pos));
			}

			soulSlots = [];
			for (pos = 0; pos < 6;pos++) {
				soulSlots.push(new SoulSlot(this, pos));
			}

			gemSlots = [];
			for (pos = 0; pos < 6;pos++) {
				if (!sutra) continue;
				gemSlots.push(new GemSlot(sutra, pos));
			}
			setSutraStep();
		}

		// 输出
		public function toString() : String {
			return "name=" + name + " Lv=" + level + " Recruit=" + recruitState;
		}
	}
}
