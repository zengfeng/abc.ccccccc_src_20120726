package game.module.soul.abyss
{
	import game.core.menu.IMenu;
	import worlds.apis.MSelfPlayer;
	import net.SWFLoader;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Bounce;
	import com.utils.UrlUtils;

	import game.core.IAssets;
	import game.core.IModuleInferfaces;
	import game.core.avatar.AvatarFight;
	import game.core.avatar.AvatarManager;
	import game.core.avatar.AvatarPlayer;
	import game.core.avatar.AvatarType;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.item.soul.Soul;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.definition.UI;
	import game.manager.VersionManager;
	import game.manager.ViewManager;
	import game.module.quest.guide.GuideMange;
	import game.net.core.Common;
	import game.net.data.CtoC.CCVIPLevelChange;
	import game.net.data.CtoS.CSAbyssAuto;
	import game.net.data.CtoS.CSAbyssChallenge;
	import game.net.data.CtoS.CSAbyssCount;
	import game.net.data.CtoS.CSAbyssLoot;
	import game.net.data.CtoS.CSAbyssLootSingle;
	import game.net.data.StoC.SCAbyssAward;
	import game.net.data.StoC.SCAbyssLootResult;

	import gameui.containers.GPanel;
	import gameui.controls.GButton;
	import gameui.controls.GCheckBox;
	import gameui.controls.GGradientLabel;
	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.core.ScaleMode;
	import gameui.data.GButtonData;
	import gameui.data.GCheckBoxData;
	import gameui.data.GPanelData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import log4a.Logger;

	import net.AssetData;
	import net.LibData;
	import net.RESManager;

	import com.commUI.MoneyBoard;
	import com.commUI.MovieClipButton;
	import com.commUI.button.KTButtonData;
	import com.commUI.labelButton.LabelButton;
	import com.commUI.labelButton.LabelButtonData;
	import com.commUI.tooltip.ToolTipManager;
	import com.commUI.tooltip.WordWrapToolTip;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	import com.greensock.easing.Sine;
	import com.utils.ColorUtils;
	import com.utils.FilterUtils;
	import com.utils.ItemUtils;
	import com.utils.StringUtils;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	/**
	 * @author jian
	 */
	public class AbyssView extends GPanel implements IModuleInferfaces, IAssets, IMenu
	{
		// ===============================
		// 定义
		// ===============================
		public static const BOSS_AVATAR_IDS : Array = ["5015", "5016", "5017", "5018"];
		public static const BOSS_NAMES : Array = ["百年妖兽", "千年妖兽", "万年妖兽", "洪荒妖兽"];
		private static const HERO_POSITION : Point = new Point(825, 490);
		private static const BOSS_POSITION : Point = new Point(580, 305);
		private static const FIGHT_POSITION : Point = new Point(650, 342);
		// ===============================
		// 属性
		// ===============================
		private var _silverSummonLeft : int = 0;
		private var _goldSummonLeft : int = 0;
		private var _silverSummonCount : int = 0;
		private var _goldSummonCount : int = 0;
		private var _isRecover : Boolean = false;
		private var _awardIndex : uint = 0;
		private var _fighting : Boolean = false;
		private var _packOpen : Boolean = false;
		// 场景
		private var _darkLayer : Sprite;
		private var _screenLayer : GComponent;
		private var _moneyBoard : GComponent;
		// private var _nameBoard : Sprite;
		// 角色
		private var _heroAvatar : AvatarPlayer;
		private var _bossAvatar : AvatarFight;
		// 召唤区域
		private var _consolePanel : Sprite;
		private var _consoleSkinNormal : Sprite;
		private var _consoleSkinVIP : Sprite;
		private var _silverSummonButton : MovieClipButton;
		private var _goldSummonButton : MovieClipButton;
		private var _silverSummonLabel : GGradientLabel;
		private var _goldSummonLabel : GGradientLabel;
		private var _batchCKBox : GCheckBox;
		private var _awardBar : ShuffleBar;
		private var _fightAwards : Array /* of Souls */;
		private var _lootButton : LabelButton;
		private var _leftButton : GButton;
		private var _rightButton : GButton;
		// private var _batchCKText : TextField;
		private var _exitButton : GButton;
		private var _packButton : SimpleButton;
		private var _firstLoaded : Boolean = true;
		private var _waitingReplay : Boolean = false;

		// 其它
		// ===============================
		// @方法
		// ===============================
		/*
		 * 构造函数
		 */
		public function AbyssView()
		{
			var data : GPanelData = new GPanelData();
			data.bgAsset = new AssetData(SkinStyle.emptySkin);
			data.align = new GAlign(0, 0, 0, 0);
			data.parent = ViewManager.instance.getContainer(ViewManager.FULL_SCREEN_UI);
			super(data);
		}
		
		/*
		 * 添加背景
		 */
		private function addDarkLayer() : void
		{
			_darkLayer = UIManager.getUI(new AssetData(UI.BLACK_BACKGROUND));
			addChild(_darkLayer);
		}

		private function addScreenLayer() : void
		{
			var data : GComponentData = new GComponentData();
			data.width = 1600;
			data.height = 800;

			_screenLayer = new GComponent(data);

			var bitmapData : BitmapData = RESManager.getBitmapData(new AssetData("abyssmap", "abyss"));
			var map : Bitmap = new Bitmap(bitmapData);
			map.x = (1600 - map.width) / 2;
			map.y = -290;

			_screenLayer.addChild(map);
			addChild(_screenLayer);
		}

		/*
		 * 添加自动召唤按钮
		 */
		private function addConsole() : void
		{
			var data : GComponentData = new GComponentData();
			data.width = 540;
			data.height = 220;

			_consolePanel = new GComponent(data);
			_screenLayer.addChild(_consolePanel);

			_consoleSkinNormal = UIManager.getUI(new AssetData(UI.ABYSS_CONSOLE_NORMAL, "abyss"));
			_consolePanel.addChild(_consoleSkinNormal);

			_consoleSkinVIP = UIManager.getUI(new AssetData(UI.ABYSS_CONSOLE_VIP, "abyss"));
			_consolePanel.addChild(_consoleSkinVIP);
		}

		private function addShuffleBar() : void
		{
			_awardBar = new ShuffleBar(10);
			_awardBar.x = -250;
			_awardBar.y = -40;
			_consolePanel.addChild(_awardBar);

			_leftButton = new GButton(UICreateUtils.buttonDataShiftLeft);
			_leftButton.x = -285;
			_leftButton.y = -25;
			_consolePanel.addChild(_leftButton);

			_rightButton = new GButton(UICreateUtils.buttonDataShiftRight);
			_rightButton.x = 270;
			_rightButton.y = -25;
			_consolePanel.addChild(_rightButton);
		}

		/*
		 * 添加召唤按钮
		 */
		private function addSummonButtons() : void
		{
			var silverButtonData : GButtonData = new GButtonData();
			silverButtonData.scaleMode = ScaleMode.SCALE_NONE;
			silverButtonData.disabledAsset = new AssetData(UI.ABYSS_SUMMON_BUTTON_UP, "abyss");
			silverButtonData.upAsset = new AssetData(UI.ABYSS_SUMMON_BUTTON_UP, "abyss");
			silverButtonData.overAsset = new AssetData(UI.ABYSS_SUMMON_BUTTON_OVER, "abyss");
			silverButtonData.downAsset = new AssetData(UI.ABYSS_SUMMON_BUTTON_DOWN, "abyss");
			_silverSummonButton = new MovieClipButton(silverButtonData);
			_silverSummonLabel = UICreateUtils.createGradientLabel({width:100, height:25, x:(_silverSummonButton.width - 100) * 0.5 + 5, y:_silverSummonButton.height - 15, gradientAsset:new AssetData("GGradientLabel_skin"), textFormat:TextFormatUtils.graphicLabel, textFieldFilters:[FilterUtils.gradientTextEdgeFilter]});
			_silverSummonButton.addChild(_silverSummonLabel);

			var goldButtonData : GButtonData = new GButtonData();
			goldButtonData.scaleMode = ScaleMode.SCALE_NONE;
			goldButtonData.disabledAsset = new AssetData(UI.ABYSS_GOLD_SUMMON_BUTTON_UP, "abyss");
			goldButtonData.upAsset = new AssetData(UI.ABYSS_GOLD_SUMMON_BUTTON_UP, "abyss");
			goldButtonData.overAsset = new AssetData(UI.ABYSS_GOLD_SUMMON_BUTTON_OVER, "abyss");
			goldButtonData.downAsset = new AssetData(UI.ABYSS_GOLD_SUMMON_BUTTON_DOWN, "abyss");
			_goldSummonButton = new MovieClipButton(goldButtonData);
			_goldSummonLabel = UICreateUtils.createGradientLabel({width:100, height:25, x:(_goldSummonButton.width - 100) * 0.5 - 16, y:_goldSummonButton.height - 20, gradientAsset:new AssetData("GGradientLabel_skin"), textFormat:TextFormatUtils.graphicLabel, textFieldFilters:[FilterUtils.gradientTextEdgeFilter]});
			_goldSummonButton.addChild(_goldSummonLabel);

			var data : GCheckBoxData = UICreateUtils.checkBoxDataDark.clone();

			data.x = -30;
			data.y = 120;
			data.labelData.text = "批量召唤";
			_batchCKBox = new GCheckBox(data);

			_consolePanel.addChild(_silverSummonButton);
			_consolePanel.addChild(_goldSummonButton);
			_consolePanel.addChild(_batchCKBox);
		}

		private function getSilverSummonTip() : String
		{
			if (_silverSummonLeft == 0)
				return "今日召唤次数已满";
			else
				return "花费" + StringUtils.addColor(AbyssUtils.SILVER_SUMMON_COST * _silverSummonCount + "银币", ColorUtils.HIGHLIGHT_DARK) + "随机召唤" + StringUtils.addColor(_silverSummonCount + "次", ColorUtils.HIGHLIGHT_DARK) + "妖兽，今日还可召唤" + StringUtils.addColor(_silverSummonLeft + "次", ColorUtils.HIGHLIGHT_DARK);
		}

		private function getGoldSummonTip() : String
		{
			if (_goldSummonLeft == 0)
				return "今日召唤次数已满";
			else
				return "花费" + StringUtils.addColor(AbyssUtils.GOLD_SUMMON_COST * _goldSummonCount + "元宝", ColorUtils.HIGHLIGHT_DARK) + "指定召唤" + StringUtils.addColor(_goldSummonCount + "次", ColorUtils.HIGHLIGHT_DARK) + "洪荒妖兽，今日还可召唤" + StringUtils.addColor(_goldSummonLeft + "次", ColorUtils.HIGHLIGHT_DARK);
		}

		/*
		 * 添加其他按钮
		 */
		private function addOtherButtons() : void
		{
			var exitButtonData : GButtonData = new GButtonData();

			exitButtonData.align = new GAlign(-1, 20, 20);
			exitButtonData.upAsset = new AssetData(UI.BUTTON_EXIT_UP);
			exitButtonData.overAsset = new AssetData(UI.BUTTON_EXIT_OVER);
			exitButtonData.downAsset = new AssetData(UI.BUTTON_EXIT_DOWN);
			exitButtonData.scaleMode = ScaleMode.SCALE_NONE;
			// exitButtonData.width = 50;
			// exitButtonData.height = 48;
			_exitButton = new GButton(exitButtonData);
			// _exitButton = UICreateUtils.createRedButton("退出", 0, 0, 500, 300);
			addChild(_exitButton);

			// _lootButton = UICreateUtils.createRedButton("拾取元神", 0, 0, HERO_POSITION.x - 45, HERO_POSITION.y - 20);
			var data : LabelButtonData = UICreateUtils.labelButtonData.clone();
			data.width = 56;
			_lootButton = new LabelButton(data);
			_lootButton.y = -60;
			_lootButton.htmlText = "<a>全部拾取</a>";

			_lootButton.visible = false;
			_consolePanel.addChild(_lootButton);
		}

		private function addMoneyBoard() : void
		{
			_moneyBoard = new MoneyBoard();
			addChild(_moneyBoard);
		}

		private function addSoulPack() : void
		{
			var buttonClass : Class = RESManager.getClass(new AssetData(UI.ABYSS_SOUL_PACK, "abyss"));
			_packButton = new buttonClass();
			_packButton.mouseEnabled = true;
			_screenLayer.addChild(_packButton);
		}

		/*
		 * 创建将领
		 */
		private function createHero() : void
		{
			_heroAvatar = AvatarManager.instance.getAvatar(UserData.instance.myHero.id, AvatarType.PLAYER_BATT_BACK, UserData.instance.myHero.cloth) as AvatarPlayer;
			_heroAvatar.mouseEnabled = false;
			_heroAvatar.mouseChildren = false;
			_heroAvatar.setName(UserData.instance.playerName, ColorUtils.TEXTCOLOR[UserData.instance.myHero.color]);
			_heroAvatar.showName();
			_heroAvatar.setAction(AvatarManager.BT_STAND);

			updateHeroPosition();

			_screenLayer.addChildAt(_heroAvatar, _screenLayer.getChildIndex(_consolePanel));
		}

		private function removeHero() : void
		{
			if (_heroAvatar)
			{
				_screenLayer.removeChild(_heroAvatar);
				_heroAvatar.dispose();
				_heroAvatar = null;
			}
		}

		/*
		 * 创建Boss
		 */
		private function createBoss(id : uint) : void
		{
			_bossAvatar = new AvatarFight();

			_bossAvatar.x = BOSS_POSITION.x;
			_bossAvatar.y = BOSS_POSITION.y;
			_bossAvatar.initAvatar(id, AvatarType.MONSTER_TYPE);
			_bossAvatar.setName(BOSS_NAMES[id]);
			_bossAvatar.showName();
			_bossAvatar.setAction(0);
			_bossAvatar.showNameAndHPbar(false);
			_bossAvatar.setAction(AvatarManager.BT_STAND, 1);

			_screenLayer.addChildAt(_bossAvatar, _screenLayer.getChildIndex(_heroAvatar));
		}

		/*
		 * 移除Boss
		 */
		private function removeBoss() : void
		{
			if (_bossAvatar && this.contains(_bossAvatar))
			{
				_screenLayer.removeChild(_bossAvatar);
				_bossAvatar.dispose();
				_bossAvatar = null;
			}
		}

		/*
		 * 布局
		 */
		override protected function layout() : void
		{
			if (!parent)
				return;

			_width = parent.stage.stageWidth;
			_height = parent.stage.stageHeight;

			GLayout.layout(_exitButton);

			_darkLayer.width = _width;
			_darkLayer.height = _height;

			_screenLayer.x = (_width - _screenLayer.width) / 2;
			_screenLayer.y = (_height - _screenLayer.height) / 2;

			// _nameBoard.x = _width - _nameBoard.width;

			_consolePanel.x = _screenLayer.width * 0.5 + 20;
			_consolePanel.y = Math.max(0, (_height - _screenLayer.height) * 0.2) + 523;

			_packButton.x = _consolePanel.x + 420;
			_packButton.y = _consolePanel.y;
		}

		// -----------------------------------------------------
		// 更新
		// -----------------------------------------------------
		private function updateSummonButtons() : void
		{
			if (_batchCKBox.selected)
			{
				_silverSummonCount = Math.min(10, _silverSummonLeft);
				_goldSummonCount = Math.min(10, _goldSummonLeft);
				_silverSummonLabel.text = "随机" + _silverSummonCount + "次";
				_goldSummonLabel.text = "高级" + _goldSummonCount + "次";
			}
			else
			{
				_silverSummonCount = 1;
				_goldSummonCount = 1;
				_silverSummonLabel.text = "随机召唤";
				_goldSummonLabel.text = "高级召唤";
			}

			// _silverSummonButton.enabled = (_silverSummonLeft > 0);
			// _goldSummonButton.enabled = (_goldSummonLeft > 0);
		}

		private function updateSummonButtonsForVIP() : void
		{
			if (UserData.instance.vipLevel < AbyssUtils.GOLD_VIP_LEVEL)
			{
				_consoleSkinNormal.visible = true;
				_consoleSkinVIP.visible = false;
				_goldSummonButton.visible = false;
				_silverSummonButton.x = -38;
				_silverSummonButton.y = 20;
			}
			else
			{
				_consoleSkinNormal.visible = false;
				_consoleSkinVIP.visible = true;
				_goldSummonButton.visible = true;
				_goldSummonButton.x = 23.5;
				_goldSummonButton.y = 8;
				_silverSummonButton.x = -92;
				_silverSummonButton.y = 20;
			}

			if (UserData.instance.vipLevel < AbyssUtils.BATCH_VIP_LEVEL)
			{
				_batchCKBox.visible = false;
			}
			else
			{
				_batchCKBox.visible = true;
			}
		}

		private function addAwardToShuffleBar(award : AwardIcon, shuffle : Boolean = true, keepPosition : Boolean = true) : void
		{
			ToolTipManager.instance.registerToolTip(award, ItemUtils.getItemToolTipClass(award.source), award.source);
			if (keepPosition)
				keepPositionAddChild(_awardBar, award);
			else
				_awardBar.addChild(award);

			award.showName = true;
			award.showRollOver = true;

			if (shuffle)
				_awardBar.shuffle();
			updateShuffleButton();
		}

		private function removeAwardFromShuffleBar(award : AwardIcon, shuffle : Boolean = true, keepPosition : Boolean = true) : void
		{
			ToolTipManager.instance.destroyToolTip(award);
			TweenLite.killTweensOf(award);

			if (keepPosition)
				keepPositionAddChild(_screenLayer, award);
			else
				_awardBar.removeChild(award);
			award.showName = false;
			award.showRollOver = false;
			award.looting = true;

			if (shuffle)
				_awardBar.shuffle();
			updateShuffleButton();
		}

		private function updateShuffleButton() : void
		{
			_leftButton.visible = _awardBar.moreLeft;
			_rightButton.visible = _awardBar.moreRight;
		}

		private function updateLootButton() : void
		{
			if (_fighting || _awardBar.numChildren == 0)
				_lootButton.visible = false;
			else
				_lootButton.visible = true;
		}

		private function updateHeroPosition() : void
		{
			_heroAvatar.x = HERO_POSITION.x;
			_heroAvatar.y = HERO_POSITION.y;
		}

		// -----------------------------------------------------
		// 交互
		// -----------------------------------------------------
		/*
		 * 进入面板
		 */
		override protected function onShow() : void
		{
			super.onShow();
			GuideMange.getInstance().checkGuide(24, 1, _silverSummonButton);
			_packOpen = false;
			updateSummonButtonsForVIP();
			initAwards();
			layout();
			Common.game_server.addCallback(0x292, onRecvAbyssInfo);
			Common.game_server.addCallback(0x293, onAbyssLootResult);
			Common.game_server.addCallback(0xFFF7, onVIPLevelChange);
			_exitButton.addEventListener(MouseEvent.CLICK, exitButtonHandler);
			_silverSummonButton.addEventListener(MouseEvent.CLICK, silverSummonBossHandler);
			_goldSummonButton.addEventListener(MouseEvent.CLICK, goldSummonBossHandler);
			_batchCKBox.addEventListener(Event.CHANGE, batchChangeHandler);
			_packButton.addEventListener(MouseEvent.CLICK, soulPackClickHandler);
			_awardBar.addEventListener(ShuffleBarEvent.SELECT, awardBar_selectHandler);
			_awardBar.addEventListener(Event.RESIZE, awardBar_resizeHandler);
			_leftButton.addEventListener(MouseEvent.CLICK, leftButton_clickHandler);
			_rightButton.addEventListener(MouseEvent.CLICK, rightButton_clickHandler);
			ToolTipManager.instance.registerToolTip(_silverSummonButton, WordWrapToolTip, getSilverSummonTip);
			ToolTipManager.instance.registerToolTip(_goldSummonButton, WordWrapToolTip, getGoldSummonTip);
			sendAbyssInfoRequest();
			createHero();

			
			if (_firstLoaded)
			{
				var res:RESManager = RESManager.instance;
				for each (var monsterId:int in BOSS_AVATAR_IDS)
				{
					var uuid:int = AvatarManager.instance.getUUId(monsterId, AvatarType.MONSTER_TYPE);
					var url:String = UrlUtils.getAvatar(uuid);
					res.add(new SWFLoader(new LibData(url, url,  true, false), AvatarManager.instance.getAvatarBD(uuid).parse, [url]));
					
				}
				res.startLoad();
				
				_firstLoaded = false;
			}
		}

		/*
		 * 退出面板
		 */
		override protected function onHide() : void
		{
			removeHero();
			Common.game_server.removeCallback(0x292, onRecvAbyssInfo);
			Common.game_server.removeCallback(0x293, onAbyssLootResult);
			Common.game_server.removeCallback(0xFFF7, onVIPLevelChange);
			_exitButton.removeEventListener(MouseEvent.CLICK, exitButtonHandler);
			_silverSummonButton.removeEventListener(MouseEvent.CLICK, silverSummonBossHandler);
			_goldSummonButton.removeEventListener(MouseEvent.CLICK, goldSummonBossHandler);
			_batchCKBox.removeEventListener(Event.CHANGE, batchChangeHandler);
			_packButton.removeEventListener(MouseEvent.CLICK, soulPackClickHandler);
			_awardBar.removeEventListener(ShuffleBarEvent.SELECT, awardBar_selectHandler);
			_awardBar.removeEventListener(Event.RESIZE, awardBar_resizeHandler);
			_leftButton.removeEventListener(MouseEvent.CLICK, leftButton_clickHandler);
			_rightButton.removeEventListener(MouseEvent.CLICK, rightButton_clickHandler);
			ToolTipManager.instance.destroyToolTip(_silverSummonButton);
			ToolTipManager.instance.destroyToolTip(_goldSummonButton);
			super.onHide();
		}

		private function leftButton_clickHandler(event : MouseEvent) : void
		{
			_awardBar.shuffleRight();
			updateShuffleButton();
		}

		private function rightButton_clickHandler(event : MouseEvent) : void
		{
			_awardBar.shuffleLeft();
			updateShuffleButton();
		}

		private function awardBar_selectHandler(event : ShuffleBarEvent) : void
		{
			var award : AwardIcon = event.cell as AwardIcon;

			if (_fighting)
				return;

			if (award.looting)
				return;

			if (award.lastClickTime != 0 && getTimer() - award.lastClickTime < 50)
				return;

			if (UserData.instance.tryPutPack(1) >= 0)
			{
				award.lastClickTime = getTimer();
				award.looting = true;
				sendAbyssLootSingle(award.index);
			}
		}

		private function awardBar_resizeHandler(event : Event) : void
		{
			if (_awardBar.numChildren == 0)
			{
				// _lootButton.visible = false;
			}
			else
			{
				// _lootButton.visible = true;
				var newX : Number = _awardBar.x + (_awardBar.width - _lootButton.width) * 0.5;

				TweenLite.to(_lootButton, 0.4, {x:newX, ease:Quint.easeOut});
			}
		}

		private function soulPackClickHandler(event : MouseEvent) : void
		{
			// var menuButton : IMenuButton = MenuManager.getInstance().getMenuButton(MenuType.SOUL);
			//
			// if (_packOpen)
			// {
			// menuButton.target.removeEventListener(MouseEvent.MOUSE_DOWN, focusInBlocker);
			// menuButton.target.hide();
			// _packOpen = false;
			// }
			// else
			// {
			// menuButton.target.addEventListener(MouseEvent.MOUSE_DOWN, focusInBlocker, false, 9999);
			// UIManager.root.addChild(menuButton.target);
			// _packOpen = true;
			// }
			MenuManager.getInstance().changMenu(MenuType.SOUL);
		}

		private function focusInBlocker(event : MouseEvent) : void
		{
			event.stopImmediatePropagation();
		}

		private function onVIPLevelChange(msg : CCVIPLevelChange) : void
		{
			updateSummonButtonsForVIP();
		}

		private function batchChangeHandler(event : Event) : void
		{
			updateSummonButtons();
		}

		/*
		 * 响应召唤Boss按钮
		 */
		private function silverSummonBossHandler(event : MouseEvent) : void
		{
			if (_fighting || _waitingReplay)
				return;

			if (_silverSummonLeft <= 0)
			{
				StateManager.instance.checkMsg(234);
				return;
			}

			if (_batchCKBox.selected)
			{
				if (UserData.instance.trySpendSilver(AbyssUtils.SILVER_SUMMON_COST * _silverSummonCount) >= 0)
				{
					GuideMange.getInstance().checkGuideByMenuid(MenuType.SOUL_ABYSS, 2, _lootButton);
					sendAbyssAutoChallenge(false);
				}
			}
			else
			{
				if (UserData.instance.trySpendSilver(AbyssUtils.SILVER_SUMMON_COST) >= 0)
				{
					GuideMange.getInstance().checkGuideByMenuid(MenuType.SOUL_ABYSS, 2, _lootButton);
					sendAbyssChallenge(false);
				}
			}
		}

		/*
		 * 响应自动召唤Boss按钮
		 */
		private function goldSummonBossHandler(event : MouseEvent) : void
		{
			if (_fighting || _waitingReplay)
				return;

			if (_goldSummonLeft <= 0)
			{
				StateManager.instance.checkMsg(234);
				return;
			}

			if (_batchCKBox.selected)
			{
				if (UserData.instance.trySpendTotalGold(AbyssUtils.GOLD_SUMMON_COST * _goldSummonCount) >= 0)
				{
					GuideMange.getInstance().checkGuideByMenuid(MenuType.SOUL_ABYSS, 2, _lootButton);
					sendAbyssAutoChallenge(true);
				}
			}
			else
			{
				if (UserData.instance.trySpendTotalGold(AbyssUtils.GOLD_SUMMON_COST) >= 0)
				{
					GuideMange.getInstance().checkGuideByMenuid(MenuType.SOUL_ABYSS, 2, _lootButton);
					sendAbyssChallenge(true);
				}
			}
		}

		/*
		 * 响应退出按钮
		 */
		private function exitButtonHandler(event : MouseEvent) : void
		{
			MenuManager.getInstance().closeMenuView(MenuType.SOUL_ABYSS);
			MenuManager.getInstance().openMenuView(MenuType.SOUL);
		}

		private function setAwards(awards : Vector.<uint>) : void
		{
			_fightAwards = [];
			for each (var key:uint in awards)
			{
				var id : uint = key & 0x7FFF;
				var binding : Boolean = (key & 0x8000) != 0;
				var nums : uint = key >> 16;

				var item : Item = ItemManager.instance.newItem(id);

				if (!item)
				{
					// trace("错误的元神奖励" + id);
					continue;
				}

				item.nums = nums;
				item.binding = binding;

				_fightAwards.push(new AwardIcon(item, _awardIndex));
				_awardIndex++;
			}
		}

		private function initAwards() : void
		{
			clearTotalAwards();
			updateShuffleButton();
			_awardIndex = 0;
		}

		private function clearTotalAwards() : void
		{
			_fightAwards = [];
			_awardBar.removeAllChild();
		}

		private function recoverAwards(awards : Vector.<uint>) : void
		{
			GuideMange.getInstance().checkGuideByMenuid(MenuType.SOUL_ABYSS, 2, _lootButton);

			setAwards(awards);

			for each (var award:AwardIcon in _fightAwards)
			{
				addAwardToShuffleBar(award, false, false);
			}

			_awardBar.shuffle();
		}

		/*
		 * 收到服务器通知开始战斗
		 */
		private function choseBoss(bosses : Vector.<uint>) : void
		{
			var bossChosen : uint = 0;

			for each (var boss:uint in bosses)
			{
				if (boss > bossChosen)
					bossChosen = boss;
			}

			removeBoss();
			createBoss(BOSS_AVATAR_IDS[bossChosen]);
			// _summonGroup.selectionModel.index = bossChosen;
		}

		// ------------------------------------------------
		// 战斗流程
		// ------------------------------------------------
		/*
		 * 开始战斗
		 */
		private function startBattle() : void
		{
			bossAppear();
			_fighting = true;
			updateLootButton();
		}

		/*
		 * Boss出现
		 */
		private function bossAppear() : void
		{
			_bossAvatar.y = -40;
			TweenLite.to(_bossAvatar, 0.2, {y:BOSS_POSITION.y});
			var appearMc : MovieClip = RESManager.getMC(new AssetData("abyss_boss_appear", "abyss"));
			appearMc.x = BOSS_POSITION.x;
			appearMc.y = BOSS_POSITION.y - 100;
			_screenLayer.addChildAt(appearMc, 1);
			appearMc.gotoAndPlay(0);
			setTimeout(heroApproch, 550);
		}

		/*
		 * 英雄走进Boss
		 */
		private function heroApproch() : void
		{
			TweenLite.to(_heroAvatar, 0.2, {x:FIGHT_POSITION.x, y:FIGHT_POSITION.y, ease:Sine.easeOut, onComplete:heroAttack});
		}

		/*
		 * 英雄攻击
		 */
		private function heroAttack() : void
		{
			_heroAvatar.player.addEventListener(Event.COMPLETE, heroAttackComplete);
			_heroAvatar.setAction(AvatarManager.ATTACK, 1, 0);
			setTimeout(bossHurt, 30);
		}

		/*
		 * Boss受挫
		 */
		private function bossHurt() : void
		{
			TweenLite.to(_bossAvatar, 0.3, {x:_bossAvatar.x - 3, y:_bossAvatar.y - 30, ease:Bounce.easeOut});
			_bossAvatar.setAction(AvatarManager.HURT, 1);
		}

		/*
		 * 英雄攻击完成
		 */
		private function heroAttackComplete(event : Event) : void
		{
			_heroAvatar.player.removeEventListener(Event.COMPLETE, heroAttackComplete);
			_heroAvatar.setAction(AvatarManager.BT_STAND);
			TweenLite.to(_heroAvatar, 0.2, {x:HERO_POSITION.x, y:HERO_POSITION.y, ease:Sine.easeOut});
			bossDown();
		}

		/*
		 * Boss倒下
		 */
		private function bossDown() : void
		{
			// _bossAvatar.die();
			// _bossAvatar.fadeQuit(null);
			_bossAvatar.hideShodow();
			setTimeout(soulFallOut, 150);
			TweenLite.to(_bossAvatar, 0.2, {alpha:0, onComplete:removeBoss});
			// setTimeout(removeBoss, 300);
		}

		/*
		 * 元神飞出
		 */
		private function soulFallOut() : void
		{
			var len : uint = _fightAwards.length;
			var awardBarPt : Point = _screenLayer.globalToLocal(_awardBar.localToGlobal(new Point(0, 0)));

			for (var i : uint = 0; i < len; i++)
			{
				var award : AwardIcon = _fightAwards[i];
				award.x = BOSS_POSITION.x - 20;
				award.y = BOSS_POSITION.y - 70;
				award.arrived = false;
				award.alpha = 0.5;
				award.scaleX = 0.2;
				award.scaleY = 0.2;

				_screenLayer.addChild(award);

				var thru1 : Point = new Point(BOSS_POSITION.x - 260, BOSS_POSITION.y - 100);
				var thru2 : Point = new Point(awardBarPt.x - 200, awardBarPt.y - 150);
				var to : Point = new Point(awardBarPt.x - 50, awardBarPt.y);

				TweenMax.to(award, 1.2 + 0.1 * i, {delay:0.1 * i, bezierThrough:[{x:thru1.x, y:thru1.y}, {x:thru2.x, y:thru2.y}, {x:to.x, y:to.y}], ease:Sine.easeIn, onComplete:onSoulArrive, onCompleteParams:[award]});
				TweenLite.to(award, 0.4, {alpha:1, scaleX:1, scaleY:1});
				setTimeout(_awardBar.shuffleRightMost, 1200);
			}
		}

		/*
		 * 元神飞到物品格
		 */
		private function onSoulArrive(award : AwardIcon = null) : void
		{
			addAwardToShuffleBar(award);

			// _awardBar.addChild(award);

			award.arrived = true;

			for each (var icon:AwardIcon in _fightAwards)
			{
				if (!icon.arrived)
					return;
			}

			onAllSoulArrive();
		}

		private function onAllSoulArrive() : void
		{
			_lootButton.addEventListener(MouseEvent.CLICK, lootAwardHandler);
			_fighting = false;
			updateLootButton();
		}

		/*
		 * 拾取元神
		 */
		private function lootAwardHandler(event : MouseEvent) : void
		{
			// GuideMange.getInstance().checkGuideByMenuid(MenuType.SOUL);

			if (UserData.instance.tryPutPack(getSoulCount()) >= 0)
				sendAbyssLootAll();
		}

		private function getSoulCount() : int
		{
			var i : int = 0;
			for each (var award:AwardIcon in _awardBar.allChildren)
			{
				if (award.source is Soul)
					i++;
			}
			return i;
		}

		private function lootAllAward() : void
		{
			_lootButton.removeEventListener(MouseEvent.CLICK, lootAwardHandler);

			var i : uint = 0;
			for each (var award:AwardIcon in _awardBar.visibleChildren)
			{
				removeAwardFromShuffleBar(award, false);
				if (award.source is Soul)
					flyAwardToPack(award, 1 - 0.05 * i);
				else
					vanishAward(award);
				i++;
			}

			clearTotalAwards();
			updateShuffleButton();
			updateLootButton();
			GuideMange.getInstance().checkGuideByMenuid(MenuType.SOUL_ABYSS, 3);
		}

		private function lootSingleAward(index : uint) : void
		{
			for each (var award:AwardIcon in _awardBar.allChildren)
			{
				if (award.index == index)
				{
					_fightAwards.slice(_fightAwards.indexOf(award.source));
					removeAwardFromShuffleBar(award);

					if (award.source is Soul)
						flyAwardToPack(award);
					else
						vanishAward(award);

					break;
				}
			}
			GuideMange.getInstance().checkGuideByMenuid(MenuType.SOUL_ABYSS, 3);
			updateShuffleButton();
			updateLootButton();
		}

		private function flyAwardToPack(award : AwardIcon, time : Number = 1) : void
		{
			// trace(award.x, award.y);
			TweenLite.to(award, time, {x:_packButton.x + _packButton.width * 0.5, y:_packButton.y + _packButton.height * 0.5, alpha:0.2, ease:Sine.easeIn, onComplete:onAwardLooted, onCompleteParams:[award]});
		}

		private function vanishAward(award : AwardIcon) : void
		{
			var vanishMC : MovieClip = RESManager.getMC(new AssetData(UI.GOLD_VANISH, "abyss"));
			vanishMC.x = award.x - 15;
			vanishMC.y = award.y - 10;
			_screenLayer.addChild(vanishMC);
			vanishMC.gotoAndPlay(1);

			TweenLite.to(award, 0.2, {alpha:0, ease:Sine.easeIn, onComplete:onAwardLooted, onCompleteParams:[award]});
		}

		private function onAwardLooted(award : AwardIcon) : void
		{
			award.looting = false;
			award.destroy();
		}

		// ------------------------------------------------
		// 发送消息到服务器
		// ------------------------------------------------
		// 请求上次未拾取的结果
		private function sendAbyssInfoRequest() : void
		{
			Logger.info("客户端请求上次结果");
			_isRecover = true;

			var msg : CSAbyssCount = new CSAbyssCount();
			Common.game_server.sendMessage(0x295, msg);
		}

		/*
		 * 发送拾取元神数据包
		 */
		private function sendAbyssLootAll() : void
		{
			Logger.info("客户端请求全部拾取");
			var msg : CSAbyssLoot = new CSAbyssLoot();
			Common.game_server.sendMessage(0x294, msg);
		}

		private function sendAbyssLootSingle(index : uint) : void
		{
			Logger.info("客户端请求单个拾取 +" + index);
			var msg : CSAbyssLootSingle = new CSAbyssLootSingle();
			msg.index = index;
			Common.game_server.sendMessage(0x296, msg);
		}

		private function sendAbyssChallenge(useGold : Boolean) : void
		{
			_waitingReplay = true;
			Logger.info("客户端请求挑战");
			var msg : CSAbyssAuto = new CSAbyssAuto();
			msg.useGold = useGold;
			Common.game_server.sendMessage(0x292, msg);
		}

		private function sendAbyssAutoChallenge(useGold : Boolean) : void
		{
			_waitingReplay = true;
			Logger.info("客户端请求批量挑战");
			var msg : CSAbyssChallenge = new CSAbyssChallenge();
			msg.useGold = useGold;
			Common.game_server.sendMessage(0x293, msg);
		}

		// ------------------------------------------------
		// 响应服务器消息
		// ------------------------------------------------
		private function onRecvAbyssInfo(msg : SCAbyssAward) : void
		{
			_waitingReplay = false;
			Logger.info("服务器通知挑战结果 boss" + msg.boss);
			var oldSilver : int = _silverSummonLeft;
			var oldGold : int = _goldSummonLeft;

			_silverSummonLeft = msg.normal;
			_goldSummonLeft = msg.advanced;

			updateSummonButtons();

			if (msg.awards.length > 0)
			{
				if (_isRecover)
				{
					// removeAwards();
					recoverAwards(msg.awards);
					onAllSoulArrive();
				}
				else
				{
					// removeAwards();
					setAwards(msg.awards);
					choseBoss(msg.boss);
					startBattle();
				}
			}

			_isRecover = false;

			if (oldGold != _goldSummonLeft)
				ToolTipManager.instance.refreshToolTip(_goldSummonButton);
			if (oldSilver != _silverSummonLeft)
				ToolTipManager.instance.refreshToolTip(_silverSummonButton);
		}

		private function onAbyssLootResult(msg : SCAbyssLootResult) : void
		{
			if (msg.index == 0xFFFFFFFF)
			{
				Logger.info("服务器通知拾取结果：拾取失败");
			}
			else if (msg.index == 0xFFFFFFFE)
			{
				Logger.info("服务器通知拾取结果：全部拾取");
				_awardIndex = 0;
				lootAllAward();
			}
			else
			{
				Logger.info("服务器通知拾取结果：单个拾取 +" + msg.index);
				lootSingleAward(msg.index);
			}
		}

		// ------------------------------------------------
		// 其它
		// ------------------------------------------------
		private function keepPositionAddChild(parent : DisplayObjectContainer, child : DisplayObject) : void
		{
			var pt : Point = parent.globalToLocal(child.localToGlobal(new Point(0, 0)));
			child.x = pt.x;
			child.y = pt.y;

			parent.addChild(child);
		}

		public function getResList() : Array
		{
			var res : Array = [new LibData(VersionManager.instance.getUrl("assets/swf/abyss.swf"), "abyss")];

			res.push(UserData.instance.myHero.getAvatarUrl(AvatarType.PLAYER_BATT_BACK));

			return res;
		}

		public function initModule() : void
		{
			addDarkLayer();
			addScreenLayer();
			addConsole();
			addSummonButtons();
			addShuffleBar();
			addMoneyBoard();
			addSoulPack();
			addOtherButtons();
		}
		
		public function get menuId():int
		{
			return MenuType.SOUL_ABYSS;
		}
	}
}
