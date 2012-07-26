package game.module.sutra {
	import game.core.item.functionItem.FunManage;
	import game.config.StaticConfig;
	import game.core.IAssets;
	import game.core.IModuleInferfaces;
	import game.core.hero.HeroManager;
	import game.core.hero.VoHero;
	import game.core.item.sutra.Sutra;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.core.menu.VoMenuButton;
	import game.core.prop.PropManager;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.definition.UI;
	import game.manager.SignalBusManager;
	import game.manager.ViewManager;
	import game.module.quest.guide.GuideMange;
	import game.net.core.Common;
	import game.net.data.StoC.SCHeroEnhance;

	import gameui.core.GAlign;
	import gameui.data.GTitleWindowData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;

	import net.AssetData;
	import net.LibData;
	import net.RESManager;

	import com.commUI.GCommonWindow;
	import com.commUI.herotab.HeroTabList;
	import com.utils.UICreateUtils;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author Lv
	 */
	public class SutraView extends GCommonWindow implements IModuleInferfaces ,IAssets {
		private var herolist : HeroTabList;
		private var heroID : int = -1;
		private var heroSutra : Sutra;
		private var sutraIMG : SutraImg;
		private var sutraSubmit : SutraSubmitPanel;
		private var showSignArr : Array = ["dodge", "crit", "pierce", "counter"];
		private var isInited : Boolean = false;
		private var _askSelectHeroId : uint = 0;

		public function SutraView() {
			_data = new GTitleWindowData();
			super(_data);
			initEvents();
		}

		override protected function initData() : void {
			_data.width = 675;
			_data.height = 438;
			_data.parent = ViewManager.instance.uiContainer;
			_data.allowDrag = true;
			super.initData();
		}

		private function initEvents() : void {
			Common.game_server.addCallback(0x15, sCHeroEnhance);
			Common.game_server.addCallback(0xFFF1, cCUserDataChangeUp);
			SignalBusManager.sutraPanelSelectHero.add(onExternalSelectHero);
		}

		private function removeEvent() : void {
			Common.game_server.removeCallback(0x15, sCHeroEnhance);
			Common.game_server.removeCallback(0xFFF1, cCUserDataChangeUp);
			SignalBusManager.sutraPanelSelectHero.remove(onExternalSelectHero);
		}

		private function onExternalSelectHero(heroId : uint) : void {
			if (isInited)
				herolist.selectHero(heroId);
			else
				_askSelectHeroId = heroId;
		}

		private function cCUserDataChangeUp(...arg) : void {
			SutraContral.instance.refreshSubmit(heroID);
		}

		private function onSelectCell(event : Event) : void {
			heroID = (herolist.selection as VoHero).id;
			SutraContral.instance.refreshSubmit(heroID);
		}

		private var effectsWord : MovieClip;

		private function sCHeroEnhance(e : SCHeroEnhance) : void {
			var hero : VoHero = HeroManager.instance.getTeamHeroById(e.id);
			// hero.runetotemID = e
			var oldStep : Number = hero.sutra.step;
			var sutra : Sutra = hero.sutra;
			sutra.step = e.wpLevel;
			if (sutra.step == 0) {
				SutraContral.instance.weapLevelUp(sutra);
				return;
			}
			if (oldStep == sutra.step) {
				SutraContral.instance.refreshSubmit(e.id);
				return;
			}
			if (hero) {
				SutraContral.instance.weapLevelUp(sutra);
			}
			GuideMange.getInstance().checkGuideByMenuid(MenuType.SUTRA);
			StateManager.instance.checkMsg(177, [sutra.name], null, [sutra.step]);
			var max : int = sutra.getNowDeltaPropKey.length;
			for (var i : int = 0; i < max;i++) {
				var key : String = sutra.getNowDeltaPropKey[i];
				var nameStr : String = PropManager.instance.getPropByKey(key).name;
				var value : Number = sutra.prop[key] + sutra.stepProp[key];

				for (var i1 : int = 0;i1 < showSignArr.length;i1++) {
					if (key == showSignArr[i1]) {
						StateManager.instance.checkMsg(176, [nameStr], null, [value]);
						return;
					}
				}
				if (key == "magic_per") {
					var str1 : String = sutra.stepNOwEffect;
					if (str1 == null) return;
					StateManager.instance.checkMsg(397, [str1]);
					return;
				}
				StateManager.instance.checkMsg(180, [nameStr], null, [value]);
			}
			if (max == 0) {
				var str : String = sutra.stepNOwEffect;
				if (str == null) return;
				StateManager.instance.checkMsg(397, [str]);
			}
			if (!effectsWord) {
				effectsWord = RESManager.getMC(new AssetData("orderUpSuccess", "commonAction"));
			}
			effectsWord.x = 203;
			effectsWord.y = 167;
			_contentPanel.addChild(effectsWord);
			effectsWord.gotoAndPlay(1);
		}

		override protected function onClickClose(event : MouseEvent) : void {
//			GuideMange.getInstance().checkGuideByMenuid(MenuType.SUTRA);
			if (this.source is VoMenuButton) {
				MenuManager.getInstance().closeMenuView((this.source as VoMenuButton).id);
			} else {
				super.onClickClose(event);
			}
		}

		public function initModule() : void {
			title = "法宝";
			addBG();
			addpanel();
			super.initViews();
			isInited = true;

			if (_askSelectHeroId != 0) {
				herolist.selectHero(heroID);
				_askSelectHeroId = 0;
			}
		}

		private function addpanel() : void {
			heroID = UserData.instance.myHero.id;

			heroSutra = UserData.instance.myHero.sutra;
			// var goodsID:int = UserData.instance.myHero.sutra;
			herolist = new HeroTabList(UICreateUtils.heroListDataLeft);
			herolist.x = 5;
			herolist.y = 0;
			_contentPanel.addChild(herolist);
			herolist.selectHero(heroID);

			sutraIMG = SutraContral.instance.sutraImg();
			sutraIMG.x = 90;
			sutraIMG.y = 12;
			_contentPanel.addChild(sutraIMG);

			sutraSubmit = SutraContral.instance.sutraSubmit();
			sutraSubmit.y = 30;
			sutraSubmit.x = 445;
			_contentPanel.addChild(sutraSubmit);

			// SutraContral.instance.refreshSubmit(heroID);
			herolist.selectionModel.addEventListener(Event.CHANGE, onSelectCell);
		}

		private function addBG() : void {
			var bg : Sprite = UIManager.getUI(new AssetData(UI.TRADE_BACKGROUND_BIG));
			bg.x = 76;
			bg.y = 0;
			bg.width = 600 - 10;
			bg.height = 440 - 10;
			_contentPanel.addChild(bg);
		}

		override public function show() : void {
			this.align = new GAlign((UIManager.stage.stageWidth - this.width) / 2, -1, (UIManager.stage.stageHeight - this.height) / 2, -1);
			GLayout.layout(this);
			super.show();
			initEvents();
		}

		override protected function onHide() : void {
//			GuideMange.getInstance().checkGuideByMenuid(MenuType.SUTRA);
			removeEvent();
			super.onHide();
			setSutrBtn();
		}

		private function setSutrBtn() : void {
			var sutra : Sutra = UserData.instance.myHero.sutra;
			var hero : VoHero = UserData.instance.myHero;

			var upStepLine : int;
			if (hero.config.sutraUp < FunManage.instance.getSutraUp(hero.level))
				upStepLine = hero.config.sutraUp;
			else
				upStepLine = FunManage.instance.getSutraUp(hero.level);

			if (sutra.step != upStepLine) {
				if (UserData.instance.profExp > sutra.nextSetpExp - 1)
					MenuManager.getInstance().getMenuButton(MenuType.SUTRA).addMenuMc(3, "!");
			}
		}

		public function getResList() : Array {
			var heroListVo : Vector.<VoHero> = UserData.instance.heroes;
			var arr : Array = new Array();
			arr.push(new LibData(StaticConfig.cdnRoot + "assets/ui/sutra.swf", "sutraSwf"));
			for each (var hero:VoHero in heroListVo) {
				var idStr : String = String(hero.sutra.id);
				arr.push(new LibData(StaticConfig.cdnRoot + ("assets/weapMC/" + idStr + ".swf"), String(idStr)));
				arr.push(hero.heroImage);
			}
			return arr;
		}
	}
}
