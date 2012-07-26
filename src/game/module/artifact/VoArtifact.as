package game.module.artifact {
	import game.core.item.prop.ItemProp;
	import game.core.menu.MenuType;
	import game.core.prop.Prop;
	import game.core.prop.PropManager;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.module.quest.guide.GuideMange;
	import game.net.core.Common;
	import game.net.data.CtoS.CSActivateArtifacts;
	import game.net.data.CtoS.CSChallengeArtifacts;
	import game.net.data.CtoS.CSTrainArtifacts;

	import com.commUI.alert.Alert;
	import com.utils.StringUtils;

	import flash.utils.getTimer;

	/**
	 * @author yangyiqiang
	 */
	public class VoArtifact {
		public var id : int;
		public var expList : Array = [];
		public var name : String;
		/**
		 * 可获得此神器的npc
		 */
		public var npcId : int;
		public var npcName : String;
		/**
		 * 成就文字
		 */
		public var introdunction : String;
		/**
		 * 达到此职业才能获得
		 */
		public var limitLevel : int;
		/**
		 * 法宝等级
		 */
		public var level : int;
		public var exp : int;
		/**
		 * 0 获得并激活，1 但没激活 2 未获得  3 不可挑战
		 */
		public var state : int = -1;
		public var commPropArray : Array = [];
		public var propArray : Array = [];
		private var counter : int = 0;

		public function get maxExp() : int {
			return expList[level];
		}

		/**
		 * 1: 免费铸魂（state==0） 2：元宝铸魂（state==0） 3：激活（state==0）  5：铸魂次数全用完（state==0）
		 * 0: 免费挑战（state==1） 4：挑战次数全用完（state==1）   
		 * 6：展示状态    7:不可挑战
		 */
		public function get type() : int {
			if (state == 1) {
				if (level == 10) return 3;
				if (ArtifactManage.instance().caseCount >= ArtifactManage.instance().caseMax) return 5;
				if (ArtifactManage.instance().caseCount >= ArtifactManage.FREE_CAST) return 2;
				return 1;
			} else if (state == 2) {
				if (ArtifactManage.instance().battleCount >= ArtifactManage.FREE_BATTLE) return 4;
				return 0;
			} else if (state == 3) {
				return 7;
			}
			return 6;
		}

		public function getUrl(monster : Boolean = true) : String {
			return  "assets/artifact/" + (monster ? "m" : "") + id + ".swf";
		}

		public function getPre() : int {
			return exp / expList[level] * 92;
		}

		public function getExpTips() : String {
			if (level == 10) return "经验：" + expList[level - 1] + "/" + expList[level - 1];
			return "经验：" + exp + "/" + expList[level];
		}

		public function getTips() : String {
			var _type : int = type;
			var str : String = name;
			if (level > 0) str += "      " + level + "级";
			str = StringUtils.addSize(StringUtils.addBold(StringUtils.addColor(str, "#ffff00")), 14);
			str += "\r";
			str += "\r";
			str += "队伍基础加成";
			if (_type == 0 || _type == 4) str += StringUtils.addColor("(挑战成功获得)", "#ff0000");
			str += "\r";
			var prop : Prop ;
			for each (var obj:Object in commPropArray) {
				prop = PropManager.instance.getPropByID(obj["id"]);
				if (!prop) continue;
				str += prop.name;
				str += StringUtils.addColorById("+" + obj["value"] + ((prop.per == 1) ? "%" : ""), 2);
				str += "\r";
			}
			if (_type == 0 || _type == 4) return str;
			str += "\r";
			str += "神器特性";
			if (state != 0 || level != 10) str += StringUtils.addColor("（需" + name + "等级10）", "#ff0000");
			str += "\r";
			for each (obj in propArray) {
				prop = PropManager.instance.getPropByID(obj["id"]);
				if (!prop) continue;
				str += prop.name;
				str += StringUtils.addColorById("+" + obj["value"] + ((prop.per == 1) ? "%" : ""), 2);
				str += "\r";
			}
			return str;
		}

		//0:未挑战 1：挑战过的未激活 2：挑战过的已激活
		public function getArtifactProp(type:int=0) : ItemProp {
			var prop : Prop ;
			var itemProp:ItemProp=new ItemProp();
			if(type==0)return itemProp;
			for each (var obj:Object in commPropArray) {
				prop = PropManager.instance.getPropByID(obj["id"]);
				if (!prop) continue;
				itemProp[prop.key]+=obj["value"];
			}

			if (type==2) {
				for each (obj in propArray) {
					prop = PropManager.instance.getPropByID(obj["id"]);
					if (!prop) continue;
					itemProp[prop.key]+=obj["value"];
				}
			}
			return itemProp;
		}

		private var _timer : uint;

		public function execute() : void {
			// if (ArtifactManage.instance().isBusy) return;
			if (getTimer() - _timer < 500) return;
			_timer = getTimer();
			var type : int = this.type;
			switch(type) {
				case 0:
					Common.game_server.sendMessage(0xE1, new CSChallengeArtifacts());
					GuideMange.getInstance().checkGuideByMenuid(MenuType.ARTIFACT);
					break;
				case 1:
					Common.game_server.sendMessage(0xE2, new CSTrainArtifacts());
					break;
				case 2:
					if ((UserData.instance.gold + UserData.instance.goldB) < 200) {
						StateManager.instance.checkMsg(4);
						break;
					} else
						StateManager.instance.checkMsg(360, [], okFun);
					break;
				case 3:
					Common.game_server.sendMessage(0xE3, new CSActivateArtifacts());
					break;
				case 4:
					StateManager.instance.checkMsg(294);
					break;
				case 5:
					StateManager.instance.checkMsg(358);
					break;
			}
		}

		private function okFun(type : String) : Boolean {
			switch(type) {
				case Alert.OK_EVENT:
				case Alert.YES_EVENT:
					Common.game_server.sendMessage(0xE2, new CSTrainArtifacts());
					break;
			}
			return true;
		}

		public function parse(arr : Array) : void {
			if (!arr) return;
			id = arr.length > counter ? arr[counter++] : 1;
			npcId = arr.length > counter ? arr[counter++] : 0;
			limitLevel = arr.length > counter ? arr[counter++] : 0;
			introdunction = arr.length > counter ? arr[counter++] : "";
			name = arr.length > counter ? arr[counter++] : "";
			npcName = arr.length > counter ? arr[counter++] : "";
			var list : String = arr.length > counter ? arr[counter++] : "";
			expList = list.split("|");
		}

		public function parseProp(arr : Array, flag : Boolean) : void {
			if (!flag) {
				commPropArray.push({id:arr[3], value:arr[4]});
			} else {
				propArray.push({id:arr[3], value:arr[4]});
				propArray.push({id:arr[5], value:arr[6]});
			}
		}
	}
}
class Obj {
	public var id : int;
	public var value : int;
}
