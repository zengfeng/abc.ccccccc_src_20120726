package game.module.trade.market
{
	import com.commUI.alert.Alert;
	import com.commUI.button.KTButtonData;
	import com.commUI.icon.ItemIcon;
	import com.commUI.icon.ItemIconData;
	import com.utils.StringUtils;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.core.item.Item;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.definition.UI;
	import game.module.trade.sale.PricePanel;
	import game.net.core.Common;
	import game.net.data.CtoS.CSBuyout;
	import gameui.containers.GPanel;
	import gameui.controls.GButton;
	import gameui.data.GPanelData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;
	import net.AssetData;













	/**
	 * @author zhenyuhang
	 */
	public class MarketListCell extends GPanel
	{
		// 重构笔记
		// 1. 参考TradeMySaleItem.as的重构笔记
		// 2. 删除用不到的price
		// 3. 不要用Array存储单个对象
		// 4. 重命名num -> _goodsCount
		//		_goodsCount最后被移除，因为可以直接用int(_countText.text)得到，同样只作一次字符串到数值的转换
		// 5. 不需要用_vo再去缓存 UserData.instance
		// private var clearBtn_Label : GLabel;
		// private var _goodsName : String = "";
		// private var _goodsCount : String = "";
		// private var _goodsOwner : String = "";
		// private var _goodsPrice : String = "";
		// private var _vo : UserData = UserData.instance;
		// =====================
		// @属性
		// =====================
		private var _itemIcon : ItemIcon;
		private var _pricePanel : PricePanel;
		private var _priceNum:String;
		private var _goodsId : int;
		private var _tradeId : int;
		private var _buyButton : GButton;
		private var _nameText : TextField;
		private var _countText : TextField;
		private var _ownerText : TextField;

		// =====================
		// @创建
		// =====================
		public function MarketListCell()
		{
			var data : GPanelData = new GPanelData();
			data.width = 540;
			data.height = 50;
			data.bgAsset = new AssetData(SkinStyle.emptySkin);
			super(data);
		}

		override protected function create() : void
		{
			super.create();
			addIcon();
			addSubPanel();
			addButton();
			_buyButton.hide();
			addLabel();
		}

		private function addIcon() : void
		{
			var _itemData : ItemIconData = new ItemIconData();
			_itemData.x = 2;
			_itemData.y = 1.5;
			_itemData.showToolTip = true;
		    _itemData.showBorder = true;
			_itemData.showLevel = true;
			_itemIcon = new ItemIcon(_itemData);
			addChild(_itemIcon);
			_itemIcon.hide();
		}

		private function addSubPanel() : void
		{
			_pricePanel = new PricePanel();
			_pricePanel.x = 360;
			_pricePanel.y = 18;
			addChild(_pricePanel);
			_pricePanel.hide();
		}

		private function addButton() : void
		{
			var data : KTButtonData = new KTButtonData(KTButtonData.SMALL_BUTTON);
			data.width = 51;
			data.height = 24;
			data.x = 445;
			data.y = 12;
			_buyButton = new GButton(data);
			_buyButton.text = "购买";
			addChild(_buyButton);
		}

		private function addLabel() : void
		{
			_nameText = UICreateUtils.createTextField(null, null, 98.8, 19, 50, 18, TextFormatUtils.panelContent);
			_countText = UICreateUtils.createTextField(null, null, 35, 19, 173, 18, TextFormatUtils.panelContent);
			_ownerText = UICreateUtils.createTextField(null, null, 95.8, 19, 253, 18, TextFormatUtils.panelContent);

			addChild(_nameText);
			addChild(_countText);
			addChild(_ownerText);
		}

		// =====================
		// @更新
		// =====================
		// 面板刷新函数
		public function setLabel(recvitem : Item, goodsName : String = "", goodsCount : String = "", goodsOwner : String = "", goodsPrice : String = "", itemId : int = 0, orderId : int = 0, tradeId : int = 0) : void
		{
			_itemIcon.source = recvitem;
			_itemIcon.show();
			_tradeId = tradeId;
			//_nameText.text = goodsName;
		    _nameText.htmlText = StringUtils.addColorById(goodsName, recvitem.color);
			_countText.text = goodsCount;
			_ownerText.text = goodsOwner;

			_pricePanel.setPrice(goodsPrice);
			_pricePanel.toolTip.source = "元宝" + goodsPrice;
			_pricePanel.show();
			_priceNum=goodsPrice;
			if (goodsOwner == UserData.instance.playerName)
			{
//				_buyButton.show();
//				_buyButton.enabled = false;
                _buyButton.hide();
			}
			else
			{
				_buyButton.show();
				_buyButton.enabled = true;
			}
		}

		public function clearListCell() : void
		{
			_nameText.text = "";
			_countText.text = "";
			_ownerText.text = "";
			_itemIcon.hide();
			_buyButton.hide();
			_pricePanel.hide();
		}

		public function getGoodsId() : int
		{
			return _goodsId;
		}

		public function getTradeId() : int
		{
			return _tradeId;
		}

		// =====================
		// @交互
		// =====================
		override protected function onShow() : void
		{
			super.onShow();
			_buyButton.addEventListener(MouseEvent.CLICK, onButtonClick);
			GLayout.layout(this);
		}

		override protected function onHide() : void
		{
			_buyButton.removeEventListener(MouseEvent.CLICK, onButtonClick);
			super.onHide();
		}
	

		// 点击购买事件
		private function onButtonClick(event : MouseEvent) : void
		{
			StateManager.instance.checkMsg(52, null, askConfirmCallback, [int(_priceNum)]);
		}

		// 确定购买事件
		private function askConfirmCallback(type : String) : Boolean
		{
			switch(type)
			{
				case Alert.OK_EVENT:
				case Alert.YES_EVENT:
					{
						var cmd : CSBuyout = new CSBuyout();
						cmd.tradeid = _tradeId;
						Common.game_server.sendMessage(0xB9, cmd); 
					}
					break;
			}
			return true;
		}
	}
}
