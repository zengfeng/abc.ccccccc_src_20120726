package game.module.rewardPackage {
	import gameui.controls.GButton;
	import gameui.controls.GImage;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.core.ScaleMode;
	import gameui.data.GImageData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.button.KTButtonData;
	import com.commUI.tooltip.ToolTipData;
	import com.utils.StringUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;

	/**
	 * @author zheng
	 */
	public class GiftPackageItem extends GComponent {
		private var _id : int;
		private var _vo : VoPackReward;

		public function GiftPackageItem(id : int) {
			_base = new GComponentData();
			_base.width = 417;
			_base.height = 50;
			_base.toolTipData = new ToolTipData();
			_base.toolTipData.labelData.wordWrap = true;
			_base.toolTipData.labelData.scaleMode = ScaleMode.SCALE9GRID;
			_id = id;
			super(_base);
		}

		public function get id() : int {
			return _vo.giftId;
		}

		private var _back : Sprite;
		private var _buyButton : GButton;
		private var _nameText : TextField;
		private var _dateText : TextField;

		private function initView() : void {
			if (_back) this.removeChild(_back);
			_back = UIManager.getUI(new AssetData(_id % 2 == 0 ? "Shop_LigthBg" : "Shop_DarkBg"));
			_back.width = 417;
			_back.height = 50;
			addChildAt(_back, 0);
			addIcon();
			addLabel();
			addButton();
			this.toolTip.source = _vo.getTips(_vo);
			if (_vo.icoButton)
				_nameText.htmlText = StringUtils.addBold(_vo.icoButton.name);
			_dateText.text = _vo.getTimerString(_vo.giftTime);
		}

		private var _img : GImage;

		private function addIcon() : void {
			if (_img) {
				_img.url = _vo.getIcoUrl(_vo.giftId);
				return;
			}
			_img = new GImage(new GImageData());
			_img.x = 5;
			addChild(_img);
			_img.url = _vo.getIcoUrl(_vo.giftId);
		}

		private function addLabel() : void {
			if (_nameText) return;
			_nameText = UICreateUtils.createTextField(null, StringUtils.addBold(_vo.icoButton ? _vo.icoButton.name : "找不到"), 120, 25, 50, 18, UIManager.getTextFormat(14, 0x2f1f00, TextFormatAlign.CENTER));
			_dateText = UICreateUtils.createTextField(_vo.getTimerString(_vo.giftId), null, 70, 18, 228, 18, UIManager.getTextFormat(12, 0x279F15, TextFormatAlign.CENTER));
			// var name:String=_vo.icoButton.name;
			addChild(_nameText);
			addChild(_dateText);
		}

		private function addButton() : void {
			if (!_buyButton) {
				var data : KTButtonData = new KTButtonData(KTButtonData.SMALL_BUTTON);
				data.width = 51;
				data.height = 24;
				data.x = 352;
				data.y = 13;
				_buyButton = new GButton(data);
				_buyButton.text = "收取";
			}
			addChild(_buyButton);
			if (!_buyButton.hasEventListener(MouseEvent.CLICK))
				_buyButton.addEventListener(MouseEvent.CLICK, onClick);
		}

		public function clear() : void {
			if (_nameText) _nameText.text = "";
			if (_dateText) _dateText.text = "";
			this.toolTip.source = null;
			if (_buyButton)
				_buyButton.visible = false;
			if (_img)
				_img.visible = false;
		}

		override public function set source(value : *) : void {
			_vo = value;
			if (_vo) {
				initView();
				_buyButton.visible = true;
				_img.visible = true;
			} else {
				clear();
			}
		}

		private function onClick(event : MouseEvent) : void {
			// NotificationProxy.opNotification(0, _vo.getId());
			GiftPackageManage.sendResGift(_vo.giftId);
		}
	}
}
