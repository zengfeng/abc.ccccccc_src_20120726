package game.module.trade.exchange
{
	import com.commUI.icon.ItemIcon;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.item.pile.PileItem;
	import game.definition.UI;
	import game.manager.ViewManager;
	import gameui.containers.GPanel;
	import gameui.controls.GButton;
	import gameui.controls.GTextInput;
	import gameui.core.GAlign;
	import gameui.data.GButtonData;
	import gameui.data.GPanelData;
	import net.AssetData;





	/**
	 * @author jian
	 */
	public class PileSplitter extends GPanel
	{
		// =====================
		// @属性
		// =====================
		private var _item : PileItem;
		private var _okFunc : Function;
		private var _cancelFunc : Function;
		private var _numsInput : GTextInput;
		private var _maxButton : GButton;
		private var _okButton : GButton;
		private var _cancelButton : GButton;

		// =====================
		// @创建
		// =====================
		public static function splitPile(pile : PileItem, okFunc : Function = null, cancelFunc : Function = null, parent : Sprite = null) :PileSplitter
		{
			var dialog : PileSplitter = new PileSplitter(pile, okFunc, cancelFunc, parent);
			var container : Sprite = parent==null ? ViewManager.instance.uiContainer : parent;
			dialog.x = (container.width - dialog.width) / 2;
			dialog.y = (container.height - dialog.height) / 2;
			container.addChild(dialog);
			return dialog;
		}

		public function PileSplitter(pile : PileItem, okFunc : Function = null, cancelFunc : Function = null, parent : DisplayObjectContainer = null)
		{
			_item = pile;

			_okFunc = okFunc;
			_cancelFunc = cancelFunc;

			var data : GPanelData = new GPanelData();
			data.width = 213;
			data.height = 137;
			data.bgAsset = new AssetData(UI.PILE_SPLITTER_BG);
			data.align = new GAlign(-1, -1, -1, -1, 1, 1);
			data.parent = parent;

			super(data);
		}

		override protected function create() : void
		{
			super.create();

			addIcon();
			addName();
			addNums();
			addMaxButton();
			addButtons();
		}
 
		private function addIcon() : void
		{
			var icon : ItemIcon = UICreateUtils.createItemIcon({x:22, y:30, showBorder:true, showBg:true, showToolTip:true});
			icon.source = _item;
			_content.addChild(icon);
		}

		private function addName() : void
		{
			_content.addChild(UICreateUtils.createTextField(null, _item.htmlName, 106, 20, 89, 30, TextFormatUtils.panelSubTitle));
		}

		private function addNums() : void
		{
			_content.addChild(UICreateUtils.createTextField("数量：", null, 60, 20, 89, 55, TextFormatUtils.panelContent));
			_numsInput = UICreateUtils.createGTextInput({text:"1", width:70, height:25, x:123, y:51, restrict:"0-9", maxChars:2, selectAll:true});
			_content.addChild(_numsInput);
		}

		private function addMaxButton() : void
		{
			var data : GButtonData = new GButtonData();
			data.upAsset = new AssetData(UI.SAN_JIAO_UP);
			data.overAsset = new AssetData(UI.SAN_JIAO_OVER);
			data.downAsset = new AssetData(UI.SAN_JIAO_DOWN);
			data.x = 175;
			data.y = 54;
			data.width = 15;
			data.height = 19;

			_maxButton = new GButton(data);
			_content.addChild(_maxButton);
		}

		private function addButtons() : void
		{
			_okButton = UICreateUtils.createGButton("确定", 80, 30, 20, 95);
			_content.addChild(_okButton);

			_cancelButton = UICreateUtils.createGButton("取消", 80, 30, 114, 95);
			_content.addChild(_cancelButton);
		}

		// =====================
		// @更新
		// =====================
		// =====================
		// @交互
		// =====================
		override protected function onShow() : void
		{
			super.onShow();
			_okButton.addEventListener(MouseEvent.CLICK, clickOkHandler);
			_cancelButton.addEventListener(MouseEvent.CLICK, clickCancelHandler);
			_maxButton.addEventListener(MouseEvent.CLICK, clickMaxHandler);
			_numsInput.addEventListener(KeyboardEvent.KEY_UP, numsInputFocusOutHandler);
		}

		override protected function onHide() : void
		{
			_okButton.removeEventListener(MouseEvent.CLICK, clickOkHandler);
			_cancelButton.removeEventListener(MouseEvent.CLICK, clickCancelHandler);
			_maxButton.removeEventListener(MouseEvent.CLICK, clickMaxHandler);
			_numsInput.removeEventListener(KeyboardEvent.KEY_UP, numsInputFocusOutHandler);
			super.onHide();
		}

		private function numsInputFocusOutHandler(event : KeyboardEvent) : void
		{


			var nums : int = int(_numsInput.text);
			if ( nums > _item.nums)
				_numsInput.text = _item.nums.toString();
			if ( nums <= 0 || !_numsInput.text)
			{
				_numsInput.text = "1";
				_numsInput.selectAll();
			}
		}

		private function clickMaxHandler(event : MouseEvent) : void
		{
			_numsInput.text = _item.nums.toString();
		}

		private function clickOkHandler(event : MouseEvent) : void
		{
			if (_okFunc != null)
				_okFunc(getSplitItem());

			dispose();
		}

		private function clickCancelHandler(event : MouseEvent) : void
		{
			if (_cancelFunc != null)
				_cancelFunc(getSplitItem());

			dispose();
		}

		private function getSplitItem() : Item
		{
			var item : Item = ItemManager.instance.newItem(_item.id);
			item.nums = uint(_numsInput.text);
			return item;
		}

		private function dispose() : void
		{
			if (this.parent && this.parent.contains(this))
				this.parent.removeChild(this);
		}
	}
}