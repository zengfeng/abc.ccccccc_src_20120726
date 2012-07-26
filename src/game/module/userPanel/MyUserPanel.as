package game.module.userPanel {
	import framerate.SecondsTimer;

	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.manager.SignalBusManager;
	import game.manager.ViewManager;
	import game.module.userBuffStatus.ui.BuffStatusContainer;

	import gameui.controls.GButton;
	import gameui.controls.GImage;
	import gameui.controls.GLabel;
	import gameui.controls.GMagicLable;
	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;
	import gameui.data.GImageData;
	import gameui.data.GLabelData;
	import gameui.manager.UIManager;
	import gameui.skin.ASSkin;

	import net.AssetData;
	import net.LibData;
	import net.RESManager;

	import com.commUI.button.KTButtonData;
	import com.commUI.tooltip.SimpleHeroTip;
	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipManager;
	import com.commUI.tooltip.WordWrapToolTip;
	import com.utils.StringUtils;
	import com.utils.TimeUtil;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;

	/**
	 * @author yangyiqiang
	 */
	public class MyUserPanel extends GComponent {
		public function MyUserPanel() {
			_base = new GComponentData();
			_base.parent = ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER);
			_base.align = new GAlign(0);
			_base.x = 3;
			_base.width = 245;
			_base.height = 96;
			super(_base);

			initView();
		}

		private var _back : Sprite;
		private var _userHead : GImage ;
		private var _name : GLabel;
		private var _level : GLabel;
		private var _vip : GLabel;
		private var _gold : GMagicLable;
		private var _goldB : GMagicLable;
		private var _silver : GMagicLable;
		private var _buffStatusContainer : BuffStatusContainer;
		private var _heroList : HeroList;
		private var _payBt : GButton;
		private var _wallowMc : MovieClip;
		private var _array : Array = [10, 6, 2];

		private function initView() : void {
			_back = UIManager.getUI(new AssetData("PlayerHeadPhoto_Bg"));
			addChild(_back);
			var _imgData : GImageData = new GImageData();
			_imgData.x = -4;
			_imgData.y = -52;
			_imgData.iocData.align = new GAlign(0);
			_imgData.libData = new LibData(UserData.instance.myHero.halfIocUrl, UserData.instance.myHero.halfIocUrl);
			_userHead = new GImage(_imgData);
			addChild(_userHead);

			_userHead.mouseEnabled = false;
			_userHead.mouseChildren = false;
			var mask : Sprite = ASSkin.emptySkin;
			mask.width = 83;
			mask.height = 83;
			addChild(mask);
			mask.addEventListener(MouseEvent.CLICK, onClick);
			ToolTipManager.instance.registerToolTip(mask, SimpleHeroTip, UserData.instance.myHero);

			var bag : Sprite = UIManager.getUI(new AssetData("PlayerHeadPhoto_Fg"));
			bag.y = 10;
			addChild(bag);
			var data : GLabelData = new GLabelData();
			data.textColor = 0xffcc00;
			data.width = 300;
			data.textFormat = UIManager.getTextFormat(14);
			data.x = 100;
			data.y = 3;
			_name = new GLabel(data);
			_name.htmlText = StringUtils.addColorById(StringUtils.addBold(UserData.instance.playerName), UserData.instance.myHero.color);
			addChild(_name);
			data = data.clone();
			data.x = 180;
			_vip = new GLabel(data);
			_vip.htmlText = StringUtils.addBold("VIP" + String(UserData.instance.vipLevel));
			addChild(_vip);
			if (UserData.instance.vipLevel <= 0) _vip.visible = false;

			data = data.clone();
			data.textFormat = UIManager.getTextFormat(12);
			data.y = 14;
			data.width = 30;
			data.text = String(UserData.instance.level);
			data.x = _array[data.text.length - 1];
			data.textFormat.align = TextFormatAlign.CENTER;
			_level = new GLabel(data);
			addChild(_level);

			data = data.clone();
			data.textFormat = UIManager.getTextFormat(12);
			data.x = 116;
			data.y = 30;
			data.width = 55;
			data.text = StringUtils.numToMillionString(UserData.instance.gold);
			_gold = new GMagicLable(data);
			_gold.setMagicText(StringUtils.numToMillionString(UserData.instance.gold), UserData.instance.gold, false);
			addChild(_gold);

			data = data.clone();
			data.x = 116;
			data.y = 48;
			data.text = StringUtils.numToMillionString(UserData.instance.silver);
			_silver = new GMagicLable(data);
			_silver.setMagicText(StringUtils.numToMillionString(UserData.instance.silver), UserData.instance.silver, false);
			addChild(_silver);

			data = data.clone();
			data.x = 180;
			data.y = 30;
			data.text = StringUtils.numToMillionString(UserData.instance.goldB);
			_goldB = new GMagicLable(data);
			_goldB.setMagicText(StringUtils.numToMillionString(UserData.instance.goldB), UserData.instance.goldB, false);
			addChild(_goldB);
			
			addTextMask();

			_buffStatusContainer = BuffStatusContainer.instance;
			_buffStatusContainer.x = 88;
			_buffStatusContainer.y = 75;
			addChild(_buffStatusContainer);

			_heroList = new HeroList();
			_heroList.y = 95;
			addChild(_heroList);
			SignalBusManager.heroWaringChange.add(onHeroFormationChange);

			var _data : GButtonData = new KTButtonData(KTButtonData.SMALL_RED_BUTTON);
			_data.width = 45;
			_data.height = 22;
			_data.x = 260;
			_data.y = 7;
			_payBt = new GButton(_data);
			_payBt.text = "充值";
			addChild(_payBt);

			if (UserData.instance.wallow) {
				initWallowIcon();
				StateManager.instance.checkMsg(345);
			}
		}

		private var _goldBoard : Sprite;
		private var _goldBBoard : Sprite;
		private var _silverBoard : Sprite;

		private function addTextMask() : void {
			_goldBoard=ASSkin.emptySkin;
			_goldBBoard=ASSkin.emptySkin;
			_silverBoard=ASSkin.emptySkin;
			_goldBoard.width=_goldBBoard.width=_silverBoard.width=60;
			_goldBoard.height=_goldBBoard.height=_silverBoard.height=20;
			
			_goldBoard.x=_silverBoard.x=96;
			_goldBBoard.x=156;
			
			_goldBoard.y=_goldBBoard.y=30;
			_silverBoard.y=48;
			
			addChild(_goldBoard);
			addChild(_goldBBoard);
			addChild(_silverBoard);
		}

		private function onHeroFormationChange(...arg) : void {
			_heroList.refresh();
		}

		private function initWallowIcon(show : Boolean = true) : void {
			WallowPanel;
			if (!show && _wallowMc) {
				ToolTipManager.instance.destroyToolTip(_wallowMc);
				SecondsTimer.removeFunction(execute);
				if (_wallowMc.parent) _wallowMc.parent.removeChild(_wallowMc);
				_wallowMc.removeEventListener(MouseEvent.CLICK, openWallow);
				MenuManager.getInstance().closeMenuView(139);
				return;
			}
			if (!_wallowMc) {
				_wallowMc = RESManager.getMC(new AssetData("wallowIcon", "lang_userPanel"));
				_wallowMc.mouseChildren = false;
				_wallowMc.buttonMode = true;
				// _wallowMc.x = 260;
				// _wallowMc.y = 7;
				_wallowMc.x = 260;
				_wallowMc.y = 40;
			}
			_wallowMc.addEventListener(MouseEvent.CLICK, openWallow);
			ToolTipManager.instance.registerToolTip(_wallowMc, WordWrapToolTip, getWallowToolTips);
			SecondsTimer.addFunction(execute);
			addChild(_wallowMc);
		}

		private function openWallow(event : MouseEvent) : void {
			if (UserData.instance.wallow == 2)
				StateManager.instance.checkMsg(344);
			else if (UserData.instance.wallow == 1)
				MenuManager.getInstance().changMenu(MenuType.WALLOW);
		}

		public function refreshWallow() : void {
			initWallowIcon(UserData.instance.wallow == 0 ? false : true);
		}

		private function getWallowToolTips() : String {
			return _wallowToolTip;
		}

		private var _wallowToolTip : String;
		private static var ANT_WALLOW : String = "你未通过防沉迷系统认证，每日在线3小时后打怪收益减半，在线5小时后打怪收益为0，请点击立刻认证。";

		public function execute() : void {
			_wallowToolTip = ANT_WALLOW + "\r" + "你已经玩了：" + TimeUtil.secondsToTime(++UserData.instance.wallowTime);
			if (UserData.instance.wallowTime == 1 * 60 * 60) StateManager.instance.checkMsg(352);
			if (UserData.instance.wallowTime == 2 * 60 * 60) StateManager.instance.checkMsg(353);
			if (UserData.instance.wallowTime == 3 * 60 * 60) StateManager.instance.checkMsg(346);
			if (UserData.instance.wallowTime == 5 * 60 * 60) StateManager.instance.checkMsg(347);
		}

		override public function show() : void {
			super.show();
			_payBt.addEventListener(MouseEvent.CLICK, _payBtClickHandler);
		}

		override public function hide() : void {
			_payBt.removeEventListener(MouseEvent.CLICK, _payBtClickHandler);
			super.hide();
		}

		private function _payBtClickHandler(event : MouseEvent) : void {
			MenuManager.getInstance().changMenu(MenuType.VIP);
		}

		public function refresh() : void {
			_name.htmlText = StringUtils.addColorById(StringUtils.addBold(UserData.instance.playerName), UserData.instance.myHero.color);
			_vip.htmlText = StringUtils.addBold("VIP " + String(UserData.instance.vipLevel));
			if (UserData.instance.vipLevel <= 0) _vip.visible = false;
			else _vip.visible = true;
			_level.text = String(UserData.instance.level);
			_level.x = _array[_level.text.length - 1];

			_gold.setMagicText(StringUtils.numToMillionString(UserData.instance.gold), UserData.instance.gold);
			_goldB.setMagicText(StringUtils.numToMillionString(UserData.instance.goldB), UserData.instance.goldB);
			_silver.setMagicText(StringUtils.numToMillionString(UserData.instance.silver), UserData.instance.silver);
		}

		public function getHeroList() : HeroList {
			return _heroList;
		}

		public function refreshHeros() : void {
			_heroList.refresh();
		}

		public function lockHeros(value : Boolean) : void {
			_heroList.lock = value;
		}

		public function getNextHeroCell() : HeroCell {
			return _heroList.getNextHeroCell();
		}

		public function showEnd(x : Number, y : Number, cell : Sprite) : void {
			_heroList.showEnd(x, y, cell);
		}

		private var timer : int = getTimer();

		private function onClick(event : MouseEvent) : void {
			if (getTimer() - timer < 500) return;
			timer = getTimer();
			MenuManager.getInstance().changMenu(MenuType.HERO_PANEL);
			SignalBusManager.heroPanelSelectHero.dispatch(UserData.instance.myHero.id);
		}

		private function provideGoldToolTip() : String {
			return UserData.instance.gold + "元宝";
		}

		private function provideGoldBToolTip() : String {
			return UserData.instance.goldB + "绑元宝";
		}

		private function provideSilverToolTip() : String {
			return UserData.instance.silver + "银币";
		}

		override protected function onShow() : void {
			super.onShow();
			ToolTipManager.instance.registerToolTip(_goldBoard, ToolTip, provideGoldToolTip);
			ToolTipManager.instance.registerToolTip(_silverBoard, ToolTip, provideSilverToolTip);
			ToolTipManager.instance.registerToolTip(_goldBBoard, ToolTip, provideGoldBToolTip);
		}

		override protected function onHide() : void {
			ToolTipManager.instance.destroyToolTip(_goldBoard);
			ToolTipManager.instance.destroyToolTip(_silverBoard);
			ToolTipManager.instance.destroyToolTip(_goldBBoard);
			super.onHide();
		}
	}
}
import game.core.hero.VoHero;
import game.core.menu.MenuManager;
import game.core.menu.MenuOpenAction;
import game.core.menu.MenuType;
import game.core.user.UserData;
import game.manager.SignalBusManager;

