package game.module.rewardPackage
{
	import game.core.item.Item;
	import game.core.item.ItemService;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.definition.ID;
	import game.definition.UI;
	import game.manager.ViewManager;
	import game.net.core.Common;

	import gameui.controls.GButton;
	import gameui.data.GButtonData;
	import gameui.data.GTitleWindowData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.GCommonWindow;
	import com.commUI.icon.ItemIcon;
	import com.commUI.icon.ItemIconData;
	import com.utils.StringUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * @author zheng
	 */
	public class OnlineGiftView extends GCommonWindow
	{
		// =====================
		// 定义
		// =====================
		public static const iconStartX : uint = 11;
		public static const iconPanelWidth : uint = 266;
		public static const iconWidth : uint = 50;
		// =====================
		// 属性
		// =====================
		private var _submitButton : GButton;
		private var _discriptionText : TextField;
		private var _icons : Array;
		private var _textFileds:Array;
        
		private var _itemList:Vector.<uint>;
		// private var _itemIcon : ItemIcon;
		// =====================
		// Getter/Setter
		// =====================
		override public function set source(value : *) : void
		{
			if (value)
				super.source = value;
				
			else
				super.source = [];
				
			if(parent)
			updateItems();
		}

		public function get items() :Vector.<uint>
		{
			return _source as Vector.<uint>;
		}

		// =====================
		// 方法
		// =====================
		// ------------------------------------------------
		// 创建
		// ------------------------------------------------
		public function OnlineGiftView()
		{
			var data : GTitleWindowData = new GTitleWindowData();
			data.width = 292;
			data.height = 178;
			data.parent = ViewManager.instance.uiContainer;
			data.allowDrag = true;
			super(data);
		}

		override protected function create() : void
		{
			super.create();
			this.title = "在线奖励";
			addBg();
			addButton();
			addLabels();
			addIcons();
		}

		private function addBg() : void
		{
			var bg : Sprite = UIManager.getUI(new AssetData(UI.COMMON_BACKGROUND05));
			bg.x = 3;
			bg.y = 0;
			bg.width = 282;
			bg.height = 175;
			_contentPanel.addChild(bg);

			var bg1 : Sprite = UIManager.getUI(new AssetData(UI.COMMON_BACKGROUND03));
			bg1.x = iconStartX;
			bg1.y = 28;
			bg1.width = iconPanelWidth;
			bg1.height = 99;
			_contentPanel.addChild(bg1);
		}

		private function addLabels() : void
		{
			_discriptionText = UICreateUtils.createTextField("在线时间越久，礼品越丰富哦!", null, 216, 20, 20, 12, UIManager.getTextFormat(12));
			_contentPanel.addChild(_discriptionText);
			var tf : TextFormat = new TextFormat();
			tf.bold = true;
			_discriptionText.setTextFormat(tf);
		}

		private function addButton() : void
		{
			var data : GButtonData = new GButtonData();
			data.x = 101;
			data.y = 135;
			data.width = 80;
			data.height = 30;
			data.labelData.text = "领取";
			_submitButton = new GButton(data);

			_contentPanel.addChild(_submitButton);
		}

		private function addIcons() : void
		{
			var itemlist : Vector.<uint>=GiftPackageManage.instance.getOnlineGiftItemList();
			var item : Item;

			var itemNum : int = itemlist.length;

			var itemGap : int = 60;
			var startGap : int = (iconPanelWidth - itemGap * (itemNum - 1) - iconWidth * itemNum) / 2;

			var _itemData : ItemIconData = new ItemIconData();
			// _itemData.x = 16;
			// _itemData.y = 45;
            _icons=[];
			_textFileds=[];
			_itemData.showToolTip = true;
			_itemData.showBorder = true;
			_itemData.showLevel = true;
			_itemData.showNums = true;

			for (var i : int = 0;i <3;i++)
			{
				var itemIcon : ItemIcon = new ItemIcon(_itemData);
                _icons.push(itemIcon);
				var nametf : TextField = new TextField();
                nametf = UICreateUtils.createTextField(null, null, 150, 20, 0, 105, UIManager.getTextFormat(12, 3088128, TextFormatAlign.CENTER));
                _textFileds.push(nametf);
			}
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		private function updateItems() : void
		{
			var numItems : int = items.length;
			var numIcons : int = _icons.length;
			var icon : ItemIcon;
            var tf:TextField;
			for (var i : int = 0; i < numIcons; i++)
			{
				icon = _icons[i];
                tf=_textFileds[i];
				if (i <= numItems)
				{
					if (!contains(icon))
						addChild(icon);
				    if (!contains(tf))
						addChild(tf);	
				}
				else
				{
					if (contains(icon))
						removeChild(icon);
		            if (contains(tf))
						removeChild(tf);	
				}
			}
			layoutIcons();
		}

		private function layoutIcons() : void
		{
			_itemList=_source as Vector.<uint>;
			
			var numShow:int = Math.min(items.length, _icons.length);
			var icon:ItemIcon;
			var str:String;
			var itemGap : int = 60;
			var startGap : int = (iconPanelWidth - itemGap * (numShow - 1) - iconWidth * numShow) / 2;
			
			for (var i:int = 0; i<numShow; i++)
			{
				var item:Item = ItemService.createItem(_itemList[i]);
				icon = _icons[i];
				icon.x = iconStartX + (itemGap + iconWidth) * i + startGap; 
				icon.y = 50;
				icon.source=item;
				
				if (item.id == ID.SILVER)
				{
					str = StringUtils.addColor(item.name, "#2F1F00");
				}
				else
				{
					str = StringUtils.addColorById(item.name, item.color);
				}
				
				(_textFileds[i] as TextField).x=icon.x-50;
				(_textFileds[i] as TextField).htmlText=str;
				
			}
		}

		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		override protected function onShow() : void
		{
			super.onShow();
			_submitButton.addEventListener(MouseEvent.CLICK, onGetGift);
			source = GiftPackageManage.instance.getOnlineGiftItemList();
		}

		override protected function onHide() : void
		{
			super.onHide();
			_submitButton.removeEventListener(MouseEvent.CLICK, onGetGift);
		}

		private function onGetGift(event : MouseEvent) : void
		{
			Common.game_server.sendMessage(0x75);
			MenuManager.getInstance().closeMenuView(MenuType.ONLINE_GIFT);
		}

	}
}
