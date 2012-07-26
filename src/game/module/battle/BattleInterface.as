package game.module.battle {
	import game.manager.VersionManager;
	import game.config.StaticConfig;
	import game.core.avatar.AvatarManager;
	import game.core.avatar.AvatarType;
	import game.core.hero.HeroManager;
	import game.core.hero.VoHero;
	import game.core.item.sutra.sutraSkill.SutraManager;
	import game.core.user.StateManager;
	import game.core.user.StateType;
	import game.core.user.UserData;
	import game.manager.MouseManager;
	import game.manager.RSSManager;
	import game.manager.SignalBusManager;
	import game.module.battle.battleData.Area;
	import game.module.battle.battleData.AttackData;
	import game.module.battle.battleData.BtProcess;
	import game.module.battle.battleData.FighterInfo;
	import game.module.battle.battleData.PropInfo2Base;
	import game.module.battle.battleData.mapData;
	import game.module.battle.battleData.skillData;
	import game.module.battle.battleData.skillType;
	import game.module.battle.view.BTSystem;
	import game.module.quest.VoMonster;
	import game.net.core.Common;
	import game.net.data.StoC.SCBattleInfo;

	import gameui.manager.UIManager;
	import gameui.skin.ASSkin;

	import log4a.Logger;

	import net.AssetData;
	import net.BDSWFLoader;
	import net.LibData;
	import net.RESManager;
	import net.SWFLoader;

	import utils.DictionaryUtil;

	import worlds.apis.MLand;
	import worlds.apis.MLoading;
	import worlds.apis.MWorld;
	import worlds.apis.MapUtil;

	import com.commUI.CommonLoading;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;

	/**
	 * @author yangyiqiang
	 */
	public class BattleInterface {
		private var _load_lm : CommonLoading;

		public function BattleInterface() : void {
			_res = RESManager.instance;
			Common.game_server.addCallback(0x66, OnReceiveBattleMsg);
			SignalBusManager.battleReady.add(addMode);
			SignalBusManager.battleOver.add(removeMode);
		}

		private var playerA : Player;
		private var playerB : Player;
		private var arr1 : Vector.<FighterInfo>;
		private	var arr2 : Vector.<FighterInfo>;
		public static var  DEBUG_RETURN_BATTLE : Boolean = false;
		private var _rotateEffects : MovieClip;
		public var _battleMode : Sprite;
		private static var modalSkin : Sprite = ASSkin.emptySkin;

		public static function addMode() : Sprite {
			if (!modalSkin)
				modalSkin = ASSkin.emptySkin;
			modalSkin.width = UIManager.stage.stageWidth;
			modalSkin.height = UIManager.stage.stageHeight;
			if (!UIManager.root.contains(modalSkin))
				UIManager.root.addChild(modalSkin);
			MouseManager.cursor = MouseManager.ARROW;
			return modalSkin;
		}

		public static function removeMode() : Sprite {
			if (modalSkin && modalSkin.parent)
				UIManager.root.removeChild(modalSkin);
			return modalSkin;
		}

		public static var lastBattleInfo : SCBattleInfo;

		private function OnReceiveBattleMsg(msg : SCBattleInfo) : void {
			trace(BTSystem.INSTANCE().GetPlayModle());

//			if (DEBUG_RETURN_BATTLE)
//				return;

			if (BTSystem.INSTANCE().GetPlayModle() == 0)  // 正常战斗
			{
				if (MWorld.isInstallComplete)  // 地图没有加载好
				{
					if (BTSystem.INSTANCE().isInBattle)
					{
						// 清理上一战斗的数据
						BTSystem.INSTANCE().setNormalOrSpecialPlay(false);
						BTSystem.INSTANCE().clearLastBattle();
					} 
					else 
					{
						BTSystem.INSTANCE().setNormalOrSpecialPlay(false);
						BTSystem.INSTANCE().clearLastBattle();
					}
					startBattle(msg);
				}
				else  // 加载地图监听
				{
					battleInfoMsg = msg;
					MWorld.sInstallComplete.add(mapInstallComplete);
				}
			}
			else  // 录像
			{
				startBattle(msg);
			}
		}

		// 地图加载ok
		private var battleInfoMsg : SCBattleInfo;

		private function mapInstallComplete() : void 
		{
			MWorld.sInstallComplete.remove(mapInstallComplete);
			startBattle(battleInfoMsg);
			battleInfoMsg = null;
		}

		/** 战斗开始 **/
		private function startBattle(msg : SCBattleInfo) : void 
		{
			_wait = new Dictionary();
			_loaded = false;
			var i : int;
			var ispvp : Boolean = false;
			var isChangeSide : Boolean = false;
			var playerRoleId : int;
			var playerRoleName : String = "";
			var playerLevel : int;
			var playerColor : uint;
			var enemyRoleId : int;
			var enemyLevel : int;
			var enemyRoleName : String = "";
			var enemyColor : uint;
			StateManager.instance.changeState(StateType.BATTLE);
			BTSystem.INSTANCE().isInBattle = true;
			_load_lm = Common.getInstance().loadPanel;
			// _load_lm.model = _res.model;
			ForRand.setRandSeed(msg.randomseed);
			SignalBusManager.battleReady.dispatch();
			// 战斗ready
			BTSystem.INSTANCE().mySide = msg.myside;
			if (msg.hasPlayeraid)
			{
				if (UserData.instance.playerId == msg.playeraid)
				{
					BTSystem.INSTANCE().mySide = 0;

					// 设置神器
					if (msg.hasArtifactslvl)
					{
						BTSystem.INSTANCE().setPlayerArtifactLvl(msg.artifactslvl >> 16 & 0xFFFF);
						BTSystem.INSTANCE().setEnemyArtifactLvl(msg.artifactslvl & 0xFFFF);
					}
					else
					{
						BTSystem.INSTANCE().setPlayerArtifactLvl(0);
						BTSystem.INSTANCE().setEnemyArtifactLvl(0);
					}
				}
			}

			if (msg.hasPlayerbid) 
			{
				if (UserData.instance.playerId == msg.playerbid) 
				{
					BTSystem.INSTANCE().mySide = 1;
					isChangeSide = true;
					// 实际换边
					if (msg.hasArtifactslvl) 
					{
						// 设置神器
						BTSystem.INSTANCE().setEnemyArtifactLvl(msg.artifactslvl >> 16 & 0xFFFF);
						BTSystem.INSTANCE().setPlayerArtifactLvl(msg.artifactslvl & 0xFFFF);
					}
					else
					{
						BTSystem.INSTANCE().setPlayerArtifactLvl(0);
						BTSystem.INSTANCE().setEnemyArtifactLvl(0);
					}
				}

				ispvp = true;
			}

			BTSystem.INSTANCE().setFightType(msg.overtype);
			BTSystem.INSTANCE().setEarnExp(msg.exp);
			var rewardlist : Array = [];
			for (i = 0; i < msg.itemlist.length; i++) 
			{
				rewardlist.push(msg.itemlist[i]);
			}
			BTSystem.INSTANCE().setRewardList(rewardlist);

			var max : int = msg.vecpropertyb.length;
			arr1 = new Vector.<FighterInfo>();
			arr2 = new Vector.<FighterInfo>();
			for (i = 0; i < max;i++) 
			{
				var info : FighterInfo = new FighterInfo();
				info.pInfo2 = new PropInfo2Base().clonePropertyB(msg.vecpropertyb[i]);
				info.initHp = info.pInfo2.health;
				info.maxHp = info.pInfo2.maxhp;
				info.setMaxGauge(info.pInfo2.gaugeMax);
				info.setGaugeUse(info.pInfo2.gaugeUse);
				info.id = msg.vecpropertyb[i].id;
				info.fID = info.pInfo2.formationid;
				// 阵型id
				info.name = info.id < 10 ? msg.vecpropertyb[i].fname : "";
				info.job = msg.vecpropertyb[i].job;
				info.ftype = msg.vecpropertyb[i].ftype;
				info.weaponId = msg.vecpropertyb[i].weaponid;
				info.skillId = msg.vecpropertyb[i].skillid;
				info.side = msg.vecpropertyb[i].side;

				info.pos = msg.vecpropertyb[i].pos;
				info.setLevel(msg.vecpropertyb[i].level);
				info.setCloth((msg.vecpropertyb[i].color >> 4) & 0xF);
				info.setColor((msg.vecpropertyb[i].color) & 0xF);
				// /Logger.debug("info.side="+info.side,"info.pos====>"+info.pos);
				(info.side == 0) ? arr1.push(info) : arr2.push(info);

				// 换边
				if (BTSystem.INSTANCE().mySide == 1) 
				{
					// if (info.side == 0) {
					// info.side = 1;
					// } else if (info.side == 1) {
					// info.side = 0;
					// }
					info.resetKey((info.side == 1) ? 0 : 1);
				}
				else 
				{
					info.resetKey();
				}

				if (ispvp) 
				{
					if (BTSystem.INSTANCE().mySide == 1) 
					{
						if (info.side == 1 && info.id <= 6) 
						{
							playerRoleId = info.id;
							playerRoleName = info.name;
							playerLevel = info.getLevel();
							playerColor = info.getColor();
						} 
						else if (info.side == 0 && info.id <= 6)
						{
							enemyRoleId = info.id;
							enemyRoleName = info.name;
							enemyLevel = info.getLevel();
							enemyColor = info.getColor();
						}
					}
					else 
					{
						if (info.side == 0 && info.id <= 6)
						{
							playerRoleId = info.id;
							playerRoleName = info.name;
							playerLevel = info.getLevel();
							playerColor = info.getColor();
						} 
						else if (info.side == 1 && info.id <= 6)
						{
							enemyRoleId = info.id;
							enemyRoleName = info.name;
							enemyLevel = info.getLevel();
							enemyColor = info.getColor();
						}
					}
				}
				else
				{
					if (info.side == 0 && info.id <= 6) 
					{
						playerRoleId = info.id;
						playerRoleName = info.name;
						playerLevel = info.getLevel();
						playerColor = info.getColor();
					} 
					else 
					{
						enemyRoleId = info.id;
						// monster role id
						enemyRoleName = info.name;
						enemyLevel = info.getLevel();
						enemyColor = info.getColor();
					}
				}
				_wait[info.getAvatarUrl()] = info.key;
				_res.add(new SWFLoader(new LibData(info.getAvatarUrl(), info.getAvatarUrl(), true, false), AvatarManager.instance.getAvatarBD(info.key).parse, [info.getAvatarUrl(), 1, updateParse, [info.getAvatarUrl()]]));
				BTSystem.INSTANCE().RESOURCES.push(info.getAvatarUrl());
				if (info.skillId > 0) 
				{
					var skillUUID : int;
					var url : String;
					var frontOrback : uint = info.side ? 0 : 1;
					if (BTSystem.INSTANCE().mySide == 1)
					{
						frontOrback = frontOrback ? 0 : 1;
					}

					var pskilldata : skillData = AttackData.skilllist[info.skillId];
					if (pskilldata == null) continue;
					var atkarea : Area = AttackData.arealist[pskilldata.atkID];
					if (atkarea == null) continue;

					// 加载技能动画1
					// trace(pskilldata.getSpellEftId());
					if (pskilldata.getSpellEftId() > 0) // 需要加载技能动画
					{
						if (pskilldata.getCanTurnOver() == 0 || pskilldata.getCanTurnOver() == 1 )
						{
							skillUUID = AvatarManager.instance.getUUId(info.getSpellEftId(), AvatarType.SKILL_TYPE_SPELL, 1);
							url = StaticConfig.cdnRoot + "assets/avatar/" + skillUUID + ".swf";
							_wait[url] = skillUUID;
							_res.add(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(skillUUID).parse, [url, 2, updateParse, [url]]));
							BTSystem.INSTANCE().RESOURCES.push(url);
						} 
						else if (pskilldata.getCanTurnOver() == 2) 
						{
							skillUUID = AvatarManager.instance.getUUId(info.getSpellEftId(), AvatarType.SKILL_TYPE_SPELL, frontOrback);
							url = StaticConfig.cdnRoot + "assets/avatar/" + skillUUID + ".swf";
							_wait[url] = skillUUID;
							_res.add(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(skillUUID).parse, [url, 2, updateParse, [url]]));
							BTSystem.INSTANCE().RESOURCES.push(url);
						}
					}

					// 需要加载地面效果
					if (pskilldata.getGroundSkillID() > 0) {
						if (pskilldata.getGroundCanTurnOver() == 0 || pskilldata.getGroundCanTurnOver() == 1) {
							skillUUID = AvatarManager.instance.getUUId(pskilldata.getGroundSkillID(), AvatarType.SKILL_TYPE_GROUND, 1);
							url = StaticConfig.cdnRoot + "assets/avatar/" + skillUUID + ".swf";
							_wait[url] = skillUUID;
							_res.add(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(skillUUID).parse, [url, 2, updateParse, [url]]));
							BTSystem.INSTANCE().RESOURCES.push(url);
						} else if (pskilldata.getGroundCanTurnOver() == 2) {
							skillUUID = AvatarManager.instance.getUUId(pskilldata.getGroundSkillID(), AvatarType.SKILL_TYPE_GROUND, frontOrback);
							url = StaticConfig.cdnRoot + "assets/avatar/" + skillUUID + ".swf";
							_wait[url] = skillUUID;
							_res.add(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(skillUUID).parse, [url, 2, updateParse, [url]]));
							BTSystem.INSTANCE().RESOURCES.push(url);
						}
					}

					// ,,,,
					// 加载技能动画2
					if (pskilldata.getSpellEftId2() > 0) // 需要加载技能动画
					{
						if (pskilldata.getCanTurnOver2() == 1)  // 可以翻转
						{
							skillUUID = AvatarManager.instance.getUUId(info.getSpellEftId2(), AvatarType.SKILL_TYPE_SPELL, 1);
							url = StaticConfig.cdnRoot + "assets/avatar/" + skillUUID + ".swf";
							_wait[url] = skillUUID;
							_res.add(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(skillUUID).parse, [url, 2, updateParse, [url]]));
							BTSystem.INSTANCE().RESOURCES.push(url);
						} else if (pskilldata.getCanTurnOver2() == 2) {
							skillUUID = AvatarManager.instance.getUUId(info.getSpellEftId2(), AvatarType.SKILL_TYPE_SPELL, 1 - frontOrback);
							// 因为是给己方的效果
							url = StaticConfig.cdnRoot + "assets/avatar/" + skillUUID + ".swf";
							_wait[url] = skillUUID;
							_res.add(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(skillUUID).parse, [url, 2, updateParse, [url]]));
							BTSystem.INSTANCE().RESOURCES.push(url);
						}
					}

					// 需要加载地面效果
					if (pskilldata.getGroundSkillID2() > 0) {
						skillUUID = AvatarManager.instance.getUUId(pskilldata.getGroundSkillID2(), AvatarType.SKILL_TYPE_GROUND, 1);
						url = StaticConfig.cdnRoot + "assets/avatar/" + skillUUID + ".swf";
						_wait[url] = skillUUID;
						_res.add(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(skillUUID).parse, [url, 2, updateParse, [url]]));
						BTSystem.INSTANCE().RESOURCES.push(url);
					}

					// 加载技能1 buff
					if (pskilldata.getBuffID() > 0)  // 需要加载buff
					{
						// skilltype = atkarea.getType();
						skillUUID = AvatarManager.instance.getUUId(pskilldata.getBuffID(), AvatarType.BUFF_TYPE);
						url = StaticConfig.cdnRoot + "assets/avatar/" + skillUUID + ".swf";
						_wait[url] = skillUUID;
						_res.add(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(skillUUID).parse, [url, 2, updateParse, [url]]));
						BTSystem.INSTANCE().RESOURCES.push(url);
					}
					// 加载技能2 buff
					if (pskilldata.getBuffPlusID() > 0) {
						// skilltype = atkarea.getType();
						skillUUID = AvatarManager.instance.getUUId(pskilldata.getBuffPlusID(), AvatarType.BUFF_TYPE);
						url = StaticConfig.cdnRoot + "assets/avatar/" + skillUUID + ".swf";
						_wait[url] = skillUUID;
						_res.add(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(skillUUID).parse, [url, 2, updateParse, [url]]));
						BTSystem.INSTANCE().RESOURCES.push(url);
					}

					// 加载buff2
					if (pskilldata.getBuffID2() > 0)  // 需要加载buff
					{
						// skilltype = atkarea.getType();
						skillUUID = AvatarManager.instance.getUUId(pskilldata.getBuffID2(), AvatarType.BUFF_TYPE);
						url = StaticConfig.cdnRoot + "assets/avatar/" + skillUUID + ".swf";
						_wait[url] = skillUUID;
						_res.add(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(skillUUID).parse, [url, 2, updateParse, [url]]));
						BTSystem.INSTANCE().RESOURCES.push(url);
					}

					if (0 == i)  // 单独加载聚气
					{
						skillUUID = AvatarManager.instance.getUUId(skillType.GAUGEFULL, AvatarType.BUFF_TYPE);
						url = StaticConfig.cdnRoot + "assets/avatar/" + skillUUID + ".swf";
						_wait[url] = skillUUID;
						_res.add(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(skillUUID).parse, [url, 2, updateParse, [url]]));
						BTSystem.INSTANCE().RESOURCES.push(url);