import gameui.controls.GButton;
import gameui.controls.GImage;
import gameui.core.GComponent;
import gameui.core.GComponentData;
import gameui.data.GButtonData;
import gameui.data.GImageData;
import gameui.manager.UIManager;

import net.AssetData;

import com.commUI.tooltip.SimpleHeroTip;
import com.commUI.tooltip.ToolTipManager;
import com.greensock.TweenLite;
import com.utils.HeroUtils;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.utils.getTimer;

/** 将领列表*/
class HeroList extends GComponent {
	private var _openBtn : GButton;
	private var _lock : Boolean = false;

	public function HeroList() {
		var data : GComponentData = new GComponentData();
		super(data);
		initView();
	}

	public function set lock(value : Boolean) : void {
		if (value == _lock) return;
		if (value) open();
		_lock = value;
	}

	private function initView() : void {
		var data : GButtonData = new GButtonData();
		data.downAsset = new AssetData("heroOpen");
		data.overAsset = new AssetData("heroOpenOver");
		data.upAsset = new AssetData("heroOpen");
		data.width = 16;
		data.height = 16;
		_openBtn = new GButton(data);
		_openBtn.addEventListener(MouseEvent.CLICK, onClick);
		addChild(_openBtn);
		initCells();
	}

	private var _openMc : MovieClip;

