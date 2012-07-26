package game.module.quest {
	import game.core.hero.HeroManager;
	import game.core.hero.VoHero;
	import game.manager.DailyInfoManager;
	import game.manager.RSSManager;
	import game.module.battle.BattleInterface;
	import game.module.daily.DailyManage;
	import game.module.quest.animation.ActionDriven;

	import net.RESManager;

	import worlds.apis.MLoading;
	import worlds.apis.MapUtil;

	import com.utils.StringUtils;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author yangyiqiang
	 */
	public final class VoQuest extends EventDispatcher {
		public const QUEST_CHANGE : String = "quest_change";
		public var base : VoQuestBase;
		private var _isCompleted : Boolean = false;
		public var stepMessages : Array = [];
		/** 状态 0：不可接 1:可接 2：已接 3：已提交 */
		private var _state : int = 0;
		private var _change : Boolean = true;
		private var _questString : String = "";

		public function setVoTaskBase(vo : VoQuestBase) : void {
			base = vo;
		}

		private function initDialogue(type : int = 0) : void {
			var temp : Array = type == 0 ? base.actionMsg.split("|") : base.secondNpcDialog.split("|");
			var dialogue : VoDialogue;
			stepMessages = [];
			for each (var str:String in temp) {
				var arr : Array = str.split("$$");
				for (var i : int = 0;i < arr.length;i++) {
					dialogue = new VoDialogue();
					dialogue.id = i == 0 ? 1 : -1;
					dialogue.str = arr[i];
					stepMessages.push(dialogue);
				}
			}
		}

		public function get id() : int {
			return base.id;
		}

		/**
		 * 任务进度
		 */
		public  function getStep() : int {
			var max : int = base.reqStep.length;
			for (var i : int = 0;i < max;i++)
				if (base.reqStep[i] <= 0) return i;
			return 0;
		}

		/** 返回拖动框的任务字符 **/
		public function getQuestString() : String {
//			if (!_change) return _questString;

			_questString = "[" + QuestManager.getInstance().typeString[base.type - 1] + "]" + base.name;
			if (_state == QuestManager.CURRENT) {
				if (isCompleted) {
					_questString += "(" + "已完成" + ")" ;
					return StringUtils.addLine(StringUtils.addEvent(StringUtils.addColor(_questString, "#00ff00"), String(id))) + "<br>";
				} else {
					_questString += "(" + StringUtils.addColorById("未完成", 5) + ")";
				}
			}

			if (_state == QuestManager.UNDONE) {
				_questString += "<br>";
				_questString += StringUtils.addColor(StringUtils.addIndent("主将" + this.base.playerLevel + "级可接受"), "#ff0000");
				return _questString;
			}
			if (_state == QuestManager.CAN_ACCEPT) {
				if (base.id == QuestManager.COMMON_DAILY)// 日常任务
					_questString += "(" + StringUtils.addColor("剩余" + DailyInfoManager.instance.getDailyVar(DailyManage.ID_QUEST) + "次", "#00ff00") + ")";
				_questString += "<br>";
				_questString += StringUtils.addLine(StringUtils.addIndent(QuestUtil.parseRegExpStr(base.questDesc)));
				return  StringUtils.addEvent(_questString, String(id)) + "<br>";
			}
			_questString += "<br>";
			_questString += StringUtils.addLine(StringUtils.addIndent(parseTargetDesc()));
			parseStep();
			_questString += "<br>";
			_change = false;
			_questString = StringUtils.addEvent(_questString, String(id));
			return  _questString;
		}

		public function getTargeString() : String {
			var str : String = StringUtils.addLine(StringUtils.addSize(StringUtils.addBold(this.base.name), 14));
			if (this.isCompleted) {
				str += StringUtils.addSize("（完成）", 12);
				return StringUtils.addColorById(str, 2);
			} else if (this.state == QuestManager.CAN_ACCEPT) {
				str += StringUtils.addSize("（可接）", 12);
			}
			return StringUtils.addColor(str, "#eb6100");
		}

		/**
		 *  1:任务接受后显示 
		2:任务提交后显示 
		3:任务提交后消失 
		4:任务接受后消失 
		5:任务完成后消失
		6:任务完成后显示
		 */
		public function set state(value : int) : void {
			// 1:可接 2：已接 3：已提交
			switch(value) {
				case 2:
					base.refreshNpc(1);
					base.refreshNpc(4);
					break;
				case 3:
					base.refreshNpc(1);
					base.refreshNpc(4);
					base.refreshNpc(5);
					base.refreshNpc(6);
					base.refreshNpc(2);
					base.refreshNpc(3);
					break;
			}
			_state = value;
			_change = true;
			dispatchEvent(new Event(QUEST_CHANGE));
		}

		public function get state() : int {
			return _state;
		}

		public function set isCompleted(value : Boolean) : void {
			_isCompleted = value;
			if (_isCompleted) {
				base.refreshNpc(1);
				base.refreshNpc(4);
				base.refreshNpc(5);
				base.refreshNpc(6);
			}
		}

		private var _isLoad : Boolean = false;

		public function preLoad() : void {
			if (_isLoad) return;
			_isLoad = true;
			var arr : Array;
			for each (var id:int in base.plots) {
				arr = ActionDriven.instance().getAnimationAssets(id);
				for each (var item:* in arr) {
					if (item is String) {
						RESManager.instance.preLoad(item);
					} else {
						RESManager.instance.preLoad(item["url"]);
					}
				}
			}
			var voNpc : VoNpc = RSSManager.getInstance().getNpcById(base.npcPublish);
			if (voNpc) {
				RESManager.instance.preLoad(voNpc.helfIocUrl);
			}
			if (base.hireFlag != "")// 招募任务
			{
				var str : Array = base.hireFlag.split("|");
				var hero : VoHero = HeroManager.instance.newHero(Number(str[1]));
				if (hero)
					RESManager.instance.preLoad(hero.halfImage);
			}
			var completeType : int = base.getCompleteTry();
			if (completeType == 10) {
				voNpc = RSSManager.getInstance().getNpcById(base.step.split(",").shift());
				if (voNpc)
					RESManager.instance.preLoad(voNpc.helfIocUrl);
			}else if(completeType==11||completeType==12||completeType==13){
				var mapId:int =base.step.split(",")[0];
				arr = MLoading.getMap(mapId);
				for each (var key:String in arr) {
					RESManager.instance.preLoad(key);
				}
			}

			arr = ActionDriven.instance().getHalfbodyAssets(id);
			for each (item in arr) {
				if (item is String) {
					RESManager.instance.preLoad(item);
				} else {
					RESManager.instance.preLoad(item["url"]);
				}
			}

			if (base.getCountry() > MapUtil.currentMapId) {
				arr = MLoading.getMap(base.getCountry());
				for each (key in arr) {
					RESManager.instance.preLoad(key);
				}
			}
			

			if (!base.monsterlst || base.monsterlst.length == 0 || (base.monsterlst.length == 1 && base.monsterlst[0] == "")) return;
			arr = BattleInterface.preLoadBattleRes(base.monsterlst, base.getCountry());
			for each (key in arr) {
				RESManager.instance.preLoad(key);
			}
		}

		public function get isCompleted() : Boolean {
			return _isCompleted;
		}

		private function parseTargetDesc() : String {
			return QuestUtil.parseRegExpStr(base.targetDesc, base.getCompleteTry());
		}

		public function parseQuestDesc() : String {
			var str : String = QuestUtil.parseRegExpStr(base.targetDesc, base.getCompleteTry(), "#FF3300");
			var stepArray : Array = base.step.split("|");
			var max : int = stepArray.length;
			for (var i : int = 0;i < max;i++) {
				var numArray : Array = (stepArray[i] as String).split(",");
				// 01:对话 02:打怪 03:打怪收集 04:使用物品 05:采集
				switch(base.getCompleteTry()) {
					case 2:
						var repStr : String = "(" + (base.reqStep.length < i ? "0" : String(base.reqStep[i])) + "/" + numArray[1] + ")";
						str = str.replace("#" + i.toString() + "#", repStr);
						break;
					case 3:
						repStr = "(" + (base.reqStep.length < i ? "0" : String(base.reqStep[i])) + "/" + numArray[2] + ")";
						str = str.replace("#" + i.toString() + "#", repStr);
						break;
				}
			}
			return  str;
		}

		private function parseStep() : void {
			if (base.getCompleteTry() != 2 && base.getCompleteTry() != 3 && base.getCompleteTry() != 5) return ;
			var stepArray : Array = base.step.split("|");
			var max : int = stepArray.length;
			for (var i : int = 0;i < max;i++) {
				var numArray : Array = (stepArray[i] as String).split(",");
				// 01:对话 02:打怪 03:打怪收集 04:使用物品 05:采集
				switch(base.getCompleteTry()) {
					case 2:
						var repStr : String = "(" + (base.reqStep.length < i ? "0" : String(base.reqStep[i])) + "/" + numArray[1] + ")";
						_questString = _questString.replace("#" + i.toString() + "#", repStr);
						break;
					case 3:
						repStr = "(" + (base.reqStep.length < i ? "0" : String(base.reqStep[i])) + "/" + numArray[2] + ")";
						_questString = _questString.replace("#" + i.toString() + "#", repStr);
						break;
					case 5:
						break;
				}
			}
		}

		private var dialogueIndex : int = -1;

		public function resetDialogueIndex(type : int = 0) : void {
			if (type != 0 || !stepMessages || stepMessages.length == 0)
				initDialogue(type);
			dialogueIndex = -1;
		}

		public function resetReqStep() : void {
			var max : int = base.reqStep.length;
			for (var i : int = 0 ;i < max;i++) {
				base.reqStep[i] = 0;
			}
			isCompleted = false;
			resetDialogueIndex();
		}

		public function getNextDialogue() : VoDialogue {
			dialogueIndex++;
			return dialogueIndex >= stepMessages.length ? null : (stepMessages[dialogueIndex] as VoDialogue).str == "" ? getNextDialogue() : stepMessages[dialogueIndex];
		}
	}
}
