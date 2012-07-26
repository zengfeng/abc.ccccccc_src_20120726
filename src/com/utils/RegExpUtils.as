package com.utils {
	import game.core.hero.HeroManager;
	import game.core.hero.VoHero;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.manager.RSSManager;
	import game.module.quest.QuestUtil;
	import game.module.quest.VoBase;
	import game.module.quest.VoMonster;

	import worlds.apis.MapUtil;
	import worlds.maps.configs.structs.MapStruct;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-3-30 ����4:44:05
	 * 过滤文本
	 */
	public class RegExpUtils {
		public function RegExpUtils(singleton : Singleton) {
			singleton;
		}

		/** 单例对像 */
		private static var _instance : RegExpUtils;

		/** 获取单例对像 */
		static public function get instance() : RegExpUtils {
			if (_instance == null) {
				_instance = new RegExpUtils(new Singleton());
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		public static var text : String;
		public static var textF : String;
		private var _regExp : RegExp;
		private var _regExpF : RegExp;

		public function get regExp() : RegExp {
			if (_regExp == null && text != null) {
				_regExp = new RegExp("(" + text + ")+?", "img");
			}
			return _regExp;
		}

		public function get regExpF() : RegExp {
			if (_regExpF == null && textF != null) {
				_regExpF = new RegExp("(" + textF + ")+?", "img");
			}
			return _regExpF;
		}

		/** 验证文本 */
		public function checkStr(str : String) : Boolean {
			if (str == null) return false;
			if (regExp == null || regExpF == null) return true;
			regExp.lastIndex = 0;
			regExpF.lastIndex = 0;
			var isReg : Boolean;
			if (regExp.test(str) || regExpF.test(str))
				isReg = true;
			else
				isReg = false;
			regExp.lastIndex = 0;
			regExpF.lastIndex = 0;
			return isReg;
		}

		/** 获取过滤文本 */
		public function getFilterStr(str : String) : String {
			if (str == null || regExp == null || regExpF == null) return str;
			// 根据正则替换字符串
			regExp.lastIndex = 0;
			regExpF.lastIndex = 0;
			if (regExpF.test(str)) {
				str = str.replace(regExpF, regHandlerF);
			}
			if (regExp.test(str)) {
				str = str.replace(regExp, regHandler);
			}
			return str;
		}

		/**  处理过滤的函数 */
		private function regHandlerF() : String {
			// 获取正则获取的字符串
			var s : String = String(arguments[0]);
			// 替换成*
			var str : String = s.replace(/.{1}/g, "*");
			return str;
		}

		/**  处理过滤的函数 */
		private function regHandler() : String {
			// 获取正则获取的字符串
			var s : String = String(arguments[0]);
			// 替换成*
			var str : String = s.replace(/.{1}/g, "*");
			return str;
		}

		public static function getFilterStr(str : String) : String {
			return RegExpUtils.instance.getFilterStr(str);
		}

		public static function checkStr(str : String) : Boolean {
			return RegExpUtils.instance.checkStr(str);
		}

		/** 替换后的内容 */
		public static function getRegExpContent(value : String, strArg : *=null, numArg : *=null) : String {
			var msg : String = value;
			var num : int = 0;
			if (strArg != null)
				for each (var str:String in strArg) {
					num++;
					msg = msg.replace(new RegExp("xx" + num, "img"), str);
				}
			if (numArg != null) {
				num = numArg["length"];
				var arr:* = numArg["slice"]();
				arr = arr["reverse"]();
				for each (var item:int in arr) {
					msg = msg.replace(new RegExp("yy" + num, "img"), item);
					num--;
				}
			}
			return RegExpUtils.parseRegExpStr(msg);
		}

		/**
		 * 						           [1-19:heroColor]
		 *itemColor(1.白 2.绿 3.蓝)        [20:itemID]
		 * 								   [21:npcID]
		 * 								   [22:itemId(用指定#ff0000)]
		 * 								   [23:num|num2]支持二个数字计算得出小数点
		 */
		public static function parseRegExpStr(str : String) : String {
			var repStr : String;
			var type : int;
			var targetStr : String;
			QuestUtil.reg.lastIndex = 0;
			var result : Array = QuestUtil.reg.exec(str);
			while (result && result.length > 1) {
				repStr = result[0];
				result = (result[1] as String).split(":");
				type = result[0];
				targetStr = result[1];
				switch(type) {
					case 20:
						var vo : Item = ItemManager.instance.newItem(Number(targetStr));
						if (!vo)
							str = str.replace(repStr, StringUtils.addColor("不认识的物品", "#ff0000"));
						else
							str = str.replace(repStr, vo.htmlName);
						break;
					case 21:
						var npc : VoBase = RSSManager.getInstance().getNpcById((Number(targetStr)));
						if (!npc)
							str = str.replace(repStr, StringUtils.addColor("不认识的NPC", "#ff0000"));
						else
							str = str.replace(repStr, StringUtils.addColor(npc.name, "#FF9900"));
						break;
					case 22:
						vo = ItemManager.instance.newItem(Number(targetStr));
						if (!vo)
							str = str.replace(repStr, StringUtils.addColor("不认识的物品", "#ff0000"));
						else
							str = str.replace(repStr, vo.name);
						break;
					case 23:
						var arr : Array = targetStr.split("|");
						var num : Number = Number(arr[0]) / Number(arr[1]);
						str = str.replace(repStr, StringUtils.numToString(num));
						break;
					case 24:
						var monster : VoMonster = RSSManager.getInstance().getMosterById((Number(targetStr)));
						if (!monster)
							str = str.replace(repStr, StringUtils.addColor("不认识的怪物", "#ff0000"));
						else
							str = str.replace(repStr, StringUtils.addColor(monster.name, "#FF9900"));
						break;
					case 25:
						var hero : VoHero = HeroManager.instance.newHero((Number(targetStr)));
						if (!hero)
							str = str.replace(repStr, StringUtils.addColor("不认识的名仙", "#ff0000"));
						else
							str = str.replace(repStr, hero.htmlName);
						break;
					case 26:
						// 地图
						var mapId : int = int(targetStr);
						if (mapId % 100 == 0) mapId += 1;
						var mapStruct : MapStruct = MapUtil.getMapStruct(mapId);
						if (!mapStruct)
							str = "不认识的地图";
						else
							str = str.replace(repStr, StringUtils.addColor(mapStruct.name, "#FF9900"));
						break;
					default:
						str = str.replace(repStr, StringUtils.addColor(targetStr, ColorUtils.TEXTCOLOR[type]));
						break;
				}
				result = QuestUtil.reg.exec(str);
			}
			return str;
		}
	}
}
class Singleton {
}