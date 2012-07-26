package game.core.user {
	import game.config.StaticConfig;
	import game.core.avatar.AvatarManager;
	import game.core.avatar.AvatarType;
	import game.core.hero.HeroManager;
	import game.core.hero.VoHero;
	import game.core.item.sutra.Sutra;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.manager.RSSManager;
	import game.manager.SignalBusManager;
	import game.manager.ViewManager;
	import game.module.guild.GuildManager;
	import game.module.userBuffStatus.BuffStatusManager;
	import game.module.userPanel.MyUserPanel;
	import game.net.core.Common;
	import game.net.core.GASignals;
	import game.net.data.CtoC.CCTeamChange;
	import game.net.data.CtoC.CCUserDataChangeUp;
	import game.net.data.CtoC.CCVIPLevelChange;
	import game.net.data.StoC.BuffData;
	import game.net.data.StoC.HeroInfo;
	import game.net.data.StoC.SCHeroDonate;
	import game.net.data.StoC.SCHeroNewList;
	import game.net.data.StoC.SCHeroSummonStatus;
	import game.net.data.StoC.SCPlayerInfo;
	import game.net.data.StoC.SCPlayerInfoChange;
	import game.net.data.StoC.SCPlayerInfoChange2;
	import game.net.data.StoC.SCUserLogin;
	import game.net.data.StoC.SCWallowUpdate;

	import net.LibData;
	import net.RESManager;
	import net.SWFLoader;

	import worlds.WorldStartup;

	import com.utils.PotentialColorUtils;
	import com.utils.StringUtils;

	/**
	 * @author yangyiqiang
	 */
	public class UserData {
		// =====================
		// 单例
		// UserData是特殊单例，为了方便操作，控制器与模型封在同一个类中
		// =====================
		private static var _instance : UserData;

		public static function get instance() : UserData {
			if (_instance == null) {
				_instance = new UserData();
			}
			return _instance;
		}

		public function UserData() {
			if (_instance)
				throw (Error("单例错误！"));
			initiate();
		}

		// =====================
		// 属性
		// =====================
		/** 金币  */
		public var gold : uint;
		/** 绑金 */
		public var goldB : uint;
		/** 银币 */
		public var silver : uint;
		public var honour : uint;
		// 修为经验
		public var  profExp : uint;
		// 修为等级
		public var  profLevel : uint;
		/** 状态 */
		public var status : int;
		/** 选项 */
		public var opt : int;
		/** 总充值量 */
		public var totalTopup : int;
		/** 总消费值 */
		public var totalConsume : int;
		/** 防沉迷  0 - 已通过防沉迷  1 - 未填写过信息  2 - 已填写但不足18岁 */
		public var wallow : int;
		/** 防沉迷时间 **/
		public var wallowTime : int;
		/** 权限 0: 玩家权限 1:普通GM**/
		public var power : int = 1;
		/** 当前包裹容量 */
		public var packCurrent : int = 0;
		/** 包裹可开到的上限 */
		public var packTotal : int = 600;
		/** 玩家编号 */
		public var playerId : uint;
		/** 玩家名 */
		public var playerName : String;
		/** 职业 */
		public var job : int = 1;
		/** VIP等级 */
		public var vipLevel : uint = 0;
		/** 主将 */
		public var myHero : VoHero;
		/** 队伍中将领，不包括主将 */
		public var heroes : Vector.<VoHero>;
		/** 其他将领 */
		public var otherHeros : Vector.<VoHero>;
		public var guildaction : uint ;
		public var guideSteps : Vector.<uint>=new Vector.<uint>();
		public var loginMapId : int = 0;
		/** 新交易的个数 */
		public var newExchangeCount : int = 0;
		public var level : int;
		public var exp : int;

		// =====================
		// Getter/Setter
		// =====================
		public function get playerHtmlName() : String {
			return StringUtils.addColor(playerName, PotentialColorUtils.getColorOfStr(myHero.potential));
		}

		// =====================
		// 方法
		// =====================
		public function initiate() : void {
			Common.game_server.addCallback(0x0E, updateWallow);
			Common.game_server.addCallback(0x10, initData);
			Common.game_server.addCallback(0x11, playerInfoChange);
			Common.game_server.addCallback(0x17, onHeroDonate);
			Common.game_server.addCallback(0x1f, playerInfoChange2);
			Common.game_server.addCallback(0x18, sCHeroSummonStatus);
			Common.game_server.addCallback(0x19, onHeroNewList);

			guideSteps.push(0);
		}

		public function updateUserData(message : SCUserLogin) : void {
			if (message.result != 0) return;
			playerId = message.playerId;
			playerName = message.name;
			vipLevel = message.vipLevel;
			guideSteps = message.steps;
			loginMapId = message.mapId;
			if (guideSteps.length == 0) {
				guideSteps.push(0);
			}
			RSSManager.getInstance().startLoad();
		}

		public var userPanel : MyUserPanel;

		private function initData(info : SCPlayerInfo) : void {
			if (!info) return;
			gold = info.gold;
			goldB = info.goldB;
			silver = info.silver;
			status = info.status;
			profExp = info.profExp;
			opt = info.opt;
			totalTopup = info.totalTopup;
			totalConsume = info.totalConsume;
			wallow = info.wallow;
			wallowTime = info.wallowTime;
			level = info.level;
			exp = info.experience;
			packTotal = info.packSize;
			heroes = new Vector.<VoHero>();
			otherHeros = new Vector.<VoHero>();
			// dungeonOpened = info.dungeonOpened;
			// dungeonGold = info.dungeonGold;

			if (info.hasTradecnt)
				newExchangeCount = info.tradecnt;

			for each (var vo:HeroInfo in info.heroes) {
				var id : uint = vo.id & 0x3FF;
				var vohero : VoHero = HeroManager.instance.newHero(id);
				if (!vohero) continue;
				if (vohero.sutra)
					vohero.sutra.runetotemID = vo.skillID;
				if (vo.hasPotential) vohero.potential = vo.potential;
				var reStatic : int = vo.id >> 10;
				if (vo.hasWpLevel && vohero.sutra) vohero.sutra.step = vo.wpLevel;
				if (reStatic == 0) {
					vohero.recruitState = reStatic;
					heroes.push(vohero);
					if (id > 10) {
						RESManager.instance.preLoad(vohero.getAvatarUrl(AvatarType.PLAYER_BATT_BACK));
					}
				} else {
					vohero.recruitState = reStatic;
					otherHeros.push(vohero);
				}
			}

			for each (var vui:uint in info.availHeroes) {
				var hid : uint = vui & 0x3FF;
				var vohero2 : VoHero = HeroManager.instance.newHero(hid);
				if (!vohero2) continue;
				vohero2.recruitState = (vui >> 10) & 0x0F;
				vohero2.sutra.stepValue = vui >> 14;
				otherHeros.push(vohero2);
			}

			GuildManager.instance.refreshRemain();
			myHero = heroes[0];
			job = myHero.job;
			var key : int = AvatarManager.instance.getUUId(myHero.id, AvatarType.PLAYER_RUN, 0);
			var url : String = StaticConfig.cdnRoot + "assets/avatar/" + key + ".swf";

			RESManager.instance.add(new SWFLoader(new LibData(url, url, true, false), AvatarManager.instance.getAvatarBD(key).parse, [url, 1]));
			myHero._name = playerName;
			userPanel = new MyUserPanel();
			userPanel.show();

			// 状态图标
			BuffStatusManager.instance.updateStatus(info.status);
			// BUFF图标
			for (var i : int = 0; i < info.buffList.length; i++) {
				var buffData : BuffData = info.buffList[i];
				BuffStatusManager.instance.updateBuffTime(buffData.buffId, buffData.leftTime);
			}

			SignalBusManager.userInitData.dispatch();

			WorldStartup.startup(UserData.instance.playerId, UserData.instance.loginMapId, ViewManager.instance.getContainer(ViewManager.MAP_CONTAINER));
		}

		public function isWallow() : Boolean {
			return wallowTime > 3 * 60 * 60;
		}

		private function updateWallow(msg : SCWallowUpdate) : void {
			wallow = msg.status;
			wallowTime = msg.wallowTime;
			StateManager.instance.checkMsg(wallow == 0 ? 350 : 351);
			userPanel.refreshWallow();
		}

		private function onHeroDonate(msg : SCHeroDonate) : void {
			var hero : VoHero = HeroManager.instance.getTeamHeroById(msg.id, 2);
			if (!hero) {
				// trace("未知将领！" + msg.id);
				return;
			}

			hero.sutra.stepValue = msg.totalCount;
		}

		private function onHeroNewList(e : SCHeroNewList) : void {
			for each (var id:uint in e.heroes) {
				var hero : VoHero = HeroManager.instance.newHero(id);
				otherHeros.push(hero);
			}
		}

		private function sCHeroSummonStatus(message : SCHeroSummonStatus) : void {
			var changed : Boolean = false;
			var type : int = 2;
			if (message.newStatus == 0) {
				var vohero : VoHero;
				type = 0;
				for (var i : int = 0;i < heroes.length;i++) {
					if (heroes[i].id == message.id) return;
				}
				for (var k : int = 0; k < otherHeros.length ; k++) {
					if (otherHeros[k].id == message.id) {
						otherHeros[k].recruitState = 0;
						heroes.push(otherHeros[k]);
						otherHeros.splice(k, 1);
						changed = true;
						break;
					}
				}
				if (!changed) {
					vohero = HeroManager.instance.newHero(message.id);
					if (!vohero) return;
					vohero.recruitState = 0;
					heroes.push(vohero);
					changed = true;
				}
			} else {
				for ( i = 0; i < heroes.length ; i++) {
					if (heroes[i].id == message.id) {
						heroes[i].recruitState = message.newStatus;
						otherHeros.push(heroes[i]);
						heroes.splice(i, 1);
						changed = true;
						type = 1;
						break;
					}
				}
			}

			if (changed) {
				var msg : CCTeamChange = new CCTeamChange();
				msg.uuid = message.id;
				msg.type = type;
				Common.game_server.sendCCMessage(0xFFF4, msg);
			}
			userPanel.refreshHeros();
		}

		/** 玩家信息发生变化 
		 *  数据标识 flag
		 *     1 - 姓名
		 *     2 - 主将ID
		 *     4 - 金币
		 *     8 - 金币改变
		 *  0x10 - 绑金
		 *  0x20 - 绑金改变
		 *  0x40 - 银币
		 *  0x80 - 银币改变
		 * 0x100 - 状态改变
		 * 0x200 - 选项
		 * 0x400 - 选项改变
		 * 0x800 - 总充值量
		 *0x1000 - 总充值量改变
		 *0x2000 - 总消费值
		 */
		private function playerInfoChange(info : SCPlayerInfoChange) : void {
			if (info.hasName) {
				playerName = info.name;
			}
			if (info.hasId) {
				playerId = info.id;
			}
			if (info.hasStatus) {
				status = info.status;
			}
			if (info.hasOpt) {
				opt = info.opt;
			}
			if (info.hasTotalTopup) {
				totalTopup = info.totalTopup;
			}
			if (info.hasTotalConsume) {
				totalConsume = info.totalConsume;
			}
			if (info.packSizeChange) {
				packTotal = info.packSizeChange;
			}
			if ( info.hasStatus ) {
				guildaction = info.status & 0xFF ;
				GuildManager.instance.refreshRemain();
				// ClanManager.updateActionRemain(guildaction);
			}
			// BUFF图标
			if (info.hasBuff) {
				var buffId : int = info.buff.buffId;
				var buffTime : int = info.buff.leftTime;
				BuffStatusManager.instance.updateBuffTime(buffId, buffTime);
			}

			// 状态图标
			if (info.hasStatus) {
				BuffStatusManager.instance.updateStatus(info.status);
			}

			// VIP Level
			if (info.hasVipLevel) {
				vipLevel = info.vipLevel;
				var vipMsg : CCVIPLevelChange = new CCVIPLevelChange();
				vipMsg.oldLevel = vipLevel;
				vipMsg.level = info.vipLevel;
				Common.game_server.sendCCMessage(0xFFF7, vipMsg);
			}

			// Exchange count
			if (info.hasTradecnt) {
				newExchangeCount = info.tradecnt;
				SignalBusManager.changeNewExchangeCount.dispatch();
			}

			if (userPanel)
				userPanel.refresh();
		}

		private function playerInfoChange2(info : SCPlayerInfoChange2) : void {
			var tipsType : uint = info.tipsType << 13;
			if (info.hasGold) {
				gold = info.gold;
			}
			if (info.hasGoldB) {
				goldB = info.goldB;
			}
			if (info.hasSilver) {
				silver = info.silver;
			}
			if (info.hasProfExp) {
				profExp = info.profExp;
				upSutraSymbol();
			}
			if (info.hasLevel) {
				if (level < info.level) ViewManager.instance.playAnimation("levelUp");
				var lvMsg : CCUserDataChangeUp = new CCUserDataChangeUp();
				lvMsg.oldLevel = level;
				level = info.level;
				lvMsg.level = info.level;
				Common.game_server.sendCCMessage(0xFFF1, lvMsg);

				GASignals.gaRoleLevelUp.dispatch(myHero.job, info.level);
			}
			if (info.hasExp)
				exp = info.exp;

			if (userPanel) userPanel.refresh();
			if (info.hasGoldChange)
				StateManager.instance.checkMsg(info.goldChange > 0 ? 159 : 154, null, null, [Math.abs(info.goldChange)], tipsType);
			if (info.hasGoldBChange)
				StateManager.instance.checkMsg(info.goldBChange > 0 ? (isWallow() == 0 ? 160 : 341) : 155, null, null, [Math.abs(info.goldBChange)], tipsType);
			if (info.hasExpGot)
				StateManager.instance.checkMsg(isWallow() == 0 ? 20 : 340, null, null, [info.expGot], tipsType);
			if (info.hasSilverChange)
				StateManager.instance.checkMsg(info.silverChange > 0 ? (isWallow() == 0 ? 161 : 343) : 156, null, null, [Math.abs(info.silverChange)], tipsType);
			if (info.hasProfExpChange)
				StateManager.instance.checkMsg(info.profExpChange > 0 ? (isWallow() == 0 ? 275 : 342) : 157, null, null, [Math.abs(info.profExpChange)], tipsType);
		}

		private function upSutraSymbol() : void {
			var sutra : Sutra = myHero.sutra;
			if (profExp > sutra.nextSetpExp - 1)
				MenuManager.getInstance().getMenuButton(MenuType.SUTRA).addMenuMc(3, "!");
		}

		// ------------------------------------------------------------
		// 元宝，银币，声望是否足够
		public function trySpendGold(cnt : int) : int {
			var rest : int = gold - cnt;
			if (rest < 0)
				StateManager.instance.checkMsg(4);
			return rest;
		}

		public function trySpendGoldB(cnt : int) : int {
			var rest : int = goldB - cnt;

			if (rest < 0)
				StateManager.instance.checkMsg(4);

			return rest;
		}

		public function trySpendTotalGold(cnt : int) : int {
			var rest : int = totalGold - cnt;
			if (rest < 0)
				StateManager.instance.checkMsg(4);
			return rest;
		}

		public function trySpendSilver(cnt : int) : int {
			var rest : int = silver - cnt;

			if (rest < 0)
				StateManager.instance.checkMsg(129);

			return rest;
		}

		public function trySpendHonor(cnt : int) : int {
			var rest : int = honour - cnt;

			if (rest < 0)
				StateManager.instance.checkMsg(129);

			return rest;
		}

		public function get totalGold() : int {
			return gold + goldB;
		}

		public function tryPutPack(cnt : int) : int {
			var rest : int = packTotal - packCurrent - cnt;

			if (rest < 0)
				StateManager.instance.checkMsg(10, null, null, [cnt]);

			return rest;
		}

		public function tryPutPacMsg153(cnt : int) : int {
			var rest : int = packTotal - packCurrent - cnt;
			if (rest < 0)
				StateManager.instance.checkMsg(153, [cnt]);
			return rest;
		}
		
		
		public function getBattlePoint():int
		{
		    var btp:int=0;	
			for(var i:int=0;i<heroes.length;i++)
			{
				if(heroes[i].state==3)
				btp+=heroes[i].bt;
			}
			return btp;
		}
	}
}
