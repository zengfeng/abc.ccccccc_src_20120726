package game.module.formation {
	import game.core.hero.HeroManager;
	import game.core.hero.VoHero;
	import game.core.item.prop.ItemProp;
	import game.core.item.prop.ItemPropManager;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.manager.SignalBusManager;
	import game.module.formation.centralPanel.CentralPanel;
	import game.module.formation.formationManage.FMManager;
	import game.module.formation.formationManage.VoFM;
	import game.module.formation.headPanel.HeadPanel;
	import game.module.formation.upgrade.UpgradePanel;

	import flash.utils.Dictionary;

	/**
	 * @author Lv
	 */
	public class FMControler
	{
		private static var _instance : FMControler;

		public function FMControler(controler : Controler) : void
		{
		}

		public static function get instance() : FMControler
		{
			if (_instance == null)
			{
				_instance = new FMControler(new Controler());
			}
			return _instance;
		}

		private var _centralMC : CentralPanel;
		private var _headMC : HeadPanel;
		private var _upgrade : UpgradePanel;

		public function centralMC() : CentralPanel
		{
			if (_centralMC == null)
			{
				_centralMC = new CentralPanel();
			}
			return _centralMC;
		}

		public function headMC() : HeadPanel
		{
			if (_headMC == null)
			{
				_headMC = new HeadPanel();
			}
			return _headMC;
		}

		public function upgrade() : UpgradePanel
		{
			if (_upgrade == null)
			{
				_upgrade = new UpgradePanel();
			}
			return _upgrade;
		}

		// ----------------------------------------------------------------------------
		// 招募将领
		public function recruitHero(heroID : int) : void
		{
			if (FMControlPoxy.isOpender == false) return;
			var hero : VoHero = HeroManager.instance.getTeamHeroById(heroID, 2);
			_headMC.RecruitHero(hero);
		}

		// 切换阵型
		public function changeFmToCenMC(id : int) : void
		{
			if (FMControlPoxy.isOpender == false) return;
			_centralMC.loaderFormation(id);
			_headMC.NowIsWaring(id);
		}

		// 删除在阵将领 并且取消出战 id:将领id
		public function deleteInFmHero(id : int) : void
		{
			if (FMControlPoxy.isOpender == false) return;
			_headMC.UnWaring(id);
			_centralMC.deleteInFmHero();
			SignalBusManager.heroWaringChange.dispatch(id, false);
		}

		// 将领出战 id:将领id
		public function heroGoWaring(id : int) : void
		{
			if (FMControlPoxy.isOpender == false) return;
			_headMC.Waring(id);
			_centralMC.addToFmHero(id);
			SignalBusManager.heroWaringChange.dispatch(id, true);
		}

		// 启用阵型成功
		public function usingFm() : void
		{
			if (FMControlPoxy.isOpender == false) return;
			_upgrade.usingFM();
		}

		// 解雇将领
		public function dismissHero() : void
		{
			if (FMControlPoxy.isOpender == false) return;
			_headMC.dismissHero();
			_centralMC.loaderFormation(FMControlPoxy.startFmK);
		}

		// 将领等级改变
		public function heroChangeLevel() : void
		{
			if (FMControlPoxy.isOpender == false) return;
			_upgrade.setItemList();
			_headMC.changeHeroLevel();
		}

		// 阵型升级和学习
		public function fmUpgrader(Fmid : int, Fmlevel : int) : void
		{
			if(!_upgrade){
				MenuManager.getInstance().getMenuButton(MenuType.FORMATION).addMenuMc(2, "新");
				return;
			}
			if (FMControlPoxy.isOpender == false) return;
			if (Fmid == FMControlPoxy.startFmK)
				changeFmToCenMC(Fmid);
			_upgrade.fmUpGraderItem(Fmid, Fmlevel);
		}

		// 左边出战将领拖动改变阵中位置
		public function changeFmPos(heroID : int) : void
		{
			if (FMControlPoxy.isOpender == false) return;
			_centralMC.leftChangeHeroStep(heroID);
		}

		// 左边未出战将领拖动到有将领的位置 交换出战英雄
		public function changeWaringState(heroID : int) : void
		{
			if (FMControlPoxy.isOpender == false) return;
			_centralMC.changeDeleteInFmHero();
			_centralMC.addToFmHero(heroID);
			SignalBusManager.heroWaringChange.dispatch(heroID, true);
		}

		public function changeWaring(heroID : int) : void
		{
			if (FMControlPoxy.isOpender == false) return;
			_headMC.Waring(heroID);
		}

		// 左边未出战将领拖动到有将领的位置 交换出战状态
		public function changeWaringStateLeft(heroID : int) : void
		{
			if (FMControlPoxy.isOpender == false) return;
			_headMC.UnWaring(heroID);
			SignalBusManager.heroWaringChange.dispatch(heroID, false);
		}

		// 清空central中的start位置
		public function clearnStartStep() : void
		{
			if (FMControlPoxy.isOpender == false) return;
			_centralMC.clearnStartStep();
		}

		// 获取将领在当前阵形中的加成
		public function getHeroFMProp(heroID : int) : ItemProp
		{
			var fmID : int = FMControlPoxy.startFmK;
			var FMdic : Dictionary = FMControlPoxy.saveAllFMDic;
			if (FMdic[fmID] == null) return null;
			var vecHeroPos : Vector.<Object> = FMdic[fmID];
			var leve : int = (FMManager.formationKindsDic[fmID] as VoFM).fm_level;
			var stepArr : Array = FMManager.formationStepTipDic[fmID];
			var stepID : String;
			var prop : ItemProp;
			for each (var obj:Object in vecHeroPos)
			{
				var id : int = obj["id"];
				if (id == heroID)
				{
					var pos : int = obj["pos"];
					var numStr : String;
					if (stepArr[pos] > 10)
						numStr = String(stepArr[pos]);
					else
						numStr = "0" + stepArr[pos];
					if (leve != 10)
						stepID = String(fmID) + "0" + String(leve) + numStr;
					else
						stepID = String(fmID) + "10" + numStr;

					prop = ItemPropManager.instance.getProp(int(stepID));
					return prop;
				}
			}
			return null;
		}

		public function getFormationProp(level : int, fmID : int, pos : int) : ItemProp
		{
			var stepArr : Array = FMManager.formationStepTipDic[fmID];
			var stepID : String;

			var numStr : String;
			if (stepArr[pos] > 10)
				numStr = String(stepArr[pos]);
			else
				numStr = "0" + stepArr[pos];
			if (level != 10)
				stepID = String(fmID) + "0" + String(level) + numStr;
			else
				stepID = String(fmID) + "10" + numStr;

			return ItemPropManager.instance.getProp(int(stepID));
		}
	}
}
class Controler
{
}
