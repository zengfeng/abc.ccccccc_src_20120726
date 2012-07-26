package game.module.daily {
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.core.user.UserData;
	import game.manager.VersionManager;
	import game.manager.ViewManager;
	import game.module.bossWar.ProxyBossWar;
	import game.module.mapGroupBattle.GBProto;
	import game.module.quest.QuestUtil;

	import worlds.apis.MValidator;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author yangyiqiang
	 */
	public class VoDaily extends EventDispatcher {
		/*
		 *	   daily  对应日常的   每日活动 
		 *	   id 活动的编号    id小的排在上面
		 *	   name
		 *	   description
		 *	   type    1：点击传送至NPC面前
		 *	   		   2: vip传送,如没vip 慢慢爬过去
		 *	   		   3: 打开指定功能面板
		 *	   link    type =1,2 时  mapId|npcId    type=3 时  menuId(参照menu.xml)  
		 *	   ioc     活动图标名
		 */
		public var id : int = 0;
		public var name : String ;
		public var _description : String ;
		public var description2 : String ;
		public var type : int;
		public var level : int;
		private var ico : String;
		private var link : String;
		private var _vars : Array = [0, 0];
		/**
		 * 状态
		 *  0 - 今日无活动  1 - 未开启  2 - 已开启  3 - 已结束
		 */
		private var _state : int = -1;

		public function parse(xml : XML) : void {
			id = xml.@id;
			name = xml.@name;
			_description = xml.@description;
			description2 = xml.@description2;
			type = xml.@type;
			link = xml.@link;
			ico = xml.@ico;
			level = xml.@level;
		}

		public function refresh() : void {
			this.dispatchEvent(new Event("refresh"));
		}

		public function get description() : String {
			var str : String = _description;
			var desc : String;

			for each (var line:String in str.split(/\|/)) {
				var field : Array = line.split(/:/);
				if (field.length == 2) {
					var condition : String = field[0];
					var content : String = field[1];

					condition = fillVars(condition);

					if (evalSimpleCondition(condition)) {
						desc = fillVars(content);
						break;
					}
				} else {
					desc = fillVars(line);
				}
			}

			return desc;
		}

		private static function evalSimpleCondition(exp : String) : Boolean {
			const reg : RegExp = /(\d+)(>|>=|==|<=|!=)(\d+)/;

			// 不符合规则，返回0
			if (!reg.test(exp)) return false;
			var arr : Array = exp.match(reg);
			var num1 : Number = arr[1];
			var num2 : Number = arr[3];
			var op : String = arr[2];

			switch(op) {
				case ">":
					return num1 > num2;
				case ">=":
					return num1 >= num2;
				case "<=":
					return num1 <= num2;
				case "<":
					return num1 < num2;
				case "==":
					return num1 == num2;
				case "!=":
					return num1 != num2;
			}

			return false;
		}

		private function fillVars(str : String) : String {
			var filledStr : String = str;
			for (var i : int = 0;i < _vars.length;i++) {
				filledStr = filledStr.replace("xx" + (i + 1), _vars[i]);
			}

			return filledStr;
		}
		
		public function execute() : void 
		{
			var result:Boolean = true ;
			switch( type ){
				case 1:
					result = MValidator.transport.doValidation(executeExe);
					break ;
				case 2:
					if( UserData.instance.vipLevel < 1 )
						result = MValidator.walk.doValidation(executeExe);
					else
						result = MValidator.transport.doValidation(executeExe);
					break ;
				case 3:
					break ;
				default:
					result = MValidator.walk.doValidation(executeExe);
					break ;
			}

			if (result == false) {
				return;
			}
			executeExe();
		}
		
		public function executeExe() : void {

			if (id == 1) {
				MenuManager.getInstance().changMenu(MenuType.DAILY_QUEST);
				return;
			}
			if (id == 6 || id == 7 || id == 8 || id == 9 || id == 10) {
				ViewManager.instance.clearFullViews();
			}
			if (id == 6 || id == 8) {
				ProxyBossWar.instance.joyInBossWar();
				MenuManager.getInstance().closeMenuView(MenuType.DAILY);
				return;
			}
			if (id == 7) {
				GBProto.instance.cs_ready();
				MenuManager.getInstance().closeMenuView(MenuType.DAILY);
				return;
			}

			if (id == 10) {
				QuestUtil.sendCSNpcReAction(22);
				return;
			}
			
			if (type == 3)
				MenuManager.getInstance().openMenuView(Number(link));
			else {
				QuestUtil.goAndClickNpc(Number(link), type == 1 || UserData.instance.vipLevel > 0);
				MenuManager.getInstance().closeMenuView(MenuType.DAILY);
			}
		}

		public function getIcoUrl() : String {
			return VersionManager.instance.getUrl("assets/ico/daily/daily" + id + ".png");
		}

		public function refreshVars(var1 : int, var2 : int, state : int) : void {
			_vars = [var1, var2];
			_state = state;
			refresh();
		}

		public function getVars() : Array {
			return _vars;
		}

		public function get state() : int {
			return _state;
		}
	}
}
