package com.commUI
{
	import game.core.user.UserData;
	import game.definition.UI;
	import game.net.core.Common;

	import gameui.controls.GMagicLable;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GLabelData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipManager;
	import com.utils.StringUtils;

	import flash.display.Sprite;

	/**
	 * @author jian
	 */
	public class MoneyBoard extends GComponent
	{
		// =====================
		// 属性
		// =====================
		private var _goldBoard : Sprite;

		private var _goldBBoard : Sprite;

		private var _silverBoard : Sprite;

		private var _goldText : GMagicLable;

		private var _silverText : GMagicLable;

		private var _goldBText : GMagicLable;

		// =====================
		// 方法
		// =====================
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------
		public function MoneyBoard()
		{
			super(new GComponentData());
		}

		override protected function create() : void
		{
			super.create();
			addBackground();
			addGold();
		}

		private function addBackground() : void
		{
			var bg : Sprite = UIManager.getUI(new AssetData(UI.MONEY_BOARD_BACKGROUND));
			addChild(bg);
		}
		
		private function addGold() : void
		{
			_goldBoard = new Sprite;
			_goldBoard.x = 2;
			_goldBoard.y = 2;
			addChild(_goldBoard);

			var icon : Sprite = UIManager.getUI(new AssetData(UI.MONEY_ICON_GOLD));
			icon.x = 0;
			icon.y = 2;
			_goldBoard.addChild(icon);
			
			var data : GLabelData = new GLabelData();
			data.textFormat = UIManager.getTextFormat(12);
			data.x = 14;
			data.y=-2;
			data.width = 50;
			_goldText = new GMagicLable(data);
			_goldBoard.addChild(_goldText);
			
			
			_silverBoard = new Sprite;
			_silverBoard.x = 2;
			_silverBoard.y = 18;
			addChild(_silverBoard);
			icon = UIManager.getUI(new AssetData(UI.MONEY_ICON_SILVER));
			icon.x = 0;
			icon.y = 2;
			_silverBoard.addChild(icon);
			data = data.clone();
			_silverText = new GMagicLable(data);
			_silverBoard.addChild(_silverText);
			
			_goldBBoard = new Sprite;
			_goldBBoard.x = 67;
			_goldBBoard.y = 2;
			addChild(_goldBBoard);
			icon = UIManager.getUI(new AssetData(UI.MONEY_ICON_GOLDB));
			icon.x = 0;
			icon.y = 2;
			_goldBBoard.addChild(icon);
			data = data.clone();
			_goldBText = new GMagicLable(data);
			_goldBBoard.addChild(_goldBText);
			
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		private function updateView(showM:Boolean=true) : void
		{
			_goldText.setMagicText(StringUtils.numToMillionString(UserData.instance.gold), UserData.instance.gold,showM);
			_silverText.setMagicText(StringUtils.numToMillionString(UserData.instance.silver), UserData.instance.silver,showM);
			_goldBText.setMagicText(StringUtils.numToMillionString(UserData.instance.goldB), UserData.instance.goldB,showM);
		}

		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		override protected function onShow() : void
		{
			super.onShow();
			updateView(false);
			Common.game_server.addCallback(0x1F, onPlayerInfoChange);
			ToolTipManager.instance.registerToolTip(_goldBoard, ToolTip, provideGoldToolTip);
			ToolTipManager.instance.registerToolTip(_silverBoard, ToolTip, provideSilverToolTip);
			ToolTipManager.instance.registerToolTip(_goldBBoard, ToolTip, provideGoldBToolTip);
		}

		override protected function onHide() : void
		{
			Common.game_server.removeCallback(0x1F, onPlayerInfoChange);
			ToolTipManager.instance.destroyToolTip(_goldBoard);
			ToolTipManager.instance.destroyToolTip(_silverBoard);
			ToolTipManager.instance.destroyToolTip(_goldBBoard);
			super.onHide();
		}

		private function onPlayerInfoChange(...arg) : void
		{
			updateView();
		}

		private function provideGoldToolTip() : String
		{
			return UserData.instance.gold + "元宝";
		}

		private function provideGoldBToolTip() : String
		{
			return UserData.instance.goldB + "绑元宝";
		}

		private function provideSilverToolTip() : String
		{
			return UserData.instance.silver + "银币";
		}
	}
}
