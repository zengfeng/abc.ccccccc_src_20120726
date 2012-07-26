package game.module.recruitHero.highFindHero
{
	import game.core.IAssets;
	import game.core.IModuleInferfaces;
	import game.core.hero.HeroManager;
	import game.core.hero.VoHero;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.item.ItemService;
	import game.core.item.pile.PileItem;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.definition.UI;
	import game.manager.VersionManager;
	import game.manager.ViewManager;
	import game.module.recruitHero.CastPanel;
	import game.net.core.Common;
	import game.net.data.CtoC.CCPackChange;
	import game.net.data.CtoS.CSHeroBetInfo;
	import game.net.data.StoC.SCHeroBet;
	import game.net.data.StoC.SCHeroBetInfo;

	import gameui.controls.GMagicLable;
	import gameui.core.GAlign;
	import gameui.core.ScaleMode;
	import gameui.data.GLabelData;
	import gameui.data.GTabData;
	import gameui.data.GTitleWindowData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;
	import net.LibData;
	import net.RESManager;

	import com.commUI.GCommonWindow;
	import com.commUI.icon.ItemIcon;
	import com.commUI.tooltip.FindHeroRuleTip;
	import com.commUI.tooltip.ToolTipManager;
	import com.commUI.tooltip.specialHeroToolTip;
	import com.greensock.TweenLite;
	import com.greensock.easing.Sine;
	import com.utils.FilterUtils;
	import com.utils.HeroUtils;
	import com.utils.StringUtils;
	import com.utils.UICreateUtils;
	import com.utils.UrlUtils;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;

	/**
	 * @author zheng
	 */
	public class HighFindHeroView extends GCommonWindow implements IAssets, IModuleInferfaces
	{
		// ===========================================================
		// @定义
		// ===========================================================
		private static const Stone : int = 3101;
		// 龙纹
		private static const Token : int = 3102;
		// 七星
		// ===========================================================
		// @属性
		// ===========================================================
		private var _allHeroListPanel : AllHeroList;
		private var _back : Sprite;
		private var _icoLable : TextField;
		private var _ico : MovieClip;
		private static var _tabDataHeroBox : GTabData;
		private var _textStone : GMagicLable;
		private var _textToken : GMagicLable;
		private var _textRemain : TextField;
		private var _textRule : TextField;
		private var _remainNum : TextField;
		private var _textGold : TextField;
		private var _goldTextScroll : TextField;
		private var _itemTextScroll : TextField;
		private var _findHeroPanel : FindHeroPanel;
		private var _blackbg1 : Sprite;
		private var _blackbg2 : Sprite;
		private var _item1 : ItemIcon;
		private var _item2 : ItemIcon;
		private var _isClosing : Boolean = false;
		
		private var _castPanel : CastPanel;

		// ===========================================================
		// @创建
		// ===========================================================
		public function HighFindHeroView()
		{
			var data : GTitleWindowData = new GTitleWindowData();
			data.width = 656;
			data.height = 447;
			data.parent = ViewManager.instance.uiContainer;
			data.panelData.bgAsset = new AssetData(SkinStyle.emptySkin);
			super(data);
		}

		private function addBg() : void
		{
			title = "高级寻仙";

			var bg : Sprite = UIManager.getUI(new AssetData("common_background_02"));
			if (!bg) return;
			bg.width = this.width - 15;
			bg.height = this.height - 6;
			bg.x = 5;
			bg.y = 0;
			this.contentPanel.add(bg);

			_ico = RESManager.getMC(new AssetData("icon_hint"));
			_ico.x = 21;
			_ico.y = 10;
			_icoLable = UICreateUtils.createTextField("通过请神可快速获得招募名仙的材料", null, 200, 18, 43, 8, UIManager.getTextFormat());
			this.contentPanel.add(_back);
			this.contentPanel.add(_ico);
			this.contentPanel.add(_icoLable);

			var findubg : Sprite = UIManager.getUI(new AssetData(UI.COMMON_BACKGROUND03));
			findubg.width = 626;
			findubg.height = 326;
			findubg.x = 13;
			findubg.y = 86;
			this.contentPanel.add(findubg);

			var findbg : Sprite = UIManager.getUI(new AssetData(UI.HIGH_FINDHERO_BACKROUND, "hfindhero"));
//			findbg.width = 622;
//			findbg.height = 322;
			findbg.x = 15;
			findbg.y = 88;
			this.contentPanel.add(findbg);

			_blackbg1 = UIManager.getUI(new AssetData(UI.HIGH_FINDHERO_BLACKBG, "hfindhero"));
			_blackbg1.width = 126;
			_blackbg1.height = 42;
			_blackbg1.x = 27;
			_blackbg1.y = 99;
			_blackbg1.mouseEnabled = true;
			this.contentPanel.add(_blackbg1);

			_blackbg2 = UIManager.getUI(new AssetData(UI.HIGH_FINDHERO_BLACKBG, "hfindhero"));
			_blackbg2.width = 126;
			_blackbg2.height = 42;
			_blackbg2.x = 27;
			_blackbg2.y = 152;
			_blackbg2.mouseEnabled = true;
			this.contentPanel.add(_blackbg2);

			var item1 : PileItem = ItemManager.instance.getPileItem(3101);
			_item1 = UICreateUtils.createItemIcon({x:27, y:98, showBorder:false, showNums:false, showToolTip:true, showRollOver:false});
			_item1.source = item1;
			_item1.x = 27;
			_item1.y = 99;
			this.contentPanel.addChild(_item1);

			var item2 : PileItem = ItemManager.instance.getPileItem(3102);
			_item2 = UICreateUtils.createItemIcon({x:27, y:150, showBorder:false, showNums:false, showToolTip:true, showRollOver:false});
			_item2.source = item2;
			_item2.showToolTip = true;
			_item2.x = 27;
			_item2.y = 150;
			this.contentPanel.addChild(_item2);
		}

		private function addHeroList() : void
		{
			var data : AllHeroListData = new AllHeroListData();
			data.tabData = tabDataHeroBox();
			data.tabData.toolTip = specialHeroToolTip;
//			data.tabData.enabled = true;

			data.rows = 1;
			data.cols = 9;

			_allHeroListPanel = new AllHeroList(data);
			_allHeroListPanel.x = 18;
			_allHeroListPanel.y = 30;
			addChild(_allHeroListPanel);
		}

		private function addLabels() : void
		{
			var data : GLabelData = new GLabelData();
			data.textFormat = UIManager.getTextFormat(12);
			data.x = 77;
			data.y = 118;
			data.width = 30;
			_textStone = new GMagicLable(data);
			_textStone.mouseChildren = false;
			_textStone.mouseEnabled = false;
			var data1 : GLabelData = new GLabelData();
			data1.textFormat = UIManager.getTextFormat(12);
			data1.x = 77;
			data1.y = 171;
			data1.width = 30;
			_textToken = new GMagicLable(data1);
			_textToken.mouseChildren = false;
			_textToken.mouseEnabled = false;

			this.contentPanel.add(_textStone);
			this.contentPanel.add(_textToken);

			var str : String = "玩法规则";
			str = StringUtils.addLine(str);
			_textRule = UICreateUtils.createTextField(null, str, 80, 18, 580, 92, UIManager.getTextFormat());
			_textRule.mouseEnabled = true;
			_textRule.selectable = false;
			this.contentPanel.addChild(_textRule);

			_textRemain = UICreateUtils.createTextField("今日免费请神次数：", null, 120, 18, 420, 380, UIManager.getTextFormat(12, 0xFFFF00));
			_textRemain.filters=[FilterUtils.iconTextEdgeFilter];
			this.contentPanel.addChild(_textRemain);

			_remainNum = UICreateUtils.createTextField("", null, 20, 18, 530, 380, UIManager.getTextFormat(12, 0xFFFF00));
			_remainNum.filters=[FilterUtils.iconTextEdgeFilter];
			this.contentPanel.addChild(_remainNum);

			_textGold = UICreateUtils.createTextField("元宝请神，大大提高福神出现概率", null, 200, 18, 420, 380, UIManager.getTextFormat(12, 0xFFFF00));
			_textGold.filters=[FilterUtils.iconTextEdgeFilter];
			this.contentPanel.addChild(_textGold);
			_textGold.visible = false;

			_goldTextScroll = UICreateUtils.createTextField(null, StringUtils.addBold("消耗50元宝"), 150, 22, 280, 200, UIManager.getTextFormat(16, 0x00ff00));
			_goldTextScroll.filters = [new GlowFilter(0x000000, 1, 2, 2, 3, 1)];
			// this.contentPanel.addChild(_goldTextScroll);
			_itemTextScroll = UICreateUtils.createTextField(null, "我是装备", 150, 22, 255, 240, UIManager.getTextFormat(16, 0x00ff00));
			_itemTextScroll.filters = [new GlowFilter(0x000000, 1, 2, 2, 3, 1)];
		}

		private function addFindHeroPanel() : void
		{
			_findHeroPanel = new FindHeroPanel();
			_findHeroPanel.x = 187;
			_findHeroPanel.y = 92;
			this.contentPanel.add(_findHeroPanel);
		}

		// ===========================================================
		// @刷新
		// ===========================================================
		private function onRefreshPanel(msg : SCHeroBet) : void
		{
			var godId : int = msg.type;
			var times : int = msg.count;
            var item:Item = ItemService.createItem(msg.item);
			_findHeroPanel.refreshGodMC(godId);
			_findHeroPanel.refreshBtn(times);

			onScrollBar(item.id, item.nums, godId);

			setReminLabel(times);
		}

		private function onRefreshItemLabel(msg : CCPackChange) : void
		{
			if (msg.topType == 32)
			{
				refreshItemLabel();
			}
		}

		private function onRefreshLabel(msg : SCHeroBetInfo) : void
		{
			var num : int = msg.count;
			setReminLabel(num);
			_findHeroPanel.refreshBtn(num);
		}

		private function refreshItemLabel() : void
		{
			var stoneNum : int = ItemManager.instance.getPileItemNums(3101);
			var tokenNum : int = ItemManager.instance.getPileItemNums(3102);

			setStoneNum(stoneNum);
			setTokenNum(tokenNum);
		}

		private function setReminLabel(num : int) : void
		{
			if (num == 0)
			{
				_textGold.visible = true;
				_textRemain.visible = false;
				_remainNum.visible = false;
			}
			else
			{
				_textGold.visible = false;
				_textRemain.visible = true;
				_remainNum.visible = true;
				_remainNum.text = num.toString();
			}
		}

		private function setStoneNum(num : int) : void
		{
			// _textStone.text=num.toString();
			_textStone.setMagicText(num.toString(), num, true);
		}

		private function setTokenNum(num : int) : void
		{
			// _textToken.text=num.toString();
			_textToken.setMagicText(num.toString(), num, true);
		}

		// ===============================================================
		// @交互
		// ===============================================================
		override protected function onShow() : void
		{
			super.onShow();

			_closeButton.addEventListener(MouseEvent.CLICK, hijack_closeClickHandler, false, 1000);
			// 寻仙结果
			Common.game_server.addCallback(0x79, onRefreshPanel);
			// 剩余寻仙次数
			Common.game_server.addCallback(0x78, onRefreshLabel);
			// 背包事件
			Common.game_server.addCallback(0xFFF2, onRefreshItemLabel);

			// ToolTipManager.instance.registerToolTip(_blackbg1, ToolTip, "龙纹钰玦");
			// ToolTipManager.instance.registerToolTip(_blackbg2, ToolTip, "七星符印");
			ToolTipManager.instance.registerToolTip(_textRule, FindHeroRuleTip, " ");
			// ToolTipManager.instance.registerToolTip(_blackbg2, ItemTip, provideItem2);
			
			_allHeroListPanel.addEventListener(Event.SELECT, heroTab_selectHandler);

			var cmd : CSHeroBetInfo = new CSHeroBetInfo();
			Common.game_server.sendMessage(0x78, cmd);
			refreshItemLabel();
			
		}
		override protected function onHide() : void
		{
			super.onHide();

			ToolTipManager.instance.destroyToolTip(this);
			// 进行寻仙
			Common.game_server.removeCallback(0x79, onRefreshPanel);
			// 剩余寻仙次数
			Common.game_server.removeCallback(0x78, onRefreshLabel);
			// 背包事件
			Common.game_server.removeCallback(0xFFF2, onRefreshItemLabel);

			ToolTipManager.instance.destroyToolTip(this);
			
			if (_castPanel)
		    _castPanel.hide();
			
		    _allHeroListPanel.selectionModel.removeEventListener(Event.CHANGE, heroTab_selectHandler);
			
			_allHeroListPanel.selectionModel.index=-1;

		}

        private function heroTab_selectHandler(event:Event):void
		{
			var hero:VoHero=_allHeroListPanel.selectedHero;
			
			if (!_castPanel)
				_castPanel = new CastPanel();
				
//			var _clickHero : VoHero = (event.target as GCell).source as VoHero;
			_castPanel.source = hero;
			_castPanel.align = new GAlign(this.width, -1, -1, 0, -1, -1);
			_contentPanel.addChild(_castPanel);
			GLayout.layout(_castPanel);
			
		}

		private function hijack_closeClickHandler(event : MouseEvent) : void
		{
			// if(getTimer()-_time<500)return;
			// _time=getTimer();
			event.stopPropagation();
			MenuManager.getInstance().openMenuView(MenuType.RECRUITHERO);
		}

		private function onScrollBar(itemid : int = 0, nums : int = 0, godId : int = 0, gold : int = 0) : void
		{
			var item : PileItem = ItemManager.instance.getPileItem(itemid);
			if (item != null)
			{
				var strItem : String = "获得";
				strItem += StringUtils.addColorById(item.name, item.color);
				strItem += "×" + nums.toString();
				strItem = StringUtils.addBold(strItem);
			}
			// godId 0 - 穷神  1 - 土地公公  2 - 财神  3 - 福神
			switch(godId)
			{
				case 0:
					break;
				case 1:
					_itemTextScroll.htmlText = StringUtils.addBold("下次获得材料×2");
					_itemTextScroll.y = 290;
					this.contentPanel.addChild(_itemTextScroll);
					TweenLite.to(_itemTextScroll, 1, {y:150, alpha:1, overwrite:1, onComplete:onComplete});
					break;
				case 2:
				case 3:
					_itemTextScroll.htmlText = strItem;
					_itemTextScroll.y = 290;
					_itemTextScroll.alpha = 0;
					this.contentPanel.addChild(_itemTextScroll);
					TweenLite.to(_itemTextScroll, 1, {y:150, alpha:1, overwrite:1, ease:Sine.easeOut, onComplete:onComplete});
					break;
			}

			// _goldTextScroll.y = 260;
			// _goldTextScroll.alpha = 0;
			// this.contentPanel.addChild(_goldTextScroll);
			// TweenLite.to(_goldTextScroll, 1, {y:230, alpha:1,overwrite:1,ease:Sine.easeOut, onComplete:onRemoveGold});
		}

		// ===========================================================
		// @其他
		// ===========================================================
		private function onComplete() : void
		{
			TweenLite.to(_itemTextScroll, 2, {y:100, alpha:0, overwrite:1, ease:Sine.easeOut, onComplete:onRemoveChild});
		}

		private function onRemoveChild() : void
		{
			if (this.contains(_itemTextScroll))
				this.contentPanel.removeChild(_itemTextScroll);
		}

		private function onRemoveGold() : void
		{
			if (this.contains(_goldTextScroll))
				this.contentPanel.removeChild(_goldTextScroll);
		}

		private function tabDataHeroBox() : GTabData
		{
			if (!_tabDataHeroBox)
			{
				var data : GTabData = new GTabData();
				data.scaleMode = ScaleMode.AUTO_WIDTH;
				data.width = 65;
				data.height = 50;

				data.upAsset = new AssetData(UI.BUTTON_BOXTAB_UNSEL_UP);
				data.overAsset = new AssetData(UI.BUTTON_BOXTAB_UNSEL_OVER);
				data.disabledAsset = new AssetData(SkinStyle.emptySkin);
				data.selectedUpAsset = new AssetData(UI.BUTTON_BOXTAB_SEL_UP);
				data.selectedDisabledAsset = new AssetData(SkinStyle.emptySkin);

				data.labelData.textColor = 0xBEBEBE;
				data.labelData.align = new GAlign(-1, -1, -1, -1, 0, 0);
				data.textRollOverColor = 0xFFFFFF;
				data.textSelectedColor = 0xEFEFEF;
				data.selected = true;
				data.padding = 0;
				data.gap = 4;

				_tabDataHeroBox = data;
			}
			return _tabDataHeroBox;
		}

		public function getResList() : Array
		{
//			return [new LibData(VersionManager.instance.getUrl("assets/swf/advancedFindHero.swf"), "hfindhero")];			
			var res:Array = [];
			
			for each (var hero:VoHero in HeroManager.instance.allHeroes.filter(HeroUtils.filterOtherHeroColor).sort(HeroUtils.sortOtherHeroColor))
			{
				res.push (hero.heroImage);
			}
			
			res.push(new LibData(VersionManager.instance.getUrl("assets/swf/advancedFindHero.swf"), "hfindhero"));
			res.push(new LibData(UrlUtils.getLangSWF("highHeroFind.swf"),"highHeroFindFont"));
			
			return res;			
		}

		public function initModule() : void
		{
			addBg();
			addHeroList();
			addFindHeroPanel();
			addLabels();
		}
	}
}
