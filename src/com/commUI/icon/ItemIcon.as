package com.commUI.icon
{
	import game.core.hero.VoHero;
	import game.core.item.IUnique;
	import game.core.item.Item;
	import game.core.item.equipable.HeroSlot;
	import game.core.item.equipable.IEquipable;
	import game.core.item.equipment.Equipment;
	import game.core.item.gem.Gem;
	import game.core.item.soul.Soul;
	import game.definition.ID;
	import game.definition.UI;
	import game.manager.SignalBusManager;

	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.quickshop.SingleQuickShop;
	import com.commUI.tooltip.ToolTipManager;
	import com.greensock.TweenLite;
	import com.utils.FilterUtils;
	import com.utils.ItemUtils;
	import com.utils.StringUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author verycd
	 */
	public class ItemIcon extends CommonIcon
	{
		// =====================
		// @定义
		// =====================
		public static const NORMAL_ICON : uint = 0;
		public static const SMALL_ICON : uint = 1;
		// =====================
		// 属性
		// =====================
		private var _mouseMask : Sprite;

		// =====================
		// @公共
		// =====================
		public function set showBorder(value : Boolean) : void
		{
			if (thisdata.showBorder == value)
				return;

			thisdata.showBorder = value;
			updateBorder();
		}

		public function set showNums(value : Boolean) : void
		{
			if (thisdata.showNums == value)
				return;

			thisdata.showNums = value;
			updateNums();
			updateName();
		}

		public function set showLevel(value : Boolean) : void
		{
			if (thisdata.showLevel == value)
				return;

			thisdata.showLevel = value;
			updateLevel();
		}

		public function set showOwner(value : Boolean) : void
		{
			if (thisdata.showOwner == value)
				return;

			thisdata.showOwner = value;
			updateOwner();
		}

		public function set showBinding(value : Boolean) : void
		{
			if (thisdata.showBinding == value)
				return;

			thisdata.showBinding = value;
			updateBinding();
		}

		public function set showToolTip(value : Boolean) : void
		{
			if (thisdata.showToolTip == value)
				return;

			thisdata.showToolTip = value;
			updateToolTip();
		}

		public function set showName(value : Boolean) : void
		{
			if (thisdata.showName == value)
				return;

			thisdata.showName = value;
			updateName();
		}

		public function set showRollOver(value : Boolean) : void
		{
			if (thisdata.showRollOver == value)
				return;

			thisdata.showRollOver = value;
			updateShowRollOver();
		}

		public function set showShopping(value : Boolean) : void
		{
			if (thisdata.showShopping == value)
				return;

			thisdata.showShopping = value;
			updateShowShopping();
		}

		public function set minNums(value : int) : void
		{
			if (thisdata.minNums == value)
				return;

			thisdata.minNums = value;
			updateNums();
		}

		override public function set source(value : *) : void
		{
			_source = value;

			if (_source)
			{
				updateImage();
				updateBorder();
				updateLevel();
				updateOwner();
				updateBinding();
				updateNums();
				updateName();
			}
			else
			{
				clear();
			}

			updateToolTip();
		}

		override public function set enabled(value : Boolean) : void
		{
			super.enabled = value;

			if (value)
				filters = [];
			else
				filters = [FilterUtils.disableFilter()];
		}

		public function ItemIcon(data : ItemIconData)
		{
			super(data);
		}

		// =====================
		// @方法
		// =====================
		private function get thisdata() : ItemIconData
		{
			return _base as ItemIconData;
		}

		override protected function create() : void
		{
			super.create();

			if (thisdata.showBg)
			{
				background = UIManager.getUI(new AssetData(UI.ROUND_ICON_BACKGROUND_EMPTY));
			}

			if (thisdata.showShopping || thisdata.showRollOver || thisdata.showToolTip || thisdata.sendChat)
			{
				addMouseMask();
			}
		}

		private function addMouseMask() : void
		{
			_mouseMask = new Sprite();
			with (_mouseMask)
			{
				graphics.beginFill(0x000000, 0);
				graphics.drawCircle(23, 23, 22);
				graphics.endFill();
			}
			addChild(_mouseMask);
		}

		// =====================
		// @更新
		// =====================
		private function updateImage() : void
		{
			iconUrl = (_source as Item).imgUrl;
		}

		private function updateBorder() : void
		{
			if (thisdata.showBorder)
			{
				border = UIManager.getUI(new AssetData(ItemUtils.getBorderByColor((_source as Item).color)));
			}
		}

		private function updateLevel() : void
		{
			if (thisdata.showLevel)
			{
				if (_source is Equipment)
				{
					if (Equipment(_source).enhanceLevel == 0)
						level = "";
					else
						level = StringUtils.addColorById("+" + Equipment(_source).enhanceLevel, Equipment(_source).enhanceColor);
				}
				else if (_source is Soul)
				{
					level = StringUtils.addColorById(" " + Soul(_source).level, Soul(_source).color);
				}
				else if (_source is Gem)
				{
					level = StringUtils.addColorById(" " + Gem(_source).level, Gem(_source).color);
				}
				else
					level = "";
			}
			else
			{
				level = "";
			}
		}

		private function updateOwner() : void
		{
			if (thisdata.showOwner)
			{
				var  heroName : String = "";

				if (_source is IEquipable)
				{
					var slot : HeroSlot = IEquipable(_source).slot as HeroSlot;

					if (slot)
					{
						var hero : VoHero = HeroSlot(IEquipable(_source).slot).hero;

						if (hero)
							heroName = hero._name.slice(0, 1);
					}
				}

				owner = heroName;
			}
			else
				owner = "";
		}

		private function updateBinding() : void
		{
			var item : Item = _source as Item;

			if (thisdata.showBinding)
			{
				if (!item.binding)
				{
					if (!_tradeIcon)
					{
						_tradeIcon = UIManager.getUI(new AssetData(UI.ICON_TRADABLE));
						_tradeIcon.x = width - 12;
						_tradeIcon.y = 2;
						_tradeIcon.mouseEnabled = false;
					}

					if (!_tradeIcon.parent)
						addChild(_tradeIcon);
				}
				else
				{
					if (_tradeIcon && _tradeIcon.parent)
						removeChild(_tradeIcon);
				}
			}
			else
			{
				if (_tradeIcon)
				{
					if (_tradeIcon.parent)
						removeChild(_tradeIcon);
					_tradeIcon = null;
				}
			}
		}

		private function updateNums() : void
		{
			var item : Item = _source as Item;

			if (thisdata.showNums && item && item.config.stackLimit > 1 && !(item is IUnique))
			{
				var text : String = "";
				if (item.nums < thisdata.minNums)
					text = StringUtils.addColor(item.nums.toString(), "#ff0000");
				else if (item.nums > 99)
					text = "99+";
				else
					text = item.nums.toString();

				pileNums = text;
			}
			else
			{
				if (_pileNumText) _pileNumText.text = "";
			}
		}

		private function updateToolTip() : void
		{
			if (thisdata.showToolTip)
			{
				if (_source)
				{
					ToolTipManager.instance.registerToolTip(_mouseMask, ItemUtils.getItemToolTipClass(_source, thisdata.showPair), this);
					var tpoint : Point = localToGlobal(new Point(mouseX, mouseY));
					if (hitTestPoint(tpoint.x, tpoint.y))
						ToolTipManager.instance.refreshToolTip(_mouseMask);
				}
				else
					ToolTipManager.instance.destroyToolTip(_mouseMask);
			}
		}

		private function updateName() : void
		{
			var item : Item = _source as Item;

			if (thisdata.showNums && item && (item.id == ID.SILVER || item.id == ID.HONOR || item.id == ID.GOLD || item.id == ID.BIND_GOLD))
			{
				htmlName = StringUtils.addColorById(item.nums.toString(), 1);
			}
			else if (thisdata.showName && _source)
			{
				htmlName = StringUtils.addColorById(item.name.slice(0, 2), item.color);
			}
			else
			{
				if (_nameText)
					_nameText.htmlText = "";
			}
		}

		private function updateShowRollOver() : void
		{
			if (thisdata.showRollOver)
			{
				_mouseMask.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				_mouseMask.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			}
			else
			{
				_mouseMask.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				_mouseMask.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			}
		}

		private function updateShowShopping() : void
		{
			if (thisdata.showShopping)
				if (!_mouseMask.hasEventListener(MouseEvent.CLICK))
					_mouseMask.addEventListener(MouseEvent.CLICK, mouseClickHandler);
				else if (_mouseMask.hasEventListener(MouseEvent.CLICK))
					_mouseMask.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
		}

		override public function set border(border : Sprite) : void
		{
			if (_border)
				removeChild(_border);

			_border = border;

			if (_border)
			{
				_border.x = 1;
				_border.y = 1;
				_border.width = 46;
				_border.height = 46;
				_border.mouseEnabled = false;

				if (thisdata.showBg)
					addChildAt(_border, 1);
				else
					addChildAt(_border, 0);
			}
		}

		/*
		 * 设置背景
		 */
		override public function set background(background : Sprite) : void
		{
			if (_background)
				removeChild(_background);

			_background = background;

			if (_background)
			{
				_background.x = 1;
				_background.y = 1;
				_background.width = 46;
				_background.height = 46;
				_background.mouseEnabled = false;
				addChildAt(_background, 0);
			}
		}

		// =====================
		// @交互
		// =====================
		override protected function onShow() : void
		{
			if (thisdata.showShopping || thisdata.sendChat)
				_mouseMask.addEventListener(MouseEvent.CLICK, mouseClickHandler);

			if (thisdata.showRollOver)
			{
				_mouseMask.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				_mouseMask.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			}
		}

		override protected function onHide() : void
		{
			if (thisdata.showShopping || thisdata.sendChat)
				_mouseMask.removeEventListener(MouseEvent.CLICK, mouseClickHandler);

			if (thisdata.showRollOver)
			{
				_mouseMask.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				_mouseMask.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			}
		}

		protected function mouseClickHandler(event : MouseEvent) : void
		{
			if (!_source) return;

			if (event.ctrlKey && thisdata.sendChat)
			{
				var item : Item = _source as Item;
				SignalBusManager.sendToChatItem.dispatch(item);
			}
			else if (thisdata.showShopping && (thisdata.shopMinLimit == 0 || (_source as Item).nums < thisdata.shopMinLimit))
			{
				SingleQuickShop.show(_source["id"], ID.GOLD, 1, null, null, this);
			}
		}

		private function rollOverHandler(event : MouseEvent) : void
		{
			_iconBitmap.filters = [FilterUtils.defaultHightLightFilter];

			if (_source)
			// TweenMax.to(_iconBitmap, 0.17, {glowFilter:{color:0xEEFF00, alpha:0.8, blurX:6, blurY:6, strength:4}});
				TweenLite.to(_iconBitmap, 0.20, {y:-3});
			else
				_iconBitmap.y = -3;
		}

		private function rollOutHandler(event : MouseEvent) : void
		{
			_iconBitmap.filters = [];
			if (_source)
				TweenLite.to(_iconBitmap, 0.20, {y:0});
			else
				_iconBitmap.y = 0;
		}
	}
}
