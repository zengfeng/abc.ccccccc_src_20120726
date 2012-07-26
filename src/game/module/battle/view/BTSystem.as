package game.module.battle.view {
	import com.commUI.tooltip.BattleTip;
	import com.commUI.tooltip.ToolTipManager;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import game.config.StaticConfig;
	import game.core.avatar.AvatarManager;
	import game.core.avatar.AvatarType;
	import game.core.user.StateManager;
	import game.core.user.StateType;
	import game.manager.RSSManager;
	import game.manager.SignalBusManager;
	import game.manager.ViewManager;
	import game.module.battle.BattleInterface;
	import game.module.battle.battleData.AttackData;
	import game.module.battle.battleData.BtBuffProcess;
	import game.module.battle.battleData.BtDefend;
	import game.module.battle.battleData.BtInit;
	import game.module.battle.battleData.BtInitProcess;
	import game.module.battle.battleData.BtProcess;
	import game.module.battle.battleData.BtRescued;
	import game.module.battle.battleData.BtStatus;
	import game.module.battle.battleData.mapData;
	import game.module.battle.battleData.resultData;
	import game.module.battle.battleData.skillData;
	import game.module.battle.battleData.skillType;
	import game.module.battle.battleData.tipData;
	import game.module.quest.VoMonster;
	import game.net.core.Common;
	import game.net.data.CtoS.CSBattleEnd;
	
	import gameui.core.GComponent;
	import gameui.manager.UIManager;
	
	import log4a.Logger;
	
	import net.AssetData;
	import net.RESManager;
	
	import worlds.apis.MWorld;
	import worlds.apis.MapUtil;

	public class BTSystem {
		public var _res:RESManager = RESManager.instance;
		
		private static var _instance : BTSystem = new BTSystem();
		public var isInBattle : Boolean = false;
		public var NormalOrSpecialPlay : Boolean = false;
		public static const SelfPoints : Array = [[622, 483], [622, 483], [737, 426], [848, 370], [848, 370], [693, 518], [693, 518], [805, 462], [918, 405], [918, 405], [763, 554], [763, 554], [876, 497], [989, 441], [989, 441], [833, 589], [833, 589], [947, 532], [1060, 476], [1060, 476], [904, 624], [904, 624], [1018, 568], [1130, 511], [1130, 511]];
		// 地方点坐标
		public static const EnemyPoints : Array = [[678, 285], [678, 285], [566, 342], [452, 398], [452, 398], [607, 250], [607, 250], [494, 307], [381, 363], [381, 363], [537, 214], [537, 214], [423, 271], [310, 327], [310, 327], [466, 179], [466, 179], [353, 235], [240, 292], [240, 292], [396, 143], [396, 143], [282, 200], [169, 257], [169, 257]];
		// 资源部分---------------------------------------------------
		// 普通效果
		public static var Effect_Baoji : Class;
		// 暴击
		public static var Effect_Poji : Class;
		// 破击
		public static var Effect_Baopo : Class;
		// 暴破
		public static var Effect_Shanbi : Class;
		// 反击
		public static var Effect_Counter : Class;
		// 作用在被攻击者身上的普通攻击动画
		public static var EffectTo_PhyAtk : Class;
		// 作用在被攻击者身上的暴击动画
		public static var EffectTo_Baoji : Class;
		// zu
		public static var EffectTo_Poji : Class;
		public static var EffectTo_Baopo : Class;
		// public static var EffectUpwords : Class;
		//
		// public static var EffectDownwords : Class;
		//		//  技能名字
		// public static var EffectSkillNameArr : Array = [];
		//		//  数字
		// public static var Number_Hurt : Bitmap;
		// 伤血数字vec
		public static var Number_HurtVec : Vector.<Bitmap> = new Vector.<Bitmap>();
		// 加血数字vec
		public static var Number_AddVec : Vector.<Bitmap> = new Vector.<Bitmap>();
		// 中毒伤血
		public static var Number_PosionVec : Vector.<Bitmap> = new Vector.<Bitmap>();
		// 战斗胜利
		public static var mc_Victory : MovieClip;
		// 战斗失败
		public static var mc_Lose : MovieClip;
		// 闪避
		// 技能效果---------------------------------------------------
		public static var Effect_SkillVec : Vector.<BitmapData> = new Vector.<BitmapData>();
		// 技能效果
		// private var allskillNum : uint;
		// 效果编号---------------------------------------------------
		public static var ID_PhyAtk : uint = 100;
		public static var ID_SkillAtk : uint = 101;
		public static var ID_Baoji : uint = 1000;
		// 暴击id
		public static var ID_Poji : uint = 1001;
		// 破击id
		public static var ID_Baopo : uint = 1002;
		// 暴破id
		public static var ID_Shanbi : uint = 1003;
		// 闪避id
		public static var ID_Skill : uint = 1004;
		// 反击id
		public static var ID_Counter : uint = 1005;
		// 其它，指技能
		private static var ID_Poision : uint = 1101;
		// 中毒ID
		private static var ID_Stun : uint = 1102;
		// 战斗类型(默认)
		public static var FT_NORMAL : uint = 0;
		// boss战
		public static var FT_BOSS : uint = 1;
		// 国战
		public static var FT_COUNTRY : uint = 2;
		// 运镖
		public static var FT_GUARD : uint = 3;
		// 家族寻宝
		public static var FT_GUILDDUGEON : uint = 4;
		// 家族运镖
		public static var FT_GBODYGUARD : uint = 5;
		// 竞技场
		public static var FT_ATHLETICS : uint = 6;
		// 任务
		public static var FT_QUESTNPC : uint = 7;
		// 副本
		public static var FT_DUGEON : uint = 8;
		// 锁妖塔
		public static var FT_LOCKBOSS : uint = 9;
		// 神器
		public static var FT_ARTIFACTS : uint = 10;
		// 可视部分---------------------------------------------------
		// 战斗层
		public var _battleSprite : Sprite = new Sprite();
		// swf上层
		public var _swfSpriteUp : Sprite = new Sprite();
		// swf底层
		public var _swfSpriteDown : Sprite = new Sprite();
		// 伤血层
		public var _bloodSprite : Sprite = new Sprite();
		// 黑色遮罩----------------------------------------------------
		private var _blackMask : Sprite = new Sprite();
		// 战斗列表----------------------------------------------------
		
		private var _fighters : Array = [];
		// 战斗结束面板
		private var _btResult : BTResult;
		// 战斗结果
		public var b_Result : Boolean;
		public var mySide : uint;
		// 战斗开始时间
		public var startTime : int;
		// 战斗结束时间
		public var endTime : int;
		// 战斗类型
		private var _fightType : uint;
		private var _container : GComponent;
		private var containerBaseX : int;
		private var containerBaseY : int;
		public var upGrid : Bitmap;
		public var downGrid : Bitmap;
		public var BASEDELYTIME : Number = 0.0;
		private var PLAYMODLE : uint = 0;
		
		// public var
		// 0:正常战斗  1:replay
		public var BtBuffData : Vector.<BtBuffProcess> = new Vector.<BtBuffProcess>();
		public var BtData : Vector.<BtProcess> = new Vector.<BtProcess>();
		public var BtInitData : Vector.<BtInit> = new Vector.<BtInit>();
		public var isAvatarLoad : Boolean = false;
		// avtar已经加入场景
		private var BaseOffsetX : int = 0;
		// 基础x像素偏移
		private var BaseOffsetY : int = 0;
		// 基础y像素偏移
		private var BackGroundPic : Bitmap;
		// 战斗背景
		private var earnExp : uint = 0;
		private var rewardlist : Array;
		private var guardResult : uint;
		public var  RESOURCES : Array = [];
		private var userpanel : BattleUserPanel;
		private var enemypanel : BattleUserPanel;
		
		private var PlayerRoleID : int;
		// 自己头像id
		private var PlayerRoleName : String;
		// 我名字
		private var PlayerLevel : int;
		private var PlayerColor : uint;
		// 潜力
		private var PlayerArtifactLvl : uint;
		// 神器等级
		private var EnemyRoleID : int;
		// 对方头像id
		private var EnemyRoleName : String;
		// 对方名字
		private var EnemyLevel : int;
		// 对方等级
		private var EnemyColor : uint;
		// 对方潜力
		private var EnemyArtifactLvl : uint;
		// 背景资源链接
		private var picNameStr : String;
		
		//为加载对selfavatar tooltip的监听
		private var _selfAvatarCopy:BTAvatar = null;

		//设置战斗
		public function setBackGroundStr(pic:String):void
		{
			picNameStr = pic;
		}

		// 对方神器等级,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		// private var SWFCONTAINER:Vector.<MovieClip> = new Vector.<BtInit>();
		public function setPlayerRoleID(id : int) : void {
			PlayerRoleID = id;
		}

		public function setPlayerRoleName(name : String) : void {
			PlayerRoleName = name;
		}

		public function setPlayerLevel(pl : int) : void {
			PlayerLevel = pl;
		}

		public function setEnemyRoleID(id : int) : void {
			EnemyRoleID = id;
		}

		public function setEnemyRoleName(name : String) : void {
			EnemyRoleName = name;
		}

		public function setEnemyLevel(el : int) : void {
			EnemyLevel = el;
		}

		public function setPlayerColor(pc : uint) : void {
			PlayerColor = pc;
		}

		public function setEnemyColor(pc : uint) : void {
			EnemyColor = pc;
		}

		public function setPlayerArtifactLvl(pafl : uint) : void {
			PlayerArtifactLvl = pafl;
		}

		public function setEnemyArtifactLvl(eafl : uint) : void {
			EnemyArtifactLvl = eafl;
		}

		public function getGuardResult() : uint {
			return guardResult;
		}

		public function setGuardResult(a : uint) : void {
			guardResult = a;
		}

		public function getEarnExp() : uint {
			return earnExp;
		}

		public function setEarnExp(e : uint) : void {
			earnExp = e;
		}

		public function getRewardList() : Array {
			return rewardlist;
		}

		public function setRewardList(r : Array) : void {
			rewardlist = r;
		}

		public function setBattleModel(modle : uint) : void {
			PLAYMODLE = modle;
		}

		public function setNormalOrSpecialPlay(nors : Boolean) : void {
			NormalOrSpecialPlay = nors;
		}

		public function setBackGroundPic(bd : BitmapData) : void {
			BackGroundPic = new Bitmap(bd);
		}

		public function SetPlayModle(modle : uint) : void {
			PLAYMODLE = modle;
		}

		public function GetPlayModle() : uint {
			return PLAYMODLE;
		}

		public function initBattleTip() : void {
		}

		public function saveBttleData() : void {
			var i : uint;

			//			//  save buff data
			if (BtBuffData.length == 0) {
				for (i = 0; i < BtBuffProcess.data.length; ++i ) {
					BtBuffData.push(BtBuffProcess.data[i].clone() as BtBuffProcess);
				}
			}

			if (BtData.length == 0) {
				for (i = 0; i < BtProcess.data.length; ++i) {
					BtData.push(BtProcess.data[i].clone() as BtProcess);
				}
			}
		}

		public function ReloadBttleData() : void {
			var i : uint;
			BtBuffProcess.data.splice(0, BtBuffProcess.data.length);
			BtProcess.data.splice(0, BtProcess.data.length);
			for (i = 0; i < BtBuffData.length; ++i) {
				BtBuffProcess.data.push(BtBuffData[i]);
			}

			for (i = 0; i < BtData.length; ++i) {
				BtProcess.data.push(BtData[i]);
			}

			for (i = 0; i < BtInitData.length; ++i) {
				BtInitProcess.data.push(BtInitData[i]);
			}
		}

		public function InitTipData() : void {
			var i : int;
			var j : int;
			var btavatar : BTAvatar;
			var bin : BtInit;
			var td : tipData;
			var isload : Boolean = false;
			isload = BtInitData.length ? true : false;
			for (i = 0; i < _fighters.length; ++i) {
				btavatar = _fighters[i] as BTAvatar;
				for (j = 0; j < BtInitProcess.data.length; ++j) {
					bin = BtInitProcess.data[j] as BtInit;
					td = new tipData();
					if (btavatar.theFighterInfo.side == bin.pside && btavatar.theFighterInfo.pos == bin.ppos) {
						btavatar.theFighterInfo.setNowHp(bin.pHp);
						btavatar.theFighterInfo.setNowGauge(bin.pGauge);

						td.playerName = btavatar.theFighterInfo.name;
						td.playerGauge = btavatar.theFighterInfo.getNowGauge();
						td.playerHp = btavatar.theFighterInfo.getNowHp();
						td.playerSkillName = btavatar.theFighterInfo.getSkillName();
						td.playerSkillId = btavatar.theFighterInfo.skillId;

						btavatar.setTipData(td);
						if (!isload)
							BtInitData.push(bin.clone() as BtInit)
						break;
					}
				}
				ToolTipManager.instance.registerToolTip(btavatar, BattleTip, td);
			}
			BtInitProcess.data.splice(0, BtInitProcess.data.length);
		}

		// 初始化函数
		private function launch() : void {
			// 绘制黑色遮罩
			_blackMask.graphics.clear();
			_blackMask.graphics.beginFill(0x000000);
			_blackMask.graphics.drawRect(0, 0, Capabilities.screenResolutionX, Capabilities.screenResolutionY);
			_blackMask.graphics.endFill();
			_container.addChild(_blackMask);

			var mapID : uint;
			var mapD : mapData;
			if (PLAYMODLE == 0) {
				// 加载背景图
				if (BTSystem.INSTANCE().getFightTypeID() == BTSystem.FT_DUGEON)  // 副本
				{
					var isDugeonBoss : Boolean = false;
					var vomster : VoMonster = RSSManager.getInstance().getMosterById(EnemyRoleID) as VoMonster;
					mapID = MapUtil.currentMapId;
					if (vomster && vomster.IsDugeonBoss())
						isDugeonBoss = true;
					if (isDugeonBoss)
						mapID = mapID * 10000 + 1;
					else
						mapID = mapID * 10000;
					mapD = AttackData.mapidlist[mapID] as mapData;
					picNameStr = mapD.urlStr;

					if (isDugeonBoss) // 大boss截图
					{
						if (BackGroundPic != null) {
							BaseOffsetX = -BackGroundPic.width / 2;
							BaseOffsetY = -BackGroundPic.height / 2;
							BackGroundPic.x = BaseOffsetX + int(UIManager.root.stage.stageWidth / 2);
							BackGroundPic.y = BaseOffsetY + int(UIManager.root.stage.stageHeight / 2);
						}
					} 
					else  // 小boss单独背景图
					{
						BackGroundPic = RESManager.getLoader(picNameStr).getContent() as Bitmap;
						BaseOffsetX = -mapD.pointX;
						BaseOffsetY = -mapD.pointY;
						BackGroundPic.x = BaseOffsetX + int(UIManager.root.stage.stageWidth / 2);
						BackGroundPic.y = BaseOffsetY + int(UIManager.root.stage.stageHeight / 2);
					}
				}
				else if (BTSystem.INSTANCE().getFightTypeID() == BTSystem.FT_QUESTNPC)  // 任务，单独背景图
				{
					mapID = MapUtil.currentMapId;
					mapD = AttackData.mapidlist[mapID] as mapData;
					picNameStr = mapD.urlStr;
					BackGroundPic = RESManager.getLoader(picNameStr).getContent() as Bitmap;
					
					BaseOffsetX = -mapD.pointX;
					BaseOffsetY = -mapD.pointY;
					BackGroundPic.x = BaseOffsetX + int(UIManager.root.stage.stageWidth / 2);
					BackGroundPic.y = BaseOffsetY + int(UIManager.root.stage.stageHeight / 2);
				}
				else if (BTSystem.INSTANCE().getFightTypeID() == BTSystem.FT_COUNTRY || BTSystem.INSTANCE().getFightTypeID() == BTSystem.FT_BOSS || BTSystem.INSTANCE().getFightTypeID() == BTSystem.FT_GUILDDUGEON)// 国战，boss战，家族boss战，截图
				{
					mapID = BTSystem.INSTANCE().getFightTypeID() * 100000;
					mapD = AttackData.mapidlist[mapID] as mapData;
					// BackGroundPic = new Bitmap(MLand.printScreen(mapD.pointX, mapD.pointY));
					if (BackGroundPic != null) {
						BaseOffsetX = -BackGroundPic.width / 2;
						BaseOffsetY = -BackGroundPic.height / 2;
						BackGroundPic.x = BaseOffsetX + int(UIManager.root.stage.stageWidth / 2);
						BackGroundPic.y = BaseOffsetY + int(UIManager.root.stage.stageHeight / 2);
					}
				}
				else if (BTSystem.INSTANCE().getFightTypeID() == BTSystem.FT_GUARD || BTSystem.INSTANCE().getFightTypeID() == BTSystem.FT_GBODYGUARD || BTSystem.INSTANCE().getFightTypeID() == BTSystem.FT_ATHLETICS)  // 运镖，家族运镖，竞技场，锁妖塔，单独背景图
				{
					// 单独load地图
					mapID = BTSystem.FT_GUARD * 100000;
					mapD = AttackData.mapidlist[mapID] as mapData;
					picNameStr = mapD.urlStr;
					BackGroundPic = RESManager.getLoader(picNameStr).getContent() as Bitmap;
					BaseOffsetX = -mapD.pointX;
					BaseOffsetY = -mapD.pointY;
					BackGroundPic.x = BaseOffsetX + int(UIManager.root.stage.stageWidth / 2);
					BackGroundPic.y = BaseOffsetY + int(UIManager.root.stage.stageHeight / 2);
				} else if (BTSystem.INSTANCE().getFightTypeID() == BTSystem.FT_LOCKBOSS) {
					// 单独load地图
					mapID = BTSystem.FT_LOCKBOSS * 100000;
					mapD = AttackData.mapidlist[mapID] as mapData;
					picNameStr = mapD.urlStr;
					BackGroundPic = RESManager.getLoader(picNameStr).getContent() as Bitmap;
					BaseOffsetX = -mapD.pointX;
					BaseOffsetY = -mapD.pointY;
					BackGroundPic.x = BaseOffsetX + int(UIManager.root.stage.stageWidth / 2);
					BackGroundPic.y = BaseOffsetY + int(UIManager.root.stage.stageHeight / 2);
				} else if (BTSystem.INSTANCE().getFightTypeID() == BTSystem.FT_ARTIFACTS) {
					mapID = getCityID() + 2;
					mapD = AttackData.mapidlist[mapID] as mapData;
					picNameStr = mapD.urlStr;
					BackGroundPic = RESManager.getLoader(picNameStr).getContent() as Bitmap;
					BaseOffsetX = -mapD.pointX;
					BaseOffsetY = -mapD.pointY;
					BackGroundPic.x = BaseOffsetX + int(UIManager.root.stage.stageWidth / 2);
					BackGroundPic.y = BaseOffsetY + int(UIManager.root.stage.stageHeight / 2);
				}
			}
			else {
				mapID = 2;
				mapD = AttackData.mapidlist[mapID] as mapData;
				picNameStr = mapD.urlStr;
				BackGroundPic = RESManager.getLoader(picNameStr).getContent() as Bitmap;
				BaseOffsetX = -mapD.pointX;
				BaseOffsetY = -mapD.pointY;
				BackGroundPic.x = BaseOffsetX + int(UIManager.root.stage.stageWidth / 2);
				BackGroundPic.y = BaseOffsetY + int(UIManager.root.stage.stageHeight / 2);
			}

			// 背景层
			_container.addChild(BackGroundPic);
			

			// grid层
			// addgrid();

			// swf下层
			_container.addChild(_swfSpriteDown);
			_swfSpriteDown.x = int(UIManager.root.stage.stageWidth / 2 - 640);
			_swfSpriteDown.y = int(UIManager.root.stage.stageHeight / 2 - 350);

			// 战斗层
			_container.addChild(_battleSprite);
			_container.show();
			_battleSprite.x = int(UIManager.root.stage.stageWidth / 2 - 640);
			_battleSprite.y = int(UIManager.root.stage.stageHeight / 2 - 350);
			UIManager.root.stage.addEventListener(Event.RESIZE, Resize_func);

			// 伤血层
			_container.addChild(_bloodSprite);
			_bloodSprite.x = int(UIManager.root.stage.stageWidth / 2 - 640);
			_bloodSprite.y = int(UIManager.root.stage.stageHeight / 2 - 350);

			// swf上层
			_container.addChild(_swfSpriteUp);
			_swfSpriteUp.x = int(UIManager.root.stage.stageWidth / 2 - 640);
			_swfSpriteUp.y = int(UIManager.root.stage.stageHeight / 2 - 350);

			// 头像
			showUserPanel();
		}

		private function Resize_func(evt : Event) : void {
			if (BackGroundPic) {
				BackGroundPic.x = BaseOffsetX + int(UIManager.root.stage.stageWidth / 2);
				BackGroundPic.y = BaseOffsetY + int(UIManager.root.stage.stageHeight / 2);
			}

			if (_battleSprite) {
				_battleSprite.x = int(UIManager.root.stage.stageWidth / 2 - 640);
				_battleSprite.y = int(UIManager.root.stage.stageHeight / 2 - 350);
			}

			if (mc_Victory) {
				mc_Victory.x = (UIManager.root.stage.stageWidth) / 2 - 5;
				mc_Victory.y = (UIManager.root.stage.stageHeight) / 2;
			}

			if (mc_Lose) {
				mc_Lose.x = (UIManager.root.stage.stageWidth) / 2 - 5;
				mc_Lose.y = (UIManager.root.stage.stageHeight) / 2;
			}

			if (_btResult) {
				_btResult.x = (UIManager.root.stage.stageWidth - _btResult.width) / 2;
				_btResult.y = (UIManager.root.stage.stageHeight - _btResult.height) / 2 - 40;
			}

			if (userpanel) {
				userpanel.x = int(UIManager.root.stage.stageWidth - userpanel.width - 10);
				userpanel.y = int(UIManager.root.stage.stageHeight - userpanel.height - 32 - 15);
			}

			// swf下层
			if (_swfSpriteDown) {
				_swfSpriteDown.x = int(UIManager.root.stage.stageWidth / 2 - 640);
				_swfSpriteDown.y = int(UIManager.root.stage.stageHeight / 2 - 350);
			}

			// swf上层
			if (_swfSpriteUp) {
				_swfSpriteUp.x = int(UIManager.root.stage.stageWidth / 2 - 640);
				_swfSpriteUp.y = int(UIManager.root.stage.stageHeight / 2 - 350);
			}

			// 伤血层
			if (_bloodSprite) {
				_bloodSprite.x = int(UIManager.root.stage.stageWidth / 2 - 640);
				_bloodSprite.y = int(UIManager.root.stage.stageHeight / 2 - 350);
			}
		}

		public function setContainer(root : GComponent) : void {
			_container = root;
			containerBaseX = root.x;
			containerBaseY = root.y;
		}

		public function addTween(time : Number) : void {
			UIManager.root.stage.addEventListener(Event.ENTER_FRAME, OnTween);
			TweenLite.to(UIManager.root.stage, 0, {delay:time, onComplete:removeTween, onCompleteParams:[], overwrite:0});
		}

		public function removeTween() : void {
			UIManager.root.stage.removeEventListener(Event.ENTER_FRAME, OnTween);
			_container.x = containerBaseX;
			_container.y = containerBaseY;
		}

		public function OnTween(evt : Event) : void {
			_container.x = containerBaseX + Math.random() * 20;
			_container.y = containerBaseY + Math.random() * 20;
		}

		public function setFightType(type : uint = 0) : void {
			_fightType = type;
		}

		public function getFightTypeID() : uint {
			return (_fightType >> 16) & 0xFF;
		}

		public function getCityID() : uint {
			return (_fightType >> 8) & 0xF;
		}

		public function getOverType() : uint   // 结束面板类型
		{
			return (_fightType & 0xF );
		}

		public function showUserPanel() : void 
		{
			if (!enemypanel)
				enemypanel = new BattleUserPanel();
			enemypanel.y = -2 + 15;
			_container.addChild(enemypanel);

			if (!userpanel)
				userpanel = new BattleUserPanel();
			_container.addChild(userpanel);
			userpanel.x = int(UIManager.root.stage.stageWidth - userpanel.width - 10);
			userpanel.y = int(UIManager.root.stage.stageHeight - userpanel.height - 32 - 15);

			userpanel.setName(PlayerRoleName);
			userpanel.setBackGround(PlayerRoleID, true, PlayerArtifactLvl);
			userpanel.setLevel(PlayerLevel);
			userpanel.setPlayerColor(PlayerColor);
			enemypanel.setName(EnemyRoleName);
			enemypanel.setBackGround(EnemyRoleID, false, EnemyArtifactLvl);
			enemypanel.setLevel(EnemyLevel);
			enemypanel.setPlayerColor(EnemyColor);
		}

		// 开始战斗
		public function start() : void 
		{
			isInBattle = true;
			saveBttleData();
			// 保存战斗数据
			// if(isInBattle)  // 正在进行上场战斗
			// clear();

			if (PLAYMODLE == 0)  // 正常战斗
			{
				ViewManager.instance.uiContainer.visible = false;
				ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER).visible = false;
				MWorld.hide();
			}

			launch();
			// handle资源

//			if (PLAYMODLE == 0) // 正常战斗
//				UIManager.root.addChild(ViewManager.chat);

			initAssets();
			// init 基础战斗效果

			// load avatar
			if (!isAvatarLoad) 
			{
				isAvatarLoad = true;
				var length : int;
				var i : int;
				length = BtProcess.selfList.length;
				for (i = 0; i < length; i++) 
				{
					var self : BTAvatar = AvatarManager.instance.getBattleAvatar(0, BtProcess.selfList[i]);
					_battleSprite.addChild(self);
					self.x = self.pos.x;
					self.y = self.pos.y;
					_fighters.push(self);
					// /Logger.debug("self.x=" + self.x, "self.y=" + self.y);
				}

				length = BtProcess.enemyList.length;
				for (i = 0; i < length; i++) 
				{
					var enemy : BTAvatar = AvatarManager.instance.getBattleAvatar(0, BtProcess.enemyList[i]);
					_battleSprite.addChild(enemy);
					enemy.x = enemy.pos.x;
					enemy.y = enemy.pos.y;
					_fighters.push(enemy);
					// /Logger.debug("enemy.x=" + enemy.x, "enemy.y=" + enemy.y);
				}
				fightersSortXY();
			}

			// 初始化tip数据
			InitTipData();

			// 判断展示战斗队列的buff
			showFighterBuff();
			SignalBusManager.battleStartNoDelay.dispatch();
			// 开打
			setTimeout(StartFight_func, 800);

			startTime = getTimer();

			trace(BtProcess.data.length);
			trace("length");
			// sendEnd(0);
			// end();
		}

		// 清除上一场战斗的buff数据
		public function clearLastBattle() : void 
		{
			var i : int;
			var j : int;
			var obj : *;

			// 先清理数据
			BtProcess.data.splice(0, BtProcess.data.length);

			// 隐藏结算面板和动画

			if (BTSystem.mc_Victory != null) 
			{
				if (BTSystem.mc_Victory.parent && BTSystem.mc_Victory.parent.contains(BTSystem.mc_Victory))
				{
					BTSystem.mc_Victory.parent.removeChild(BTSystem.mc_Victory);
				}
			}

			if ( BTSystem.mc_Lose != null) 
			{
				if (BTSystem.mc_Lose.parent && BTSystem.mc_Lose.parent.contains(BTSystem.mc_Lose))
				{
					BTSystem.mc_Lose.parent.removeChild(BTSystem.mc_Lose);
				}
			}

			if (_btResult)
				_btResult.hide();

			// 停止tween
			if (_battleSprite != null) 
			{
				for (i = 0; i < _battleSprite.numChildren; ++i)
				{
					obj = _battleSprite.getChildAt(i);
					if(obj != null)
						TweenLite.killTweensOf(obj)
				}
			}

			if (_bloodSprite != null) 
			{
				for (i = 0; i < _bloodSprite.numChildren; ++i)
				{
					obj = _bloodSprite.getChildAt(i);
					if(obj != null)
						TweenLite.killTweensOf(obj);
				}
			}

			this.end();
		}

		// 判断展示战斗队列的初始buff
		public function showFighterBuff() : void 
		{
			var i : uint = 0;
			var j : uint = 0;
			var k : uint = 0;
			var btBuf : BtBuffProcess;
			var bs : BtStatus;
			var self : BTAvatar = null;
			for (i = 0; i < BtBuffProcess.data.length; ++i )
			{
				btBuf = BtBuffProcess.data[i];
				for (j = 0; j < btBuf.StatusList.length; ++j) 
				{
					bs = btBuf.StatusList[j] as BtStatus;
					for ( k = 0 ; k < _fighters.length ; k++)
					{
						if (_fighters[k].theFighterInfo.side == bs.sideFrom && _fighters[k].theFighterInfo.pos == bs.fpos) {
							self = _fighters[k];
							break;
						}
					}
					PlaySkillBuff(self, bs.skillid, 1);
					// skillid?????
					if (self == null)
						Logger.debug("showFighterBuff BtAvatar is null");
				}
			}

			BtBuffProcess.data.splice(0, BtBuffProcess.data.length);
		}

		// 层次排序
		public function fightersSortXY() : void 
		{
			var i : int = 0;
			var j : int = 0;
			_fighters.sortOn("y");
			for ( i = 0; i < _fighters.length; i++) 
			{
				if (_battleSprite.contains(_fighters[i] as DisplayObject)) 
				{
					_battleSprite.setChildIndex(_fighters[i], j);
					j++;
				}
			}
		}

		// 加减血排序
		public function bloodSpriteSortXY() : void 
		{
			if (_bloodSprite == null || _bloodSprite.numChildren <= 1)
				return;
			var i : int;
			var j : int;
			var numbersArr : Array = [];


			for (i = 0; i < _bloodSprite.numChildren; ++i)
			{
				numbersArr.push(_bloodSprite.getChildAt(i));
			}

			numbersArr.sortOn("y");
			for ( i = 0, j = 0; i < numbersArr.length; i++) 
			{
				if (_bloodSprite.contains(numbersArr[i] as DisplayObject))
				{
					_bloodSprite.setChildIndex(numbersArr[i], j);
					j++;
				}
			}
		}

		// 仅仅移除
		public function OnlyRemoveAvatars() : void
		{
			var i : int = 0;
			var obj : *;
			while (_battleSprite && _battleSprite.numChildren > 0)
			{
				obj = _battleSprite.getChildAt(i);
				if (obj is BTAvatar) 
				{
					(obj as BTAvatar).hide();
					(obj as BTAvatar).clear();
				}
				if (_battleSprite.contains(obj))
					_battleSprite.removeChild(obj);
				++i;
			}
		}

		// 结束or重播
		public function end() : void 
		{
			var i : int = 0;
			if (PLAYMODLE == 0)  // 清除战斗
			{
				SignalBusManager.battleOver.dispatch();
				// 战斗over
				// 移除tips
				for (i = 0; i < _fighters.length; ++i) 
				{
					ToolTipManager.instance.destroyToolTip(_fighters[i]);
				}
				// 清理avatar
				BattleInterface.clear();
				// 清除资源
				clear();
				DisposAllResources();
				// sendEnd(1);

				StateManager.instance.changeState(StateType.BATTLE, false);
				isAvatarLoad = false;
				runEndClickCall();
				// SystemUtil.gc();
			} 
			else  // 重播
			{
				isAvatarLoad = false;
				ReloadBttleData();
				start();
			}
		}

		// 发送结束数据
		// 过程结束 0   点击面板结束 1
		public  function sendEnd(type : uint) : void 
		{
			if (PLAYMODLE == 0) 
			{
				var msg : CSBattleEnd = new CSBattleEnd();
				if (type == 0)
					msg.type = getFightTypeID();
				else if (type == 1)
					msg.type = getFightTypeID() + 0x1000;
				Common.game_server.sendMessage(0x66, msg);
			}
		}

		private function clear() : void 
		{
			clearBattlePanel();
			if (PLAYMODLE == 0) 
			{
				if (_container)
					_container.hide();
//				ViewManager.instance.uiContainer.addChild(ViewManager.chat);
				ViewManager.instance.uiContainer.visible = true;
				ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER).visible = true;
				MWorld.show();
			}
			UIManager.root.stage.removeEventListener(Event.RESIZE, Resize_func);
			_fighters = [];
			for each (var data:BitmapData in Effect_SkillVec)
			{
				data.dispose();
			}
			RESManager.instance.remove("Battle");
			Effect_SkillVec = new Vector.<BitmapData>();
			// for each(var bitemap:Bitmap in _numberList){
			// if(bitemap && bitemap.bitmapData)
			// bitemap.bitmapData.dispose();
			// }

			//
			for each (var str:String in _swfEffect) 
			{
				RESManager.instance.remove(str);
			}
		}

		public function DisposAllResources() : void 
		{
			var obj : *;
			RESOURCES.splice(0, RESOURCES.length);

			if (_container) 
			{
				if (BackGroundPic)
				{
					if (_container.contains(BackGroundPic))
						_container.removeChild(BackGroundPic);
				}

				// _battleSprite
				if (_battleSprite) 
				{
					while (_battleSprite && _battleSprite.numChildren > 0) 
					{
						obj = _battleSprite.getChildAt(0);
						if (obj is BTAvatar) 
						{
							(obj as BTAvatar).hide();
							(obj as BTAvatar).clear();
						}
						if (_battleSprite.contains(obj))
							_battleSprite.removeChild(obj);
					}

					if (_container.contains(_battleSprite))
						_container.removeChild(_battleSprite);
				}

				// _swfSpriteUp
				if (_swfSpriteUp != null) 
				{
					while (_swfSpriteUp && _swfSpriteUp.numChildren > 0)
					{
						obj = _swfSpriteUp.getChildAt(0);
						if (_swfSpriteUp.contains(obj))
							_swfSpriteUp.removeChild(obj);
					}

					if (_container.contains(_swfSpriteUp))
						_container.removeChild(_swfSpriteUp);
				}

				// _swfSpriteDown
				if (_swfSpriteDown != null)
				{
					while (_swfSpriteUp && _swfSpriteUp.numChildren > 0)
					{
						obj = _swfSpriteUp.getChildAt(0);
						if (obj is MovieClip) (obj as MovieClip).stop();
						if (_swfSpriteUp.contains(obj))
							_swfSpriteUp.removeChild(obj);
					}

					if (_container.contains(_swfSpriteUp))
						_container.removeChild(_swfSpriteUp);
				}

				// _swfSpriteDown
				if (_bloodSprite != null) 
				{
					while (_bloodSprite && _bloodSprite.numChildren > 0) 
					{
						obj = _bloodSprite.getChildAt(0);
						if (obj is MovieClip) (obj as MovieClip).stop();
						if (_bloodSprite.contains(obj))
							_bloodSprite.removeChild(obj);
					}

					if (_container.contains(_bloodSprite))
						_container.removeChild(_bloodSprite);
				}
			}

			if (BackGroundPic)
				AvatarManager.instance.removeBattleBack(picNameStr, BackGroundPic.bitmapData);

			if (mc_Victory) mc_Victory.stop();
			if (mc_Lose) mc_Lose.stop();
		}

		public function clearBattlePanel() : void  // 立即关闭
		{
			if (_btResult)
				_btResult.close();
		}

		public function clearBattlePanelDelay() : void  // 延时关闭
		{
			return;
			setTimeout(clearBattlePanel, 6000);
		}

		public function endBattleDelay(delaytime : uint = 5000) : void 
		{
			return;
			setTimeout(end, delaytime);
		}

		private var _endCallFunList : Vector.<Function> = new Vector.<Function>();

		public function addEndCall(fun : Function) : void
		{
			var index : int = _endCallFunList.indexOf(fun);
			if (index == -1)
				_endCallFunList.push(fun);
		}

		public function removeEndCall(fun : Function) : void
		{
			var index : int = _endCallFunList.indexOf(fun);
			if (index != -1)
				_endCallFunList.splice(index, 1);
		}

		private var _clickEndCallList : Vector.<Object> = new Vector.<Object>();

		/*
		 * BTSystem.addClickEndCall({fun:QuestUtil.questAction, arg:[temp.id]});
		 */
		public function addClickEndCall(obj : Object) : void
		{
			if (obj == null || !obj["fun"] ) return;
			var index : int = _clickEndCallList.indexOf(obj);
			if (index == -1)
				_clickEndCallList.push(obj);
		}

		public function removeClickEndCall(obj : Object) : void
		{
			var index : int = _clickEndCallList.indexOf(obj);
			if (index != -1)
				_clickEndCallList.splice(index, 1);
		}

		public function runEndCall() : void 
		{
			for (var i : int = 0; i < _endCallFunList.length; i++)
			{
				var fun : Function = _endCallFunList[i];
				if (fun != null) fun.apply();
			}
		}

		public function runEndClickCall() : void 
		{
			if (_clickEndCallList.length <= 0) return;
			for (var i : int = 0; i < _clickEndCallList.length; i++)
			{
				var fun : Object = _clickEndCallList[i];
				if (!fun["fun"]) continue;
				(fun["fun"] as Function).apply(null, fun["arg"]);
			}
			_clickEndCallList = new Vector.<Object>();
		}

		// 加入战斗网格
		private function addgrid() : void 
		{
			upGrid = new Bitmap(RESManager.getBitmapData(new AssetData("grid", "Numbers")));
			downGrid = new Bitmap(RESManager.getBitmapData(new AssetData("grid", "Numbers")).clone());

			_container.addChild(upGrid);
			upGrid.x = 112 + int(UIManager.root.stage.stageWidth / 2 - 640);
			upGrid.y = 113 + int(UIManager.root.stage.stageHeight / 2 - 350);

			_container.addChild(downGrid);
			downGrid.x = 564 + int(UIManager.root.stage.stageWidth / 2 - 640);
			downGrid.y = 340 + int(UIManager.root.stage.stageHeight / 2 - 350);
		}

		// UI初始化
		public function initAssets() : void {
			var i : int;
			if (!Effect_Baoji) 
			{
				// 攻击者效果
				Effect_Baoji = RESManager.getLoader("Numbers").getClass("Effect_Baoji");
				Effect_Poji = RESManager.getLoader("Numbers").getClass("Effect_Poji");
				Effect_Baopo = RESManager.getLoader("Numbers").getClass("Effect_Baopo");
				Effect_Shanbi = RESManager.getLoader("Numbers").getClass("Effect_Shanbi");
				Effect_Counter = RESManager.getLoader("Numbers").getClass("Effect_Counter");

				// 被攻击者身上的效果
				EffectTo_PhyAtk = RESManager.getLoader("Numbers").getClass("Effect_PhyAtk");
				EffectTo_Baoji = RESManager.getLoader("Numbers").getClass("EffectTo_Baoji");
				EffectTo_Poji = RESManager.getLoader("Numbers").getClass("EffectTo_Poji");

				// EffectTo_Baopo = RESManager.getLoader("Numbers").getClass("EffectTo_Baopo");
			}

			// Number_Hurt = new Bitmap(RESManager.getBitmapData(new AssetData("Numbers_hurt","Battle")));
			// Effect_Victory = RESManager.getLoader("Numbers").getClass("Effect_Victory");
			if(mc_Victory == null)
				mc_Victory = RESManager.getMC(new AssetData("Effect_Victory", "Numbers"));
			if(mc_Lose == null)
				mc_Lose = RESManager.getMC(new AssetData("Effect_Lose", "Numbers"));

			for ( i = 0; i < 12; ++i )
			{
				// 普通伤血
				if (i == 0)
					Number_HurtVec[i] = new Bitmap(RESManager.getBitmapData(new AssetData("Number_Hurt_a", "Numbers")));
				else if (i == 1)
					Number_HurtVec[i] = new Bitmap(RESManager.getBitmapData(new AssetData("Number_Hurt_b", "Numbers")));
				else
					Number_HurtVec[i] = new Bitmap(RESManager.getBitmapData(new AssetData("Number_Hurt_" + (i - 2).toString(), "Numbers")));

				// 加血
				if (i == 0)
					Number_AddVec[i] = new Bitmap(RESManager.getBitmapData(new AssetData("Number_add_a", "Numbers")));
				else if (i == 1)
					Number_AddVec[i] = new Bitmap(RESManager.getBitmapData(new AssetData("Number_add_b", "Numbers")));
				else
					Number_AddVec[i] = new Bitmap(RESManager.getBitmapData(new AssetData("Number_add_" + (i - 2).toString(), "Numbers")));

				// 中毒
				if (i == 0)
					Number_PosionVec[i] = new Bitmap(RESManager.getBitmapData(new AssetData("Number_poison_a", "Numbers")));
				else if (i == 1)
					Number_PosionVec[i] = new Bitmap(RESManager.getBitmapData(new AssetData("Number_poison_b", "Numbers")));
				else
					Number_PosionVec[i] = new Bitmap(RESManager.getBitmapData(new AssetData("Number_poison_" + (i - 2).toString(), "Numbers")));
			}

			// 技能效果
			for ( i = 0; i < Effect_SkillVec.length; ++i)
			{
				Effect_SkillVec[i] = RESManager.getBitmapData(new AssetData("EffectSkill_" + i.toString(), "Battle"));
			}
		}

		// 技能攻击效果，攻击者或者受挫者
		private function PlaySkillEffect(target : BTAvatar, playType : uint, spellEftid : uint, frontOrback : uint, needTurnOver : Boolean, angle : uint) : void
		{
			target.playSkillEfft(playType, spellEftid, frontOrback, needTurnOver, angle);
		}

		// 技能buff效果，被攻击者播放
		private function PlaySkillBuff(target : BTAvatar, skillId : uint, control : uint = 0, skillAB : uint = 0) : void 
		{
			if (target)
				target.playSkillBuff(skillId, control, skillAB);
		}

		//		//  地面技能
		// private function PlaySkillGroundEft(target : BTAvatar, skillid : uint) : void
		// {
		// target.playgroudeft(skillid);
		// }
		// index 0 上层播放, 1下层层播放
		private var _swfEffect : Array = [];

		private function PlaySwfEffect(side : uint, skillid : uint, index : uint, target : BTAvatar = null) : void 
		{
			var pskilldata : skillData = AttackData.skilllist[skillid];
			var key : String = StaticConfig.cdnRoot + "assets/avatar/" + AvatarManager.instance.getUUId(pskilldata.getGroundSkillID(), AvatarType.SKILL_TYPE_GROUND, 1) + ".swf";
			if (!RESManager.getLoader(key)) return;
			var swfmc : MovieClip = RESManager.getLoader(key).getContent() as MovieClip;
			_swfEffect.push(key);
			if (swfmc)
			{
				// 播放层
				if (index == 0) // 上层
					this._swfSpriteUp.addChild(swfmc);
				else if (index == 1)  // 下层
					this._swfSpriteDown.addChild(swfmc);

				// 播放位置
				if (side == 0) // 对面播放
				{
					swfmc.gotoAndPlay(1);
					if (target != null) 
					{
						swfmc.x = target.x;
						swfmc.y = target.y;
					}
					else
					{
						swfmc.x = 423;
						swfmc.y = 271;
					}
				} 
				else 
				{
					swfmc.gotoAndPlay(1);
					if (target != null)
					{
						swfmc.x = target.x;
						swfmc.y = target.y;
					}
					else 
					{
						swfmc.x = 876;
						swfmc.y = 497;
					}
				}
			}
		}

		// 战斗效果,攻击者自己身上播放
		private function ShowEffect(effectID : uint, target : BTAvatar, skillID : uint = 0) : void
		{
			// 振动效果
			if (effectID == ID_Baopo ) 
			{
				addTween(0.3);
			}

			// 根据效果id，显示相应效果
			if (effectID <= ID_Counter )
			{
				target.showAvatarEfft(effectID);
			}

			if (effectID == ID_Skill) 
			{
				target.showAvatarEfft(effectID, skillID);
			}
		}

		// 战斗效果，被攻击者身上播放
		private function ShowEffectTo(effectID : uint, target : BTAvatar, skillID : uint = 0, flag : uint = 0) : void 
		{
			// 根据效果id，显示相应效果
			if (effectID <= ID_Shanbi ) 
			{
				target.showAvatarEfftTo(effectID, 0, flag);
			}

			// if (effectID == ID_Skill)
			// {
			// target.showAvatarEfftTo(effectID,skillID);
			// }
		}

		// 战斗动作
		private function ShowAction(target : BTAvatar, actionID : uint) : void 
		{
			// trace("actionID========>" + actionID);
			target.setAction(actionID);
			
			if(actionID == AvatarManager.DIE)//如果该avatar死亡
			{
				//移除改avatar的tooltip
				ToolTipManager.instance.destroyToolTip(target);
			}
		}

		// private var _numberList : Vector.<BattleNumber>=new Vector.<BattleNumber>()
		// 伤害文字 0 普通 1中毒
		private function ShowHarm(harm : int, target : BTAvatar, type : int = 0) : void 
		{
			// 显示伤血
			if (harm == 0 || target == null)
				return;
			var bx : int = 0;
			var by : int = 0;
			var numBitmap : BattleNumber = new BattleNumber();
			var flag : int = harm ? 0 : 1;
			numBitmap.initNumbers(Number_HurtVec, Math.abs(harm), flag);
			// _numberList.push(numBitmap);
			numBitmap.toNumber();
			numBitmap.visible = true;
			numBitmap.scaleX = 0.5;
			numBitmap.scaleY = 0.5;
			numBitmap.alpha = 0.3;

			// target.addChild(numBitmap);
			if (target.getSide() == 1)
			{
				// numBitmap.x = target.getTopX() - 20;
				// numBitmap.y = target.getTopY() - 15;
				numBitmap.x = target.x + target.getTopX() - 20;
				numBitmap.y = target.y + target.getTopY() - 15;
			}
			else 
			{
				// numBitmap.x = target.getTopX() + 80;
				// numBitmap.y = target.getTopY() - 15;
				numBitmap.x = target.x + target.getTopX() + 80;
				numBitmap.y = target.y + target.getTopY() - 15;
			}
			_bloodSprite.addChild(numBitmap);
			bx = numBitmap.x;
			by = numBitmap.y;
			TweenLite.to(numBitmap, 0.1, {delay:0.1, scaleX:1, scaleY:1, x:bx - 20, y:by - 28, alpha:1, ease:Expo.easeOut, overwrite:0});
			TweenLite.to(numBitmap, 0.8, {delay:0.55, alpha:0, ease:Expo.easeOut, onComplete:ShowHarmComplete_func, onCompleteParams:[_bloodSprite, numBitmap], overwrite:0});
		}

		// 加血
		private function ShowAddHP(addhp : int, afteraddhp : uint, target : BTAvatar, type : int = 0) : void 
		{
			// 显示加血
			if (addhp == 0 || target == null)
				return;

			var bx : int = 0;
			var by : int = 0;
			var numBitmap : BattleNumber = new BattleNumber();
			var hpPercent : Number = 0;

			// 首先显示血条变化
			target.theFighterInfo

			hpPercent = (afteraddhp / Number(target.getInitHP())) * 100;
			if (hpPercent == 0 && afteraddhp != 0)
				hpPercent = 1;
			target.showHPBar(hpPercent);

			// tips变化
			target.theFighterInfo.setNowHp(afteraddhp);
			target.getTipData().playerHp = afteraddhp;

			// 数字效果
			numBitmap.initNumbers(Number_AddVec, Math.abs(addhp), type);
			// _numberList.push(numBitmap);
			numBitmap.toNumber();
			numBitmap.visible = true;
			numBitmap.scaleX = 0.1;
			numBitmap.scaleY = 0.1;
			numBitmap.alpha = 1;
			target.addChild(numBitmap);
			if (target.getSide() == 1)
			{
				numBitmap.x = target.getTopX() + 15;
				numBitmap.y = target.getTopY() - 10;
			}
			else
			{
				numBitmap.x = target.getTopX() + 15;
				numBitmap.y = target.getTopY() - 10;
			}

			bx = numBitmap.x;
			by = numBitmap.y;
			TweenLite.to(numBitmap, 0.2, {delay:0.1, scaleX:1, scaleY:1, x:bx - 10, y:by - 28 - 20, alpha:1, ease:Expo.easeOut, overwrite:0});
			TweenLite.to(numBitmap, 0.6, {delay:0.35, alpha:1, y:by - 28 - 10 - 60, ease:Linear.easeNone, overwrite:0});
			TweenLite.to(numBitmap, 0.2, {delay:0.75, alpha:0, y:by - 28 - 10 - 80, ease:Linear.easeNone, onComplete:ShowHarmComplete_func, onCompleteParams:[target, numBitmap], overwrite:0});
			//			//  血条bar
			//			//  血条变化
			// var hpPercent : int = 0;
			// hpPercent = Number(target.theFighterInfo.getNowHp()) / Number(target.getInitHP()) * 100;
			// if (hpPercent == 0 && target.theFighterInfo.getNowHp() != 0)
			// hpPercent = 1;
			// target.showHPBar(hpPercent);
		}

		private function ShowPoisonHarm(harm : int, target : BTAvatar, type : int = 0) : void 
		{
			// 显示中毒伤血
			if (harm == 0 || target == null)
				return;
			var bx : int = 0;
			var by : int = 0;
			var numBitmap : BattleNumber = new BattleNumber();

			var flag : int = harm ? 0 : 1;
			numBitmap.initNumbers(Number_PosionVec, Math.abs(harm), flag);
			// _numberList.push(numBitmap);
			numBitmap.toNumber();
			numBitmap.visible = true;
			numBitmap.scaleX = 0.5;
			numBitmap.scaleY = 0.5;
			numBitmap.alpha = 0.3;
			target.addChild(numBitmap);
			if (target.getSide() == 1) 
			{
				numBitmap.x = target.getTopX() - 20;
				numBitmap.y = target.getTopY() - 15;
			} 
			else 
			{
				numBitmap.x = target.getTopX() + 80;
				numBitmap.y = target.getTopY() - 15;
			}

			bx = numBitmap.x;
			by = numBitmap.y;
			TweenLite.to(numBitmap, 0.1, {delay:0.1, scaleX:1, scaleY:1, x:bx - 20, y:by - 28, alpha:1, ease:Expo.easeOut, overwrite:0});
			TweenLite.to(numBitmap, 0.8, {delay:0.55, alpha:0, ease:Expo.easeOut, onComplete:ShowHarmComplete_func, onCompleteParams:[target, numBitmap], overwrite:0});
		}

		// private function ShowHarm(harm : int, target : BTAvatar, type : int = 0) : void
		// {
		//			//  伤血或者加血
		//			//			//   数据
		//			//  if(target != null)
		//			//  {
		//			//  target.theFighterInfo.setNowHp(target.theFighterInfo.getNowHp() + harm);
		//			//  }
		//
		//			//  显示伤血
		// trace("harm==============================>", harm);
		// if(harm == 0 || target == null)
		// return;
		// var bx : int = 0;
		// var by : int = 0;
		// var numBitmap : BattleNumber = new BattleNumber();
		// var flag : int = harm ? 0 : 1;
		// numBitmap.initNumbers(Number_HurtVec, Math.abs(harm), flag);
		// numBitmap.toNumber();
		// numBitmap.visible = true;
		// numBitmap.scaleX = 0.5;
		// numBitmap.scaleY = 0.5;
		// numBitmap.alpha = 0.3;
		// target.addChild(numBitmap);
		// if (target.getSide() == 1)
		// {
		// numBitmap.x = target.getTopX() - 20;
		// numBitmap.y = target.getTopY() - 15;
		// }
		// else
		// {
		// numBitmap.x = target.getTopX() + 80;
		// numBitmap.y = target.getTopY() - 15;
		// }
		//
		// bx = numBitmap.x;
		// by = numBitmap.y;
		// TweenLite.to(numBitmap, 0.1, {delay:0.1, scaleX:1, scaleY:1, x:bx - 20, y:by - 28, alpha:1, ease:Expo.easeOut, overwrite:0});
		// TweenLite.to(numBitmap, 0.4, {delay:0.55, alpha:0, ease:Expo.easeOut, onComplete:ShowHarmComplete_func, onCompleteParams:[target, numBitmap], overwrite:0});
		//
		//			//			//   血条bar
		//			//			//   血条变化
		//			//  var hpPercent : int = 0;
		//			//  hpPercent = Number(target.theFighterInfo.getNowHp()) / Number(target.getInitHP()) * 100;
		//			//  if (hpPercent == 0 && target.theFighterInfo.getNowHp() != 0)
		//			//  hpPercent = 1;
		//			//  target.showHPBar(hpPercent);
		// }
		// 隐藏和显示某人血条和名字
		private function ShowNameAndHPBar(target : BTAvatar, bVisible : Boolean = true) : void 
		{
			target.showNameAndHPbar(bVisible);
		}

		private function ShowHarmComplete_func(harmer : Sprite, tf : BattleNumber) : void
		{
			if (tf && tf.parent) tf.parent.removeChild(tf);
		}

		public function VictorAndLose() : void
		{
			SignalBusManager.battleEnd.dispatch();
			// 抛出end事件
			if (b_Result) 
			{
				mc_Victory.gotoAndStop(1);
				UIManager.root.addChild(mc_Victory);
				mc_Victory.x = (UIManager.root.stage.stageWidth) / 2 - 5;
				mc_Victory.y = (UIManager.root.stage.stageHeight) / 2;
				mc_Victory.gotoAndPlay(1);
			}
			else
			{
				mc_Lose.gotoAndStop(1);
				UIManager.root.addChild(mc_Lose);
				mc_Lose.x = (UIManager.root.stage.stageWidth) / 2 - 5;
				mc_Lose.y = (UIManager.root.stage.stageHeight) / 2;
				mc_Lose.gotoAndPlay(1);
			}
		}

		// 开打
		private function StartFight_func() : void 
		{
			SignalBusManager.battleStart.dispatch();
			Fight_func(BtProcess.data.shift());
		}

		// 战斗过程
		private function Fight_func(p : BtProcess) : void 
		{
			var self : BTAvatar;
			var target : BTAvatar;
			var i : int;
			var j : int;
			if (p == null) 
			{
				// trace("战斗结束", p);
				// trace(BtProcess.data.length);

				endTime = getTimer() - startTime;
				runEndCall();
				isInBattle = false;
				// end();
				if (!NormalOrSpecialPlay)
				{
					if (!_btResult)
					{
						_btResult = new BTResult();
						_btResult.setTextResult(getFightTypeID(), b_Result ? 1 : 0, new resultData(earnExp, 0, rewardlist));
					}
					else
					{
						_btResult.setTextResult(getFightTypeID(), b_Result ? 1 : 0, new resultData(earnExp, 0, rewardlist));
					}

					_btResult.show();
					_btResult.x = (UIManager.root.stage.stageWidth - _btResult.width) / 2;
					_btResult.y = (UIManager.root.stage.stageHeight - _btResult.height) / 2 - 40;
					_btResult.alpha = 0;
					TweenLite.to(_btResult, 0.6, {alpha:1, scaleX:1, scaleY:1, ease:Expo.easeOut, overwrite:0});

					TweenLite.to(_btResult, 0, {delay:0.3, onComplete:VictorAndLose, onCompleteParams:[], overwrite:0});
				}
				NormalOrSpecialPlay = false;

				// 战斗过程结束
				sendEnd(0);

				return;
			}

			//
			if ( p.oneAtkInfo == null)   // 效果状态改变
			{
				var BaseDelay : Number = 0.0;
				var tgSide : int;
				var tgPos : int;
				var tgDmg : uint;
				var skillid : int;
				var letDie : int;
				var showtype : uint;
				var skillAB : uint;
				// 是第几个技能
				// 例如中毒
				if (p.SChangeList.length > 0)
				{
					tgSide = p.SChangeList[0].toside;
					tgPos = p.SChangeList[0].tpos;
					tgDmg = -p.SChangeList[0].data;
					skillid = p.SChangeList[0].skillid;
					showtype = p.SChangeList[0].type;
					letDie = p.SChangeList[0].letDie;
					skillAB = p.SChangeList[0].skillab
				}

				for ( i = 0 ; i < _fighters.length ; i++) 
				{
					if (_fighters[i].theFighterInfo.side == tgSide && _fighters[i].theFighterInfo.pos == tgPos) 
					{
						target = _fighters[i];
						break;
					}
				}

				if (tgDmg > 0)
				{
					// 目标播放受挫动画
					target.setAction(AvatarManager.HURT)
					// 伤害值
					ShowPoisonHarm(-tgDmg, target, skillid);

					// 血条变化
					var hpPercent : int = 0;
					var damageLeft : uint = 0;
					trace(target.theFighterInfo.getNowHp());
					trace(tgDmg);
					trace(target.getInitHP());
					damageLeft = (target.theFighterInfo.getNowHp() - tgDmg) > 0 ? (target.theFighterInfo.getNowHp() - tgDmg) : 0;
					hpPercent = (damageLeft / Number(target.getInitHP())) * 100;
					if (hpPercent == 0 && damageLeft != 0)
						hpPercent = 1;
					target.showHPBar(hpPercent);

					// 攻击过程中的tips数据变化
					if (tgDmg < 0)
						tgDmg = -tgDmg;
					target.theFighterInfo.setNowHp(target.theFighterInfo.getNowHp() - tgDmg);
					target.getTipData().playerHp = damageLeft;

					TweenLite.to(target, 0, {delay:target.getAtkTimeTrad(), onComplete:PlaySkillBuff, onCompleteParams:[target, skillid, showtype, skillAB], overwrite:0});
					BaseDelay += target.getAtkTimeTrad();
				} 
				else // 判断是否取消眩晕
				{
					TweenLite.to(target, 0, {delay:0.2, onComplete:PlaySkillBuff, onCompleteParams:[target, skillid, showtype, skillAB], overwrite:0})
				}

				if (letDie == 1) // 中毒伤血死亡
				{
					TweenLite.to(target, 0, {delay:target.getAtkTimeTrad(), onComplete:ShowAction, onCompleteParams:[target, AvatarManager.DIE], overwrite:0});
					BaseDelay += target.getAtkTimeDie();
				}

				setTimeout(Fight_func, BaseDelay * 1000, BtProcess.data.shift());
			} 
			else if (p.oneAtkInfo != null && p.defendList != null)
			{
				// 找到攻击者和首要目标
				for ( i = 0 ; i < _fighters.length ; i++)
				{
					if (_fighters[i].theFighterInfo.side == p.oneAtkInfo.atkerSide && _fighters[i].theFighterInfo.pos == p.oneAtkInfo.atkerPos)
					{
						self = _fighters[i];
					} 
					else if (_fighters[i].theFighterInfo.side != p.oneAtkInfo.atkerSide && _fighters[i].theFighterInfo.pos == p.oneAtkInfo.atkPos)
					{
						target = _fighters[i];
					}
				}

				if (self != null || target != null)
				{
					// trace("位置", p.oneAtkInfo.atkerSide, p.oneAtkInfo.atkerPos);
				}

				if (self == null || target == null)
				{
					// trace("位置出错", p.oneAtkInfo.atkerSide, p.oneAtkInfo.atkerPos);
					Fight_func(BtProcess.data.shift());
					return;
				}

				// 开始攻击动作
				if(_selfAvatarCopy == null)
				{
					_selfAvatarCopy = self;
				}
				else
				{
					//复位tooltip
					ToolTipManager.instance.registerToolTip(_selfAvatarCopy, BattleTip, _selfAvatarCopy.getTipData());
					_selfAvatarCopy = self;
				}
				//隐藏tooltip
				ToolTipManager.instance.destroyToolTip(self);
				
				if ( p.oneAtkInfo.skillType == -1 )  // 物理攻击
				{
					if (p.oneAtkInfo.atkerSide == 0) 
					{
						if (self.theFighterInfo.getAtkMoveType() == 0 || self.theFighterInfo.getAtkMoveType() == 2) // 攻击不需要移动
						{
							TweenLite.to(self, self.getAtkTimeStand(), {x:self.x, y:self.y, onComplete:FightStepA, onCompleteParams:[self, target, p], overwrite:0});
						} 
						else if (self.theFighterInfo.getAtkMoveType() == 1 || self.theFighterInfo.getAtkMoveType() == 3 || self.theFighterInfo.getAtkMoveType() == 4) // 目标前
						{
							TweenLite.to(self, self.getAtkTimesally(), {x:target.x + 70, y:target.y + 35, onComplete:FightStepA, onCompleteParams:[self, target, p], overwrite:0});
						}
						else   // 阵前
						{
							TweenLite.to(self, self.getAtkTimesally(), {x:566 + 85, y:342 + 43, onComplete:FightStepA, onCompleteParams:[self, target, p], overwrite:0});
						}
					}
					else
					{
						if (self.theFighterInfo.getAtkMoveType() == 0 || self.theFighterInfo.getAtkMoveType() == 2) // 攻击不需要移动
						{
							TweenLite.to(self, self.getAtkTimeStand(), {x:self.x, y:self.y, onComplete:FightStepA, onCompleteParams:[self, target, p], overwrite:0});
						}
						else if (self.theFighterInfo.getAtkMoveType() == 1 || self.theFighterInfo.getAtkMoveType() == 3 || self.theFighterInfo.getAtkMoveType() == 4) {
							TweenLite.to(self, self.getAtkTimesally(), {x:target.x - 70, y:target.y - 35, onComplete:FightStepA, onCompleteParams:[self, target, p], overwrite:0});
						}
						else
						{
							TweenLite.to(self, self.getAtkTimesally(), {x:566 + 85, y:342 + 43, onComplete:FightStepA, onCompleteParams:[self, target, p], overwrite:0});
						}
					}
				} 
				else // 法术攻击
				{
					if (p.oneAtkInfo.atkerSide == 0) 
					{
						if (self.theFighterInfo.getAtkMoveType() == 0 || self.theFighterInfo.getAtkMoveType() == 1) // 攻击不需要移动
						{
							TweenLite.to(self, self.getAtkTimeStand(), {x:self.x, y:self.y, onComplete:FightStepA, onCompleteParams:[self, target, p], overwrite:0});
						} 
						else if (self.theFighterInfo.getAtkMoveType() == 2 || self.theFighterInfo.getAtkMoveType() == 3)
						{
							TweenLite.to(self, self.getAtkTimesally(), {x:target.x + 70, y:target.y + 35, onComplete:FightStepA, onCompleteParams:[self, target, p], overwrite:0});
						} 
						else if ( self.theFighterInfo.getAtkMoveType() == 4)// 阵前
						{
							TweenLite.to(self, self.getAtkTimesally(), {x:566 + 85, y:342 + 43, onComplete:FightStepA, onCompleteParams:[self, target, p], overwrite:0});
						}

						// 判断对自己方的效果
						if (self.theFighterInfo.getSpellEftId2() > 0 || self.theFighterInfo.getBuffID2() > 0)
						{
							trace(self.theFighterInfo.getSpellEftId2());
							trace(self.theFighterInfo.getBuffID2());
							TweenLite.to(self, self.getAtkTimesally(), {onComplete:FightStepAOurs, onCompleteParams:[self, p], overwrite:0});
						}
					} 
					else 
					{
						if (self.theFighterInfo.getAtkMoveType() == 0 || self.theFighterInfo.getAtkMoveType() == 1) // 攻击不需要移动
						{
							TweenLite.to(self, self.getAtkTimeStand(), {x:self.x, y:self.y, onComplete:FightStepA, onCompleteParams:[self, target, p], overwrite:0});
						} 
						else if (self.theFighterInfo.getAtkMoveType() == 2 || self.theFighterInfo.getAtkMoveType() == 3) 
						{
							TweenLite.to(self, self.getAtkTimesally(), {x:target.x - 70, y:target.y - 35, onComplete:FightStepA, onCompleteParams:[self, target, p], overwrite:0});
						}
						else if (self.theFighterInfo.getAtkMoveType() == 4)// 阵前
						{
							TweenLite.to(self, self.getAtkTimesally(), {x:566 + 85, y:342 + 43, onComplete:FightStepA, onCompleteParams:[self, target, p], overwrite:0});
						}

						// 判断对自己方的效果
						if (self.theFighterInfo.getSpellEftId2() > 0 || self.theFighterInfo.getBuffID2() > 0)
						{
							TweenLite.to(self, self.getAtkTimesally(), {onComplete:FightStepAOurs, onCompleteParams:[self, p], overwrite:0});
						}
					}
				}

				// 如果有聚气，隐藏聚气
				for (i = 0; i < p.SChangeList.length; ++i) 
				{
					if (p.SChangeList[i].skillid == skillType.GAUGEFULL && p.SChangeList[i].type == 0)
						self.playSkillBuff(skillType.GAUGEFULL, 0, skillAB);
				}

				// 隐藏血条
				ShowNameAndHPBar(self, false);
			}
		}

		public function FightStepA(self : BTAvatar, target : BTAvatar, p : BtProcess) : void 
		{
			var i : int;
			var j : int;
			var tgAvatar : BTAvatar;
			var damage : int = 0;
			var damageLeft : uint = 0;
			var bDie : Boolean = false;
			var bCounter : Boolean = false;
			var CounterDmg : int = 0;
			var CounterLeft : uint = 0;
			var bCounterDie : Boolean = false;
			var bfirst : Boolean = true;
			var bskillAtk : Boolean = false;
			// 是什么攻击
			var bskillAction : Boolean = false;
			// 是什么表现效果
			var skillid : uint = 0;
			var overtype : uint = 0;
			// 物理法术进是否有技能是否需要翻转

			// 排序
			fightersSortXY();

			// 攻击者播放攻击动作
			// 判断是否使用技能
			if (p.oneAtkInfo.skillType > -1)  // 使用技能动作,(-1 为物理攻击)
			{
				// trace("技能攻击");
				bskillAtk = true;
				// skillid = self.theFighterInfo.skillId;
				overtype = self.theFighterInfo.getCanTurnOver();

				// 开始播放法术攻击动作
				self.setAction(AvatarManager.MAGIC_ATTACK);
				if (self.theFighterInfo.getSpellEftId() > 0)  // 如果有技能效果动画
				{
					bskillAction = true;
					var spellEftid : uint = self.theFighterInfo.getSpellEftId();
					var needTurnOver : Boolean = false;
					var frontOrback : uint = 0;
					var angle : uint = self.theFighterInfo.getAngleType();
					if (self.theFighterInfo.getCanTurnOver() == 1) // 正面技能需要翻转
					{
						frontOrback = 1;
						if (self.theFighterInfo.side == 1)
							needTurnOver = true;
						else
							needTurnOver = false;
					}
					else
					{
						frontOrback = self.theFighterInfo.side ? 0 : 1;
						needTurnOver = false;
					}
					if (self.theFighterInfo.getTargetType() == 1)  // 技能出手方表现
					{
						// 播放法术技能攻击效果
						TweenLite.to(self, self.getAtkTimeSkillPoint(), {onComplete:PlaySkillEffect, onCompleteParams:[self, 0, spellEftid, frontOrback, needTurnOver, angle], overwrite:0});
					}
					else if (self.theFighterInfo.getTargetType() == 2) // 首要目标方表现
					{
						// 播放法术技能攻击效果
						TweenLite.to(target, self.getAtkTimeSkillPoint(), {onComplete:PlaySkillEffect, onCompleteParams:[target, 1, spellEftid, frontOrback, needTurnOver, angle], overwrite:0});
					}
					else if (self.theFighterInfo.getTargetType() == 3) // 多个目标
					{
						for (i = 0; i < p.defendList.length; ++i)
						{
							defender = p.defendList[i] as BtDefend;
							// 匹配avatar
							for (j = 0 ; j < _fighters.length ; j++)
							{
								if (_fighters[j].theFighterInfo.side != p.oneAtkInfo.atkerSide && _fighters[j].theFighterInfo.pos == defender.pos)
								{
									target = _fighters[j];
									break;
								}
							}
							// 所有受挫播放法术技能攻击效果
							TweenLite.to(target, self.getAtkTimeSkillPoint(), {onComplete:PlaySkillEffect, onCompleteParams:[target, 1, spellEftid, frontOrback, needTurnOver, angle], overwrite:0});
						}
					}
				}
			} 
			else  // 普通物理攻击
			{
				// trace("物理攻击或者普通技能攻击");
				bskillAtk = false;
				// 开始播放物理攻击动作
				self.setAction(AvatarManager.ATTACK);
			}

			// 显示技能文字（横扫千军）
			if (bskillAtk)
			{
				self.showSkillName();
			}

			// 判断被攻击者是否都被命中
			var defender : BtDefend;
			for (i = 0; i < p.defendList.length; ++i)
			{
				defender = p.defendList[i] as BtDefend;
				// 匹配avatar
				for (j = 0 ; j < _fighters.length ; j++) 
				{
					if (_fighters[j].theFighterInfo.side != p.oneAtkInfo.atkerSide && _fighters[j].theFighterInfo.pos == defender.pos)
					{
						tgAvatar = _fighters[j];
						break;
					}
				}

				damage = defender.damage;
				damageLeft = defender.leftHp;
				if (defender.leftHp > 0)
					bDie = false;
				else
					bDie = true;

				if (defender.counterDmg == -1 || defender.counterDmg > 0) // 闪避或者反击
				{
					bCounter = true;
					CounterDmg = defender.counterDmg;
					CounterLeft = defender.counterLeft;
					if (defender.counterLeft == 0) 
					{
						bCounterDie = true;
					}
				} 
				else
				{
					bCounter = false;
					CounterDmg = 0;
				}

				// 首要目标
				if (0 == i)
					bfirst = true;
				else
					bfirst = false;

				if (bskillAction)  // 有美术技能表现
				{
					if (bskillAtk) // 法术
					{
						// damage == 0 闪避   damage > 0 命中
						TweenLite.to(tgAvatar, 0, {delay:( self.getAtkTimeSkillPoint() + self.getAtkTimeSkillEfftBreak()), onComplete:FightStepB, onCompleteParams:[p, self, tgAvatar, damage, damageLeft, bDie, bCounter, CounterDmg, CounterLeft, bCounterDie, bfirst, bskillAtk, bskillAction], overwrite:0});
					}
				} 
				else  // 没有美术技能表现
				{
					if (bskillAtk)
					{
						// damage == 0 闪避   damage > 0 命中
						TweenLite.to(tgAvatar, 0, {delay:( self.getAtkTimeSkillPoint()), onComplete:FightStepB, onCompleteParams:[p, self, tgAvatar, damage, damageLeft, bDie, bCounter, CounterDmg, CounterLeft, bCounterDie, bfirst, bskillAtk, bskillAction], overwrite:0});
					}
					else 
					{
						// damage == 0 闪避   damage > 0 命中
						TweenLite.to(tgAvatar, 0, {delay:( self.getAtkTimePhyPoint()), onComplete:FightStepB, onCompleteParams:[p, self, tgAvatar, damage, damageLeft, bDie, bCounter, CounterDmg, CounterLeft, bCounterDie, bfirst, bskillAtk, bskillAction], overwrite:0});
					}
				}

				// 攻击过程中的tips数据变化
				self.theFighterInfo.setNowHp(defender.aterleftHp);
				self.theFighterInfo.setNowGauge(defender.aterleftGauge);
				tgAvatar.theFighterInfo.setNowHp(defender.leftHp);
				tgAvatar.theFighterInfo.setNowGauge(defender.leftGauge);
				self.getTipData().playerHp = defender.aterleftHp;
				self.getTipData().playerGauge = defender.aterleftGauge;
				tgAvatar.getTipData().playerHp = defender.leftHp;
				tgAvatar.getTipData().playerGauge = defender.leftGauge;
			}
		}

		// 处理对自己方的效果
		public function FightStepAOurs(self : BTAvatar, p : BtProcess) : void {
			var i : uint = 0;
			var j : uint = 0;
			var effectAvatar : BTAvatar;
			var spellEftid : uint = self.theFighterInfo.getSpellEftId2();
			var needTurnOver : Boolean = false;
			var frontOrback : uint = 0;
			var angle : uint = self.theFighterInfo.getAngleType2();
			var addhp : int = 0;
			var afteraddhp : uint = 0;
			var rescuer : BtRescued;
			if (self.theFighterInfo.getSpellEftId2() > 0 && self.theFighterInfo.getBuffID2() > 0)  // 如果有技能效果动画
			{
				if (p.rescuedList.length == 0)
					return;
				if (self.theFighterInfo.getCanTurnOver2() == 1) // 正面技能需要翻转
				{
					frontOrback = 1;
					if (self.theFighterInfo.side == 1)
						needTurnOver = true;
					else
						needTurnOver = false;
				}
				else 
				{
					frontOrback = self.theFighterInfo.side ? 1 : 0;
					needTurnOver = false;
				}

				if (self.theFighterInfo.getTargetType2() == 1)  // 技能出手方表现
				{
					// 播放法术技能攻击效果
					// 加血
					rescuer = p.rescuedList[0];
					addhp = rescuer.addHp;
					afteraddhp = rescuer.leftHp;
					// ((self.theFighterInfo.getNowHp() + addhp) > self.getInitHP()) ? self.getInitHP(): (self.theFighterInfo.getNowHp() + addhp);

					TweenLite.to(self, self.getAtkTimeSkillPoint(), {onComplete:PlaySkillEffect, onCompleteParams:[self, 1, spellEftid, frontOrback, needTurnOver, angle], overwrite:0});
					if (addhp > 0)
						TweenLite.to(self, self.getAtkTimeSkillPoint(), {onComplete:ShowAddHP, onCompleteParams:[addhp, afteraddhp, self, 1], overwrite:0});

					// 下一层表现buff
					TweenLite.to(self, self.getAtkTimeSkillPoint() + self.getAtkTimeSkillEfftBreak(), {onComplete:FightStepBOurs, onCompleteParams:[p], overwrite:0});
				} 
				else if (self.theFighterInfo.getTargetType2() == 3) // 只能多个目标
				{
					// 播放法术技能攻击效果
					// 支持多人

					for (i = 0; i < p.rescuedList.length; ++i)
					{
						rescuer = p.rescuedList[i];
						trace("攻击时技能效果");
						for ( j = 0 ; j < _fighters.length ; j++)
						{
							if (_fighters[j].theFighterInfo.side == rescuer.side && _fighters[j].theFighterInfo.pos == rescuer.pos)
							{
								effectAvatar = _fighters[j];
								break;
							}
						}

						if (effectAvatar) 
						{
							// 如果是加血，显示加血
							addhp = rescuer.addHp;

							//
							afteraddhp = rescuer.leftHp;

							TweenLite.to(effectAvatar, self.getAtkTimeSkillPoint(), {onComplete:PlaySkillEffect, onCompleteParams:[effectAvatar, 1, spellEftid, frontOrback, needTurnOver, angle], overwrite:0});
							if (addhp != 0)
								TweenLite.to(effectAvatar, self.getAtkTimeSkillPoint(), {onComplete:ShowAddHP, onCompleteParams:[addhp, afteraddhp, effectAvatar, 1], overwrite:0});

							// 下一层表现buff
							if (i == 0) 
							{
								TweenLite.to(self, self.getAtkTimeSkillPoint() + self.getAtkTimeSkillEfftBreak(), {onComplete:FightStepBOurs, onCompleteParams:[p], overwrite:0});
							}
						}
					}
				}
			} 
			else if (self.theFighterInfo.getSpellEftId2() > 0)
			{
				if (p.rescuedList.length == 0)
					return;
				if (self.theFighterInfo.getCanTurnOver2() == 1) // 正面技能需要翻转
				{
					frontOrback = 1;
					if (self.theFighterInfo.side == 1)
						needTurnOver = true;
					else
						needTurnOver = false;
				} 
				else
				{
					frontOrback = self.theFighterInfo.side ? 1 : 0;
					needTurnOver = false;
				}

				if (self.theFighterInfo.getTargetType2() == 1)  // 技能出手方表现
				{
					// 加血
					rescuer = p.rescuedList[0];
					addhp = rescuer.addHp;
					afteraddhp = rescuer.leftHp;

					// 播放法术技能攻击效果
					TweenLite.to(self, self.getAtkTimeSkillPoint(), {onComplete:PlaySkillEffect, onCompleteParams:[self, 1, spellEftid, frontOrback, needTurnOver, angle], overwrite:0});

					if (addhp > 0)
						TweenLite.to(self, self.getAtkTimeSkillPoint(), {onComplete:ShowAddHP, onCompleteParams:[addhp, afteraddhp, self, 1], overwrite:0});

					// 下一层表现buff
					// TweenLite.to(self, self.getAtkTimeSkillPoint() + self.getAtkTimeSkillEfftBreak(), {onComplete:FightStepBOurs, onCompleteParams:[p], overwrite:0});
				}
				else if (self.theFighterInfo.getTargetType2() == 3) // 技能目标方表现
				{
					// 播放法术技能攻击效果
					// 支持多人

					for (i = 0; i < p.rescuedList.length; ++i) 
					{
						rescuer = p.rescuedList[i];
						trace("攻击时技能效果");
						for ( j = 0 ; j < _fighters.length ; j++) 
						{
							if (_fighters[j].theFighterInfo.side == p.rescuedList[i].side && _fighters[j].theFighterInfo.pos == p.rescuedList[i].pos)
							{
								effectAvatar = _fighters[j];
								break;
							}
						}

						if (effectAvatar)
						{
							// 如果是加血，显示加血
							addhp = rescuer.addHp;
							afteraddhp = rescuer.leftHp;

							TweenLite.to(effectAvatar, self.getAtkTimeSkillPoint(), {onComplete:PlaySkillEffect, onCompleteParams:[effectAvatar, 1, spellEftid, frontOrback, needTurnOver, angle], overwrite:0});
							if (addhp != 0)
								TweenLite.to(effectAvatar, self.getAtkTimeSkillPoint(), {onComplete:ShowAddHP, onCompleteParams:[addhp, afteraddhp, effectAvatar, 1], overwrite:0});

							// 下一层表现buff
							if (i == 0)
							{
								// TweenLite.to(self, self.getAtkTimeSkillPoint() + self.getAtkTimeSkillEfftBreak(), {onComplete:FightStepBOurs, onCompleteParams:[p], overwrite:0});
							}
						}
					}
				}
			} 
			else if (self.theFighterInfo.getBuffID2() > 0) // 仅有buff
			{
				if (p.rescuedList.length == 0)
					return;
				TweenLite.to(self, self.getAtkTimeSkillatk(), {onComplete:FightStepBOurs, onCompleteParams:[p], overwrite:0});
			}
		}

		public function FightStepB(p : BtProcess, self : BTAvatar, tgAvatar : BTAvatar, damage : int, damageLeft : uint, bDie : Boolean, bCounter : Boolean = false, CounterDmg : int = 0, CounterLeft : uint = 0, bCounterDie : Boolean = false, bfirst : Boolean = true, bskillAtk : Boolean = false, bskillAction : Boolean = false) : void {
			var i : int;
			var j : int;
			var BaseDelay : Number = 0;
			var passTime : Number = 0;
			var TestTime : Number = 0;
			var backtime : Number = 0.0;

			if (bskillAction) // 有美术技能效果，需加上额外效果暴破时间
			{
				if (bskillAtk) 
				{
					passTime = self.getAtkTimeSkillPoint() + self.getAtkTimeSkillEfftBreak();

					if ( self.theFighterInfo.getGroundSkillID() > 0 && self.theFighterInfo.getGroundSkillID() < 30000 )
					{
						tgAvatar.playGroudEft(self.theFighterInfo.skillId);
					} 
					else
					{
						if (self.theFighterInfo.getTargetType() == 4) // 阵中央上层
						{
							PlaySwfEffect(self.getSide(), self.theFighterInfo.skillId, 0);
						} 
						else if (self.theFighterInfo.getTargetType() == 5) // 阵中央下层
						{
							PlaySwfEffect(self.getSide(), self.theFighterInfo.skillId, 1);
						}
						else if (self.theFighterInfo.getTargetType() == 6) // 首要目标上层
						{
							PlaySwfEffect(self.getSide(), self.theFighterInfo.skillId, 0, tgAvatar);
						}
						else if (self.theFighterInfo.getTargetType() == 7) // 首要目标下层
						{
							PlaySwfEffect(self.getSide(), self.theFighterInfo.skillId, 1, tgAvatar);
						}
					}
				}
			} 
			else
			{
				if (bskillAtk)
				{
					if ( self.theFighterInfo.getGroundSkillID() > 0 && self.theFighterInfo.getGroundSkillID() < 30000 ) 
					{
						tgAvatar.playGroudEft(self.theFighterInfo.skillId);
					} 
					else
					{
						if (self.theFighterInfo.getTargetType() == 4) // 阵中央上层
						{
							PlaySwfEffect(self.getSide(), self.theFighterInfo.skillId, 0);
						}
						else if (self.theFighterInfo.getTargetType() == 5) // 阵中央下层
						{
							PlaySwfEffect(self.getSide(), self.theFighterInfo.skillId, 1);
						}
						else if (self.theFighterInfo.getTargetType() == 6) // 首要目标上层
						{
							PlaySwfEffect(self.getSide(), self.theFighterInfo.skillId, 0, tgAvatar);
						} 
						else if (self.theFighterInfo.getTargetType() == 7) // 首要目标下层
						{
							PlaySwfEffect(self.getSide(), self.theFighterInfo.skillId, 1, tgAvatar);
						}
					}
					passTime = self.getAtkTimeSkillPoint();
				} 
				else 
				{
					passTime = self.getAtkTimePhyPoint();
				}
			}

			// 归位时间(站立，移动两种，时间不同)
			if (damage == -1) 
			{
				if (p.SChangeList.length > 1)
				{
					// trace("pause");
				}
				// 闪避等文字
				setTimeout(ShowEffect, 0, BTSystem.ID_Shanbi, tgAvatar);
				if (p.oneAtkInfo.atkerSide == 0)
				{
					TweenLite.to(tgAvatar, 0.2, {x:tgAvatar.pos.x - 30, y:tgAvatar.pos.y - 30, overwrite:0});
					TweenLite.to(tgAvatar, 0.2, {delay:0.2, x:tgAvatar.pos.x, y:tgAvatar.pos.y, overwrite:0});
				}
				else
				{
					TweenLite.to(tgAvatar, 0.2, {x:tgAvatar.pos.x + 30, y:tgAvatar.pos.y + 30, overwrite:0});
					TweenLite.to(tgAvatar, 0.2, {delay:0.2, x:tgAvatar.pos.x, y:tgAvatar.pos.y, overwrite:0});
				}
				BaseDelay += 0.4;
			} 
			else 
			{
				// 被攻击方中暴击等效果
				if (p.oneAtkInfo.atkerSide == 0)
					ShowEffectTo(p.oneAtkInfo.effectType, tgAvatar);
				else
					ShowEffectTo(p.oneAtkInfo.effectType, tgAvatar, 0, 1);

				if (p.oneAtkInfo.effectType < 1000)
				{
					// 普通被击打效果
					if (p.oneAtkInfo.atkerSide == 0)
						ShowEffectTo(ID_PhyAtk, tgAvatar);
					else
						ShowEffectTo(ID_PhyAtk, tgAvatar, 0, 1);
				}

				// 暴击等文字
				if (bfirst) 
				{
					ShowEffect(p.oneAtkInfo.effectType, self);
				}

				// 伤血等文字
				ShowHarm(-Math.abs(damage), tgAvatar);

				// 血条减少
				var hpPercent : int = 0;
				hpPercent = Number(damageLeft) / Number(tgAvatar.getInitHP()) * 100;
				if (hpPercent == 0 && damageLeft != 0)
					hpPercent = 1;
				tgAvatar.showHPBar(hpPercent);

				// 受挫动作
				tgAvatar.setAction(AvatarManager.HURT);

				// 如果被攻击者死亡
				if (bDie) 
				{
					TweenLite.to(tgAvatar, 0, {delay:tgAvatar.getAtkTimeTrad(), onComplete:ShowAction, onCompleteParams:[tgAvatar, AvatarManager.DIE], overwrite:0});
				}

				BaseDelay += tgAvatar.getAtkTimeTrad();
			}

			// 伤血文字排序
			bloodSpriteSortXY();

			// 判断攻击时buffer相关效果,只需播放一次

			if (bfirst)
			{
				for (i = 0; i < p.SChangeList.length; ++i)
				{
					if (p.SChangeList[i].atkorBackatk == 0)
					{
						// trace("攻击时技能效果");
						for ( j = 0 ; j < _fighters.length ; j++)
						{
							if (_fighters[j].theFighterInfo.side == p.SChangeList[i].toside && _fighters[j].theFighterInfo.pos == p.SChangeList[i].tpos)
							{
								var effectAvatar : BTAvatar = _fighters[j];
								break;
							}
						}

						if (p.SChangeList[i].letDie != 2)
						{
							// 显示buffer效果
							if (!effectAvatar) continue;
							// buff延时消失 TweenLite.to(effectAvatar, 0, {delay:effectAvatar.getAtkTimeTrad(), onComplete:PlaySkillBuff, onCompleteParams:[effectAvatar, p.SChangeList[i].skillType, p.SChangeList[i].type], overwrite:0});
							// buff立马消失
							if (p.SChangeList[i].skillid == skillType.GAUGEFULL && p.SChangeList[i].type == 0)
							{
								effectAvatar.playSkillBuff(p.SChangeList[i].skillid, p.SChangeList[i].type, p.SChangeList[i].skillab);
							}
							else
								effectAvatar.playSkillBuff(p.SChangeList[i].skillid, p.SChangeList[i].type, p.SChangeList[i].skillab);

							// 这个地方有问题。。。
							effectAvatar.playUpDownWords(p.SChangeList[i].skillid, p.SChangeList[i].type, p.SChangeList[i].skillab);

							if (p.SChangeList[i].data > 0) 
							{
								// 显示加血
								ShowHarm(p.SChangeList[i].data, effectAvatar);

								// 加血
								effectAvatar.theFighterInfo.setNowHp(effectAvatar.theFighterInfo.getNowHp() + p.SChangeList[i].data);
								//								//  血条增加
								effectAvatar.showHPBar(Number(effectAvatar.theFighterInfo.getNowHp()) / Number(effectAvatar.getInitHP()) * 100);

								// 攻击过程中的tips数据变化
								effectAvatar.theFighterInfo.setNowHp(effectAvatar.theFighterInfo.getNowHp());
								effectAvatar.getTipData().playerHp = effectAvatar.theFighterInfo.getNowHp();
							} 
							else if (p.SChangeList[i].data < 0) 
							{
								// 应该显示中毒伤血
								TweenLite.to(effectAvatar, 0, {delay:0.2, onComplete:ShowPoisonHarm, onCompleteParams:[p.SChangeList[i].data, effectAvatar, 1], overwrite:0});
							}
						}
					}
				}
			}

			// 是首要目标
			if (bfirst) 
			{
				// 如果被攻击者反击
				if (bCounter) 
				{
					// 反击动作
					TweenLite.to(tgAvatar, 0, {delay:tgAvatar.getAtkTimeTrad(), onComplete:ShowAction, onCompleteParams:[tgAvatar, AvatarManager.ATTACK], overwrite:0});
					// 显示反击动画
					// TweenLite.to(tgAvatar, 0, {delay:tgAvatar.getAtkTimeTrad() + self.getAtkTimePhyPoint(), onComplete:ShowEffect, onCompleteParams:[ID_Counter, tgAvatar], overwrite:0});
					// 进入下层动作判断
					TweenLite.to(tgAvatar, 0, {delay:(tgAvatar.getAtkTimeTrad() + tgAvatar.getAtkTimePhyPoint()), onComplete:FightStepC, onCompleteParams:[p, tgAvatar, self, CounterDmg, CounterLeft, bCounterDie], overwrite:0});
				} 
				else // 攻击者归位
				{
					if (bskillAtk)  // 在技能攻击中
					{
						if (self.theFighterInfo.getAtkMoveType() == 0 || self.theFighterInfo.getAtkMoveType() == 1)
						{
							backtime = self.getAtkTimeStand();
						} 
						else
						{
							backtime = self.getAtkTimeback();
						}

						// //  trace("self.getAtkTimeSkillEfft()" + self.getAtkTimeSkillEfft());
						// //  trace("self.getAtkTimeSkillBreak()" + self.getAtkTimeSkillBreak());
						TweenLite.to(self, backtime, {delay:self.getAtkTimeSkillatk() - passTime, x:self.pos.x, y:self.pos.y, overwrite:0});

						// for test
						TweenLite.to(self, 0, {delay:self.getAtkTimeSkillatk() - passTime, onComplete:ShowAction, onCompleteParams:[self, AvatarManager.BT_STAND], overwrite:0});
						// 攻击者归位排序
						TweenLite.to(self, 0, {delay:self.getAtkTimeSkillatk() - passTime + backtime, onComplete:fightersSortXY, onCompleteParams:[], overwrite:0});

						BaseDelay += backtime + self.getAtkTimeSkillatk() - passTime;
						// 血条和名字
						TweenLite.to(self, 0, {delay:self.getAtkTimeSkillatk() - passTime + backtime, onComplete:ShowNameAndHPBar, onCompleteParams:[self, true], overwrite:0});

						TestTime = BASEDELYTIME + self.getAtkTimeSkillatk() - passTime + backtime;
					}
					else   // 物理攻击时
					{
						if (self.theFighterInfo.getAtkMoveType() == 0 || self.theFighterInfo.getAtkMoveType() == 2) {
							backtime = self.getAtkTimeStand();
						} 
						else
						{
							backtime = self.getAtkTimeback();
						}

						TweenLite.to(self, backtime, {delay:self.getAtkTimePhyatk() - passTime, x:self.pos.x, y:self.pos.y, overwrite:0});
						// 攻击者归位排序
						TweenLite.to(self, 0, {delay:self.getAtkTimePhyatk() - passTime + backtime, onComplete:fightersSortXY, onCompleteParams:[], overwrite:0});

						BaseDelay += backtime + self.getAtkTimePhyatk() - passTime;
						// 血条和名字
						TweenLite.to(self, 0, {delay:self.getAtkTimePhyatk() - passTime + backtime, onComplete:ShowNameAndHPBar, onCompleteParams:[self, true], overwrite:0});

						TestTime = BASEDELYTIME + self.getAtkTimePhyatk() - passTime + backtime;
					}

					// if(bskillAction) // 有美术技能效果，等技能效果播放完了，继续下个回合
					{
						if (bskillAtk)
						{
							// 大于受挫时间
							var waittime : Number = 0;
							var skill1waittime : Number = 0;
							// 效果1时间
							var skill2waittime : Number = 0;
							// 地面效果时间
							var skill3waittime : Number = 0;
							// 给己方加的效果时间
							if (self.theFighterInfo.getSpellEftId() > 0 )
								skill1waittime = (self.getAtkTimeSkillEfft() - self.getAtkTimeSkillEfftBreak());
							if (self.theFighterInfo.getGroundSkillID() > 0)
								skill2waittime = self.getAtkTimeGroundEfft();
							if (self.theFighterInfo.getSpellEftId2() > 0)
								skill3waittime = (self.getAtkTimeSkillEfft2() - self.getAtkTimeSkillEfftBreak());

							waittime = (skill1waittime >= skill2waittime) ? skill1waittime : skill2waittime;
							waittime = (waittime >= skill3waittime) ? waittime : skill3waittime;

							if (waittime > TestTime)
								TestTime = waittime + 0.5;
							// - tgAvatar.getAtkTimeTrad();
						}
					}

					// 进入下一次攻击
					// setTimeout(Fight_func, BaseDelay*1000-400,BtProcess.data.shift());
					setTimeout(Fight_func, TestTime * 1000, BtProcess.data.shift());
				}
			}
		}

		// 处理己方效果以及buff
		public function FightStepBOurs(p : BtProcess) : void 
		{
			var i : int = 0;
			var j : int = 0;
			var effectAvatar : BTAvatar;
			for (i = 0; i < p.rescuedList.length; ++i) 
			{
				for ( j = 0 ; j < _fighters.length ; j++) 
				{
					if (_fighters[j].theFighterInfo.side == p.rescuedList[i].side && _fighters[j].theFighterInfo.pos == p.rescuedList[i].pos)
					{
						effectAvatar = _fighters[j];
						break;
					}
				}
				if (effectAvatar)
					effectAvatar.playSkillBuff2(p.SChangeList[i].skillid, p.SChangeList[i].type);
			}
		}

		// 处理反击
		public function FightStepC(p : BtProcess, tgAvatar : BTAvatar, self : BTAvatar, damage : int, damageLeft : uint, bDie : Boolean) : void 
		{
			var BaseDelay : Number = 0;
			var backtime : Number = 0.0;

			var TestTime : Number = 0;

			// 反击动画
			ShowEffect(BTSystem.ID_Counter, tgAvatar);

			// 归位时间(站立，移动两种，时间不同)

			if (self.theFighterInfo.getAtkMoveType() == 0 || self.theFighterInfo.getAtkMoveType() == 2) {
				backtime = self.getAtkTimeStand();
			} 
			else
			{
				backtime = self.getAtkTimeback();
			}
			// 反击闪避
			if (damage == -1) 
			{
				// 闪避等文字
				setTimeout(ShowEffect, 0, BTSystem.ID_Shanbi, self);

				// 如果是远程
				if (self.theFighterInfo.getAtkMoveType() == 0 || self.theFighterInfo.getAtkMoveType() == 2) // 攻击不需要移动
				{
					if (p.oneAtkInfo.atkerSide == 0)
					{
						TweenLite.to(self, 0.3, {x:self.pos.x + 30, y:self.pos.y + 30, overwrite:0});
						// TweenLite.to(self,0.3,{delay:0.2,x:tgAvatar.pos.x+70, y:tgAvatar.pos.y+40,overwrite:0});
					} 
					else 
					{
						TweenLite.to(self, 0.3, {x:self.pos.x - 30, y:self.pos.y - 30, overwrite:0});
						// TweenLite.to(self,0.3,{delay:0.2,x:tgAvatar.pos.x-70, y:tgAvatar.pos.y-40,overwrite:0});
					}
				}
				else // 如果是近战
				{
					if (p.oneAtkInfo.atkerSide == 0)
					{
						TweenLite.to(self, 0.3, {x:tgAvatar.pos.x + 70 + 30, y:tgAvatar.pos.y + 35 + 30, overwrite:0});
						// TweenLite.to(self,0.3,{delay:0.2,x:tgAvatar.pos.x+70, y:tgAvatar.pos.y+40,overwrite:0});
					} 
					else
					{
						TweenLite.to(self, 0.3, {x:tgAvatar.pos.x - 70 - 30, y:tgAvatar.pos.y - 35 - 30, overwrite:0});
						// TweenLite.to(self,0.3,{delay:0.2,x:tgAvatar.pos.x-70, y:tgAvatar.pos.y-40,overwrite:0});
					}
				}

				// 攻击者归位
				TweenLite.to(self, backtime, {delay:(0.3 + 0.2), x:self.pos.x, y:self.pos.y, overwrite:0});
				// 攻击者归位排序
				TweenLite.to(self, 0, {delay:(0.3 + 0.2) + backtime, onComplete:fightersSortXY, onCompleteParams:[], overwrite:0});

				// 血条和名字
				TweenLite.to(self, 0, {delay:(0.3 + 0.2) + backtime, onComplete:ShowNameAndHPBar, onCompleteParams:[self, true], overwrite:0});

				BaseDelay += 0.5 + backtime;

				// 如果被反击者死亡
				if (bDie) 
				{
					// 归位后死亡
					TweenLite.to(self, 0, {delay:0.5 + backtime + 0.2, onComplete:ShowAction, onCompleteParams:[self, AvatarManager.DIE], overwrite:0});
					BaseDelay += 0.2;
				}

				TestTime = BASEDELYTIME + (0.3 + 0.2) + backtime;
				// 进入下一次攻击
				// setTimeout(Fight_func,BaseDelay*1000+1+500,BtProcess.data.shift());
				setTimeout(Fight_func, TestTime * 1000, BtProcess.data.shift());
			} 
			else
			{
				// 伤血等文字
				ShowHarm(-Math.abs(damage), self);

				// 受挫动作
				self.setAction(AvatarManager.HURT);

				// 血条减少
				var hpPercent : int = 0;
				hpPercent = Number(damageLeft) / Number(self.getInitHP()) * 100;
				if (hpPercent == 0 && damageLeft != 0)
					hpPercent = 1;
				self.showHPBar(hpPercent);

				// 普通被击打效果
				if (p.oneAtkInfo.atkerSide == 0)
					ShowEffectTo(ID_PhyAtk, self);
				else
					ShowEffectTo(ID_PhyAtk, self, 0, 1);

				// 攻击者归位
				TweenLite.to(self, backtime, {delay:(0.1 + self.getAtkTimeTrad()), x:self.pos.x, y:self.pos.y, overwrite:0});

				// 攻击者归位排序
				TweenLite.to(self, 0, {delay:((0.1 + self.getAtkTimeTrad()) + self.getAtkTimeback()), onComplete:fightersSortXY, onCompleteParams:[], overwrite:0});

				// 血条和名字
				TweenLite.to(self, 0, {delay:(0.1 + self.getAtkTimeTrad()) + backtime, onComplete:ShowNameAndHPBar, onCompleteParams:[self, true], overwrite:0});

				BaseDelay += 0.1 + self.getAtkTimeTrad() + backtime;
				// 如果被反击者死亡
				if (bDie)
				{
					TweenLite.to(self, 0, {delay:(0.1 + self.getAtkTimeTrad() + backtime + 0.1), onComplete:ShowAction, onCompleteParams:[self, AvatarManager.DIE], overwrite:0});
					BaseDelay += 0.2;
				}

				// 进入下一次攻击
				// setTimeout(Fight_func,BaseDelay*1000+1+400,BtProcess.data.shift());

				TestTime = BASEDELYTIME + (0.1 + self.getAtkTimeTrad()) + self.getAtkTimeback();
				setTimeout(Fight_func, TestTime * 1000, BtProcess.data.shift());
			}
		}

		public function BTSystem() : void
		{
		}

		public static function INSTANCE() : BTSystem
		{
			if (_instance == null)
			{
				_instance = new BTSystem();
			}
			return _instance;
		}
		
		
		public function battleDebug(str:String):void
		{
			Logger.debug("所有对象容器[_container]子对象个数：" + _container.numChildren);
			//sprite对象
			Logger.debug("战斗层[_battleSprite]对象个数：" + _battleSprite.numChildren);
			Logger.debug("swf上层[_swfSpriteUp]对象个数：" + _swfSpriteUp.numChildren);		
			Logger.debug("swf下层[_swfSpriteDown]对象个数：" + _swfSpriteDown.numChildren);
			Logger.debug("伤血层[_bloodSprite]对象个数：" + _bloodSprite.numChildren);
			Logger.debug("黑色遮罩层[_bloodSprite]对象个数：" + _bloodSprite.numChildren);	
			//Compnent对象
			Logger.debug("战斗结束面板[_btResult:GComponent]对象个数：" + _btResult.numChildren);
			Logger.debug("用户头像面板[userpanel:GComponent]对象个数：" + userpanel.numChildren);	
			Logger.debug("敌人头像面板[enemypanel:GComponent]对象个数：" + enemypanel.numChildren);	
			//数组对象
			Logger.debug("战斗对象列表[_fighters(Array)]长度：" + _fighters.length);
			Logger.debug("战斗BUFF数据[BtBuffData:(vector)]对象个数：" + BtBuffData.length);
			Logger.debug("战斗回合数据[BtData:(vector)]对象个数：" + BtData.length);
			Logger.debug("战斗初始化数据 位置血量等[BtInitData:(vector)]对象个数：" + BtInitData.length);
			Logger.debug("资源对象[RESOURCES(Array)]长度：" + RESOURCES.length);	
			Logger.debug("战斗奖励列表[rewardlist(Array)]长度：" + rewardlist.length);	
							
			//BitMap对象
			if(upGrid)
			Logger.debug("upGrid(bitmap)存在宽 高："+upGrid.bitmapData.width+upGrid.bitmapData.height);
			if(downGrid)
			Logger.debug("downGrid(bitmap)存在宽 高："+downGrid.bitmapData.width+upGrid.bitmapData.height);	
			if(BackGroundPic)	
			Logger.debug("战斗背景BackGroundPic(bitmap)宽 高："+BackGroundPic.bitmapData.width+BackGroundPic.bitmapData.height);	
			
		}
		
	}
}