package game.module.monsterPot
{
	import com.utils.FilterUtils;

	import game.config.StaticConfig;
	import game.core.IAssets;
	import game.core.IModuleInferfaces;
	import game.core.avatar.AvatarManager;
	import game.core.avatar.AvatarThumb;
	import game.core.avatar.AvatarType;
	import game.core.item.Item;
	import game.core.item.ItemService;
	import game.core.menu.IMenu;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.manager.MouseManager;
	import game.manager.ViewManager;
	import game.module.chat.ManagerChat;
	import game.module.quest.guide.GuideMange;

	import gameui.controls.GButton;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.manager.UIManager;

	import log4a.Logger;

	import net.AssetData;
	import net.LibData;
	import net.RESManager;

	import utils.MathUtil;

	import worlds.apis.CloneSelfPlayer;

	import com.commUI.MoneyBoard;
	import com.commUI.alert.Alert;
	import com.commUI.button.KTButtonData;
	import com.commUI.icon.ItemIcon;
	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipManager;
	import com.greensock.*;
	import com.greensock.easing.Quart;
	import com.utils.StringUtils;
	import com.utils.UICreateUtils;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class MonsterPotScene extends GComponent implements IModuleInferfaces, IAssets ,IMenu
	{
		// ===============================================================
		// 单例
		// ===============================================================
		public static function get instance() : MonsterPotScene
		{
			if (_instace == null)
			{
				_instace = new MonsterPotScene(new Singleton());
			}
			return _instace;
		}

		private static var _instace : MonsterPotScene = null;
		// ===============================================================
		// 定义
		// ===============================================================
		public static const PLAYER_POSITION : Point = new Point(960, 740);
		public static const SUMMON_POSITION : Point = new Point(965, 547);
		public static const MONSTER_POSITION : Array = getMonsterPosition();

		private static function getMonsterPosition() : Array
		{
			var arr : Array = [];
			arr[1] = {x:570, y:558, scaleX:1, scaleY:1};
			arr[2] = {x:700, y:420, scaleX:1, scaleY:1};
			arr[3] = {x:965, y:366, scaleX:1, scaleY:1};
			arr[4] = {x:1230, y:430, scaleX:-1, scaleY:1};
			arr[5] = {x:1360, y:568, scaleX:-1, scaleY:1};
			return arr;
		}

		// ===============================================================
		// 属性
		// ===============================================================
		private var _background : Sprite;
		private var _menuBackground : Sprite;
		private var _leaveButton : Sprite;
		private var _resetBtn : Sprite;
		private var _leftArrow : Sprite;
		private var _rightArrow : Sprite;
		private var _targetArrow : MovieClip;
		private var _openCountryCount : uint = 0;
		private var _monsterPot : MovieClip = null;
		private var _fightIcon : Sprite = null;
		private var _countryButtons : Vector.<CountryButton>=new Vector.<CountryButton>();
		private var _countryMenuContainer : Sprite = new Sprite();
		private var _monsterContainer : Sprite = new Sprite();
		private var _itemContainer : Sprite = new Sprite();
		private var _moneyInfo : MoneyBoard;
		private var _allPickBtn : GButton;
		private var _stuffItems : Vector.<ItemIcon>=new Vector.<ItemIcon>();
		private var _monsterAvatar : AvatarThumb;
		private var _corpseAvatar : AvatarThumb;
		private var _selfPlayer : CloneSelfPlayer;
		private var _playerPath : ByteArray;
		private var _monsterPotPlaying : Boolean = false;
		private var _model : MonsterPotModel = MonsterPotManager.instance.model;
		private var _manager : MonsterPotManager = MonsterPotManager.instance;
		private var _isApprochingMonster : Boolean = false;
		private var _avatarDict : Dictionary = new Dictionary();

		// ===============================================================
		// 方法
		// ===============================================================
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------
		public function MonsterPotScene(singleton : Singleton)
		{
			_model = _manager.model;
			_base = new GComponentData();
			_base.parent = ViewManager.instance.getContainer(ViewManager.FULL_SCREEN_UI);
			_manager.view = this;
			super(base);
		}

		// 预加载资源
		public function getResList() : Array
		{
			var arr : Array = [];
			var uuid : int;
			var countryVO : MonsterCountryVO = _model.currentCountryVO;

			if (countryVO)
			{
				for (var monsterId : int = countryVO.nextMonsterId ;monsterId <= countryVO.openedMonsterId; monsterId++)
				{
					uuid = AvatarManager.instance.getUUId(countryVO.getAvatarIdByMonsterId(monsterId), AvatarType.MONSTER_TYPE);
					arr.push(StaticConfig.cdnRoot + "assets/avatar/" + uuid + ".swf");
				}

				if (countryVO.state == MonsterCountryVO.CORPSE)
					arr.push(StaticConfig.cdnRoot + "assets/avatar/" + AvatarManager.instance.getUUId(countryVO.getAvatarIdByMonsterId(countryVO.currentMonsterId), AvatarType.MONSTER_TYPE) + ".swf");
			}

			arr.push(new LibData(StaticConfig.cdnRoot + "assets/swf/monsterPot.swf", "monsterPot"));
			return arr;
		}

		// 初始化模块
		public function initModule() : void
		{
			with (this.graphics)
			{
				beginFill(0x0000000);
				this.width = UIManager.stage.stageWidth;
				this.height = UIManager.stage.stageHeight;
				drawRect(0, 0, UIManager.stage.stageWidth, UIManager.stage.stageHeight);
				endFill();
			}

			_background = RESManager.getSprite(new AssetData("monsterPot_background_sprite", "monsterPot"));
			addChild(_background);

			_background.addChild(_monsterContainer);
			addChild(_itemContainer);

			_menuBackground = RESManager.getSprite(new AssetData("monsterPot_menuBackground_sprite", "monsterPot"));
			addChild(_menuBackground);

			_moneyInfo = new MoneyBoard();
			addChild(_moneyInfo);

			_leaveButton = RESManager.getSprite(new AssetData("monsterPot_leaveBtn_sprite", "monsterPot"));
			addChild(_leaveButton);

			_resetBtn = RESManager.getSprite(new AssetData("monsterPot_resetBtn_sprite", "monsterPot"));
			addChild(_resetBtn);

			_leftArrow = RESManager.getSprite(new AssetData("monsterPot_leftArrow_sprite", "monsterPot"));
			_menuBackground.addChild(_leftArrow);

			_rightArrow = RESManager.getSprite(new AssetData("monsterPot_rightArrow_sprite", "monsterPot"));
			_menuBackground.addChild(_rightArrow);

			_fightIcon = RESManager.getSprite(new AssetData("monsterPot_fight_sprite", "monsterPot"));

			_menuBackground.addChild(_countryMenuContainer);

			_allPickBtn = UICreateUtils.createGButton("全部拾取", 100, 30, 100, 100, KTButtonData.NORMAL_BUTTON);
			positonCommponent();

			addMonsterPot();

			var load : URLLoader = new URLLoader();
			load.dataFormat = URLLoaderDataFormat.BINARY;
			load.addEventListener(Event.COMPLETE, pathLoadCompleted);
			load.load(new URLRequest(StaticConfig.cdnRoot + "assets/scene/monsterPot"));

			addCountryButtons();
			addTargetArrow();
		}

		// 创建国按钮
		private function addCountryButtons() : void
		{
			var i : int = 0;
			for each (var countryVO:MonsterCountryVO in _model.countries)
			{
				var countryBtn : CountryButton = new CountryButton();
				// TODO：重构国按钮之后可以把暴露在外的数据封装起来
				countryBtn.source = countryVO;
				countryBtn.btn = RESManager.getMC(new AssetData("monsterPot_country" + countryVO.countryId + "_mc", "monsterPot"));
				countryBtn.name = "countryMenu_" + countryVO.countryId;
				countryBtn.text = countryVO.countryName;
				countryBtn.clickFun = menuClickFun;
				countryBtn.clickFunParam = [countryBtn, true];
				countryBtn.x = i * (countryBtn.width + 50);

				_countryButtons.push(countryBtn);
				i++;
			}
		}

		// 创建炼妖壶MC
		private function addMonsterPot() : void
		{
			_monsterPot = RESManager.getMC(new AssetData("monsterPot_potBtn_movieClip", "monsterPot"));
			_monsterPot.x = 960;
			_monsterPot.y = 604;
		}

		// 创建拾取箭头
		private function addTargetArrow() : void
		{
			_targetArrow = RESManager.getMC(new AssetData("monsterPot_targetArrow_mc", "monsterPot"));
			_targetArrow.x = 960;
			_targetArrow.y = 474;
			_targetArrow.mouseChildren = false;
			_targetArrow.mouseEnabled = false;
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		// 重置View
		public function updateView() : void
		{
			updateCountryButtons();
			updateArrow();
			updateMonsterContainer();
			// updateResetButton();
			updateMonsterPot();
			updateTargetArrow();
		}

		private function updateTargetArrow() : void
		{
		}

		// 更新国菜单
		private function updateCountryButtons() : void
		{
			removeChildrens(_countryMenuContainer);

			for each (var countryButton:CountryButton in _countryButtons)
			{
				if (countryButton.vo.opened)
				{
					countryButton.selected = (_model.currentCountryId == countryButton.vo.countryId);
					_countryMenuContainer.addChild(countryButton);
				}
			}
		}

		// 更新怪物
		private function updateMonsterContainer() : void
		{
			removeMonsters();

			var monsterAvatar : AvatarThumb;
			var countryVO : MonsterCountryVO = _model.currentCountryVO;

			if (!countryVO)
				return;

			for (var monsterId : int = countryVO.nextMonsterId; monsterId <= countryVO.openedMonsterId; monsterId++)
			{
				monsterAvatar = getMonsterAvatarById(countryVO.getAvatarIdByMonsterId(monsterId));

				monsterAvatar.name = "potMonster_" + monsterId;
				monsterAvatar.scaleX = 0.6;
				monsterAvatar.scaleY = 0.6;

				_monsterContainer.addChild(monsterAvatar);

				if (countryVO.state == MonsterCountryVO.SUMMONED && monsterId == countryVO.currentMonsterId)
				{
					monsterAvatar.x = SUMMON_POSITION.x;
					monsterAvatar.y = SUMMON_POSITION.y;
					monsterAvatar.scaleX = 1;
					monsterAvatar.scaleY = 1;
					monsterAvatar.stand();

					_monsterAvatar = monsterAvatar;
					_monsterAvatar.addEventListener(MouseEvent.CLICK, monster_mouseHandler);
					_monsterAvatar.addEventListener(MouseEvent.MOUSE_OVER, monster_mouseHandler);
					_monsterAvatar.addEventListener(MouseEvent.MOUSE_OUT, monster_mouseHandler);
				}
				else
				{
					var position : Object = MONSTER_POSITION[monsterId];
					monsterAvatar.x = position.x;
					monsterAvatar.y = position.y;
					monsterAvatar.scaleX = position.scaleX;
					monsterAvatar.scaleY = position.scaleY;
					monsterAvatar.stand();
				}
			}

			// 有尸体
			if (countryVO.state == MonsterCountryVO.CORPSE)
			{
				monsterAvatar = getMonsterAvatarById(countryVO.getAvatarIdByMonsterId(countryVO.currentMonsterId));
				monsterAvatar.x = SUMMON_POSITION.x;
				monsterAvatar.y = SUMMON_POSITION.y;

				monsterAvatar.scaleX = 1;
				monsterAvatar.scaleY = 1;
				monsterAvatar.setAction(AvatarManager.DIE);
				monsterAvatar.addEventListener(MouseEvent.CLICK, corpse_clickHandler);
				monsterAvatar.addEventListener(MouseEvent.MOUSE_OVER, corpse_mouseHandler);
				monsterAvatar.addEventListener(MouseEvent.MOUSE_OUT, corpse_mouseHandler);
				_corpseAvatar = monsterAvatar;
				_monsterContainer.addChild(monsterAvatar);

				showTargetArrow();
				updateGuide();
			}

			// 调整位置
			if (_monsterAvatar && _monsterContainer.contains(_monsterAvatar))
				_monsterContainer.setChildIndex(_monsterAvatar, _monsterContainer.numChildren - 1);
		}

		private function getMonsterAvatarById(id : int) : AvatarThumb
		{
			var monsterAvatar : AvatarThumb = _avatarDict[id];

			if (!monsterAvatar)
			{
				monsterAvatar = new AvatarThumb();
				monsterAvatar.initAvatar(id, AvatarType.MONSTER_TYPE);
				_avatarDict[id] = monsterAvatar;
			}

			return monsterAvatar;
		}

		private function showTargetArrow() : void
		{
			if (!_targetArrow.parent)
				_background.addChild(_targetArrow);
		}

		private function hideTargetArrow() : void
		{
			if (_targetArrow.parent)
				_targetArrow.parent.removeChild(_targetArrow);
		}

		//		//  重置按钮
		// private function updateResetButton() : void
		// {
		// if (UserData.instance.vipLevel > 0)
		// {
		// if (!contains(_resetBtn))
		// addChild(_resetBtn);
		// }
		// else
		// {
		// if (_resetBtn.parent)
		// _resetBtn.parent.removeChild(_resetBtn);
		// }
		// }
		// 更新炼妖壶MC
		private function updateMonsterPot() : void
		{
			var countryVO : MonsterCountryVO = _model.currentCountryVO;
			if (countryVO.state == MonsterCountryVO.IDLE && countryVO.nextMonsterId <= countryVO.openedMonsterId)
			{
				if (!_monsterPot.parent)
				{
					if (_selfPlayer)
					{
						_background.addChildAt(_monsterPot, _background.getChildIndex(_selfPlayer.avatar));
					}
					else
					{
						_background.addChild(_monsterPot);
					}
				}

				// 更新新手引导
				updateGuide();
			}
			else
			{
				if (_monsterPot.parent)
					_monsterPot.parent.removeChild(_monsterPot);
			}
		}

		private function getResetButtonToolTip() : String
		{
			var countryVO : MonsterCountryVO = _model.currentCountryVO;

			var resetSpend : uint;
			resetSpend = countryVO.nextMonsterId > 1 ? countryVO.nextMonsterId - 1 : 1;
			if (resetSpend > 5)
			{
				resetSpend = 5;
			}

			var rtStr : String;

			if (countryVO.freeResetCount > 0)
			{
				rtStr = "免费重置次数：" + StringUtils.addColor(countryVO.freeResetCount.toString(), "#ffff00") + "\r";
			}
			else if (countryVO.goldResetCount <= 0)
			{
				rtStr = "剩余重置次数：<font color='#ffff00'>" + countryVO.goldResetCount + "</font>\r<font color='#666666'>今日重置次数已用完</font>";
			}
			else
			{
				rtStr = "剩余重置次数：<font color='#ffff00'>" + countryVO.goldResetCount + "</font>\r花费 <font color='#ffff00'>" + (resetSpend * _model.resetPrice) + "</font> 元宝重置 <font color='#ffff00'>" + resetSpend + "</font> 只本国妖兽";
			}
			return rtStr;
		}

		// 更新箭头
		private function updateArrow() : void
		{
			if (_openCountryCount > 6)
			{
				_leftArrow.visible = true;
				_rightArrow.visible = true;
			}
			else
			{
				_leftArrow.visible = false;
				_rightArrow.visible = false;
			}
			_countryMenuContainer.x = (_menuBackground.width - _countryMenuContainer.width) / 2;
			_countryMenuContainer.y = (_menuBackground.height - _countryMenuContainer.height) / 2 - 5;
		}

		// 更新鼠标状态
		private function corpse_mouseHandler(e : Event) : void
		{
			if (e.type == MouseEvent.MOUSE_OVER)
			{
				Mouse.cursor = MouseManager.PICK_UP;
				(e.target as DisplayObject).filters = [FilterUtils.defaultGlowFilter];
			}
			else
			{
				Mouse.cursor = MouseManager.ARROW;
				(e.target as DisplayObject).filters = [];
			}
		}

		// 新手引导
		private function updateGuide() : void
		{
			var state : int = _model.currentCountryVO.state;

			if (state == MonsterCountryVO.IDLE)
			{
				GuideMange.getInstance().checkGuideByMenuid(MenuType.MONSTERPOT, 0, _monsterPot);
			}
			else if (state == MonsterCountryVO.SUMMONED)
			{
				GuideMange.getInstance().checkGuideByMenuid(MenuType.MONSTERPOT, 1, _monsterAvatar);
			}
			else if (state == MonsterCountryVO.CORPSE)
			{
				GuideMange.getInstance().checkGuideByMenuid(MenuType.MONSTERPOT, 2, _corpseAvatar);
			}
		}

		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		// ------------------------------------------------
		// 战利品拾取
		// ------------------------------------------------
		private function allPickup(e : Event) : void
		{
			if (UserData.instance.tryPutPack(_itemContainer.numChildren) < 0)
			{
				return;
			}

			if (_allPickBtn.parent != null && _allPickBtn.parent.contains(_allPickBtn))
			{
				_allPickBtn.parent.removeChild(_allPickBtn);
			}

			for (var i : uint = 0; i < _itemContainer.numChildren; i++)
			{
				var item : DisplayObject = _itemContainer.getChildAt(i);
				TweenMax.to(item, 1, {bezier:[{x:item.x, y:item.y - 50}], blurFilter:{blurY:20}, alpha:0});
			}
			TweenLite.to(_itemContainer, 1, {alpha:0, onComplete:allPickupCompleted});

			// if (currentSelectedBtn.pendingProgressPos < 5) {
			// currentSelectedBtn.pendingProgressPos+=1;
			// }
			MonsterPotManager.instance.sendLootAwardRequest();
		}

		private function allPickupCompleted() : void
		{
			// _itemContainer.removeChildren();
			removeChildrens(_itemContainer);
			_itemContainer.graphics.clear();
			_itemContainer.visible = false;
		}

		// 炼妖壶鼠标事件
		private function monsterPot_mouseHandler(e : Event) : void
		{
			if (_monsterPotPlaying)
				return;

			switch (e.type)
			{
				case MouseEvent.CLICK:
					var countryVO : MonsterCountryVO = _model.currentCountryVO;
					countryVO.state = MonsterCountryVO.SUMMONED;
					countryVO.currentMonsterId = countryVO.nextMonsterId;
					// 开始播放动画
					_monsterPot.addFrameScript(30, onMonsterPotAnimationComplete);
					_monsterPot.gotoAndPlay(3);
					_monsterPotPlaying = true;
					break;
				case MouseEvent.MOUSE_OVER:
					_monsterPot.gotoAndStop(2);
					break;
				case MouseEvent.MOUSE_OUT:
					_monsterPot.gotoAndStop(1);
					break;
			}
		}

		// 招怪动画播放完成
		private function onMonsterPotAnimationComplete() : void
		{
			_monsterPotPlaying = false;

			// 招怪
			placeMonsterOnPot();

			// 移除炼妖壶
			if (_monsterPot.parent)
				_monsterPot.parent.removeChild(_monsterPot);

			var countryVO : MonsterCountryVO = _model.currentCountryVO;
			countryVO.state = MonsterCountryVO.SUMMONED;

			// 更新新手引导
			updateGuide();
		}

		// 招怪
		private function placeMonsterOnPot() : void
		{
			updateMonsterContainer();
		}

		// 怪物鼠标事件
		private function monster_mouseHandler(e : Event) : void
		{
			var m : AvatarThumb = e.currentTarget as AvatarThumb;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER:
					Mouse.cursor = MouseManager.BATTLE;
					_fightIcon.mouseEnabled = false;
					_fightIcon.x = m.x;
					_fightIcon.y = m.y - m.height;
					break;
				case MouseEvent.MOUSE_OUT:
					Mouse.cursor = MouseManager.ARROW;
					break;
				case MouseEvent.CLICK:
					approchMonster();
					break;
			}
		}

		private function approchMonster() : void
		{
			if (_isApprochingMonster)
				return;

			_isApprochingMonster = true;

			var fightPoint : Point = new Point();
			var p1 : Point = new Point(_selfPlayer.x, _selfPlayer.y);
			var p2 : Point = SUMMON_POSITION;
			var b : Number = 60;
			var a : Number = Math.sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y));
			var c : Number = (a - b) / a;
			fightPoint.x = p1.x + (p2.x - p1.x) * c;
			fightPoint.y = p1.y + (p2.y - p1.y) * c;

			_selfPlayer.walkTo(fightPoint.x, fightPoint.y);
			_selfPlayer.sWalkEnd.add(onApprochMonster);
		}

		private function onApprochMonster() : void
		{
			_isApprochingMonster = false;
			_selfPlayer.sWalkEnd.remove(onApprochMonster);
			_manager.sendChallengeDemonRequest();
		}

		// 尸体点击事件
		private function corpse_clickHandler(e : Event) : void
		{
			var m : AvatarThumb = e.currentTarget as AvatarThumb;
			m.removeEventListener(MouseEvent.CLICK, corpse_clickHandler);
			m.removeEventListener(MouseEvent.MOUSE_OVER, corpse_mouseHandler);
			m.removeEventListener(MouseEvent.MOUSE_OUT, corpse_mouseHandler);
			Mouse.cursor = MouseCursor.ARROW;

			hideTargetArrow();

			lootItems();
		}

		// 获取战利品
		private function lootItems() : void
		{
			var countryVO : MonsterCountryVO = _model.currentCountryVO;

			var items : Vector.<uint>=countryVO.stuffItems;

			_itemContainer.visible = true;
			_itemContainer.graphics.clear();
			_itemContainer.graphics.beginFill(0x000000, 0.5);
			_itemContainer.graphics.drawRoundRectComplex(0, 0, items.length * 60, 60, 5, 5, 5, 5);
			_itemContainer.graphics.endFill();

			layoutItemContainer();
			_itemContainer.alpha = 0.5;
			TweenLite.to(_itemContainer, 3, {alpha:1});

			addChild(_allPickBtn);

			_allPickBtn.addEventListener(MouseEvent.CLICK, allPickup);

			for (var i : uint = 0; i < items.length; i++)
			{
				var item : game.core.item.Item = ItemService.createItem(items[i]);

				var icon : ItemIcon = UICreateUtils.createItemIcon({x:0, y:0, showBorder:false, showBg:false, showRollOver:true, showBinding:false, showNums:true, showToolTip:true}) as ItemIcon;
				// item.nums=count;
				icon.source = item;
				_stuffItems.push(icon);
				_itemContainer.addChild(icon);

				var startx : Number = _itemContainer.width / 2;
				var starty : Number = -100;

				var midx : Number;
				var midy : Number;
				var endx : Number;
				var endy : Number;

				midx = (items.length * 60 - items.length * 300) / 2 + i * 300 + (300 - icon.width) / 2;
				endx = i * 60 + (60 - icon.width) / 2;
				midy = MathUtil.random(starty - 200, starty - 400);
				endy = (60 - icon.height) / 2;

				icon.x = startx;
				icon.y = starty;

				icon.scaleX = 0.2;
				icon.scaleY = 0.2;
				TweenMax.to(icon, Point.distance(new Point(midx, midy), new Point(endx, endy)) / 400, {bezier:[{x:midx, y:midy}, {x:endx, y:endy}], scaleX:1, scaleY:1, alpha:1, ease:Quart.easeOut, onComplete:iconFlyEnd, onCompleteParams:[icon]});
			}
		}

		// 战利品飞行结束
		private function iconFlyEnd(icon : ItemIcon) : void
		{
			icon.showBorder = true;
			icon.showBinding = true;
		}

		// 点击国按钮
		private function menuClickFun(clickBtn : CountryButton, refresh : Boolean = false) : void
		{
			var countryVO : MonsterCountryVO = clickBtn.vo;

			if (countryVO.countryId == _model.currentCountryId)
				return;

			if (_isApprochingMonster)
				return;

			var currentVO : MonsterCountryVO = _model.currentCountryVO;
			if (currentVO.state == MonsterCountryVO.CORPSE)
			{
				StateManager.instance.checkMsg(315);
				return;
			}

			_model.currentCountryId = clickBtn.vo.countryId;

			updateView();
		}

		// ------------------------------------------------
		// 玩家移动
		// ------------------------------------------------
		// 加载寻路文件，创建玩家
		protected function pathLoadCompleted(event : Event) : void
		{
			_playerPath = (event.currentTarget as URLLoader).data as ByteArray;
			(event.currentTarget as URLLoader).close();
			_selfPlayer = new CloneSelfPlayer();
			_selfPlayer.mouseEnabled = false;
			_selfPlayer.addTo(_background, _background.getChildIndex(_monsterContainer) + 1);
			if (_background.contains(_monsterPot))
				_background.setChildIndex(_monsterPot, _background.getChildIndex(_selfPlayer.avatar));
			_selfPlayer.setPathData(_playerPath);
			_selfPlayer.initPosition(PLAYER_POSITION.x, PLAYER_POSITION.y);
			_background.addEventListener(MouseEvent.CLICK, background_clickHandler);
			_selfPlayer.setStandDirection(SUMMON_POSITION.x, SUMMON_POSITION.y);
		}

		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		override protected function onShow() : void
		{
			super.onShow();

			// 事件
			ToolTipManager.instance.registerToolTip(_resetBtn, ToolTip, getResetButtonToolTip);

			_monsterPot.addEventListener(MouseEvent.CLICK, monsterPot_mouseHandler);
			_monsterPot.addEventListener(MouseEvent.MOUSE_OVER, monsterPot_mouseHandler);
			_monsterPot.addEventListener(MouseEvent.MOUSE_OUT, monsterPot_mouseHandler);
			_leaveButton.addEventListener(MouseEvent.CLICK, leaveButton_clickHandler);
			_background.addEventListener(MouseEvent.CLICK, background_clickHandler);
			_resetBtn.addEventListener(MouseEvent.CLICK, resetButton_clickHandler);

			if (_selfPlayer)
			{
				_selfPlayer.updateAvatar();
				_selfPlayer.setStandDirection(SUMMON_POSITION.x, SUMMON_POSITION.y);
			}

			updateView();
			stageResizeHandler();
			ManagerChat.instance.moveViewToUIContainer();
			// updateGuide();
		}

		override protected function onHide() : void
		{
			// 事件

			_monsterPot.removeEventListener(MouseEvent.MOUSE_OVER, monsterPot_mouseHandler);
			_monsterPot.removeEventListener(MouseEvent.MOUSE_OUT, monsterPot_mouseHandler);
			_monsterPot.removeEventListener(MouseEvent.CLICK, monsterPot_mouseHandler);

			_leaveButton.removeEventListener(MouseEvent.CLICK, leaveButton_clickHandler);
			_background.removeEventListener(MouseEvent.CLICK, background_clickHandler);
			_resetBtn.removeEventListener(MouseEvent.CLICK, resetButton_clickHandler);

			ManagerChat.instance.moveViewToAutoContainer();

			removeChildrens(_itemContainer);
			removeMonsters();
			for each (var avatarMonster:AvatarThumb in _avatarDict)
			{
				avatarMonster.dispose();
			}
			_avatarDict = new Dictionary();
			super.onHide();
		}

		private function removeMonsters() : void
		{
			if (_monsterAvatar)
			{
				_monsterAvatar.removeEventListener(MouseEvent.CLICK, monster_mouseHandler);
				_monsterAvatar.removeEventListener(MouseEvent.MOUSE_OVER, monster_mouseHandler);
				_monsterAvatar.removeEventListener(MouseEvent.MOUSE_OUT, monster_mouseHandler);
			}

			if (_corpseAvatar)
			{
				_corpseAvatar.filters = [];
				_corpseAvatar.addEventListener(MouseEvent.CLICK, corpse_clickHandler);
				_corpseAvatar.addEventListener(MouseEvent.MOUSE_OVER, corpse_mouseHandler);
				_corpseAvatar.addEventListener(MouseEvent.MOUSE_OUT, corpse_mouseHandler);
			}
			
			removeChildrens(_monsterContainer);
			_monsterAvatar = null;
			_corpseAvatar = null;
		}

		// 退出炼妖壶
		private function leaveButton_clickHandler(event : MouseEvent) : void
		{
			MenuManager.getInstance().closeMenuView(MenuType.MONSTERPOT);
			// GuideMange.getInstance().resetAndCheckGuide(MenuType.MONSTERPOT);
		}

		// 点击背景，玩家跑动
		protected function background_clickHandler(event : MouseEvent) : void
		{
			if (_isApprochingMonster)
				return;

			if (!_selfPlayer)
				return;

			trace(event.currentTarget, "##@#@#@#@#@#@", event.target);
			if (event.target == _background)
			{
				_selfPlayer.walkTo(_background.mouseX, _background.mouseY);
			}
		}

		// 点击重置按钮
		private function resetButton_clickHandler(e : Event) : void
		{
			var countryVO : MonsterCountryVO = _model.currentCountryVO;

			if (countryVO.state == MonsterCountryVO.CORPSE)
			{
				StateManager.instance.checkMsg(315);
				return;
			}

			if (countryVO.goldResetCount + countryVO.freeResetCount <= 0)
			{
				StateManager.instance.checkMsg(304);
				return;
			}

			if (countryVO.nextMonsterId == 1)
			{
				StateManager.instance.checkMsg(317);
				return;
			}

			var resetSpend : uint = countryVO.nextMonsterId > 1 ? countryVO.nextMonsterId - 1 : 1;
			if (resetSpend > 5)
			{
				resetSpend = 5;
			}

			if (countryVO.freeResetCount > 0)
				onConfirmReset(Alert.OK_TEXT);
			else
				StateManager.instance.checkMsg(301, null, onConfirmReset, [resetSpend * _model.resetPrice]);
		}

		// 确认重置
		private function onConfirmReset(str : String) : Boolean
		{
			if (str == Alert.OK_TEXT || str == Alert.YES_TEXT || str == Alert.OK_EVENT)
			{
				_manager.sendResetDemonRequest();
			}
			return true;
		}

		// ------------------------------------------------
		// 布局
		// ------------------------------------------------
		override public function stageResizeHandler() : void
		{
			this.x = 0;
			this.y = 0;
			with (this.graphics)
			{
				beginFill(0x0000000);
				this.width = UIManager.stage.stageWidth;
				this.height = UIManager.stage.stageHeight;
				drawRect(0, 0, UIManager.stage.stageWidth, UIManager.stage.stageHeight);
				endFill();
			}

			positonCommponent();
		}

		private function positonCommponent() : void
		{
			_background.x = (UIManager.stage.stageWidth - _background.width) / 2;
			_background.y = (UIManager.stage.stageHeight - _background.height) / 2 + 64;
			_moneyInfo.x = 5;
			_moneyInfo.y = 5;
			_menuBackground.x = (UIManager.stage.stageWidth - _menuBackground.width) / 2;
			_menuBackground.y = 0;
			_leaveButton.x = this.width - _leaveButton.width - 5;
			_leaveButton.y = 5;
			_resetBtn.x = _leaveButton.x - _resetBtn.width - 5;
			_resetBtn.y = _leaveButton.y;
			_leftArrow.x = 50;
			_leftArrow.y = (_menuBackground.height - _leftArrow.height) / 2;
			_rightArrow.x = _menuBackground.width - 50 - _rightArrow.width;
			layoutItemContainer();
			_rightArrow.y = _leftArrow.y;
			if (_monsterPot != null)
			{
				_monsterPot.x = 960;
				_monsterPot.y = 604;
			}
			if (_targetArrow != null)
			{
				_targetArrow.x = 960;
				_targetArrow.y = 474;
			}
		}

		private function layoutItemContainer() : void
		{
			_itemContainer.x = (UIManager.stage.stageWidth - _itemContainer.width) / 2 - 10;
			_itemContainer.y = UIManager.stage.stageHeight * 0.5 + (UIManager.stage.stageHeight * 0.5 - _itemContainer.height) * 0.7;
			_allPickBtn.x = _itemContainer.x + (_itemContainer.width - _allPickBtn.width) / 2;
			_allPickBtn.y = _itemContainer.y + 65;
		}

		// ------------------------------------------------
		// 其他
		// ------------------------------------------------
		private function removeChildrens(ct : DisplayObjectContainer) : void
		{
			for (var i : int = ct.numChildren - 1; i >= 0; i--)
			{
				ct.removeChildAt(0);
			}
		}

		public function get menuId() : int
		{
			return MenuType.MONSTERPOT;
		}
	}
	// class end
}
class Singleton
{
}