//						skillUUID = AvatarManager.instance.getUUId(skillType.GAUGEFULL + 1, AvatarType.BUFF_TYPE);
//						url = StaticConfig.cdnRoot + "assets/avatar/" + skillUUID + ".swf";
//						_wait[url] = skillUUID;
//						_res.add(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(skillUUID).parse, [url, 2, updateParse, [url]]));
//						BTSystem.INSTANCE().RESOURCES.push(url);
					}

					// 加载技能名字
				}
			}

			// 设置头像id
			BTSystem.INSTANCE().setPlayerRoleID(playerRoleId);
			BTSystem.INSTANCE().setPlayerRoleName(playerRoleName);
			BTSystem.INSTANCE().setPlayerLevel(playerLevel);
			BTSystem.INSTANCE().setEnemyRoleID(enemyRoleId);
			BTSystem.INSTANCE().setEnemyLevel(enemyLevel);
			BTSystem.INSTANCE().setEnemyRoleName(enemyRoleName);
			BTSystem.INSTANCE().setPlayerColor(playerColor);
			BTSystem.INSTANCE().setEnemyColor(enemyColor);

			BtProcess.selfList = arr1;
			BtProcess.enemyList = arr2;
			playerA = new Player();
			playerB = new Player();
			playerA.putFighterInfoArr(arr1);
			playerB.putFighterInfoArr(arr2);
			playerA.setbChangeSide(isChangeSide);

			// trace(BTSystem.INSTANCE().getFightTypeID());
			var picNameStr : String;
			var mapD : mapData;
			var mapID : uint;
			// 加载背景图
			trace(BTSystem.INSTANCE().getFightTypeID());
			if (BTSystem.INSTANCE().GetPlayModle() == 0) {
				if (BTSystem.INSTANCE().getFightTypeID() == BTSystem.FT_DUGEON)  // 副本
				{
					var isDugeonBoss : Boolean = false;
					var vomster : VoMonster = RSSManager.getInstance().getMosterById(enemyRoleId) as VoMonster;
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
						// 截图
						BTSystem.INSTANCE().setBackGroundPic(MLand.printScreen(mapD.pointX, mapD.pointY));
					} else// 小boss单独背景图
					{
						_res.add(VersionManager.instance.getLoader(picNameStr, picNameStr));
						BTSystem.INSTANCE().RESOURCES.push(picNameStr);
					}
				}
				else if (BTSystem.INSTANCE().getFightTypeID() == BTSystem.FT_QUESTNPC)  // 任务,单独背景图
				{
					mapID = MapUtil.currentMapId;
					mapD = AttackData.mapidlist[mapID] as mapData;
					picNameStr = mapD.urlStr;
					_res.add(VersionManager.instance.getLoader(picNameStr, picNameStr));
//					_res.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + picNameStr, picNameStr)));
					BTSystem.INSTANCE().RESOURCES.push(picNameStr);
				} 
				else if (BTSystem.INSTANCE().getFightTypeID() == BTSystem.FT_COUNTRY || BTSystem.INSTANCE().getFightTypeID() == BTSystem.FT_BOSS || BTSystem.INSTANCE().getFightTypeID() == BTSystem.FT_GUILDDUGEON)// 国战，boss战，家族boss战，截图
				{
					// 截图
					mapID = BTSystem.INSTANCE().getFightTypeID() * 100000;
					mapD = AttackData.mapidlist[mapID] as mapData;
					BTSystem.INSTANCE().setBackGroundPic(MLand.printScreen(mapD.pointX, mapD.pointY));
				}
				else if (BTSystem.INSTANCE().getFightTypeID() == BTSystem.FT_GUARD || BTSystem.INSTANCE().getFightTypeID() == BTSystem.FT_GBODYGUARD || BTSystem.INSTANCE().getFightTypeID() == BTSystem.FT_ATHLETICS)  // 运镖，家族运镖，竞技场，锁妖塔，单独背景图
				{
					// 单独load地图
					mapID = BTSystem.FT_GUARD * 100000;
					mapD = AttackData.mapidlist[mapID] as mapData;
					picNameStr = mapD.urlStr;
					_res.add(VersionManager.instance.getLoader(picNameStr, picNameStr));
//					_res.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + picNameStr, picNameStr)));
					BTSystem.INSTANCE().RESOURCES.push(picNameStr);
				} else if ( BTSystem.INSTANCE().getFightTypeID() == BTSystem.FT_LOCKBOSS) {
					mapID = BTSystem.FT_LOCKBOSS * 100000;
					mapD = AttackData.mapidlist[mapID] as mapData;
					picNameStr = mapD.urlStr;
					_res.add(VersionManager.instance.getLoader(picNameStr, picNameStr));
//					_res.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + picNameStr, picNameStr)));
					BTSystem.INSTANCE().RESOURCES.push(picNameStr);
				} else if (BTSystem.INSTANCE().getFightTypeID() == BTSystem.FT_ARTIFACTS) {
					mapID = BTSystem.INSTANCE().getCityID() + 2;
					mapD = AttackData.mapidlist[mapID] as mapData;
					picNameStr = mapD.urlStr;
					_res.add(VersionManager.instance.getLoader(picNameStr, picNameStr));
//					_res.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + picNameStr, picNameStr)));
					BTSystem.INSTANCE().RESOURCES.push(picNameStr);
				}
			} 
			else  // repaly
			{
				mapID = 2;
				mapD = AttackData.mapidlist[mapID] as mapData;
				picNameStr = mapD.urlStr;
				_res.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + picNameStr, picNameStr)));
				BTSystem.INSTANCE().RESOURCES.push(picNameStr);
			}
			


			if (!_rotateEffects)
				_res.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + "assets/swf/rotateEffects.swf", "rotateEffects")));

			_res.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + "assets/ui/Numbers.swf", "Numbers")));
			_res.add(new BDSWFLoader(new LibData(StaticConfig.cdnRoot + "assets/avatar/battle/die.swf", "diessss")));
			BTSystem.INSTANCE().RESOURCES.push("diessss");
			if (isLoaded()) {
				toRotateEffects();
				return;
			}
			_res.addEventListener(Event.COMPLETE, loadComplete);
			_load_lm.startShow(false);
			MLoading.pause();
			_res.startLoad();
		}

		private function isLoaded() : Boolean {
			for each (var key:String in BTSystem.INSTANCE().RESOURCES) {
				var uuid:int=_wait[key];
//				Logger.info("check key===>"+key);
				if(key=="diessss"){
//					Logger.info("isLoaded key===>"+key);
					continue;
				}
				if (!RESManager.isLoade(key, true) && AvatarManager.instance.getAvatarBD(uuid).bds.total == 0) return false;
//				Logger.info("isLoaded key===>"+key);
			}
			return true;
		}

		public static function PreLoadBackPicByCityID(cityid : uint) : String {
			var mapD : mapData = AttackData.mapidlist[cityid > 200 ? cityid * 10000 : cityid] as mapData;
			return mapD ? mapD.urlStr : null;
		}

		// 根据skillid读取技能资源,side:1阵上方 0：阵下方
		public static function getResArrBySkillID(skillIdArr : Array, side : uint = 1, isLoader : Boolean = false) : Array {
			var i : int;
			var skillId : uint = 0;
			var pskilldata : skillData = null;
			var skillUUID : uint = 0;
			var frontOrback : uint = side ? 0 : 1;
			var url : String;
			var resArr : Array = [];
			for (i = 0; i < skillIdArr.length; ++i) {
				skillId = skillIdArr[i];
				pskilldata = AttackData.skilllist[skillId];
				if (pskilldata == null)
					continue;
				if (pskilldata.getSpellEftId() > 0) // 需要加载技能动画
				{
					if (pskilldata.getCanTurnOver() == 0 || pskilldata.getCanTurnOver() == 1 ) {
						skillUUID = AvatarManager.instance.getUUId(pskilldata.getSpellEftId(), AvatarType.SKILL_TYPE_SPELL, 1);
						url = StaticConfig.cdnRoot + "assets/avatar/" + skillUUID + ".swf";
						if (!isLoader)
							resArr.push(url);
						else
							resArr.push(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(skillUUID).parse, [url, 2]));
					}
					else if (pskilldata.getCanTurnOver() == 2) {
						skillUUID = AvatarManager.instance.getUUId(pskilldata.getSpellEftId(), AvatarType.SKILL_TYPE_SPELL, frontOrback);
						url = StaticConfig.cdnRoot + "assets/avatar/" + skillUUID + ".swf";
						if (!isLoader)
							resArr.push(url);
						else
							resArr.push(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(skillUUID).parse, [url, 2]));
					}
				}

				// 需要加载地面效果
				if (pskilldata.getGroundSkillID() > 0) {
					if (pskilldata.getGroundCanTurnOver() == 0 || pskilldata.getGroundCanTurnOver() == 1) {
						skillUUID = AvatarManager.instance.getUUId(pskilldata.getGroundSkillID(), AvatarType.SKILL_TYPE_GROUND, 1);
						url = StaticConfig.cdnRoot + "assets/avatar/" + skillUUID + ".swf";
						if (!isLoader)
							resArr.push(url);
						else
							resArr.push(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(skillUUID).parse, [url, 2]));
					} else if (pskilldata.getGroundCanTurnOver() == 2) {
						skillUUID = AvatarManager.instance.getUUId(pskilldata.getGroundSkillID(), AvatarType.SKILL_TYPE_GROUND, frontOrback);
						url = StaticConfig.cdnRoot + "assets/avatar/" + skillUUID + ".swf";
						if (!isLoader)
							resArr.push(url);
						else
							resArr.push(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(skillUUID).parse, [url, 2]));
					}
				}

				// 加载技能动画2
				if (pskilldata.getSpellEftId2() > 0) // 需要加载技能动画
				{
					if (pskilldata.getCanTurnOver2() == 1)  // 可以翻转
					{
						skillUUID = AvatarManager.instance.getUUId(pskilldata.getSpellEftId2(), AvatarType.SKILL_TYPE_SPELL, 1);
						url = StaticConfig.cdnRoot + "assets/avatar/" + skillUUID + ".swf";
						if (!isLoader)
							resArr.push(url);
						else
							resArr.push(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(skillUUID).parse, [url, 2]));
					} else if (pskilldata.getCanTurnOver2() == 2) {
						skillUUID = AvatarManager.instance.getUUId(pskilldata.getSpellEftId2(), AvatarType.SKILL_TYPE_SPELL, 1 - frontOrback);
						// 因为是给己方的效果
						url = StaticConfig.cdnRoot + "assets/avatar/" + skillUUID + ".swf";
						if (!isLoader)
							resArr.push(url);
						else
							resArr.push(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(skillUUID).parse, [url, 2]));
					}
				}

				// 需要加载地面效果
				if (pskilldata.getGroundSkillID2() > 0) {
					skillUUID = AvatarManager.instance.getUUId(pskilldata.getGroundSkillID2(), AvatarType.SKILL_TYPE_GROUND, 1);
					url = StaticConfig.cdnRoot + "assets/avatar/" + skillUUID + ".swf";
					if (!isLoader)
						resArr.push(url);
					else
						resArr.push(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(skillUUID).parse, [url, 2]));
				}

				// 加载技能1 buff
				if (pskilldata.getBuffID() > 0)  // 需要加载buff
				{
					skillUUID = AvatarManager.instance.getUUId(pskilldata.getBuffID(), AvatarType.BUFF_TYPE);
					url = StaticConfig.cdnRoot + "assets/avatar/" + skillUUID + ".swf";
					if (!isLoader)
						resArr.push(url);
					else
						resArr.push(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(skillUUID).parse, [url, 2]));
				}
				// 加载技能2 buff
				if (pskilldata.getBuffPlusID() > 0) {
					skillUUID = AvatarManager.instance.getUUId(pskilldata.getBuffPlusID(), AvatarType.BUFF_TYPE);
					url = StaticConfig.cdnRoot + "assets/avatar/" + skillUUID + ".swf";
					if (!isLoader)
						resArr.push(url);
					else
						resArr.push(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(skillUUID).parse, [url, 2]));
				}

				// 加载buff2
				if (pskilldata.getBuffID2() > 0)  // 需要加载buff
				{
					skillUUID = AvatarManager.instance.getUUId(pskilldata.getBuffID2(), AvatarType.BUFF_TYPE);
					url = StaticConfig.cdnRoot + "assets/avatar/" + skillUUID + ".swf";
					if (!isLoader)
						resArr.push(url);
					else
						resArr.push(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(skillUUID).parse, [url, 2]));
				}

				// 单独加载聚气
				if (i == 0) {
					skillUUID = AvatarManager.instance.getUUId(skillType.GAUGEFULL, AvatarType.BUFF_TYPE);
					url = StaticConfig.cdnRoot + "assets/avatar/" + skillUUID + ".swf";
					if (!isLoader)
						resArr.push(url);
					else
						resArr.push(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(skillUUID).parse, [url, 2]));

