package com.commUI {
	import game.core.menu.IMenu;
	import game.core.menu.MenuManager;
	import game.core.menu.VoMenuButton;
	import game.definition.UI;

	import gameui.containers.GTitleWindow;
	import gameui.data.GTitleBarData;
	import gameui.data.GTitleWindowData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import log4a.Logger;

	import net.AssetData;

	import com.utils.TextFormatUtils;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.utils.getTimer;

	/**
	 * @author yangyiqiang
	 */
	public class GCommonWindow extends GTitleWindow implements IMenu {
		// =====================
		// 定义
		// =====================
		public static const EXTRA_TOP : Number = 31;
		public static const EXTRA_BOTTOM : Number = 30;
		public static const EXTRA_LEFT : Number = 20;
		public static const EXTRA_RIGHT : Number = 16;
		// =====================
		// 属性
		// =====================
		protected var _titleLabel : TextField = new TextField();
		protected var _titleBg : DisplayObject;
		protected var _titleTassel : DisplayObject;
		protected var _leftTassel : DisplayObject;
		protected var _windowBG : DisplayObject;

		// =====================
		// 方法
		// =====================
		public function GCommonWindow(data : GTitleWindowData) {
			var t : int = getTimer();
			_data = data;
			initWindowData(data);
			initData();
			super(data);
			initViews();
			Logger.info("面板创建耗时 " + (getTimer() - t));
		}

		protected function initWindowData(data : GTitleWindowData) : GTitleWindowData {
			var titleBarData : GTitleBarData = new GTitleBarData();
			titleBarData.backgroundAsset = new AssetData(UI.COMMON_WINDOW_TITLE_BACKGROUND);
			titleBarData.height = EXTRA_TOP;
			titleBarData.y = -EXTRA_TOP;

			data.titleBarData = titleBarData;
			data.allowDrag = true;
			// data.align = new GAlign((UIManager.stage.stageWidth - data.width) / 2, -1, (UIManager.stage.stageHeight - data.height) / 2);

			data.panelData.bgAsset = new AssetData(SkinStyle.emptySkin);
			data.panelData.width = data.width;
			data.panelData.height = data.height;
			data.panelData.x = 0;
			data.panelData.y = 0;

			data.closeButtonData.width = 16;
			data.closeButtonData.height = 16;
			data.closeButtonData.upAsset = new AssetData(UI.COMMON_WINDOW_BUTTON_CLOSE_UP);
			data.closeButtonData.downAsset = new AssetData(UI.COMMON_WINDOW_BUTTON_CLOSE_DOWN);
			data.closeButtonData.overAsset = new AssetData(UI.COMMON_WINDOW_BUTTON_CLOSE_OVER);

			return data;
		}

		protected function initData() : void {
		}

		public function get outWidth() : Number {
			return this.width + EXTRA_LEFT + EXTRA_RIGHT;
		}

		protected function initViews() : void {
		}

		override protected function create() : void {
			addWindowBG();

			super.create();

			// 标题背景
			_titleBg = UIManager.getUI(new AssetData(UI.COMMON_WINDOW_TITLE_TEXTURE));
			_titleBar.addChild(_titleBg);

			// 穗子
			_titleTassel = UIManager.getUI(new AssetData(UI.COMMON_WINDOW_TITLE_TASSEL));
			_titleBar.addChild(_titleTassel);

			// 左边穗子
			_leftTassel = UIManager.getUI(new AssetData(UI.COMMON_WINDOW_LEFT_TASSEL));
			addChild(_leftTassel);

			// 标题
			_titleLabel.embedFonts = true;
			_titleLabel.selectable = false;
			_titleLabel.mouseEnabled = false;
			_titleLabel.defaultTextFormat = TextFormatUtils.windowTitle;
			_titleLabel.filters = [new DropShadowFilter(0, 45, 0x000000, 1, 5, 5, 2)];
			_titleLabel.width = width;
			_titleLabel.height = 28;
			_titleBar.addChild(_titleLabel);
		}

		private function addWindowBG() : void {
			_windowBG = UIManager.getUI(new AssetData(UI.COMMON_WINDOW_BACKGROUND));
			// _windowBG.alpha = 0.3;
			addChild(_windowBG);
		}

		override protected function layout() : void {
			_titleBar.width = _width;
			_windowBG.y = -10;
			_windowBG.x = 0;
			_windowBG.width = _width;
			_windowBG.height = _height + 15;

			_contentPanel.x = 0;
			_contentPanel.y = 0;
			_contentPanel.width = _width;
			_contentPanel.height = _height;

			_titleBar.x = -EXTRA_LEFT;
			_titleBar.width = EXTRA_LEFT + EXTRA_RIGHT + _width;

			_closeButton.x = _titleBar.width - 58;
			_closeButton.y = 5 - EXTRA_TOP;

			_titleLabel.x = 18;
			_titleLabel.y = (_titleBar.height - _titleLabel.height) / 2;
			_titleBg.x = (_titleBar.width - _titleBg.width) / 2;

			_titleTassel.x = _titleBar.width - 61;
			_titleTassel.y = -4;

			_leftTassel.x = -17;
			_leftTassel.y = _height + EXTRA_BOTTOM - _leftTassel.height;
		}

		protected var _menuId : int=-1;

		public function get menuId() : int {
			return _menuId;
		}

		public function set menuId(value : int) : void {
			_menuId = value;
		}

		override protected function onClickClose(event : MouseEvent) : void {
			if (this.source is VoMenuButton) {
				MenuManager.getInstance().closeMenuView((this.source as VoMenuButton).id);
			} else {
				super.onClickClose(event);
			}
		}

		override public function set title(str : String) : void {
			_titleLabel.htmlText = str;
			// _titleLabel.setTextFormat(TextFormatUtils.windowTitle);
		}

		public function changeState(value : uint) : void {
			// Abstract
			// 通用接口，用于改变窗口的特殊状态（页签，内容）
		}
	}
}
