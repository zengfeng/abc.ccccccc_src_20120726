package game.module.recruitHero
{
	import game.core.hero.HeroManager;
	import game.core.hero.VoHero;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.core.user.UserData;
	import game.definition.UI;
	import game.manager.ViewManager;
	import game.module.recruitHero.highFindHero.HighFindHeroView;
	import game.module.sutra.SutraContral;
	import game.net.core.Common;
	import game.net.data.StoC.SCHeroNewList;

	import gameui.cell.GCell;
	import gameui.controls.GButton;
	import gameui.controls.GLabel;
	import gameui.controls.GTextArea;
	import gameui.core.GAlign;
	import gameui.data.GLabelData;
	import gameui.data.GTitleWindowData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.GCommonWindow;
	import com.commUI.button.KTButtonData;
	import com.utils.StringUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author Lv
	 */
	public class RecruitView extends GCommonWindow
	{
		// =====================
		// 属性
		// =====================
		private var _heroList : RecruitHeroList;
		private var _hintText : TextField;
		private var _hintIcon : Sprite;
		private var _castPanel : CastPanel;
		private var _heroArray : Array;
		private var _linkText : TextField;
		private var _highString : TextField;
		private var _currentText : GTextArea;

		// =====================
		// 方法
		// =====================
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------
		public function RecruitView()
		{
			var data : GTitleWindowData = new GTitleWindowData();
			data.width = 435;
			data.height = 440;
			data.allowDrag = true;
			data.parent = ViewManager.instance.uiContainer;
			super(data);
		}

		override protected function create() : void
		{
			super.create();

			title = "寻仙";
			addBg();
			addHelpIcon();
			addHelpMessage();
			addRecruitHeroList();
			addLinkText();

			super.initViews();
			GLayout.layout(this);
		}

		private function addBg() : void
		{
			var bg : Sprite = UIManager.getUI(new AssetData(UI.RECRUIT_HERO_VIEW_BG));
			bg.x = 5;
			bg.y = 0;
			bg.width = 420;
			bg.height = 435;
			_contentPanel.addChild(bg);

			// var data : KTButtonData = new KTButtonData(KTButtonData.SMALL_BUTTON);
			// data.width = 51;
			// data.height = 24;
			// data.x = 200;
			// data.y = 5;
			// var _buyButton:GButton = new GButton(data);
			// _buyButton.text = "购买";
			// //  _contentPanel.addChild(_buyButton);	
			// //  _buyButton.addEventListener(MouseEvent.CLICK, buyChTime);
			// var dataText:GLabelData = new GLabelData();
			// dataText.text = StringUtils.addColor(StringUtils.addLine("进入高级寻仙"),"#FF3300");
			// dataText.y = 5;
			// dataText.x = 330;
			// dataText.textFieldFilters = [];
			// var textBtn:GLabel = new GLabel(dataText);
			// _contentPanel.addChild(textBtn);
			// textBtn.addEventListener(MouseEvent.CLICK, buyChTime);
		}

		private function addLinkText() : void
		{
			_linkText = UICreateUtils.createTextField(null, "", 100, 20, 325, 8);
			_linkText.textColor = 0xff3300;
			_linkText.htmlText = "<b><u>进入高级寻仙</u></b>";
			_linkText.mouseEnabled = true;
			_linkText.selectable = false;
			_contentPanel.addChild(_linkText);
		}

		private var _high : HighFindHeroView;

		private function buyChTime(event : MouseEvent) : void
		{
			MenuManager.getInstance().openMenuView(MenuType.FINDHERO);
			// var str:String;	
			// MarqueeManager.instance.showMarquee(str);
		}

		private function addHelpIcon() : void
		{
			_hintIcon = UIManager.getUI(new AssetData(UI.RECRUIT_HERO_VIEW_HELP_ICON));
			_hintIcon.x = 18;
			_hintIcon.y = 9;
			_hintIcon.width = 17;
			_hintIcon.height = 13;

			var _myHero : VoHero = UserData.instance.myHero;
			if (_myHero.level < 40)
				_hintIcon.visible = true;
			else
				_hintIcon.visible = false;
			_contentPanel.addChild(_hintIcon);
		}

		private function addHelpMessage() : void
		{
			_hintText = new TextField();
			_hintText.x = 40;
			_hintText.y = 6;
			_hintText.width = 160;
			_hintText.textColor = 0x2F1F00;
			_hintText.text = "加深与名仙的交情可将其招募";
			_hintText.mouseEnabled = false;

			var _myHero : VoHero = UserData.instance.myHero;
			if (_myHero.level < 40)
				_hintText.visible = true;
			else
				_hintText.visible = false;
			_contentPanel.addChild(_hintText);
		}

		private function addRecruitHeroList() : void
		{
			_heroList = new RecruitHeroList();
			_heroList.x = 13;
			_heroList.y = 29;
			_contentPanel.addChild(_heroList);
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		private function updateHeroList() : void
		{
			// var heroes : Array = HeroManager.instance.teamHeroes.concat(HeroManager.instance.otherHeroes);
			var heroes : Array = [];
			var myHero : VoHero = HeroManager.instance.myHero;

			for each (var hero:VoHero in HeroManager.instance.allHeroes)
			{
				if (hero == myHero)
					continue;
				if (hero.preRecruitLevel > myHero.level)
					continue;
				heroes.push(hero);
			}

			// 将领排序
			var heroA : VoHero = new VoHero();
			var heroB : VoHero = new VoHero();
			var temp : VoHero = new VoHero();
			for (var i : int = 0; i < heroes.length; i++)
			{
				for (var j : int = 1; j < heroes.length - i; j++)
				{
					heroA = heroes[j - 1] as VoHero;
					heroB = heroes[j] as VoHero;
					if (heroA.recruitLevel < heroB.recruitLevel)
					{
						// 开启等级排名，高前低后
						temp = heroes[j - 1];
						heroes[j - 1] = heroes[j];
						heroes[j] = temp;
					}
					else if (heroA.recruitLevel == heroB.recruitLevel && heroA.sutra.stepValue < heroB.sutra.stepValue)
					{
						// 开启等级相同时，铸宝进度排名，高前低后（已招募过的将领铸炼进度为零）
						temp = heroes[j - 1];
						heroes[j - 1] = heroes[j];
						heroes[j] = temp;
					}
					else if (heroA.recruitLevel == heroB.recruitLevel && heroA.sutra.stepValue == heroB.sutra.stepValue && heroA.id < heroB.id)
					{
						// 开启等级相同，铸宝进度相同时，按名仙ID排名，高前低后
						temp = heroes[j - 1];
						heroes[j - 1] = heroes[j];
						heroes[j] = temp;
					}
				}
			}
			_heroList.source = heroes;
			_heroArray = heroes;
		}

		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		override protected function onShow() : void
		{
			super.onShow();
			updateHeroList();
			Common.game_server.addCallback(0x19, onHeroNewList);
			Common.game_server.addCallback(0xFFF1, cCUserDataChangeUp);
			// _heroList.addEventListener(GCell.SELECT, targetSelectHandler, true);
			_heroList.addEventListener(GCell.SINGLE_CLICK, targetSelectHandler, true);
			_linkText.addEventListener(MouseEvent.CLICK, buyChTime);
			_linkText.addEventListener(MouseEvent.ROLL_OVER, linkTextRollOverHandler);
			_linkText.addEventListener(MouseEvent.ROLL_OUT, linkTextRollOutHandler);
		}

		override protected function onHide() : void
		{
			Common.game_server.removeCallback(0x19, onHeroNewList);
			Common.game_server.removeCallback(0xFFF1, cCUserDataChangeUp);
			// _heroList.removeEventListener(GCell.SELECT, targetSelectHandler, true);
			_heroList.removeEventListener(GCell.SINGLE_CLICK, targetSelectHandler, true);
			_linkText.removeEventListener(MouseEvent.CLICK, buyChTime);
			_linkText.removeEventListener(MouseEvent.ROLL_OVER, linkTextRollOverHandler);
			_linkText.removeEventListener(MouseEvent.ROLL_OUT, linkTextRollOutHandler);

			if (_castPanel)
				_castPanel.hide();

			super.onHide();
		}

		private function linkTextRollOverHandler(event : MouseEvent) : void
		{
			_linkText.textColor = 0xff6633;
		}

		private function linkTextRollOutHandler(event : MouseEvent) : void
		{
			_linkText.textColor = 0xff3300;
		}

		private function targetSelectHandler(event : Event) : void
		{
			if (!_castPanel)
				_castPanel = new CastPanel();
			var _clickHero : VoHero = (event.target as GCell).source as VoHero;
			_castPanel.source = _clickHero;
			_castPanel.align = new GAlign(this.width, -1, -1, 0, -1, -1);
			_contentPanel.addChild(_castPanel);
			GLayout.layout(_castPanel);
		}

		// 新增将领
		private function onHeroNewList(e : SCHeroNewList) : void
		{
			if (e.heroes)
			{
				updateHeroList();
			}
		}

		// 将领等级提升
		private function cCUserDataChangeUp(...arg) : void
		{
			SutraContral.instance.refreshSubmit(UserData.instance.myHero.id);
			updateHeroList();
		}
	}
}
