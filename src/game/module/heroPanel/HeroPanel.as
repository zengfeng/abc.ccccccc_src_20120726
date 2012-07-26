package game.module.heroPanel
{
	import game.module.riding.RidingView;
	import game.core.IModuleInferfaces;
	import game.core.IAssets;
	import game.core.IModuleInferfaces;
	import game.core.hero.VoHero;
	import game.core.item.ItemManager;
	import game.core.item.equipment.Equipment;
	import game.core.item.equipment.EquipmentSlot;
	import game.core.item.sutra.Sutra;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.definition.UI;
	import game.manager.SignalBusManager;
	import game.manager.ViewManager;
	import game.module.heroPanel.transfer.TransferSidePanel;
	import game.module.pack.PackVariable;
	import game.module.riding.RidingView;
	import game.module.soul.SoulUtils;
	import game.net.core.Common;
	import game.net.data.CtoC.CCHeroEqChange;
	import game.net.data.CtoC.CCHeroPanelOpen;
	import game.net.data.CtoS.CSHeroSummon;

	import gameui.controls.GButton;
	import gameui.controls.GImage;
	import gameui.core.GAlign;
	import gameui.data.GButtonData;
	import gameui.data.GImageData;
	import gameui.data.GTitleWindowData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.GCommonWindow;
	import com.commUI.alert.Alert;
	import com.commUI.button.KTButtonData;
	import com.commUI.herotab.HeroTabList;
	import com.commUI.herotab.HeroTabListData;
	import com.commUI.tooltip.HeroPropPanelTip;
	import com.commUI.tooltip.SoulPowerTip;
	import com.commUI.tooltip.SutraTip;
	import com.commUI.tooltip.ToolTipManager;
	import com.protobuf.Message;
	import com.utils.ColorUtils;
	import com.utils.FilterUtils;
	import com.utils.ItemUtils;
	import com.utils.StringUtils;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;





	/**
	 * @author yangyiqiang
	 */
	public class HeroPanel extends GCommonWindow implements IAssets, IModuleInferfaces
	{
		// =====================
		// 定义
		// =====================
		public static const START_ID : int = 81;
		public static const END_ID : int = 86;
		public static const POTENTIAL_OPEN_LEVEL : uint = 30;
		// =====================
		// 属性
		// =====================
		protected var _propPanel : HeroPropPanel;
		protected var _transPanel : TransferSidePanel;
		protected var _propFrame : HeroNature;
		protected var _selectedHero : VoHero;
		protected var _heroTabList : HeroTabList;
		// 81 头饰  82 盔甲  83 束腰 84 长靴 85 戒  86 坠饰
		protected var _eqDic : Dictionary = new Dictionary();
		protected var _dissmisButton : GButton;
		protected var _heroImage : GImage;
		protected var _sutraIcon : GImage;
		protected var _soulIcon : Sprite;
		protected var _heroClickMask : Sprite;
		protected var _soulPowerText : TextField;
		protected var _sutraNameText : TextField;
		protected var _heroSoul : Sprite;

		// =====================
		// 方法
		// =====================
		public function HeroPanel()
		{
			_data = new GTitleWindowData();
			_data.width = 425;
			_data.height = 435;
			_data.parent = ViewManager.instance.uiContainer;
			_data.allowDrag = true;
			super(_data);
		}
		
		public function initModule():void
		{
			title = "角色";
			super.initViews();
			addBg();
			addSutra();
			addSoulPower();
			addHeroImage();
			addHeroClickMask();
			addHeroEquipBg();
			addHeroProps();
			addEqCells();
			addButtons();
			addHeroTabList();
			addHeroPropPanel();
			addTransPanel();			
		}

		public function getResList() : Array
		{
			var res:Array = [];
			
			for each (var hero:VoHero in UserData.instance.heroes)
			{
				res.push (hero.heroImage);
				res.push (hero.fullImage);	
			}
			return res;
		}

		override public function set x(value : Number) : void
		{
			// trace("x=====>" + value);
			super.x = value;
		}

		private function addBg() : void
		{
			var bg : Sprite = UIManager.getUI(new AssetData("common_background_02"));
			if (!bg) return;
			bg.width = this.width - 85;
			bg.height = this.height - 5;
			bg.x = 76;
			bg.y = 0;
			this.contentPanel.add(bg);

			var bg_1 : Sprite = UIManager.getUI(new AssetData("common_background_03"));
			if (!bg_1) return;
			bg_1.width = 302;
			bg_1.height = 265;
			bg_1.x = 96;
			bg_1.y = 60;
			this.contentPanel.add(bg_1);

			var bg_2 : Sprite = UIManager.getUI(new AssetData(UI.BACKGROUND_TAICHI));
			if (!bg_2) return;
			bg_2.alpha = 0.2;
			bg_2.width = 176;
			bg_2.height = 177;
			bg_2.x = 158;
			bg_2.y = 110;
			this.contentPanel.add(bg_2);
		}

		private function addHeroEquipBg() : void
		{
			const EQ_BG_X_1 : int = 106;
			const EQ_BG_X_2 : int = 340;
			const EQ_BG_Y : int = 105;
			var heroEqbg_1 : Sprite = UIManager.getUI(new AssetData("hero_equipment_bg_1"));
			if (!heroEqbg_1) return;
			heroEqbg_1.x = EQ_BG_X_1;
			heroEqbg_1.y = EQ_BG_Y;
			this.contentPanel.add(heroEqbg_1);

			var heroEqbg_2 : Sprite = UIManager.getUI(new AssetData("hero_equipment_bg_2"));
			if (!heroEqbg_2) return;
			heroEqbg_2.x = EQ_BG_X_1;
			heroEqbg_2.y = EQ_BG_Y + 64;
			this.contentPanel.add(heroEqbg_2);

			var heroEqbg_3 : Sprite = UIManager.getUI(new AssetData("hero_equipment_bg_3"));
			if (!heroEqbg_3) return;
			heroEqbg_3.x = EQ_BG_X_1;
			heroEqbg_3.y = EQ_BG_Y + 64 * 2;
			this.contentPanel.add(heroEqbg_3);

			var heroEqbg_4 : Sprite = UIManager.getUI(new AssetData("hero_equipment_bg_4"));
			if (!heroEqbg_4) return;
			heroEqbg_4.x = EQ_BG_X_2;
			heroEqbg_4.y = EQ_BG_Y;
			this.contentPanel.add(heroEqbg_4);

			var heroEqbg_5 : Sprite = UIManager.getUI(new AssetData("hero_equipment_bg_5"));
			if (!heroEqbg_5) return;
			heroEqbg_5.x = EQ_BG_X_2;
			heroEqbg_5.y = EQ_BG_Y + 64;
			this.contentPanel.add(heroEqbg_5);

			var heroEqbg_6 : Sprite = UIManager.getUI(new AssetData("hero_equipment_bg_6"));
			if (!heroEqbg_6) return;
			heroEqbg_6.x = EQ_BG_X_2;
			heroEqbg_6.y = EQ_BG_Y + 64 * 2;
			this.contentPanel.add(heroEqbg_6);
		}

		private function addSutra() : void
		{
			var bg : Sprite = UIManager.getUI(new AssetData(UI.SOUL_POWER_BACKGROUND));
			bg.width = 140;
			bg.x = 96;
			bg.y = 15;
			this.contentPanel.addChild(bg);

			_sutraIcon = UICreateUtils.createGImage(null, 0, 0, 90, 8);
			addChild(_sutraIcon);

			_sutraNameText = UICreateUtils.createTextField(null, null, 100, 20, 135, 26, TextFormatUtils.panelContent);
			_sutraNameText.textColor = ColorUtils.GOLDEN;
			this.contentPanel.addChild(_sutraNameText);
		}

		private function addSoulPower() : void
		{
			_heroSoul = UIManager.getUI(new AssetData(UI.SOUL_POWER_BACKGROUND));
			_heroSoul.width = 140;
			_heroSoul.x = 256;
			_heroSoul.y = 15;
			this.contentPanel.add(_heroSoul);

			_soulIcon = UIManager.getUI(new AssetData(UI.SOUL_POWER_ICON));
			_soulIcon.mouseEnabled = true;
			_soulIcon.x = 253;
			_soulIcon.y = 6;
			this.contentPanel.add(_soulIcon);

			_soulPowerText = UICreateUtils.createTextField(null, null, 100, 20, 295, 26, TextFormatUtils.panelContent);
			_soulPowerText.textColor = ColorUtils.TEXTCOLOROX[ColorUtils.GOLDEN];
			this.contentPanel.addChild(_soulPowerText);
		}

		private function addHeroProps() : void
		{
			_propFrame = new HeroNature();
			_propFrame.x = 96;
			_propFrame.y = 329;
			// _propFrame.align = new GAlign(100, -1, 277 + 39);
			this.contentPanel.add(_propFrame);
		}

		private function addHeroPropPanel() : void
		{
			var data : GTitleWindowData = new GTitleWindowData();
			data.width = 113;
			data.height = 405;
			data.parent = this;
			data.align = new GAlign(width, -1, -1, 0);
			_propPanel = new HeroPropPanel(data);
		}

		private function addTransPanel() : void
		{
			var data : GTitleWindowData = new GTitleWindowData();
			data.width = 305;
			data.height = 283;
			data.parent = this;
			data.align = new GAlign(width, -1, -1, (height - data.height) / 2);
			_transPanel = new TransferSidePanel(data);
		}

		protected function addEqCells() : void
		{
			var cell : EqCell;
			for (var i : int = START_ID;i < (END_ID + 1);i++)
			{
				cell = new EqCell();
				cell.x = i < 84 ? 105 : 339;
				cell.y = ((i - START_ID) % 3) * 64 + 104;
				// cell.setType(i);
				_eqDic[i] = cell;
				this.contentPanel.add(cell);
			}
		}

		private function addHeroImage() : void
		{
			var data : GImageData = new GImageData();
			data.align = new GAlign(105, -1, -1, 360);
			data.iocData.align = new GAlign(0, -1, -1, 0);

			_heroImage = new GImage(data);
			_heroImage.mouseEnabled = false;
			_heroImage.mouseChildren = false;
			this.contentPanel.add(_heroImage);

			var heroShadow : Sprite = UIManager.getUI(new AssetData("Hero_shadow"));
			heroShadow.x = 160;
			heroShadow.y = 300;
			this.contentPanel.add(heroShadow);
		}

		private function addHeroClickMask() : void
		{
			_heroClickMask = new Sprite();
			_heroClickMask.x = 170;
			_heroClickMask.y = 75;
			with (_heroClickMask)
			{
				graphics.beginFill(0x000000, 0);
				graphics.drawEllipse(0, 0, 170, 240);
				graphics.endFill();
			}
			this.contentPanel.addChild(_heroClickMask);
		}

		protected function addHeroTabList() : void
		{
			var data : HeroTabListData = new HeroTabListData();
			data.tabData = UICreateUtils.tabDataHeroLeft;

			_heroTabList = new HeroTabList(data);

			_heroTabList.x = 5;
			_heroTabList.y = 0;
			addChild(_heroTabList);
		}
        
		
		private var _ridingButton:GButton;
		protected function addButtons() : void
		{
			var data : GButtonData = new KTButtonData();
			data.x = this.width / 2 - 60 - 4;
			data.y = 393;
			_dissmisButton = new GButton(data);
			_dissmisButton.text = "离队";

			addChild(_dissmisButton);
			
			data.x= this.width / 2+100;
			_ridingButton = new GButton(data);
			_ridingButton.text = "坐骑";
//			addChild(_ridingButton);
//			_ridingButton.addEventListener(MouseEvent.CLICK, onRidingPanelOpen);
		}
		private var _ridingPanel:RidingView;
		private function onRidingPanelOpen(e:MouseEvent):void
		{
			 MenuManager.getInstance().openMenuView(MenuType.RIDING);
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		protected function selectDefaultHero() : void
		{
			if (!_heroTabList.selection)
				_heroTabList.selectHero(UserData.instance.myHero.id);

			_selectedHero = _heroTabList.selection;
			PackVariable.selectedHero = _selectedHero;
		}

		protected function updateView() : void
		{
			if (!_selectedHero)
				return;

			updateEqCells();
			updateHeroInfo();
			updateSutra();
			updateSoulPower();
			updateButtons();
		}

		protected function updateEqCells() : void
		{
			var cell : EqCell;
			for (var i : int = START_ID;i < (END_ID + 1);i++)
			{
				cell = _eqDic[i];
				if (cell)
				{
					var eq : Equipment = _selectedHero.getEquipment(i);
					cell.source = eq;
					if (eq)
						cell.transferTarget = ItemUtils.getTransferTarget(_selectedHero.level, eq, _selectedHero.job);
					else
						cell.transferTarget = null;
				}
			}
		}

		private function updateHeroInfo() : void
		{
			if (_propFrame)
				_propFrame.source = _selectedHero;
			if (_propPanel)
				_propPanel.source = _selectedHero;

			_heroImage.url = _selectedHero.fullImage;
		}

		private function changHero(vo : VoHero) : void
		{
			_selectedHero = vo;
			PackVariable.selectedHero = _selectedHero;
			if (!vo) return;
			updateView();
		}

		private function updateSutra() : void
		{
			var sutra : Sutra = _selectedHero.sutra;
			_sutraNameText.htmlText = StringUtils.addColorById(sutra.name + (sutra.step > 0 ? " " + _selectedHero.sutra.stepString : ""), sutra.color);
			_sutraIcon.url = _selectedHero.sutra.imgUrl;
		}

		private function updateSoulPower() : void
		{
			_soulPowerText.htmlText = "元神力：" + SoulUtils.calHeroSoulPower(_selectedHero).toString();
		}

		protected function updateButtons() : void
		{
			var arr : Array = [];
			_dissmisButton.visible = (_selectedHero.id != UserData.instance.myHero.id && UserData.instance.level > 29);
			if (_dissmisButton.visible) arr.push(_dissmisButton);

			var max : int = 342;
			var stardX : int = 85 + (max - arr.length * 97) / 2;
			for (var i : int = 0;i < arr.length;i++)
			{
				arr[i]["x"] = stardX + i * 97;
			}
		}

		private function onHeroPropChange(hero : VoHero) : void
		{
			if (_selectedHero && hero.id == _selectedHero.id)
				_propFrame.refreshProp();
		}

		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		override protected function onShow() : void
		{
			super.onShow();
			addEvents();

			selectDefaultHero();
			updateView();
		}

		override protected function onHide() : void
		{
			removeEvents();
			// MenuManager.getInstance().closeMenuView(MenuType.TRAININFO);
			// MenuManager.getInstance().closeMenuView(MenuType.TRANSFER);
			if (_propPanel)
				_propPanel.hide();
			if (_transPanel)
				_transPanel.hide();
			super.onHide();
		}

		protected function addEvents() : void
		{
			_dissmisButton.addEventListener(MouseEvent.CLICK, dissmissButton_ClickHandler);
			_heroTabList.selectionModel.addEventListener(Event.CHANGE, heroTab_SelectHandler);
			_heroClickMask.addEventListener(MouseEvent.ROLL_OVER, mask_rollOverHandler);
			_heroClickMask.addEventListener(MouseEvent.ROLL_OUT, mask_rollOutHandler);
			_sutraIcon.addEventListener(MouseEvent.ROLL_OVER, mask_rollOverHandler);
			_sutraIcon.addEventListener(MouseEvent.ROLL_OUT, mask_rollOutHandler);
			_soulIcon.addEventListener(MouseEvent.ROLL_OVER, mask_rollOverHandler);
			_soulIcon.addEventListener(MouseEvent.ROLL_OUT, mask_rollOutHandler);
			_heroClickMask.addEventListener(MouseEvent.CLICK, mask_clickHandler);
			_sutraIcon.addEventListener(MouseEvent.CLICK, sutraIcon_clickHandler);
			_soulIcon.addEventListener(MouseEvent.CLICK, soulIcon_clickHandler);
			ToolTipManager.instance.registerToolTip(_soulIcon, SoulPowerTip, provideSelectedHero);
			ToolTipManager.instance.registerToolTip(_heroClickMask, HeroPropPanelTip, provideSelectedHero);
			ToolTipManager.instance.registerToolTip(_sutraIcon, SutraTip, provideSelectSutra, true);
			Common.game_server.addCallback(0xFFF3, onHeroEqChange);
			Common.game_server.addCallback(0xFFF2, onPackChange);
			Common.game_server.addCallback(0xFFF1, onLevelUp);
			SignalBusManager.packPanelChange.add(onPackPanelOpen);
			SignalBusManager.heroPanelSelectHero.add(onExternalSelectHero);

			notifyPanelOpen(true);
			SignalBusManager.heroPropChange.add(onHeroPropChange);

			for each (var eqCell:EqCell in _eqDic)
			{
				eqCell.addEventListener(EnhanceTransferEvent.TRANSFER, enhanceTransferHandler);
			}
		}

		private function onExternalSelectHero(heroId : uint) : void
		{
			_heroTabList.selectHero(heroId);
		}

		protected function removeEvents() : void
		{
			_dissmisButton.removeEventListener(MouseEvent.CLICK, dissmissButton_ClickHandler);
			_heroTabList.selectionModel.removeEventListener(Event.CHANGE, heroTab_SelectHandler);
			_heroClickMask.removeEventListener(MouseEvent.ROLL_OVER, mask_rollOverHandler);
			_heroClickMask.removeEventListener(MouseEvent.ROLL_OUT, mask_rollOutHandler);
			_heroClickMask.removeEventListener(MouseEvent.CLICK, mask_clickHandler);
			_sutraIcon.removeEventListener(MouseEvent.ROLL_OVER, mask_rollOverHandler);
			_sutraIcon.removeEventListener(MouseEvent.ROLL_OUT, mask_rollOutHandler);
			_soulIcon.removeEventListener(MouseEvent.ROLL_OVER, mask_rollOverHandler);
			_soulIcon.removeEventListener(MouseEvent.ROLL_OUT, mask_rollOutHandler);
			_sutraIcon.removeEventListener(MouseEvent.CLICK, sutraIcon_clickHandler);
			_soulIcon.removeEventListener(MouseEvent.CLICK, soulIcon_clickHandler);
			ToolTipManager.instance.destroyToolTip(_soulIcon);
			ToolTipManager.instance.destroyToolTip(_heroClickMask);
			ToolTipManager.instance.destroyToolTip(_sutraIcon);
			Common.game_server.removeCallback(0xFFF3, onHeroEqChange);
			Common.game_server.removeCallback(0xFFF2, onPackChange);
			Common.game_server.removeCallback(0xFFF1, onLevelUp);

			SignalBusManager.packPanelChange.remove(onPackPanelOpen);
			SignalBusManager.heroPanelSelectHero.add(onExternalSelectHero);
			notifyPanelOpen(false);
			SignalBusManager.heroPropChange.remove(onHeroPropChange);

			for each (var eqCell:EqCell in _eqDic)
			{
				eqCell.removeEventListener(EnhanceTransferEvent.TRANSFER, enhanceTransferHandler);
			}
		}

		protected function onPackPanelOpen() : void
		{
			if (_transPanel)
				_transPanel.hide();
		}

		protected function sutraIcon_clickHandler(event : MouseEvent) : void
		{
			if (event.ctrlKey)
				return;
				
			if (!MenuManager.getInstance().checkOpen(MenuType.SUTRA))
				StateManager.instance.checkMsg(106);
			else
			{
				MenuManager.getInstance().openMenuView(MenuType.SUTRA);
				SignalBusManager.sutraPanelSelectHero.dispatch(_selectedHero.id);
			}
		}

		protected function soulIcon_clickHandler(event : MouseEvent) : void
		{
			// if (UserData.instance.level < SOUL_OPEN_LEVEL)
			if (!MenuManager.getInstance().checkOpen(MenuType.SOUL))
				StateManager.instance.checkMsg(105);
			else
			{
				MenuManager.getInstance().openMenuView(MenuType.SOUL);
				SignalBusManager.soulPanelSelectHero.dispatch(_selectedHero.id);
			}
		}

		protected function mask_clickHandler(event : MouseEvent) : void
		{
			if (!_propPanel.parent)
			{
				_propPanel.show();
				GLayout.layout(_propPanel);
			}
			else
			{
				_propPanel.hide();
			}
		}

		protected function mask_rollOverHandler(event : MouseEvent) : void
		{
			var target : Sprite = (event.target == _heroClickMask) ? _heroImage : event.target as Sprite;
			target.filters = [FilterUtils.defaultGlowFilter];
		}

		protected function mask_rollOutHandler(event : MouseEvent) : void
		{
			var target : Sprite = (event.target == _heroClickMask) ? _heroImage : event.target as Sprite;
			target.filters = [];
		}

		protected function heroTab_SelectHandler(event : Event) : void
		{
			changHero(_heroTabList.selection);
		}

		/**
		 * 离队
		 */
		protected function dissmissButton_ClickHandler(event : MouseEvent) : void
		{
			if (_selectedHero.equipments.length > 0 || _selectedHero.souls.length > 0)
				StateManager.instance.checkMsg(96, [_selectedHero.name], onConfirmDissmiss, [_selectedHero.color]);
			else
				StateManager.instance.checkMsg(95, [_selectedHero.name], onConfirmDissmiss, [_selectedHero.color]);
		}

		protected function onConfirmDissmiss(type : String) : Boolean
		{
			if (type == Alert.YES_EVENT || type == Alert.OK_EVENT)
			{
				var msg : CSHeroSummon = new CSHeroSummon();
				msg.id = _selectedHero.id;
				msg.summon = false;
				Common.game_server.sendMessage(0x18, msg);
			}
			return true;
		}

		/**
		 * 装备物品
		 */
		protected function onHeroEqChange(msg : CCHeroEqChange) : void
		{
			var vo : Equipment = ItemManager.instance.getEquipableItem(msg.uuid) as Equipment;
			if (!vo) return;
			if (_selectedHero.level < vo.level)
			{
				ViewManager.instance.rollMessage(StringUtils.addColor("等级不够!", "#ff0000"));
				return;
			}
			var slot : EquipmentSlot = _selectedHero.getEqSlot(vo.type);
			slot.equip(vo);
		}

		/*
		 * 装备信息发生变化
		 */
		protected function onPackChange(msg : Message) : void
		{
			if (!msg) return;
			updateEqCells();
			updateHeroInfo();
			updateSoulPower();
		}

		protected function onLevelUp(...arg) : void
		{
			updateView();
		}

		protected function enhanceTransferHandler(event : EnhanceTransferEvent) : void
		{
			_transPanel.setSourceTarget(event.sourceEquipment, event.targetEquipment);
			_transPanel.show();
			GLayout.layout(_transPanel);
			MenuManager.getInstance().closeMenuView(MenuType.PACK, false);
		}

		// ------------------------------------------------
		// 其它
		// ------------------------------------------------
		private static function notifyPanelOpen(status : Boolean) : void
		{
			PackVariable.heroPanelOpen = status;
			var msg : CCHeroPanelOpen = new CCHeroPanelOpen();
			msg.status = status;
			Common.game_server.sendCCMessage(0xFFF5, msg);
		}

		protected function provideSelectedHero() : VoHero
		{
			return _selectedHero;
		}

		protected function provideSelectSutra() : Sutra
		{
			return _selectedHero.sutra;
		}
	}
}