	public function showEnd(x : Number, y : Number, cell : Sprite) : void {
		_openMc = MenuOpenAction.instance.getOpenMc();
		_openMc.gotoAndPlay(0);
		_openMc.addEventListener("endFlash", onEnd);
		_openMc.x = x;
		_openMc.y = y;
		UIManager.root.addChild(_openMc);
		TweenLite.to(cell, 1, {alpha:0, onComplete:end, onCompleteParams:[cell]});
	}

	private function end(cell : Sprite) : void {
		if (cell && cell.parent) cell.parent.removeChild(cell);
	}

	private function onEnd(event : Event) : void {
		_openMc.removeEventListener("endFlash", onEnd);
		if (_openMc && _openMc.parent) _openMc.parent.removeChild(_openMc);
		lock = false;
		refresh();
	}

	/** true 不显示  false 显示 */
	private var _isShow : Boolean = false;
	private var _time : uint;

	private function onClick(event : MouseEvent) : void {
		if (_lock) return;
		if (getTimer() - _time < 500) return;
		_time = getTimer();
		_isShow = !_isShow;
		if (_isShow) {
			_openBtn.rotation = 180;
			_openBtn.x = 16;
			_openBtn.y = 16;
		} else {
			_openBtn.rotation = 0;
			_openBtn.x = 0;
			_openBtn.y = 0;
		}
		refresh();
	}

