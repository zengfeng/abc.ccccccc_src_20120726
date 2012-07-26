package game.module.debug
{
	import worlds.players.PlayerData;
	import worlds.players.GlobalPlayers;
	import worlds.auxiliarys.MapMath;

	import game.net.data.CtoS.CSGDEnter;
	import game.net.data.CtoS.CSBossEnter;
	import game.net.data.CtoS.CSGEEnter;

	import com.commUI.tooltip.ToolTipManager;

	import game.core.hero.VoHero;
	import game.core.user.StateManager;
	import game.core.user.SysMsgVo;
	import game.core.user.UserData;
	import game.manager.RSSManager;
	import game.manager.ViewManager;
	import game.module.battle.BattleInterface;
	import game.module.battle.view.BTSystem;
	import game.module.chat.ManagerChat;
	import game.module.mapFishing.pool.FishingPool;
	import game.module.mapNpcConvoy.NpcConvoy;
	import game.module.monsterPot.MonsterPotManager;
	import game.module.quest.QuestUtil;
	import game.module.quest.VoNpc;
	import game.module.settings.SettingData;
	import game.module.userBuffStatus.BuffStatusManager;
	import game.net.core.Common;
	import game.net.data.StoC.SCAvatarInfoChange;

	import gameui.manager.UIManager;

	import log4a.Logger;

	import test.debugTool.DebugToolView;
	import test.toolbox.Toolbox;

	import utils.SystemUtil;

	import worlds.WorldProto;
	import worlds.apis.BarrierOpened;
	import worlds.apis.GateOpened;
	import worlds.apis.MLand;
	import worlds.apis.MLoading;
	import worlds.apis.MMouse;
	import worlds.apis.MNpc;
	import worlds.apis.MPlayer;
	import worlds.apis.MSelfPlayer;
	import worlds.apis.MStory;
	import worlds.apis.MTo;
	import worlds.mediators.SelfMediator;
	import worlds.roles.cores.Npc;
	import worlds.roles.cores.Player;
	import worlds.roles.structs.PlayerStruct;

	import com.commUI.alert.Alert;
	import com.utils.UICreateUtils;
	import com.utils.printf;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;

	public class GMMethod
	{
		public static var isShowDebugInfo : Boolean = true;
		public static var isDebug : Boolean = false;
		public static const PREFIX : String = "gm";
		public static const HELP : String = "help";
		public static const IS_DEBUG : String = "isDebug";
		public static const SHOW_NET_INFO : String = "net";
		public static const SHOW_AVATAR_SIZE : String = "avatarSize";
		public static const ADD_PLAYER : String = "addPlayer";
		public static const GO_SCENE : String = "goScene";
		public static const IS_HIDE_BATTLE : String = "be";
		public static const RESET : String = "reset";
		public static const TO_POINT : String = "toPoint";
		public static const TO_MAP : String = "toMap";
		public static const TO_NPC : String = "toNpc";
		public static const TO_GATE : String = "toGate";
		public static const TO_DUPL : String = "toDupl";
		public static const SELF_POSITION : String = "selfPosition";
		public static const EN_MOUSE_MOVE : String = "enMouseMove";
		public static const SM_ENTER : String = "storyEnter";
		public static const SM_EXIT : String = "storyExit";
		public static const TRANSPORT : String = "transport";
		public static const NPC_CONVOY_ADD : String = "npcConvoyAdd";
		public static const NPC_CONVOY_REMOVE : String = "npcConvoyRemove";
		public static const PLAYER_LIST : String = "playerList";
		public static const CLAN_PROMPT : String = "clanPrompt";
		public static const VERSION : String = "version";
		public static const PS : String = "ps";
		public static const CHAT_PROMPT : String = "chatPrompt";
		public static const CHAT_SYSTEM : String = "chatSystem";
		public static const CHAT_SYSMSG : String = "chatSysmsg";
		public static const CHAT_SYSTEM_NOTIC : String = "chatSystemNotic";
		public static const RETURN_BATTLE : String = "returnBattle";
		public static const IS_SHOW_DEBUG_INFO : String = "isShowDebugInfo";
		public static const CACHE_AS_BITMAP : String = "cacheAsBitmap";
		public static const SHOW_UI : String = "showui";
		public static const TF_BORDER : String = "tfborder";
		public static const SET_GHOST : String = "setGhost";
		public static const SET_MODEL_ID : String = "setModelId";
		public static const CHANGE_MODEL : String = "changeModel";
		public static const SET_NPC_VISIBELE : String = "setNpcVisible";
		public static const SET_GATE_OPENED : String = "setGateOpened";
		public static const SET_BARRIER_OPENED : String = "setBarrierOpened";
		public static const VO_NPC_VISIBLE : String = "voNpcVisible";
		public static const BOUND_ANIMATION : String = "boundAnimation";
		public static const PLAYER_UI_ADD : String = "playerUIAdd";
		public static const PLAYER_UI_REMOVE : String = "playerUIRemove";
		public static const PLAYER_UI_REMOVE_ALL : String = "playerUIRemoveAll";
		public static const WALK_TIME : String = "walkTime";
		public static const LS_HERO : String = "lshero";
		public static const MSG : String = "msg";
		public static const SET_BUFF : String = "setBuff";
		public static const SET_STATUS : String = "setStatus";
		public static const PROFILER : String = "profiler";
		public static const NPC_SHOW : String = "npcShow";
		public static const MAP_LOAD_PAUSE : String = "mapLoadPause";
		public static const MAP_LOAD_GO : String = "mapLoadGo";
		public static const MOUSE_ENABLE_WALK : String = "mouseEnableWalk";
		public static const DEBUG_FISHING : String = "debugFishing";
		public static const DEBUG_MONSTER_POT : String = "debugMP";
		public static const DEBUG_TOOLOPEN : String = "dt";
		public static const DEBUG_MEMORY : String = "debugMemory";
		public static const DEBUG_TIPS : String = "debugTips";

		private function help() : void
		{
			var info : String = "GM命令:" + "gm help-帮助<br> " + "gm net-流量<br>";
			info += "gm clanPrompt 家族提示消息<br>";
			info += "gm addPlayer n(数量)<br>";
			info += "gm getPosition 获取当前角色坐标<br>";
			info += "gm goScene sceneID difficultyLevel 切换地图<br>";
			info += "gm sceneSH 0/1 显示或隐藏地图<br>";
			info += "gm be 结束战斗<br>";
			info += "gm reset id value 初始化勾选<br>";
			info += "gm toPoint x y callFun callFunArgs responseRadius 去地图某个位置 <br>";
			info += "gm toMap mapId x y flashStep 去地图某个位置mapId小于等于0是就是当前地图 <br>";
			info += "gm toNpc npcId mapId flashStep 去地图某个NPC位置mapId小于等于0是就是当前地图<br>";
			info += "gm toGate toMapId stand 去地图某个出口入口toMapId小于等于0是就是当前地图, stand 是否站立<br>";
			info += "gm toDupl duplMapId flashStep guideType x y去副本<br>";

			info += "gm selfPosition 获取自己玩家位置<br>";
			info += "gm storyEnter 进入剧情 <br>";
			info += "gm storyExit 退出剧情 <br>";
			info += "gm transport x y mapId 传送 mapId为0时是当前地图<br>";
			info += "gm npcConvoyAdd npcId 设置某个NPC跟随自己 <br>";
			info += "gm npcConvoyRemove npcId 移除某个NPC跟随自己 <br>";
			info += "gm playerList 获取玩家列表 <br>";
			info += "gm ps centerX centerY width height 地图截屏 <br>";
			info += "gm chatPrompt content isHTMLFormat 聊天提示消息 <br>";
			info += "gm chatSystem content isHTMLFormat 聊天系统消息 <br>";
			info += "gm chatSystemNotic content isHTMLFormat 聊天系统通知消息 <br>";
			info += "gm selfSpeed num 自己速度 <br>";
			info += "gm returnBattle true/false 不进入战斗<br>";
			info += "gm isShowDebugInfo true/false 是否显示debug信息<br>";
			info += "gm setGhost playerId true/false 设置是否为灵魂<br>";
			info += "gm setModelId playerId modelId 设置玩家模式<br>";
			info += "gm changeModel playerId modelId 设置玩家模式装<br>";
			info += "gm setNpcVisible npcId true/false 设置NPC是否显示<br>";
			info += "gm setGateOpened gateId true/false 设置Gate是否显示<br>";
			info += "gm setBarrierOpened gateId true/false 设置路障是否显示<br>";
			info += "gm voNpcVisible npcId true/false 设置是否为灵魂<br>";
			info += "gm boundAnimation animationId/-1   设置是否绑定动画(-1为取消绑定)<br>";
			info += "gm playerUIAdd displayOjbect 添加玩家UI<br>";
			info += "gm playerUIRemove displayOjbect 移除玩家UI<br>";
			info += "gm playerUIRemoveAll displayOjbect 移除所有玩家UI<br>";
			info += "gm walkTime fromX fromY toX toY speed 输出走路时间<br>";
			info += "gm lshero 列表所有将领<br>";
			info += "gm msg msgId|str[0],str[1],...|int[0],int[1]";
			info += "gm setBuff buffId time 设置BuffICO <br>";
			info += "gm setStatus  statusId level 设置状态 <br> ";
			info += "gm debugFishing 调试钓鱼 <br> ";
			info += "gm npcShow 显示出隐藏的NPC <br> ";
			info += "gm mapLoadPause 地图加载管理暂停加载  <br> ";
			info += "gm mapLoadGo 地图加载管理继续加载  <br> ";
			info += "gm mouseEnableWalk 鼠标是否能点击走路  <br> ";

			info += "gm debugToolOpen 打开调试工具";
			Logger.info(info);
		}

		private function showNetInfo() : void
		{
			var info : String = Common.game_server.data.toString() + "  已读:" + Common.game_server.readBytes + "字节,";
			info += "已发:" + Common.game_server.writeBytes + "字节.";
			Logger.info(info);
		}

		public static var PLAYER_ID : int = 3000;

		public static function addPlayers(num : int) : void
		{
			var playerStruct : PlayerStruct;
			var selfPlayerStruct : PlayerStruct = MSelfPlayer.struct;
			var globalPlayers : GlobalPlayers = GlobalPlayers.instance;
			var playerData : PlayerData = PlayerData.instance;
			var x : int = MSelfPlayer.position.x;
			var y : int = MSelfPlayer.position.y;
			for (var i : int = 0; i < num; i++)
			{
				playerStruct = new PlayerStruct();
				playerStruct.id = PLAYER_ID;
				PLAYER_ID++;
				playerStruct.name = "玩家_" + i;
				playerStruct.avatarVer = 1;
				playerStruct.newAvatarVer = 1;
				playerStruct.clothId = MapMath.randomInt(3, 0);
				playerStruct.heroId = MapMath.randomInt(6, 1);
//				playerStruct.clothId =1;
//				playerStruct.heroId = 1;
				playerStruct.setPotential(selfPlayerStruct.potential);
				playerStruct.x = x + MapMath.randomPlusMinus(200);
				playerStruct.y = y + MapMath.randomPlusMinus(200);
				playerStruct.walking = true;
				playerStruct.walktimeStart = getTimer();
				playerStruct.fromX = playerStruct.x + MapMath.randomPlusMinus(200);
				playerStruct.fromY = playerStruct.y + MapMath.randomPlusMinus(200);
				playerStruct.toX = playerStruct.x + MapMath.randomPlusMinus(200);
				playerStruct.toY = playerStruct.y + MapMath.randomPlusMinus(200);
				globalPlayers.addPlayer(playerStruct);
				playerData.addWaitInstall(playerStruct);
			}
		}

		public function GMMethod() : void
		{
		}

		public function run(params : Array) : void
		{
			if (params.length == 0) return;
			var method : String = params.shift();
			var playerId : int;
			switch(method)
			{
				case GMMethod.HELP:
					help();
					break;
				case GMMethod.SHOW_NET_INFO:
					showNetInfo();
					break;
				case ADD_PLAYER:
					addPlayers(params.shift());
					break;
				case IS_HIDE_BATTLE:
					BTSystem.INSTANCE().end();
					break;
				case GO_SCENE:
					break;
				case RESET:
					SettingData.setDataById(params.shift(), params.shift() == "true" ? true : false);
					break;
				case TO_POINT:
					MTo.toPoint(1, params.shift(), params.shift(), 0, 0, Logger.info, ["toPoint Succeed"]);
					break;
				case TO_MAP:
					MTo.toMap(1, params.shift(), params.shift(), params.shift(), Logger.info, ["toMap, Succeed"], params.shift() != "true" ? false : true);
					break;
				case TO_NPC:
					MTo.toNpc(params.shift() != "true" ? 0 : 1, params.shift(), params.shift(), Logger.info, ["toNpc Succeed"], params.shift() != "true" ? false : true);
					break;
				case TO_GATE:
					MTo.toGate(params.shift(), params.shift(), params.shift() != "true" ? false : true, Logger.info, ["toGate Succeed"], params.shift() != "true" ? false : true);
					break;
				case TO_DUPL:
					MTo.toDuplNpc(params.shift(), params.shift() != "true" ? false : true);
					break;
				case TRANSPORT:
					MTo.transportTo(1, params.shift(), params.shift(), params.shift(), Logger.info, ["tranSprotTo Succeed"]);
					// var mapId:int = params.shift();
					// if(!mapId) mapId = 0;
					// MapProto.instance.cs_transport(params.shift(), params.shift(), params.shift());
					break;
				case SELF_POSITION:
					Logger.info("自己玩家位置：", SelfMediator.cbPosition.call().toString());
					break;
				case EN_MOUSE_MOVE:
					MMouse.enableWalk = params.shift() == "true";
					break;
				case SM_ENTER:
					MStory.enter();
					break;
				case SM_EXIT:
					MStory.exit();
					break;
				case PLAYER_LIST:
					var player : PlayerStruct = MSelfPlayer.struct;
					Logger.info("自己玩家 ID = " + player.id + "   NAME = " + player.name);
					Logger.info("<b>列家列表</b>");
					Logger.info("<b>ID</b> ---------- <b>NAME</b>");
					var list : Vector.<PlayerStruct> = MPlayer.getStructList();
					for (var i : int = 0; i < list.length; i++)
					{
						player = list[i];
						Logger.info(player.id + " ---------- " + player.name);
					}
					break;
				case NPC_CONVOY_ADD:
					NpcConvoy.addNpc(parseInt(params.shift()));
					break;
				case NPC_CONVOY_REMOVE:
					NpcConvoy.removeNpc(parseInt(params.shift()));
					break;
				case CLAN_PROMPT:
					ManagerChat.instance.clanPrompt(params.shift());
					break;
				case VERSION:
					Logger.info(SystemUtil.getVersion(), "version===>111", "UIManager.version===>" + UIManager.version);
					break;
				case PS:
					ps(params);
					break;
				case IS_DEBUG:
					isDebug = params.shift() == "true";
					// if (isDebug)
					// {
					// _miner = new TheMiner();
					// UIManager.root.addChild(_miner);
					// }
					// else if (_miner && _miner.parent)
					// {
					// _miner.parent.removeChild(_miner);
					// _miner = null;
					// }
					break;
				case CHAT_PROMPT:
					ManagerChat.instance.prompt(params.shift(), true);
					break;
				case CHAT_SYSTEM:
					ManagerChat.instance.system(params.shift(), true);
					break;
				case CHAT_SYSTEM_NOTIC:
					ManagerChat.instance.systemNotic(params.shift(), true);
					break;
				case CHAT_SYSMSG:
					var vo : SysMsgVo = StateManager.instance.getMsgVo(params.shift());
					if (vo)
					{
						ManagerChat.instance.system(vo.text, true);
					}
					break;
				case RETURN_BATTLE:
					BattleInterface.DEBUG_RETURN_BATTLE = params.shift() == "true";
					break;
				case IS_SHOW_DEBUG_INFO:
					isShowDebugInfo = params.shift() == "true";
					break;
				case CACHE_AS_BITMAP:
					cacheViewAsBitmap(params.shift() == "true");
					break;
				case SHOW_UI:
					showUI(params.shift() == "true");
					break;
				case TF_BORDER:
					tfborder(UIManager.root);
					break;
				case SET_GHOST:
					playerId = params.shift() ;
					var value : Boolean = params.shift() == "true";
					var ghostPlayer : Player = MPlayer.getPlayer(playerId);
					if (ghostPlayer)
					{
						ghostPlayer.setGhost(value);
					}
					break;
				case SET_MODEL_ID:
					playerId = params.shift() ;
					var modelId : int = params.shift();
					var acMsg : SCAvatarInfoChange = new SCAvatarInfoChange();
					acMsg.id = playerId;
					acMsg.avatarVer = (modelId << 5) + Math.random() * 10;
					WorldProto.instance.sc_playerAvatarInfoChange(acMsg);
					break;
				case CHANGE_MODEL:
					playerId = params.shift() ;
					var chagemodelId : int = params.shift();
					var chagePlayer : Player = MPlayer.getPlayer(playerId);
					if (chagePlayer)
					{
						chagePlayer.changeModel(chagemodelId);
					}
					break;
				case SET_NPC_VISIBELE:
					var npcId : int = params.shift() ;
					if (params.shift() == "true")
					{
						MNpc.add(npcId);
					}
					else
					{
						MNpc.remove(npcId);
					}
					break;
				case SET_GATE_OPENED:
					GateOpened.setState(params.shift(), params.shift() == "true");
					break;
				case GMMethod.SET_BARRIER_OPENED:
					BarrierOpened.setState(params.shift(), params.shift() == "true");
					break;
					if (ghostPlayer)
					{
						ghostPlayer.setGhost(value);
					}
					break;
				case VO_NPC_VISIBLE:
					var vonpcId : int = params.shift() ;
					var voNpc : VoNpc = RSSManager.getInstance().getNpcById(vonpcId);
					if (voNpc)
					{
						voNpc.visable = params.shift() == "true";
					}
					break;
				case BOUND_ANIMATION:
					QuestUtil.tempAnimation = params.shift();
					break;
				case PLAYER_UI_ADD:
					if (playerUI == null) playerUI = UICreateUtils.createGButton("UIUIUIUIUIUIUI");
					MSelfPlayer.player.uiAdd(playerUI);
					break;
				case PLAYER_UI_REMOVE:
					if (playerUI)
					{
						MSelfPlayer.player.uiRemove(playerUI);
						playerUI = null;
					}
					break;
				case PLAYER_UI_REMOVE_ALL:
					MSelfPlayer.player.uiRemoveAll();
					break;
				case LS_HERO:
					listHero();
					break;
				case WALK_TIME:
					walkTime_fromX = params.shift() ;
					walkTime_fromY = params.shift() ;
					walkTime_toX = params.shift() ;
					walkTime_toY = params.shift() ;
					walkTime_speed = params.shift() ;
					MTo.transportTo(1, walkTime_fromX, walkTime_fromY, 0, walkTimeTransportCall);
					break;
				case MSG:
					var arr : Array = (params.shift() as String).split("|");
					var id : int = arr[0];
					var var1 : Array = arr[1] ? (arr[1] as String).split(",") : null;
					var var2 : Array = arr[2] ? (arr[2] as String).split(",") : null;
					StateManager.instance.checkMsg(id, var1, null, var2);
					break;
				case SET_BUFF:
					BuffStatusManager.instance.updateBuffTime(params.shift(), params.shift());
					break;
				case SET_STATUS:
					BuffStatusManager.instance.updateStatusLevel(params.shift(), params.shift());
					break;
				case DEBUG_FISHING:
					FishingPool.instance.reportStatus();
					break;
				case DEBUG_MONSTER_POT:
					var op : String = params.shift();
					if (op == "battle")
					{
						MonsterPotManager.instance.sendChallengeDemonRequest();
					}
					else if (op == "loot")
					{
						MonsterPotManager.instance.sendLootAwardRequest();
					}
					MonsterPotManager.instance.debug();
					break;
				case NPC_SHOW:
					npcShow();
					break;
				case MAP_LOAD_PAUSE:
					MLoading.pause();
					break;
				case MAP_LOAD_GO:
					MLoading.go();
					break;
				case DEBUG_TOOLOPEN:
					debugTool();
					break;
				case MOUSE_ENABLE_WALK:
					MMouse.enableWalk = params.shift() == "true";
					break;
				case DEBUG_MEMORY:
					debugMemory(params.shift());
					break;
				case "debugBattle":
					Common.game_server.sendCCMessage(0x66, BattleInterface.lastBattleInfo);
					break;
				case DEBUG_TIPS:
					ToolTipManager.instance.debug();
					break;
				case "showAlert":
					Alert.show("");
					break;
			}
		}

		private var _debugMemoryIntervalId : uint;

		private function debugMemory(op : String = null) : void
		{
			if (op == "gc")
			{
				Logger.debug("垃圾回收 ... 请稍后再测试");
				System.gc();
			}
			// else if (op == "low")
			// {
			// System.pauseForGCIfCollectionImminent(0.5);
			// }
			// else if (op == "high")
			// {
			// System.pauseForGCIfCollectionImminent(0.95);
			// }
			else if (op == "watch")
			{
				if (_debugMemoryIntervalId)
					debugMemory("stop");
				_debugMemoryIntervalId = setInterval(debugMemory, 1000);
			}
			else if (op == "stop")
			{
				clearInterval(_debugMemoryIntervalId);
				_debugMemoryIntervalId = 0;
			}

			Logger.debug((new Date).toTimeString());
			// Logger.debug(printf("系统内存：%.2fMB", System.privateMemory / 1024 /1024));
			Logger.debug(printf("全部内存：%.2fMB", System.totalMemory / 1024 / 1024));
			Logger.debug(printf("剩余内存：%.2fMB", System.freeMemory / 1024 / 1024));
			// Logger.debug(printf("CPU使用：%.2f%", System.processCPUUsage * 100));
			Logger.debug();
		}

		public function npcShow() : void
		{
			var list : Vector.<Npc> = MNpc.getNpcList();
			var  npc : Npc;
			for (var i : int = 0; i < list.length; i++)
			{
				npc = list[i];
				if (npc.avatar)
				{
					npc.avatar.alpha = 1;
				}
			}
		}

		private function listHero() : void
		{
			Logger.info("=============> MyHero");
			// Logger.info(UserData.instance.myHero.toString());
			Logger.info("=============> Heroes");
			for each (var hero:VoHero in UserData.instance.heroes)
			{
				// Logger.info(hero.toString());
			}
			Logger.info("=============> OtherHeroes");
			for each (hero in UserData.instance.otherHeros)
			{
				// Logger.info(hero.toString());
			}
		}

		private var walkTime_fromX : int;
		private var walkTime_fromY : int;
		private var walkTime_toX : int;
		private var walkTime_toY : int;
		private var walkTime_speed : Number;
		private var walkTime_time : Number;

		private function walkTimeTransportCall() : void
		{
			walkTime_time = getTimer();
			MSelfPlayer.player.changeSpeed(walkTime_speed);
			MSelfPlayer.sWalkEnd.add(walkTimeWalkEndCall);
			MTo.toPoint(1, walkTime_toX, walkTime_toY);
		}

		private function walkTimeWalkEndCall() : void
		{
			MSelfPlayer.sWalkEnd.remove(walkTimeWalkEndCall);
			Alert.show((getTimer() - walkTime_time));
			MSelfPlayer.player.changeSpeed(MSelfPlayer.struct.speed);
		}

		private var playerUI : DisplayObject;

		private function tfborder(root : DisplayObjectContainer) : void
		{
			Toolbox.forEachChildIn(root, ontfborder, -1);
		}

		private function ontfborder(target : DisplayObject, depth : int) : Boolean
		{
			if (target is TextField)
			{
				with ((target.parent as Sprite).graphics)
				{
					lineStyle(1);
					drawRect(target.x, target.y, target.width, target.height);
					drawRect(target.x + 2, target.y + 2, (target as TextField).textWidth, (target as TextField).textHeight);
				}
			}
			return true;
		}

		private function showUI(show : Boolean) : void
		{
			var autoContainer : DisplayObjectContainer = ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER);
			var uiContainer : DisplayObjectContainer = ViewManager.instance.getContainer(ViewManager.UIC_CONTAINER);
			var ioc : DisplayObjectContainer = ViewManager.instance.getContainer(ViewManager.IOC_CONTAINER);

			for each (var container:DisplayObjectContainer in  [autoContainer, uiContainer, ioc])
			{
				if (show)
				{
					if (!container.parent)
						UIManager.root.addChild(container);
				}
				else
				{
					if (container.parent)
						container.parent.removeChild(container);
				}
			}

			if (show)
				Logger.info("开启UI");
			else
				Logger.info("关闭UI");
		}

		private function cacheViewAsBitmap(value : Boolean) : void
		{
			UserData.instance.userPanel.cacheAsBitmap = value;
			ManagerChat.instance.view.cacheAsBitmap = value;
			ViewManager.instance.uiContainer.cacheAsBitmap = value;

			if (value)
				Logger.info("开启ＵＩ缓存");
			else
				Logger.info("关闭ＵＩ缓存");
		}

		// private var _miner : TheMiner;
		private var psBitmap : Bitmap;
		private var psSprict : Sprite;

		public function ps(...args : *) : void
		{
			args = args[0];
			if (args[0] == "null" )
			{
				clearPS();
				return;
			}
			if (psBitmap == null)
			{
				psBitmap = new Bitmap();
				psSprict = new Sprite();
				psSprict.addChild(psBitmap);
				psSprict.addEventListener(MouseEvent.MOUSE_DOWN, psSprict_mouseDown);
				psSprict.doubleClickEnabled = true;
				psSprict.addEventListener(MouseEvent.DOUBLE_CLICK, clearPS);
			}

			clearPS();

			psBitmap.bitmapData = MLand.printScreen(//
			parseInt(args[0]) ? parseInt(args[0]) : MSelfPlayer.position.x, 
			// 
			parseInt(args[1]) ? parseInt(args[1]) : MSelfPlayer.position.y, 
			// 
			args[2] ? parseInt(args[2]) : 0, 
			// 
			args[3] ? parseInt(args[3]) : 0);
			ViewManager.instance.uiContainer.addChild(psSprict);
		}

		private function psSprict_mouseDown(event : MouseEvent) : void
		{
			psSprict.removeEventListener(MouseEvent.MOUSE_DOWN, psSprict_mouseDown);
			psSprict.addEventListener(MouseEvent.MOUSE_UP, psSprict_mouseUp);
			psSprict.startDrag();
		}

		private function psSprict_mouseUp(event : MouseEvent) : void
		{
			psSprict.stopDrag();
			psSprict.addEventListener(MouseEvent.MOUSE_DOWN, psSprict_mouseDown);
		}

		public function clearPS(event : Event = null) : void
		{
			if (psBitmap)
			{
				if (psSprict.parent) psSprict.parent.removeChild(psSprict);
				if (psBitmap.bitmapData) psBitmap.bitmapData.dispose();
				psBitmap.bitmapData = null;
			}
		}

		private function debugTool() : void
		{
			var debugTool : DebugToolView = new DebugToolView();
			UIManager.root.addChild(debugTool);
		}
	}
}
