package game.module.quest {
	import game.core.avatar.AvatarThumb;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.manager.RSSManager;
	import game.manager.SignalBusManager;
	import game.manager.VersionManager;
	import game.manager.ViewManager;
	import game.module.guild.GuildManager;
	import game.module.mapNpcConvoy.NpcConvoy;
	import game.module.pack.ManagePack;
	import game.module.quest.guide.GuideMange;
	import game.module.recruitHero.QuestRecruitPanel;
	import game.module.tasteTea.TasteTeaControl;
	import game.net.core.Common;
	import game.net.data.CtoS.CSCollectOver;
	import game.net.data.CtoS.CSCompleteQuest;
	import game.net.data.CtoS.CSNpcReAction;
	import game.net.data.CtoS.CSNpcTrigger;
	import game.net.data.CtoS.CSQuestOperateReq;

	import gameui.manager.UIManager;
	import gameui.skin.ASSkin;

	import net.LibData;
	import net.RESManager;

	import worlds.apis.MMouse;
	import worlds.apis.MNpc;
	import worlds.apis.MSelfPlayer;
	import worlds.apis.MTo;
	import worlds.apis.MapUtil;
	import worlds.maps.configs.structs.MapStruct;
	import worlds.roles.cores.Npc;

	import com.utils.HeroUtils;
	import com.utils.StringUtils;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;

	/**
	 * @author yangyiqiang
	 */
	public final class QuestUtil
	{
		public static var reg : RegExp = /\[(.+?)\]/g;
		private static var nameArray : Array = [["少侠", "女侠"], ["大哥哥", "大姐姐"], ["小子", "丫头"], ["他", "她"]];
		private static var modalRunSkin : Sprite = ASSkin.emptySkin;
		public static const QUEST_COLOR : String = "#00ff00";
		private static var _customQuestColor : String;
		public static var tempAnimation : int = -1;

		/**
		 * npc  [1:npcId]
		 * 地图 [2:mapId]
		 * 怪物 [3:monsterId]
		 * 物品 [4:itemId]
		 * 称谓 [10:num]  num : 
		 *                      1 少侠/女侠  [10:1]
		 *                      2 大哥哥/大姐姐 [10:2]
		 *                      3 小子/丫头[10:3]
		 *						4 他/她[10:4]
		 * 称谓 [11:1]            玩家名字     
		 */
		public static function parseRegExpStr(str : String, questType : int = 0, questColor : String = QUEST_COLOR) : String
		{
			_customQuestColor = questColor;
			var repStr : String;
			var type : int;
			var targetStr : String;
			var mosterCounter : int = 0;
			var goodCounter : int = 0;
			reg.lastIndex = 0;
			var result : Array = reg.exec(str);
			while (result && result.length > 1)
			{
				repStr = result[0];
				result = (result[1] as String).split(":");
				type = result[0];
				targetStr = result[1];
				switch(type)
				{
					case 1:
						// npc
						var npc : VoBase = RSSManager.getInstance().getNpcById(Number(targetStr));
						if (!npc) return "";
						str = str.replace(repStr, StringUtils.addColor(StringUtils.addLine(npc.name), _customQuestColor));
						break;
					case 2:
						// 地图
						var mapId : int = int(targetStr);
						if (mapId % 100 == 0) mapId += 1;
						var mapStruct : MapStruct = MapUtil.getMapStruct(mapId);
						if (!mapStruct)
						{
							str = "不认识的地图";
							break;
						}
						str = str.replace(repStr, StringUtils.addColor(StringUtils.addLine(mapStruct.name), _customQuestColor));
						break;
					case 3:
						// 怪物
						var moster : VoBase = RSSManager.getInstance().getNpcById(Number(targetStr));
						if (!moster) return "";
						var tempStr : String = questType == 2 ? StringUtils.addColor(StringUtils.addLine(moster.name) + "#" + mosterCounter++ + "#", _customQuestColor) : StringUtils.addColor(StringUtils.addLine(moster.name), _customQuestColor);
						str = str.replace(repStr, tempStr);
						break;
					case 4:
						// 物品
						var vo : Item = ItemManager.instance.newItem(Number(targetStr));
						if (!vo)
							str = str.replace(repStr, StringUtils.addColor(StringUtils.addLine("不认识的物品"), _customQuestColor));
						else
						{
							tempStr = questType == 3 ? StringUtils.addColor(StringUtils.addLine(vo.name) + "#" + goodCounter++ + "#", _customQuestColor) : StringUtils.addColor(StringUtils.addLine(vo.name), _customQuestColor);
							str = str.replace(repStr, tempStr);
						}
						break;
					case 10:
						// 替换玩家名字 为"少侠", "女侠", "大哥哥", "大姐姐，小子/丫头"
						var num : Number = Number(targetStr);
						tStr = nameArray[num - 1][HeroUtils.getMySex()];
						str = str.replace(repStr, tStr);
						break;
					case 11:
						// 替换玩家名字
						var tStr : String = "^";
						str = str.replace(repStr, tStr);
						break;
				}
				reg.lastIndex = 0;
				result = reg.exec(str);
			}
			return str;
		}

		/**
		 * 解析任务动作
		 */
		private static var str : Array = [];
		private static var isIn : Boolean = false;

		public static function questAction(questId : int) : void
		{
			questVoAction(QuestManager.getInstance().search(questId));
		}

		public static function questVoAction(vo : VoQuest) : void
		{
			if (!vo) return;
			if (vo.id == _currnQuestId && isInAutoRun) return;
			if (vo.id == QuestManager.COMMON_DAILY)
			{
				MenuManager.getInstance().changMenu(MenuType.DAILY_QUEST);
				return;
			}
			if (vo.isCompleted)
			{
				if (vo.base.type == QuestManager.DAILY)
				{
					MenuManager.getInstance().openMenuView(MenuType.DAILY_QUEST);
					return;
				}
				QuestDisplayManager.getInstance().showMainQuest(vo);
				if (vo.base.getCompleteTry() == 7 || vo.base.getCompleteTry() == 8)
				{
					NpcConvoy.removeNpc(vo.base.npcPublish);
					QuestUtil.removeQuestMode();
				}
				return;
			}

			if (vo.base.npcPublish != 0 && vo.getStep() == 0 && vo.base.type == 3)
			{
				goNpc(vo.base.npcPublish, vo.id);
				return;
			}
			if (vo.state == QuestManager.CAN_ACCEPT)// 如果是可接任务，直接走向接取任务npc
			{
				goNpc(vo.base.npcPublish, vo.id);
				return;
			}
			// if (vo.isLastStep)// 要走到提交npc处
			// {
			// goNpc(vo.base.npcFinish, vo.id, 1);
			// return;
			// }
			if (vo.base.hireFlag != "")// 招募任务
			{
				str = vo.base.hireFlag.split("|");
				if (vo.getStep() == (Number(str[0]) - 1))
				{
					var panel : QuestRecruitPanel = new QuestRecruitPanel();
					panel.source = str[1];
					panel.show();
					return;
				}
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
			 *  11:                    		去副本打怪(同平常打怪)
			 *	12:							去副本打怪(同平常打怪收集)
			 *	13:							去副本打怪,打怪前出现剧情
			 */
			var completeType : int = vo.base.getCompleteTry();
			switch(completeType)
			{
				case 1:
				case 2:
				case 3:
				case 9:
				case 10:
					goNpc(vo.base.step.split(",").shift(), vo.id);
					break;
				case 4:
					str = vo.base.step.split(",");
					structId = str[0];
					_type = 0;
					startUserItem();
					break;
				case 5:
					str = vo.base.step.split(",");
					structId = str[0];
					_type = 0;
					startAutoRun(vo.id);
					MTo.toMap(1, str[2], str[3], str[1], startUserItem, null, false);
					break;
				case 6:
					str = vo.base.step.split(",");
					structId = str[0];
					goNpc(structId, vo.id);
					break;
				case 7:
				case 8:
					addQuestMode();
					str = vo.base.step.split(",");
					structId = str[vo.base.type == QuestManager.DAILY ? vo.getStep() - 1 : vo.getStep()];
					goNpc(structId, vo.id, vo.id);
					if (!isIn)
					{
						var tempBase : VoBase = RSSManager.getInstance().getNpcById(vo.base.npcPublish);
						if (!tempBase) return;
						MSelfPlayer.setClanName("护送" + tempBase.name + "中...", _customQuestColor);
						NpcConvoy.addNpc(completeType == 7 ? vo.base.npcPublish : str[0]);
						isIn = true;
					}
					break;
				case 11:
				// 去副本打怪
				case 12:
					str = vo.base.step.split(",");
					startAutoRun();
					MTo.toDuplNpc(str[0]);
					break;
				case 13:
					// 去副本打怪,打怪前出现剧情
					str = vo.base.step.split(",");
					startAutoRun();
					MTo.toDuplNpc(str[0]);
					break;
				// 打开功能面板
				case 14:
					str = vo.base.step.split(",");
					MenuManager.getInstance().openMenuView(str[0]);
					break;
				default :
					goNpc(vo.base.step.split(",").shift(), vo.id);
					break;
			}
		}

		private static var modalSkin : Sprite = ASSkin.emptySkin;

		public static function addQuestMode() : Sprite
		{
			if (!modalSkin)
				modalSkin = ASSkin.emptySkin;
			modalSkin.width = UIManager.stage.stageWidth;
			modalSkin.height = UIManager.stage.stageHeight;
			if (!ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER).contains(modalSkin))
				ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER).addChildAt(modalSkin, 0);
			return modalSkin;
		}

		public static function removeQuestMode() : Sprite
		{
			if (modalSkin && modalSkin.parent)
			{
				ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER).removeChild(modalSkin);
			}
			return modalSkin;
		}

		private static function addQuestRunMode() : Sprite
		{
			if (!modalRunSkin)
				modalRunSkin = ASSkin.emptySkin;
			modalRunSkin.width = UIManager.stage.stageWidth;
			modalRunSkin.height = UIManager.stage.stageHeight;
			if (!ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER).contains(modalRunSkin))
				ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER).addChildAt(modalRunSkin, 0);
			return modalRunSkin;
		}

		private static function removeQuestRunMode() : Sprite
		{
			if (modalRunSkin && modalRunSkin.parent)
			{
				ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER).removeChild(modalRunSkin);
			}
			return modalRunSkin;
		}

		private static var _type : int = 0;
		private static var _progressLoading : MovieClip;
		private static var _avatar : AvatarThumb;

		public static function startUserItem() : void
		{
			endAutoRun();
			addQuestMode();
			progressLoading(_type == 0 ? "使用" + StringUtils.addColor(ItemManager.instance.getPileItem(structId).name, _customQuestColor) + "中" : "采集" + StringUtils.addColor(ItemManager.instance.getPileItem(goodsId).name, QUEST_COLOR) + "中");
		}

		/**
		 * 对外接口
		 */
		public static function progressLoading(str : String) : void
		{
			if (!_progressLoading)
			{
				RESManager.instance.load(new LibData(VersionManager.instance.getUrl("assets/swf/loading3.swf"), "questLoading", true, false), playProgress, [str]);
			}
			else
			{
				playProgress(str);
			}
		}

		public static function progressLoadingClose() : void
		{
			if (_progressLoading == null) return;
			_progressLoading.removeEventListener(Event.COMPLETE, onListener);
			_progressLoading.stop();
			if (_progressLoading.parent)
			{
				_progressLoading.parent.removeChild(_progressLoading);
			}
		}

		private static var _questId : int;

		public static function getGoodId(questId : int) : void
		{
			var vo : VoQuest = QuestManager.getInstance().search(questId);
			if (!vo) return;
			_type = 1;
			str = vo.base.step.split(",");
			structId = str[0];
			goodsId = str[1];
			_questId = questId;
		}

		private static function playProgress(str : String) : void
		{
			_progressLoading = RESManager.getLoader("questLoading").getContent() as MovieClip;
			if (!_progressLoading) return;
			_progressLoading.addEventListener(Event.COMPLETE, onListener);
			_progressLoading.gotoAndStop(0);
			_avatar = MSelfPlayer.avatar;
			_progressLoading.width = 160;
			_avatar.addStateObj(_progressLoading);
			_avatar.hideName();
			_progressLoading["text"]["textName"]["htmlText"] = str;
			_progressLoading.gotoAndPlay(0);
			if (_progressLoading && _progressLoading["bar"]) (_progressLoading["bar"] as MovieClip).gotoAndPlay(1);
		}

		private static function onListener(event : Event) : void
		{
			if (_progressLoading && _progressLoading["bar"]) (_progressLoading["bar"] as MovieClip).gotoAndStop(1);
			SignalBusManager.questCollectProgressPlayComplete.dispatch();
			if (_type == 0)
				useItem();
			else
				collectOver(_questId);
			if (_avatar) _avatar.showName();
			removeQuestMode();
			_progressLoading.removeEventListener(Event.COMPLETE, onListener);
			_progressLoading.stop();
			if (_progressLoading.parent)
			{
				_progressLoading.parent.removeChild(_progressLoading);
			}
		}

		// 收集完毕
		private static function collectOver(quest : int) : void
		{
			var cmd : CSCollectOver = new CSCollectOver();
			cmd.questId = quest;
			Common.game_server.sendMessage(0x34, cmd);
		}

		private static function useItem() : void
		{
			ManagePack.useItem(structId, true, 1, 0);
		}

		/**
		 * 走向指定npc
		 * type:0  到达发送npcClick
		 * type:1  到达发送sendQuestComplete
		 */
		private static function goNpc(npcId : int, questId : int, conveyId : int = 0, type : int = 0, isRun : int = 0, flashStep : Boolean = false) : void
		{
			var tempBase : VoNpc = RSSManager.getInstance().getNpcById(npcId);
			if (!tempBase) return;
			structId = npcId;
			startAutoRun(conveyId, isRun);
			type == 0 ? MTo.toNpc(1,npcId, tempBase.mapId, npcClick, [0, conveyId, questId], flashStep) : MTo.toNpc(1, npcId, tempBase.mapId, sendQuestComplete, [conveyId, 0, questId], flashStep);
		}

		public static var  isInAutoRun : Boolean = false;
		private static var _currnQuestId : uint;

		private static function startAutoRun(id : int = 0, isRun : int = 0) : void
		{
			_currnQuestId = id;
			if (isRun != 0) return;
			MSelfPlayer.setClanName("自动寻路中...", "#00ee66");
			_lastTime = getTimer();
			addQuestRunMode().addEventListener(MouseEvent.CLICK, onClick);
			isInAutoRun = true;
			GuideMange.getInstance().hide();
		}

		private static var _lastTime : uint;
		private static var _num : uint = 0;

		private static function onClick(event : MouseEvent) : void
		{
			if (getTimer() - _lastTime < 1000) return;
			if (++_num == 1) return;
			MMouse.clickEvent();
			endAutoRun();
			checkQuide();
		}

		public static function endAutoRun() : void
		{
			MSelfPlayer.setClanName("");
			_lastTime = 0;
			_num = 0;
			removeQuestRunMode().removeEventListener(MouseEvent.CLICK, onClick);
			isInAutoRun = false;
		}

		/**
		 * 新手引导，引导框指向任务框
		 */
		public static function checkQuide() : void
		{
			if (MenuManager.getInstance().getMenuState(MenuType.ARTIFACT)) return;
			if (QuestDisplayManager.getInstance().checkQuestMain()) return ;
			if (QuestDisplayManager.getInstance().getMainAction() && QuestDisplayManager.getInstance().getMainAction().parent) return;
			if (ViewManager.dialogueSprite.parent) return;
			if (UserData.instance.level > GuideMange.GUIDE_MAX)
			{
				GuideMange.getInstance().hide();
				return;
			}
			var vo : VoQuest = QuestManager.getInstance().search(_currnQuestId);
			if ((!vo || !QuestDisplayManager.getInstance().isShowing(vo)) && !isInAutoRun && !MapUtil.isDuplMap())
			{
				GuideMange.getInstance().moveTo(-150, 0, "点击继续任务", QuestDisplayManager.getInstance().questView);
			}
		}

		/**
		 * 走到npc范围内触发的事件
		 */
		private static var structId : int = 0;
		private static var goodsId : int = 0;

		public static function npcClick(id : int = 0, conveyId : int = 0, questId : int = 0) : void
		{
			id = id == 0 ? structId : id;
			SignalBusManager.clickNPC.dispatch(id);

			// TODO: 挖矿，跳过消息发送，由内部模块处理
			if (id == 3009)
			{
				endAutoRun();
				return;
			}

			if (id == 3002)
			{
				if ( !GuildManager.instance.checkActionOpen(1) )
				{
					StateManager.instance.checkMsg(171);
				}
				else
				{
					TasteTeaControl.instance.setupUI();
					endAutoRun();
					return;
				}
			}

			if ( id == 3001 )
			{
				if ( GuildManager.instance.actiondata[0].personalremain > 0 )
				{
					var tree : Npc = MNpc.getNpc(3001);
					tree.setAction(9, 1);
					// AnimalManager.instance.getNpc(3001).treeshake();
					// TODO
				}
				else
				{
					StateManager.instance.checkMsg(148);
					return ;
				}
			}

			var cmd : CSNpcTrigger = new CSNpcTrigger();
			cmd.npcId = id;
			if (conveyId != 0) cmd.conveyId = conveyId;
			if (questId != 0) cmd.questId = questId;
			Common.game_server.sendMessage(0x33, cmd);
			endAutoRun();
//			Logger.debug("npcClick==> id=" + id, "questId===>" + questId);
		}

		/**
		 * 对外接口
		 * npcId 
		 * flashStep  是否传送
		 */
		public static function goAndClickNpc(npcId : int, flashStep : Boolean = false) : void
		{
			goNpc(npcId, 0, 0, 0, 0, flashStep);
		}

		public static const ACCEPT : int = 1;
		public static const SUBMIT : int = 2;

		// op 操作类型 1:接收  2:提交;
		public static function sendTaskOperateReq(questId : int, op : int, QualityId : int = 0) : void
		{
			var _cmd : CSQuestOperateReq = new CSQuestOperateReq();
			_cmd.questId = questId;
			_cmd.op = op;
			_cmd.questQualityId = QualityId;
			Common.game_server.sendMessage(0x31, _cmd);
		}

		public static function sendQuestComplete(questId : int, flag : int) : void
		{
			var _cmd : CSCompleteQuest = new CSCompleteQuest();
			_cmd.questId = questId;
			_cmd.flag = flag;
			Common.game_server.sendMessage(0x35, _cmd);
			endAutoRun();
		}

		// 点击npc链接
		public static function sendCSNpcReAction(action : int) : void
		{
			var _cmd : CSNpcReAction = new CSNpcReAction();
			_cmd.actionId = action;
			Common.game_server.sendMessage(0x38, _cmd);
		}
	}
}
