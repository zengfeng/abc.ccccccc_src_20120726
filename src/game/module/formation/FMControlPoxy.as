package game.module.formation {
	import game.core.hero.HeroManager;
	import game.core.hero.VoHero;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.core.user.UserData;
	import game.manager.SignalBusManager;
	import game.module.formation.formationManage.FMManager;
	import game.module.formation.formationManage.VoFM;
	import game.net.core.Common;
	import game.net.data.CtoC.CCTeamChange;
	import game.net.data.CtoC.CCUserDataChangeUp;
	import game.net.data.CtoS.CSSetSquad;
	import game.net.data.StoC.FormationInfo;
	import game.net.data.StoC.SCHeroSummonStatus;
	import game.net.data.StoC.SCLearn;
	import game.net.data.StoC.SCPlayerInfo;
	import game.net.data.StoC.SCSetSquad;
	import game.net.data.StoC.SCSwitchSquad;

	import flash.utils.Dictionary;

	/**
	 * @author Lv
	 */
	public class FMControlPoxy {
		private static var _instance : FMControlPoxy;
		// 存储所有阵型  K：阵型ID
		public static var saveAllFMDic : Dictionary = new Dictionary();
		// 启用阵型id
		public static var startFmK : int;
		// 是否是阵眼  阵眼： true   非阵眼：false；
		public static var isFmEye : Boolean;
		public static var isOpender : Boolean = false;

		public function FMControlPoxy(controler : Controler) : void {
			controler;
			sToC();
		}

		public static function get instance() : FMControlPoxy {
			if (_instance == null) {
				_instance = new FMControlPoxy(new Controler());
			}
			return _instance;
		}

		private function sToC() : void {
			// 服务器发送各个阵形的等级
			Common.game_server.addCallback(0x10, sCPlayerInfo);
			// 改变阵型指定位置的名仙
			Common.game_server.addCallback(0x1C, sCSetSquad);
			// 启用阵型
			Common.game_server.addCallback(0x1E, sCSwitchSquad);
			// 学习新阵型
			Common.game_server.addCallback(0x1D, sCLearn);
			// 将领等级改变
			Common.game_server.addCallback(0xFFF1, cCHeroLevelUp);
			// 招募将领
			Common.game_server.addCallback(0x18, sCHeroSummonStatus);
			// 将领解雇
			Common.game_server.addCallback(0xFFF4, cCTeamChange);
		}

		private function cCTeamChange(e : CCTeamChange) : void {
			if (e.type == 1) {
				waringHeroOut(e.uuid);
			}
		}

		// 出战英雄离队
		public function waringHeroOut(heroID : int) : void {
			for each (var vec:Vector.<Object> in FMControlPoxy.saveAllFMDic) {
				deleteHero(vec, heroID);
			}
			FMControler.instance.dismissHero();
		}

		private function deleteHero(vec : Vector.<Object>, heroID : int) : void {
			var max : int = vec.length;
			for (var i : int = 0 ; i < max;i++) {
				var obj : Object = vec[i];
				if (obj["id"] == heroID) {
					vec.splice(i, 1);
					return;
				}
			}
		}

		// 招募将领
		private function sCHeroSummonStatus(e : SCHeroSummonStatus) : void {
			if (e.newStatus == 0) {
				var id : int = e.id;
				FMControler.instance.recruitHero(id);
			}
		}

		// 将领等级改变
		private function cCHeroLevelUp(e : CCUserDataChangeUp) : void {
			FMControler.instance.heroChangeLevel();
			var fmc : Array = FMManager.formationLeveLimitVec;
			for (var i : int = 0 ; i < fmc.length; i++) {
				if (e.level == fmc[i])
					MenuManager.getInstance().getMenuButton(MenuType.FORMATION).addMenuMc(2, "新");
			}
		}

		// 改变阵型指定位置的名仙
		private function sCSetSquad(e : SCSetSquad) : void {
			var heroID : int = e.heroId;
			var pos : int = e.position;
			var objVec : Vector.<Object> = saveAllFMDic[e.formation];
			var max : int = objVec.length;
			var obj : Object;
			var isWaring : Boolean;
			if (heroID != 0) {
				obj = new Object();
				obj["id"] = heroID;
				obj["pos"] = pos;
				objVec.push(obj);
				FMControler.instance.changeFmToCenMC(e.formation);
				isWaring = true;
				// return;
			} else {
				for (var i : int = 0;i < max ;i++) {
					obj = objVec[i];
					if (pos == obj["pos"]) {
						objVec.splice(i, 1);
						isWaring = false;
						// return;
					}
				}
			}
			if (startFmK == e.formation) {
				SignalBusManager.heroWaringChange.dispatch(heroID, isWaring);
				setWaring();
			}
		}

		// 学习新阵型
		private function sCLearn(e : SCLearn) : void {
			var id : int = e.id;
			var level : int = e.level;
			var vo : VoFM = FMManager.formationKindsDic[id];
			vo.fm_level = level;
			if (saveAllFMDic[id] == null) {
				var vec : Vector.<Object> = new Vector.<Object>();
				var obj : Object = new Object();
				obj["id"] = UserData.instance.myHero.id;
				obj["pos"] = 0;
				vec.push(obj);
				saveAllFMDic[id] = vec;
			}
			FMControler.instance.fmUpgrader(id, level);
		}

		private var fistBo : Boolean = true;

		// 启用阵型
		private function sCSwitchSquad(e : SCSwitchSquad) : void {
			// 阵型ID
			startFmK = e.id;
			setWaring();
			if (fistBo) {
				fistBo = false;
				return;
			}
			FMControler.instance.usingFm();
			SignalBusManager.formationChange.dispatch();
		}

		/**
		 * 服务器发送各个阵形的等级
		 */
		private function sCPlayerInfo(e : SCPlayerInfo) : void {
			var huint : Vector.<FormationInfo>;
			huint = e.formations;
			var vo : VoFM;
			for each (var i:FormationInfo in huint) {
				var ID : String = String(i.id);
				vo = FMManager.formationKindsDic[ID];
				vo.fm_level = i.level;
				// 位置列表((英雄ID << 8) + 位置编号) 位置 =  vo.fr_positionArr[hero&0xFF]   将领ID = hero>>8;
				var listVec : Vector.<uint> = i.position;
				var obj : Object;
				var vec : Vector.<Object> = new Vector.<Object>();
				for each (var num:uint in listVec) {
					obj = new Object();
					var id : int = num >> 8;
					var pos : int = num & 0xFF;
					obj["id"] = id;
					obj["pos"] = pos;
					vec.push(obj);
				}
				saveAllFMDic[ID] = vec;
			}
		}

		// -------------------------------cToS-------------------------------------
		// 英雄从退出当前出战状态
		public function outNowHeroWaring(pos : Number) : void {
			var cmd : CSSetSquad = new CSSetSquad();
			cmd.heroId = 0;
			cmd.formation = startFmK;
			cmd.position = pos;
			Common.game_server.sendMessage(0x1C, cmd);
			var heroVec : Vector.<Object> = saveAllFMDic[startFmK];
			var max : int = heroVec.length;
			for (var i : int = 0;i < max;i++) {
				var obj : Object = heroVec[i];
				if (pos == obj["pos"]) {
					heroVec.splice(i, 1);
					return;
				}
			}
		}

		// /---------------------------------------------------------------
		// 保存当前出战将领的出战状态
		private function setWaring() : void {
			var heroListVo : Vector.<VoHero> = UserData.instance.heroes;
			for each (var hero:VoHero in heroListVo) {
				hero.state = 0;
			}
			var objVec : Vector.<Object> = FMControlPoxy.saveAllFMDic[startFmK];
			var heroVo : VoHero;
			for each (var obj:Object in objVec) {
				var id : int = obj["id"];
				heroVo = HeroManager.instance.getTeamHeroById(id);
				heroVo.state = 3;
			}
			if (UserData.instance.userPanel)
				UserData.instance.userPanel.refreshHeros();
		}
	}
}
class Controler {
}