//					skillUUID = AvatarManager.instance.getUUId(skillType.GAUGEFULL + 1, AvatarType.BUFF_TYPE);
//					url = StaticConfig.cdnRoot + "assets/avatar/" + skillUUID + ".swf";
//					if (!isLoader)
//						resArr.push(url);
//					else
//						resArr.push(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(skillUUID).parse, [url, 2]));
				}
			}
			return resArr;
		}

		public static function preLoadBattleRes(monsterList : Array, cityid : int, isLoader : Boolean = false) : Array {
			var tempArray : Array = [];
			var arr : Array = [];
			var skills : Array = [];
			var skillId : int;
			var  uuid : int ;
			for each (var id:int in monsterList) {
				if (id == 0) {
					id = 4006 + UserData.instance.myHero.id;
				}
				var monster : VoMonster = RSSManager.getInstance().getMosterById(id);
				if (monster) {
					if (isLoader) {
						uuid = AvatarManager.instance.getUUId(monster.avatarId, AvatarType.MONSTER_TYPE);
						tempArray.push(new SWFLoader(new LibData(monster.avatarUrl, monster.avatarUrl, true, false), AvatarManager.instance.getAvatarBD(uuid).parse, [monster.avatarUrl, 2]));
					} else
						tempArray.push(monster.avatarUrl);
					for each (skillId in  monster.skills) {
						if (skills.indexOf(skillId) == -1) skills.push(skillId);
					}
				}
			}
			arr = BattleInterface.getResArrBySkillID(skills, 1, isLoader);
			arr = arr.concat(tempArray);
			var myheros : Array = HeroManager.instance.teamHeroes;
			var heroSkill : Array = [];
			for each (var hero:VoHero in myheros) {
				if (isLoader) {
					uuid = AvatarManager.instance.getUUId(hero.id, AvatarType.PLAYER_BATT_BACK, hero.cloth);
					var url : String = hero.getAvatarUrl(AvatarType.PLAYER_BATT_BACK);
					arr.push(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(uuid).parse, [url, 2]));
				} else
					arr = arr.concat(hero.getAvatarUrl(AvatarType.PLAYER_BATT_BACK));
				heroSkill.push(SutraManager.instance.getNowSkillID(hero));
			}
			arr = arr.concat(BattleInterface.getResArrBySkillID(heroSkill, 0, isLoader));

			if (isLoader) {
				arr.push(new SWFLoader(new LibData(StaticConfig.cdnRoot + "assets/swf/rotateEffects.swf", "rotateEffects")));
				arr.push(new SWFLoader(new LibData(StaticConfig.cdnRoot + "assets/ui/Numbers.swf", "Numbers")));
				arr.push(new BDSWFLoader(new LibData(StaticConfig.cdnRoot + "assets/avatar/battle/die.swf", "diessss")));
			} else {
				arr.push(StaticConfig.cdnRoot + "assets/swf/rotateEffects.swf");
				arr.push(StaticConfig.cdnRoot + "assets/ui/Numbers.swf");
				arr.push(StaticConfig.cdnRoot + "assets/avatar/battle/die.swf");
			}

			var mapString : String = BattleInterface.PreLoadBackPicByCityID(cityid);
			if (mapString) {
				if (isLoader) {
					arr.push(new SWFLoader(new LibData(StaticConfig.cdnRoot + mapString, mapString)));
				} else {
					arr.push(StaticConfig.cdnRoot + mapString);
				}
			}
			return arr;
		}

		private var _wait : Dictionary = new Dictionary();
		private var _loaded : Boolean = false;

		private function updateParse(key : int) : void {
			delete _wait[key];
			Logger.info("updateParse key===>"+key);
			if (_loaded && DictionaryUtil.isEmpty(_wait)) {
				toRotateEffects();
			}
		}

		private var _res : RESManager;

		private function loadComplete(evt : Event) : void {
			_res.removeEventListener(Event.COMPLETE, loadComplete);
			_load_lm.show();
			_loaded = true;
			MLoading.go();
			if (!DictionaryUtil.isEmpty(_wait)) {
				setTimeout(toRotateEffects, 500);
				return;
			}
			toRotateEffects();
		}

		private function toRotateEffects() : void {
			_loaded = false;
			_load_lm.hide();
			if (!_rotateEffects) {
				_rotateEffects = RESManager.getMC(new AssetData("rotateEffects", "rotateEffects"));
			}
			_rotateEffects.addEventListener("end", onEnd);
			_rotateEffects.addEventListener("start", onStart);
			_rotateEffects.x = UIManager.stage.stageWidth / 2;
			_rotateEffects.y = UIManager.stage.stageHeight / 2;
			UIManager.root.addChild(_rotateEffects);
			_rotateEffects.gotoAndPlay(1);
		}

		private function onStart(event : Event) : void {
			_rotateEffects.removeEventListener("start", onStart);
			playerA.assault(playerB);
			BTSystem.INSTANCE().b_Result = playerA.getBattleResult();
			if (BTSystem.INSTANCE().mySide == 1)
				BtProcess.ChangeSide();
			BTSystem.INSTANCE().start();
		}

		private function onEnd(event : Event) : void {
			_rotateEffects.removeEventListener("end", onEnd);
			if (_rotateEffects.parent) _rotateEffects.parent.removeChild(_rotateEffects);
		}
		
		public static function clear() : void {
			for each (var bitMap:Bitmap in BTSystem.Number_HurtVec) {
				bitMap.bitmapData.dispose();
				bitMap = null;
			}
			BTSystem.Number_HurtVec = new Vector.<Bitmap>();
			for each (bitMap in BTSystem.Number_AddVec) {
				bitMap.bitmapData.dispose();
				bitMap = null;
			}
			BTSystem.Number_AddVec = new Vector.<Bitmap>();
			for each (bitMap in BTSystem.Number_PosionVec) {
				bitMap.bitmapData.dispose();
				bitMap = null;
			}
			BTSystem.Number_PosionVec = new Vector.<Bitmap>();

			for each (bitMap in BTSystem.Effect_SkillVec) {
				bitMap.bitmapData.dispose();
				bitMap = null;
			}
			BTSystem.Effect_SkillVec = new Vector.<BitmapData>();
			AvatarManager.instance.clearBattleAvatars();
		}
	}
}
