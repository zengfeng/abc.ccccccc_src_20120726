package game.module.mapConvoy.ui
{
	import com.commUI.icon.ItemIcon;
	import com.utils.ColorUtils;
	import com.utils.UICreateUtils;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.module.mapConvoy.ConvoyConfig;
	import gameui.controls.GLabel;
	import gameui.controls.GRadioButton;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GLabelData;




	/**
	 * @author ZengFeng (Email:zengfeng75[AT]163.com) 2012-3-14   ����4:01:09 
	 */
	public class XiangLuOptionItem extends GComponent {
		public var id : int;
		public var icon : ItemIcon;
		public var radioButton : GRadioButton;

		public function XiangLuOptionItem(id : int) {
			this.id = id;
			_base = new GComponentData();
			_base.width = 55;
			_base.height = 90;
			super(_base);
			initViews();
		}

		private function initViews() : void {
//			 var iconData:ItemIconData = new ItemIconData();
			// iconData.showBg = true;
			// iconData.showBorder = true;
			// iconData.showToolTip = true;
			// iconData.showNums = id != ConvoyConfig.XIANG_LU_1;
			// icon = new ItemIcon(iconData);
			icon = UICreateUtils.createItemIcon({showBg:true, showBorder:true, showToolTip:true, showNums:id != ConvoyConfig.XIANG_LU_1, showShopping:id != ConvoyConfig.XIANG_LU_1, shopMinLimit:1});
			var item : Item = ItemManager.instance.getPileItem(ConvoyConfig.xiangLuGoodsDic[id]);
			icon.source = item;
			icon.x = (_base.width - icon.width) / 2;
			icon.y = 0;
			addChild(icon);
			var labelData : GLabelData = new GLabelData();
			labelData.text = item.name;
			labelData.textColor = ColorUtils.TEXTCOLOROX[item.color];
			labelData.width = _base.width;
			labelData.textFormat.align = TextFormatAlign.CENTER;
			labelData.y = icon.height + 3;
			labelData.textFieldFilters = [];
			var label : GLabel = new GLabel(labelData);
			addChild(label);

			// var radioButtonData:GRadioButtonData = new GRadioButtonData();
			// radioButtonData.iconData.width = 15;
			// radioButtonData.iconData.height = 15;
			// radioButton = new GRadioButton(radioButtonData);
			radioButton = UICreateUtils.createGRadioButton("");
			radioButton.source = id;
			radioButton.x = (_base.width - radioButton.width) / 2;
			radioButton.y = _base.height - radioButton.height;
			addChild(radioButton);

			this.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(event : MouseEvent) : void {
			if (id != ConvoyConfig.XIANG_LU_1) {
				var item : Item = icon.source;
				if (item.nums < 1) {
					item = ItemManager.instance.getPileItem(ConvoyConfig.xiangLuGoodsDic[id]);
					if (item.nums >= 1) {
						icon.source = item;
					} else {
					}
				}
			}

			radioButton.selected = true;
		}

		public function refresh() : void {
			var item : Item = ItemManager.instance.getPileItem(ConvoyConfig.xiangLuGoodsDic[id]);
			icon.source = item;
		}
	}
}
