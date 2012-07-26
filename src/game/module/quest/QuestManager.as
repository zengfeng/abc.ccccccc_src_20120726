package game.module.quest
{
	import game.core.avatar.AvatarNpc;
	import game.core.user.UserData;
	import game.manager.DailyInfoManager;
	import game.manager.RSSManager;
	import game.module.daily.DailyManage;
	import game.module.dailyQuest.DailyQuestPanel;
	import game.module.quest.animation.ActionDriven;
	import game.net.data.StoC.SCQuestList;
	import game.net.data.StoC.SCQuestList.CurrQuestList;

	import flash.utils.Dictionary;


	/**
	 * @author yangyiqiang
	 */
	public final class QuestManager
	{
		/** 不可接任务 */
		public static const  UNDONE : int = 0;
		/** 可接任务 */
		public static const CAN_ACCEPT : int = 1;
		/** 已接任务 */
		public static const CURRENT : int = 2;
		/** 已提交任务 */
		public static const SUBMIT : int = 3;
		/** 日常任务 */
		public static const DAILY : int = 3;
		public static const COMMON_DAILY : int = 301000;
		private static var _instance : QuestManager;
		private const STATES_MAX : int = 4;
		public var typeString : Array = ["主", "支", "令"];
		public var voNpcLinkDic : Dictionary = new Dictionary();
		public var mapNpcDic : Dictionary = new Dictionary();
		/** 从配置文件中读入的任务列表 */
		private  var _xmlTasks : Vector.<VoQuest>;
		/** 
		 * 任务列表,按state排序
		 * state 0：不可接 1:可接 2：已接 3：已提交
		 */
		private  var _list : Vector.<VoQuest>;
		private  var _dailyList : Vector.<VoQuest>;
		/** 存储各个state的起始和结束位 总长=4
		 *  第0位记录(state=0)的结束位 
		 *  第1位记录(state=1)的结束位 
		 *  第2位记录(state=2)的结束位 
		 *  第3位记录(state=3)的结束位 
		 *  state 0：不可接 1:可接 2：已接 3：已提交
		 */
		private  var _states : Vector.<int>;
		
//		public static var _nextWantedTime

		public function QuestManager() : void
		{
			if (_instance)
			{
				throw Error("QuestManager 是单类，不能多次初始化!");
			}
			_xmlTasks = new Vector.<VoQuest>();
			_list = new Vector.<VoQuest>();
			_states = new Vector.<int>(STATES_MAX, true);
			_dailyList = new Vector.<VoQuest>();
			DailyQuestPanel;
		}

		/** 
		 * @author yangyiqiang
		 * @version 1.0
		 * @param 单类
		 * @see VoTask
		 * @return TaskManager
		 */
		public static function getInstance() : QuestManager
		{
			if (_instance == null)
			{
				_instance = new QuestManager();
			}
			return _instance;
		}

		/** 初始化xml */
		public function initXmlQuests(xml : XML) : void
		{
			if (!xml) return;
			for each (var item:XML in xml.children())
			{
				var quest : VoQuest = new VoQuest();
				var base : VoQuestBase = new VoQuestBase();
				base.prase(item);
				quest.setVoTaskBase(base);
				_xmlTasks.push(quest);
				if (quest.base.type == DAILY)
					_dailyList.push(quest);
			}
			RSSManager.getInstance().deleteData("quest");
			ActionDriven.instance().initXml(RSSManager.getInstance().getData("questAnimation"));
		}

		/** 服务器返回任务列表 */
		public function refreshQuests(msg : SCQuestList) : void
		{
			initXmlQuests(RSSManager.getInstance().getData("quest"));
			initQuestList();
			var temp : VoQuest;
			for each (var task:CurrQuestList in msg.currQuestList)
			{
				temp = resetQuestState(task.questId, QuestManager.CURRENT);
				if (!temp) continue;
				temp.isCompleted = task.isCompleted;
				temp.base.reqStep = task.stepNum;
			}
			for each (var taskId:uint in msg.submitQuestId)
			{
				temp = resetQuestState(taskId, QuestManager.SUBMIT);
				if (!temp) continue;
				while (temp.base.preTaskId != 0)
				{
					temp = resetQuestState(temp.base.preTaskId, QuestManager.SUBMIT);
					if (!temp) break;
				}
			}

			var tempList : Vector.<VoQuest> = getTastInterval(UNDONE);
			var max : int = tempList.length;
			for (var i : int = 0;i < max;i++)
			{
				temp = tempList[i];
				if (isCanAccept(temp))
				{
					if (temp.state == CAN_ACCEPT) continue;
					resetQuestState(temp.id, CAN_ACCEPT);
				}
				else
				{
					if (temp.state == CAN_ACCEPT)
						resetQuestState(temp.id, UNDONE);
				}
			}

			tempList = getTastInterval(SUBMIT);
			tempList.sort(compareB);
			max = tempList.length;
			for (i = 0;i < max;i++)
			{
				temp = tempList[i];
				temp.state = SUBMIT;
			}
		}

		/**  
		 * 返回state 区间的任务列表
		 */
		public function getTastInterval(state : int) : Vector.<VoQuest>
		{
			if (state < 0 || state >= STATES_MAX) return null;
			var startIndex : int = state == 0 ? 0 : _states[state - 1];
			return _list.slice(startIndex, _states[state]);
		}

		public function preLoader(vo : VoQuest) : void
		{
			vo.preLoad();
			var num : int = 5;
			while (num > 0 && vo)
			{
				num--;
				for each (var id:int in vo.base.posTaskId)
				{
					vo = search(id);
					if (vo)
						vo.preLoad();
				}
			}
		}

		/** 改变任务状态 **/
		public function resetQuestState(taskId : int, state : int) : VoQuest
		{
			var index : int = indexOf(taskId);
			if (index < 0) return null;
			var temp : VoQuest = _list[index];
			removeByIndex(index);
			temp.state = state;
			return addQuest(temp);
		}

		public function resetQuestNpcState(vo : VoQuest) : void
		{
			// if (vo.state == CAN_ACCEPT&&vo.getStep()==0&&vo.stepMessages.length>0)
			if (vo.state == CAN_ACCEPT)
				resetNpc(vo.id, vo.base.npcPublish, AvatarNpc.CAN_ACCEPT);
			else
				resetNpc(vo.id, vo.base.npcPublish, AvatarNpc.NOTHING);
		}

		/** 删除任务 **/
		public function removeQuest(taskId : int) : VoQuest
		{
			var index : int = indexOf(taskId);
			var temp : VoQuest;
			if (index != -1)
			{
				temp = _list[index];
				removeByIndex(index);
			}
			return temp;
		}

		/** 查找任务 **/
		public function search(questId : int, state : int = 0) : VoQuest
		{
			var index : int = indexOf(questId, state);
			return index == -1 ? null : _list[index];
		}

		/**
		 * 是否已经提交
		 */
		public function isSubmit(questId : int) : Boolean
		{
			var index : int = indexOf(questId);
			if (index == -1 ) return false;
			if (_list[index].state == QuestManager.SUBMIT) return true;
			return false;
		}

		/** 提交任务 **/
		public function submitQuest(taskId : int) : Array
		{
			var temp : VoQuest = resetQuestState(taskId, QuestManager.SUBMIT);
			if (!temp) return [];
			var tempArray : Array = temp.base.posTaskId;
			var arr : Array = [];
			for each (var id:int in tempArray)
			{
				var vo : VoQuest = search(id);
				if (vo && isCanAccept(vo))
				{
					resetQuestState(id, CAN_ACCEPT);
					arr.push(vo);
				}
			}
			return arr;
		}

		/** 等级发生变化时 增量 **/
		public function levelUp() : Array
		{
			var temp : Vector.<VoQuest> = _xmlTasks.splice(0, findNum());
			var arr : Array = [];
			for each (var vo:VoQuest in temp)
			{
				if (isCanAccept(vo))
				{
					vo.state = CAN_ACCEPT;
					arr.push(vo);
				}
				addQuest(vo);
			}
			return arr;
		}

		/**
		 * 查找下一个可以接的主线任务
		 */
		public function findNextQuest() : VoQuest
		{
			for each (var vo:VoQuest in _xmlTasks)
			{
				if (vo.base.type == 1) return vo;
			}
			return null;
		}

		public function refreshDaily() : void
		{
			var vo : VoQuest = search(COMMON_DAILY);
			if (vo && isCanAccept(vo))
				resetQuestState(COMMON_DAILY, CAN_ACCEPT);
		}

		/** 初始化任务列表 **/
		public function initQuestList() : void
		{
			_xmlTasks.sort(compare);
			_dailyList.sort(compare);
			_list = _xmlTasks.splice(0, findNum());
			_states[0] = _states[1] = _states[2] = _states[3] = _list.length ;
		}

		private function resetNpc(quest : int, npcId : int, state : int) : void
		{
			var npcVo : VoNpc;
			npcVo = RSSManager.getInstance().getNpcById(npcId);
			if (!npcVo) return;
			npcVo.setQuestState(quest, state);
		}

		/** 查找任务索引 **/
		private function indexOf(taskId : int, state : int = 0) : int
		{
			var max : int = _list.length;
			// state=_states[state];
			for (var i : int = state;i < max;i++)
			{
				if (_list[i].id == taskId)
				{
					return i;
				}
			}
			return -1;
		}

		/** 根据位置索引删除任务 **/
		private function removeByIndex(index : int) : void
		{
			if (index == -1 || index >= _list.length) return;
			var state : int = _list[index].state;
			_list.splice(index, 1);
			for (var i : int = state;i < _states.length;i++)
				_states[i]--;
		}

		/** 查找当前等级可接任务数量 **/
		private function findNum() : int
		{
			var max : int = _xmlTasks.length;
			for (var i : int = 0;i < max; i++)
			{
				if (_xmlTasks[i].base.playerLevel > UserData.instance.level)
					return i;
			}
			return i > 0 ? i : 0;
		}

		/** 任务是否可接 **/
		private function isCanAccept(vo : VoQuest) : Boolean
		{
			if (!vo) return false;
			// 过滤已接和已提交任务
			if (vo.state == CURRENT || vo.state == SUBMIT) return false;
			// 是否达到任务等级
			if (vo.base.playerLevel > UserData.instance.level) return false;
			// 是否满足任务的职业限定
			if (vo.base.jobLimit && vo.base.jobLimit != UserData.instance.job) return false;
			// 前置任务是否完成
			var temp : VoQuest = search(vo.base.preTaskId);
			if (temp && temp.state != SUBMIT) return false;
			if (!temp && vo.base.preTaskId != 0) return false;
			if (vo.base.type == DAILY && vo.base.id != COMMON_DAILY) return false;
			if (vo.base.id == COMMON_DAILY)
			{
				if (DailyInfoManager.instance.getDailyVar(DailyManage.ID_QUEST) <= 0) return false;
				for each (var value:VoQuest in _dailyList)
				{
					if (value.state == CURRENT) return false;
				}
			}
			return true;
		}

		private function compare(a : VoQuest, b : VoQuest) : int
		{
			return a.base.playerLevel - b.base.playerLevel;
		}

		private function compareB(a : VoQuest, b : VoQuest) : int
		{
			return a.id - b.id;
		}

		/** 添加任务 */
		private function addQuest(voTask : VoQuest) : VoQuest
		{
			if (!voTask) return null;
			_list.splice(_states[voTask.state], 0, voTask);
			for (var i : int = voTask.state;i < STATES_MAX;i++)
				_states[i]++;
			return voTask;
		}
	}
}
