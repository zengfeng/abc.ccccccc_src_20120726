package game.module.gem.identify
{
	import com.commUI.icon.ItemIcon;
	import com.commUI.itemgrid.ItemGrid;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.core.item.Item;
	import game.core.item.gem.Gem;
	import game.core.user.StateManager;
	import game.definition.UI;
	import gameui.controls.GButton;
	import gameui.controls.GRadioButton;
	import gameui.data.GRadioButtonData;
	import gameui.manager.UIManager;
	import net.AssetData;





	/**
	 * @author jian
	 */
	public class SingleIdentifyPanel extends AbstractorSubPanel
	{
		// =====================
		// @属性
		// =====================
		public static var OPEN_BATCH : String = "open_batch";
		private var _master : GemMasterVO;
		private var _masterImg : Sprite;
		private var _masterPhrase : TextField;
		private var _costText : TextField;
		private var _costIcon : Sprite;
		private var _rawStoneIcon : ItemIcon;
		private var _identifyButton : GButton;
		private var _batchButton : GButton;
		private var _luckRButton : GRadioButton;

		// ==============================================================
		// @接口
		// ==============================================================
		public function SingleIdentifyPanel(control : GemIdentifyControl, sourceGrid : ItemGrid)
		{
			super(control, sourceGrid);
		}

		public function set master(value : GemMasterVO) : void
		{
			_master = value;

			_masterPhrase.text = value.phrase;

			if (_masterImg)
				_content.removeChild(_masterImg);
			_masterImg = UIManager.getUI(value.imgAsset);
			_masterImg.x = 10;
			_masterImg.y = 60;
			_content.addChildAt(_masterImg, 0);
		}

		// =====================
		// @创建
		// =====================
		/*
		 * 创建
		 */
		override protected function create() : void
		{
			super.create();

			addPhrase();
			addLuckRButtion();
			addRawStone();
			addCost();
			addButtons();
		}

		/*
		 * 大师对话
		 */
		private function addPhrase() : void
		{
			var board : Sprite = UIManager.getUI(new AssetData(UI.GEM_PHRASE_BOARD));
			board.x = 60;
			board.y = 5;
			_content.addChild(board);

			_masterPhrase = UICreateUtils.createTextField(null, null, 168, 45, 70, 10, TextFormatUtils.panelContent);
			_masterPhrase.wordWrap = true;
			_content.addChild(_masterPhrase);
		}

		/*
		 * 仙缘
		 */
		private function addLuckRButtion() : void
		{
			var data : GRadioButtonData = new GRadioButtonData();
			data.x = 157;
			data.y = 261;
			data.labelData.text = "如遇仙缘\r再次鉴定";

			_luckRButton = new GRadioButton(data);
			_content.addChild(_luckRButton);
		}

		/*
		 * 添加原石
		 */
		private function addRawStone() : void
		{
			_rawStoneIcon = UICreateUtils.createItemIcon({x:98, y:243, showBorder:true, showBg:true, showToolTip:true});
			_content.addChild(_rawStoneIcon);
		}

		/*
		 * 添加花费
		 */
		private function addCost() : void
		{
			_content.addChild(UICreateUtils.createTextField("消耗：", null, 120, 20, 82, 304, TextFormatUtils.panelContent));

			_costText = UICreateUtils.createTextField(null, null, 0, 0, 132, 304, TextFormatUtils.panelContent);
			_content.addChild(_costText);
		}

		/*
		 * 添加鉴定按钮
		 */
		private function addButtons() : void
		{
			_identifyButton = UICreateUtils.createGButton("鉴定", 0, 0, 43, 330);
			_content.addChild(_identifyButton);

			_batchButton = UICreateUtils.createGButton("批量鉴定", 0, 0, 135, 330);
			_content.addChild(_batchButton);
		}

		// =====================
		// @更新
		// =====================
		private function updateCost() : void
		{
		}

		// ==============================================================
		// @交互
		// ==============================================================
		/*
		 * 进入面板
		 */
		override protected function onShow() : void
		{
			super.onShow();

			_identifyButton.addEventListener(MouseEvent.CLICK, identifyHandler);
			_batchButton.addEventListener(MouseEvent.CLICK, openBatchHandler);
			_rawStoneIcon.addEventListener(MouseEvent.CLICK, iconClickHandler);
		}

		/*
		 * 退出面板
		 */
		override protected function onHide() : void
		{
			_identifyButton.removeEventListener(MouseEvent.CLICK, identifyHandler);
			_batchButton.removeEventListener(MouseEvent.CLICK, openBatchHandler);
			_rawStoneIcon.removeEventListener(MouseEvent.CLICK, iconClickHandler);
			super.onHide();
		}

		/*
		 * 物品从包裹进入待鉴定格
		 */
		override protected function addUnidentifiedItem(item : Item) : void
		{
			_rawStoneIcon.source = item;
		}

		/*
		 * 物品从待鉴定格退回包裹
		 */
		private function iconClickHandler(event : MouseEvent) : void
		{
			if (_rawStoneIcon.source != null)
			{
				_rawStoneIcon.source = null;
				updateItemGrid();
			}
		}

		override protected function getFilterItems() : Array
		{
			if (_rawStoneIcon.source)
				return [_rawStoneIcon.source];
			else
				return [];
		}

		/*
		 * 玩家点击鉴定按钮
		 */
		private function identifyHandler(event : MouseEvent) : void
		{
			var item : Item = _rawStoneIcon.source;

			if (item && !(item is Gem))
			{
				_control.addEventListener(Event.COMPLETE, identifyCompleteHandler);
				_control.item = item;
				_control.master = _master;
				_control.wantLuck = _luckRButton.selected;
				_control.identify();
			}
			else
			{
				StateManager.instance.checkMsg(84);
				_rawStoneIcon.source = null;
			}
		}

		/*
		 * 鉴定结果
		 */
		private function identifyCompleteHandler(event : Event) : void
		{
			_control.removeEventListener(Event.COMPLETE, identifyCompleteHandler);
			_rawStoneIcon.source = _control.identifiedGem;
			updateItemGrid();
		}

		/*
		 * 点击批量按钮
		 */
		private function openBatchHandler(event : MouseEvent) : void
		{
			var e : Event = new Event(OPEN_BATCH);
			dispatchEvent(e);
		}
	}
}