	public function open() : void {
		if (!_isShow) return;
		onClick(new MouseEvent(""));
	}

	public function getNextHeroCell() : HeroCell {
		for (var i : int = 0;i < _list.length;i++) {
			if (_list[i] == null) break;
		}
		var cell : HeroCell = new HeroCell(UIManager.root);
		var point : Point = this.localToGlobal(new Point(_listView[i].x, _listView[i].y));
		cell.x = point.x;
		cell.y = point.y;
		cell.mouseChildren = false;
		cell.mouseEnabled = false;
		return cell;
	}

	private function initCells() : void {
		var cell : HeroCell;
		for (var i : int = 0;i < MAX;i++) {
			cell = new HeroCell(this);
			cell.y = 20 + i * 44;
			_listView.push(cell);
		}
		refresh();
	}

	public static const MAX : int = 4;
	private var _list : Vector.<VoHero>=new Vector.<VoHero>();
	private var _listView : Vector.<HeroCell>=new Vector.<HeroCell>();

	public function refresh() : void {
		if (_lock) return;
		_list = new Vector.<VoHero>();
		for each (var vo:VoHero in UserData.instance.heroes) {
			if (vo.state == 3 && vo.id > 10) _list.push(vo);
		}
		_list.sort(HeroUtils.sortFun);
		for (var i : int = 0;i < MAX ;i++) {
			if (!_listView[i]) continue;
			_listView[i].source = i < _list.length ? _list[i] : null;
			if (_isShow) {
				_listView[i].hide();
			}
		}
	}
}
/**
 * 将领单元格
 */
class HeroCell extends GComponent {
	public function HeroCell(parent : Sprite) {
		var data : GComponentData = new GComponentData();
		data.parent = parent;
		super(data);
		initView();
	}

	private var _back : Sprite;
	private var _fore : Sprite;
	private var _hero : GImage;

	private function initView() : void {
		_back = UIManager.getUI(new AssetData("heroCell"));
		addChild(_back);
		var imgData : GImageData = new GImageData();
		_hero = new GImage(imgData);
		addChild(_hero);
		_fore = UIManager.getUI(new AssetData("heroCellOut"));
		addChild(_fore);
	}

	private function onClick(event : MouseEvent) : void {
		MenuManager.getInstance().openMenuView(MenuType.HERO_PANEL);
		SignalBusManager.heroPanelSelectHero.dispatch(_vo.id);
	}

	private function mouseDownHandler(event : MouseEvent) : void {
		if (event.ctrlKey && _vo) {
			SignalBusManager.sendToChatHero.dispatch(_vo);
			event.stopPropagation();
		}
	}

	private var _vo : VoHero;

	override public function set source(value : *) : void {
		_source = value;
		if (value is VoHero) {
			_vo = value;
			_hero.url = _vo.heroSmallHead;
			this.show();
		} else {
			_vo = null;
			this.hide();
		}
	}

	override protected function onShow() : void {
		super.onShow();
		addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		addEventListener(MouseEvent.CLICK, onClick);
		ToolTipManager.instance.registerToolTip(this, SimpleHeroTip);
	}

	override protected function onHide() : void {
		super.onHide();
		removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		removeEventListener(MouseEvent.CLICK, onClick);
		ToolTipManager.instance.destroyToolTip(this);
	}
}

