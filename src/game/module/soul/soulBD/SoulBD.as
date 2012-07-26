package game.module.soul.soulBD
{
	import com.greensock.TweenLite;
	import com.utils.ColorUtils;
	import com.utils.FilterUtils;
	import com.utils.StringUtils;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.core.item.soul.Soul;
	import gameui.controls.BDPlayer;
	import gameui.controls.GImage;
	import gameui.core.GComponentData;
	import gameui.data.GImageData;




	/**
	 * @author jian
	 */
	public class SoulBD extends Sprite
	{
		// =====================
		// Attribute
		// =====================
		private var _source : Soul;
		private var _filterContainer : Sprite;
		private var _flamePlayer : BDPlayer;
		private var _flameManager : SoulFlameManager = SoulFlameManager.instance;
		private var _totemIcon : GImage;
		private var _showName : Boolean;
		private var _showLevel : Boolean;
		private var _nameText : TextField;
		private var _levelText : TextField;
		private var _hitArea : Sprite;
		private var _showRollOver : Boolean = false;

		// =====================
		// Getter/Setter
		// =====================
		public function get soul() : Soul
		{
			return _source as Soul;
		}

//		public function get totem() : DisplayObject
//		{
//			return _totemIcon;
//		}

		public function set source(value : Soul) : void
		{
			if (_source != value)
			{
				_source = value;
				update();
			}
		}

		public function set showName(value : Boolean) : void
		{
			_showName = value;
			updateName();
		}
		
		public function set showLevel(value:Boolean):void
		{
			_showLevel = value;
			updateLevel();
		}

		public function set showRollOver(value : Boolean) : void
		{
			_showRollOver = value;
			updateShowRollOver();
		}

		public function clear() : void
		{
//			if (_flamePlayer)
//				_flamePlayer.dispose();

//			if (_totemIcon)
//				_totemIcon.clearUp();

			if (_nameText)
				_nameText.htmlText = "";

			filters = [];
		}

		// =====================
		// Method
		// =====================
		public function SoulBD(showName : Boolean = false, showLevel:Boolean = false)
		{
			_showName = showName;
			_showLevel = showLevel;

			_filterContainer = new Sprite();
			addChild(_filterContainer);

			_flamePlayer = new BDPlayer(new GComponentData());
			_filterContainer.addChild(_flamePlayer);

//			_totemIcon = new GImage(new GImageData());
//			_totemIcon.x = -22;
//			_totemIcon.y = -21;
//			_filterContainer.addChild(_totemIcon);
		}

		private function update() : void
		{
			if (_source)
			{
				updateHue();
//				updateTotem();
				updateFlame();
				updateName();
				updateLevel();
			}
			else
			{
				clear();
			}
		}

		private function updateTotem() : void
		{
			_totemIcon.url = (_source as Soul).totemUrl;
		}

		private function updateFlame() : void
		{
			_flamePlayer.setBDData(_flameManager.getFlameBD(soul.flameId));
			_flamePlayer.play(_flameManager.getFlameTime(soul.flameId), null, 0);
		}

		private function updateName() : void
		{
			if (_showName)
			{
				if (!_nameText)
				{
					_nameText = UICreateUtils.createTextField(null, null, 48, 16, -24, 13, TextFormatUtils.iconName);
					_nameText.filters = [FilterUtils.iconTextEdgeFilter];
					addChild(_nameText);
				}
				_nameText.htmlText = (_source as Soul).htmlShortName;
			}
			else
			{
				if (_nameText)
					_nameText.htmlText = "";
			}
		}

		private function updateLevel() : void
		{
			if (_showLevel)
			{
				if (!_levelText)
				{
					_levelText = UICreateUtils.createTextField(null, null, 48, 16, -19, -19, TextFormatUtils.iconLevel);
					_levelText.filters = [FilterUtils.iconTextEdgeFilter];
					addChild(_levelText);
				}
				_levelText.htmlText = StringUtils.addColorById(soul.level.toString(), soul.color);
			}
			else
			{
				if (_levelText)
					_levelText.htmlText = "";
			}
		}

		public function updateHue() : void
		{
			
			if (soul.isExpSoul())
				_filterContainer.filters = [];
			else if (soul.color == ColorUtils.GREEN)
				_filterContainer.filters = [FilterUtils.getHueFilter(-106)];
			else if (soul.color == ColorUtils.BLUE)
				_filterContainer.filters = [];
			else if (soul.color == ColorUtils.VIOLET)
				_filterContainer.filters = [FilterUtils.getHueFilter(93)];
			else if (soul.color == ColorUtils.ORANGE)
				_filterContainer.filters = [];
			else
				_filterContainer.filters = [];
		}

		private function updateShowRollOver() : void
		{
			if (_showRollOver)
			{
				if (!_hitArea)
				{
					_hitArea = new Sprite();
					_hitArea.graphics.beginFill(0);
					_hitArea.graphics.drawCircle(25, 25, 25);
				}
				hitArea = _hitArea;
				addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			}
			else
			{
				hitArea = null;
				removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			}
		}

		private function rollOverHandler(event : MouseEvent) : void
		{
			TweenLite.to(_filterContainer, 0.20, {y:-3});
		}

		private function rollOutHandler(event : MouseEvent) : void
		{
			TweenLite.to(_filterContainer, 0.20, {y:0});
		}
	}
}
