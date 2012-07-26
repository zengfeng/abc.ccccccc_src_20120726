package game.module.quest {
	import game.manager.RSSManager;

	import flash.utils.Dictionary;

	/**
	 * @author yangyiqiang
	 */
	internal final class VoQuestBase {
		/**
		 * id  任务ID 
		 *     第1位         任务类型：主线1，支线2，日常3，循环4
		 *     第2，3位       国家编号 
		 *     第4位         完成方式  01:对话 02:打怪 03:打怪收集 04:使用物品 05:采集 06:护送    
		 *     第5，6，7位    任务序号  从01开始
		 */
		public var id : int;
		/**  name 任务名字 */
		public var name : String;
		/** 招募标识  id|panelId  id从1开始编*/
		public var hireFlag : String;
		/** 
		 *  playerLevel  玩家等级 
		 */
		public var playerLevel : int;
		/** 
		 *  preTaskId  前置任务ID
		 */
		public var preTaskId : int = 0;
		/** 后置任务 */
		public var posTaskId : Array = [];
		/**  职业限制，特定的职业才能接的任务 */
		public var jobLimit : int;
		/**    step        任务步骤  和getCompleteTry（完成方式）
		 * 		
		 *                01： 对话:1,无步骤  
		 *                02： 打怪:npcID,num            怪物ID和数量，用|分隔
		 *                03： 收集:npcID,goodID,num     怪物ID和物品ID及物品数量, 用|分隔  
		 *                04： 使用物品:goodID
		 *                05： 特定地点使用物品:          用|分隔  (goodID|mapId|X|Y)
		 *                06： 采集
		 *                07： 护送
		 *                08： 探索
		 */
		public var step : String;
		public var reqStep : Vector.<uint>;
		/**  发布任务的NPCID */
		public var npcPublish : int;
		/**   提交任务的NPCID    */
		// public var npcFinish : int;
		/**   actionMsg    */
		public var actionMsg : String;
		/**   secondNpcDialog    */
		public var secondNpcDialog : String;
		public var introdunction : String;
		/**   
		 * 任务目标描述 
		 * 1 : NPCID
		 */
		public var targetDesc : String;
		public var questDesc : String;
		public var taskAward : String;
		private var _type : int;
		public var notice : String;
		public var headId : uint;
		public var monsterlst : Array;
		public var plots : Array;

		public function VoTask() : void {
		}

		/** 第1位    任务类型：主线1，支线2，日常3，循环4 **/
		public function get type() : int {
			return id / 100000;
		}

		/**
		 *  最后两位    完成方式 
		 *  01:对话1                        
		 *  02:打怪 						去找某个npc或者去打某个moster(怪物（npc）ID在step字段)
		 *  03:打怪收集 					去找某个npc或者去打某个moster(怪物（npc）ID在step字段)
		 *  04:使用物品 					使用物品:goodID
		 *  05:指定地点使用物品 			去指定地点使用某物品 (物品ID和地点在step字段)
		 *  06:采集 
		 *  07:护送1 
		 *  08:护送2 
		 *  09:探索 
		 *  10：对话2
		 */
		public function getCompleteTry() : int {
			return _type;
		}

		/**  第2，3位       国家编号  **/
		public function getCountry() : int {
			return (id % 10000) / 1000+1;
		}

		public function prase(xml : XML) : void {
			if (xml.@id == undefined) return;
			id = xml.@id;
			name = xml.@name;
			_type = xml.@subType;
			playerLevel = xml.@playerLevel;
			preTaskId = xml.@preQuestId;
			posTaskId = String(xml.@posQuestId).split(",");
			jobLimit = xml.@jobLimit;
			step = xml.@step;
			npcPublish = xml.@npcPublish;
			// npcFinish = xml.@npcFinish;
			actionMsg = xml.@actionMsg;
			introdunction = xml.@introdunction;
			targetDesc = xml.@targetDesc;
			taskAward = xml.@questAward;
			hireFlag = xml.@hireFlag;
			secondNpcDialog = xml.@secondNpcDialog;
			questDesc = xml.@questDesc;
			notice = xml.@notice;
			headId = xml.@headId;
			if (xml.@monsterlst != undefined)
				monsterlst = String(xml.@monsterlst).split("|");
			var temp : Array = String(xml.@plot).split("|");
			for each (var str:String in temp) {
				if (!plots) plots = [];
				plots.push(str.split(":")[1]);
			}
			reqStep = new Vector.<uint>(String(xml.@reqStep).split(",").length);
			initNpc(String(xml.@npcDisplay).split("|"));
		}

		/**
		 *  1:任务接受后显示 
		2:任务提交后显示 
		3:任务提交后消失 
		4:任务接受后消失 
		5:任务完成后消失
		6:任务完成后显示
		 */
		public function refreshNpc(type : int = 1) : void {
			var arr : Array = _list[type];
			var vo : VoNpc;
			switch(type) {
				case 1:
				case 2:
				case 6:
					for each (var id:int in arr) {
						vo = RSSManager.getInstance().getNpcById(id);
						if (vo) vo.visable = true;
					}
					break;
				case 3:
				case 4:
				case 5:
					for each (id in arr) {
						vo = RSSManager.getInstance().getNpcById(id);
						if (vo) vo.visable = false;
					}
					break;
			}
		}

		private function initNpc(arr : Array) : void {
			for each (var str:String in arr) {
				var temp : Array = str.split(":");
				if (!_list[temp[0]])
					_list[temp[0]] = [];
				(_list[temp[0]] as Array).push(temp[1]);
			}
		}

		private var _list : Dictionary = new Dictionary();
	}
}
