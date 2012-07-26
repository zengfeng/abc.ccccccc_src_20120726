package game.module.vip.view
{
	import game.definition.UI;
	import game.module.vip.VIPItemVO;

	import gameui.cell.GCell;
	import gameui.cell.GCellData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	import com.utils.StringUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;

	/**
	 * @author ME
	 */
	public class VIPListCell extends GCell
	{
		// ======================================================
		// 属性
		// ======================================================
		private var _nameText : TextField;
		private var _currTimesText : TextField;
		private var _nextTimesText : TextField;

		// ======================================================
		// Getter/Setter
		// ======================================================
		override public function set source(value : *) : void
		{
			_source = value;

			if (_source)
			{
				updateBg();
				updateVipListCellText();
			}
			else
				clear();
		}

		public function get vipVO() : VIPItemVO
		{
			return _source as VIPItemVO;
		}

		// ======================================================
		// 方法
		// ======================================================
		public function VIPListCell(data : GCellData)
		{
			data.upAsset = new AssetData(SkinStyle.emptySkin);
			data.overAsset = null;
			data.selected_upAsset = null;
			data.selected_overAsset = null;
			data.disabledAsset = null;
			super(data);
		}

		override protected function create() : void
		{
			super.create();
			addVipListCellText();
		}

		private function addVipListCellText() : void
		{
			_nameText = UICreateUtils.createTextField(null, "", 300, 18, 70, 4, UIManager.getTextFormat(12, 0x2f1f00, TextFormatAlign.LEFT));
			addChild(_nameText);

			_currTimesText = UICreateUtils.createTextField(null, "", 50, 18, 203, 4, UIManager.getTextFormat(12, 0x2f1f00, TextFormatAlign.CENTER));
			// addChild(_currTimesText);

			_nextTimesText = UICreateUtils.createTextField(null, "", 50, 18, 350, 4, UIManager.getTextFormat(12, 0x2f1f00, TextFormatAlign.CENTER));
			// addChild(_nextTimesText);
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		private function updateVipListCellText() : void
		{
			// _nameText.text = vipVO.name;
			// _currTimesText.text = vipVO.currState;
			// _nextTimesText.text = vipVO.nextState;
			// _nextTimesText.textColor = vipVO.nextLevelColor;
			if (vipVO.nextLevelColor == 0x2f1f00)
			{
				_nameText.htmlText = StringUtils.addColor(String(vipVO.vipListNum) + "." + vipVO.name + " ", "#2f1f00") + StringUtils.addColor(vipVO.nextState, "#2f1f00");
			}
			else
			{
				_nameText.htmlText = StringUtils.addColor(String(vipVO.vipListNum) + "." + vipVO.name + " ", "#2f1f00") + StringUtils.addColor(vipVO.nextState, "#ff3300");
			}
		}

		private function clear() : void
		{
			_nameText.text = "";
			_currTimesText.text = "";
			_nextTimesText.text = "";
		}

		private function updateBg() : void
		{
			var bg : Sprite;
			if (vipVO.bgInt == 0)
				bg = UIManager.getUI(new AssetData(UI.VIP_LIST_LIGHT_BG));
			else
				bg = UIManager.getUI(new AssetData(UI.VIP_LIST_DARK_BG));
			bg.x = 0;
			bg.y = 0;
			bg.width = 386 - 5;
			bg.height = 25;
			addChildAt(bg, 0);
		}
	}
}
