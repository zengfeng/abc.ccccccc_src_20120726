package game.module.mapMining.ui
{
	import game.definition.UI;

	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.icon.ItemIcon;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * @author Rieman
	 */
	public class MiningAwardPanel extends GComponent
	{
		// =====================
		// 属性
		// =====================
		private var _awardIcons : Array;
		private var _awardItems : Array;
		private var _awardText : TextField;
		private var _background:Sprite;

		// =====================
		// Getter/Setter
		// =====================
		public function set awards(value : Array) : void
		{
			if (value == null)
				value = [];
				
			_awardItems = value;

			updateAwards();
			layoutElements();
		}

		// =====================
		// 方法
		// =====================
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------
		public function MiningAwardPanel()
		{
			var data : GComponentData = new GComponentData();
			super(data);
		}

		override protected function create() : void
		{
			super.create();
			addBackground();
			addAwardIcons();
			addAwardText();
		}

		private function addBackground() : void
		{
			_background = UIManager.getUI(new AssetData(UI.COMMON_BACKGROUND05));
			_background.y = -125;
			_background.height = 100;
			addChild(_background);
			
			var arrow:Sprite = UIManager.getUI(new AssetData(UI.AWARD_BOARD_ARROW));
			arrow.height = 32;
			arrow.x = -15;
			arrow.y = -31;
			addChild(arrow);
		}

		private function addAwardIcons() : void
		{
			_awardIcons = [];
			for (var i : int = 0; i < 4; i++)
			{
				var icon : ItemIcon = UICreateUtils.createItemIcon({showBorder:true, showBg:true, showNums:true});
				icon.y = -90;
				_awardIcons[i] = icon;
			}
		}

		private function addAwardText() : void
		{
			_awardText = UICreateUtils.createTextField(null, null, 200, 20, 0, -112, TextFormatUtils.panelContent);
			addChild(_awardText);
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		private function updateAwards() : void
		{
			var len:int = _awardIcons.length;
			var num:int = _awardItems.length;
			
			for (var i:int = 0; i<len; i++)
			{
				var icon:ItemIcon = _awardIcons[i];
				
				if (i<num)
				{
					icon.source = _awardItems[i];
					if (!contains(icon))
						addChild(icon);
				}
				else
				{
					if (contains(icon))
						removeChild(icon);
				}
			}
			
			_awardText.htmlText = "恭喜！你获得了仙石！";
		}

		private function layoutElements() : void
		{
			var num:int = _awardItems.length;
			var wicons:int = 50 * num + 16 * (num -1);
			var w:int = Math.max(266, wicons + 25 * 2);
			_background.width = w;
			_background.x = -int(w * 0.5);
			
			for (var i:int = 0; i<num;i++)
			{
				_awardIcons[i].x = _background.x + i * (50 + 16) + (w - wicons)/2;
			}
			
			_awardText.x = _background.x + 20;
		}
	}
}
