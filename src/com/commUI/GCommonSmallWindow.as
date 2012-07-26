package com.commUI
{
	import com.utils.TextFormatUtils;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import game.core.menu.MenuManager;
	import game.core.menu.VoMenuButton;
	import game.definition.UI;
	import gameui.containers.GTitleWindow;
	import gameui.core.GAlign;
	import gameui.data.GPanelData;
	import gameui.data.GTitleBarData;
	import gameui.data.GTitleWindowData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;
	import net.AssetData;




	
	public class GCommonSmallWindow extends GTitleWindow
	{
		// =====================
		// 定义
		// =====================
		public static const EXTRA_TOP:uint = 30;
		public static const EXTRA_BOTTOM:uint = 5;
		public static const EXTRA_LEFT:uint = 0;
		public static const EXTRA_RIGHT:uint = 5;
		
		// =====================
		// 属性
		// =====================
        protected var _titleLabel:TextField = new TextField();
		protected var _background:Sprite;
		
		// =====================
		// Getter/Setter
		// =====================
		override public function set title(str : String) : void
		{
			_titleLabel.htmlText = str;
			_titleLabel.setTextFormat(TextFormatUtils.windowTitle);
		}
		
		// =====================
		// 方法
		// =====================
		public function GCommonSmallWindow(data:GTitleWindowData)
		{
			initWindowData(data);
			super(data);
			initViews();
		}
        
        protected function initWindowData(data : GTitleWindowData = null) : void
		{
			if (!data) return;
			
			var titleBarData : GTitleBarData = data.titleBarData;
			titleBarData.backgroundAsset = new AssetData(UI.COMMON_SMALL_WINDOW_TITLE_BACKGROUND);

			var panelData : GPanelData = data.panelData;
			panelData.bgAsset = new AssetData(SkinStyle.emptySkin);

//			data.align = new GAlign((UIManager.stage.stageWidth - data.width) / 2,-1,(UIManager.stage.stageHeight - data.height) / 2);
		}
		
		protected function initData():void
		{
		}
		protected function initViews():void
		{
		}
        
        override protected function create() : void
		{
			super.create();
			
			addBackground();
			addTitleLabel();
		}
		
		private function addBackground():void
		{
			_background = UIManager.getUI(new AssetData(UI.COMMON_WINDOW_BACKGROUND));
			addChildAt(_background, 0);
		}
		
		private function addTitleLabel():void
		{
			_titleLabel.embedFonts = true;
			_titleLabel.selectable = false;
			_titleLabel.mouseEnabled = false;
			_titleLabel.filters = [new DropShadowFilter(0,45,0x000000,1,5,5,2)];
			_titleLabel.width = _titleBar.width;
			_titleLabel.height = 28;
			_titleLabel.defaultTextFormat = TextFormatUtils.windowTitle;
			_titleBar.addChild(_titleLabel);
		}
		
		override protected function layout() : void
		{
			_background.width = _width + EXTRA_LEFT + EXTRA_RIGHT;
			_background.height = _height + EXTRA_TOP + EXTRA_BOTTOM;
			_background.y = - EXTRA_TOP;
			 
			_titleBar.width = _width;
			_titleBar.height = 29;
			_titleBar.y = - EXTRA_TOP;

			_contentPanel.x = 0;
			_contentPanel.y = 0;
			_contentPanel.width = _width;
			_contentPanel.height = _height;
			
			_closeButton.x = _titleBar.width - 25;
			_closeButton.y = -25;
			
			_titleLabel.y = (_titleBar.height - _titleLabel.height) / 2;
		}

		override protected function onClickClose(event : MouseEvent) : void
		{
			if (this.source is VoMenuButton)
			{
				MenuManager.getInstance().closeMenuView((this.source as VoMenuButton).id);
			}
			else
			{
				super.onClickClose(event);
			}
		}
	}
}