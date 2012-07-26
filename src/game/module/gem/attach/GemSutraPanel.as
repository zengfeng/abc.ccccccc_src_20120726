package game.module.gem.attach
{
	import game.core.item.sutra.Sutra;
	import game.definition.UI;
	import game.net.core.Common;
	import game.net.data.CtoC.CCUserDataChangeUp;

	import gameui.controls.GImage;
	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GImageData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.utils.StringUtils;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * @author jian
	 */
	public class GemSutraPanel extends GComponent
	{
		// =====================
		// 定义
		// =====================
		private static const COLUMNS : uint = 2;

		private static const ROWS : uint = 3;

		private static const OFFSET_X : uint = 31;

		private static const OFFSET_Y : uint = 92;

		private static const CELL_SPACE_X : uint = 187;

		private static const CELL_SPACE_Y : uint = 66;

		// =====================
		// 属性
		// =====================
		private var _nameText : TextField;

		private var _sutraImage : GImage;

		private var _slotArray : Array /* of GemSlotCell */;

		private var _taiChi : Sprite;

		// =====================
		// Setter/Getter
		// =====================
		override public function set source(value : *) : void
		{
			super.source = value;

			updateNameText();
			updateSutraImage();
			updateSlots();
		}

		public function set sutra(value : Sutra) : void
		{
			this.source = value;
		}

		public function get sutra() : Sutra
		{
			return _source as Sutra;
		}

		// =====================
		// 方法
		// =====================
		public function GemSutraPanel(data : GComponentData)
		{
			super(data);
		}

		override protected function create() : void
		{
			super.create();

			addBackground();
			addNameText();
			addSutraImage();
			addSlots();
		}

		private function addBackground() : void
		{
			var bg : Sprite = UIManager.getUI(new AssetData(UI.AREA_BACKGROUND));
			bg.x = 0;
			bg.y = 0;
			bg.width = _base.width;
			bg.height = _base.height;
			addChild(bg);

			_taiChi = UIManager.getUI(new AssetData(UI.GEM_TAICHI));
			_taiChi.x = (width - _taiChi.width) / 2;
			_taiChi.y = (height - _taiChi.height) / 2;
			addChild(_taiChi);
		}

		private function addNameText() : void
		{
			_nameText = UICreateUtils.createTextField(null, null, 130, 25, 63, 6, TextFormatUtils.panelSubTitleCenter);
			addChild(_nameText);

			var underline : Sprite = UIManager.getUI(new AssetData(UI.UNDERLINE_STYLE_1));
			underline.x = 60;
			underline.y = 26;
			addChild(underline);
		}

		private function addSutraImage() : void
		{
			var data : GImageData = new GImageData();
			data.iocData.align = new GAlign(-1, -1, -1, -1, 0, 0);
			data.width = 175;
			data.height = 253;
			data.x = 40;
			data.y = 32;

			_sutraImage = new GImage(data);
			addChild(_sutraImage);
		}

		private function addSlots() : void
		{
			_slotArray = [];
			for (var row : uint = 0; row < ROWS; row++)
			{
				for (var col : uint = 0; col < COLUMNS; col++)
				{
					var slot : GemSlotCell = new GemSlotCell();
					slot.x = OFFSET_X + CELL_SPACE_X * col;
					slot.y = OFFSET_Y + CELL_SPACE_Y * row;
					addChild(slot);
					_slotArray.push(slot);
				}
			}
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		private function updateNameText() : void
		{
			_nameText.htmlText = StringUtils.addColorById(sutra.name + " " + sutra.step + "阶", sutra.color);
		}

		private function updateSutraImage() : void
		{
			_sutraImage.url = sutra.imgLargeUrl;
		}

		private function updateSlots() : void
		{
			var slots : Array = sutra.hero.gemSlots;
			var length : uint = slots.length;
			var level : uint = sutra.hero.level;
			var num : uint = Math.min(6, (level < 70) ? 0 : ((level - 70) / 5 + 2));
			var unlockLevel : uint = level - (level % 5) + 5;

			for (var i : uint = 0; i < length;i++)
			{
				var slotCell : GemSlotCell = _slotArray[i] as GemSlotCell;
				slotCell.source = slots[i];

				if (i < num)
				{
					slotCell.lock = false;
				}
				else
				{
					slotCell.unlockLevel = unlockLevel;
					slotCell.lock = true;
				}
			}
		}

		override protected function onShow() : void
		{
			super.onShow();
			Common.game_server.addCallback(0xFFF1, onHeroLevelUp);
		}

		override protected function onHide() : void
		{
			Common.game_server.removeCallback(0xFFF1, onHeroLevelUp);
			super.onHide();
		}

		private function onHeroLevelUp(msg : CCUserDataChangeUp) : void
		{
			if (_source)
			{
				updateSlots();
			}
		}
	}
}
