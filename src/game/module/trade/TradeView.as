package game.module.trade
{
	import com.commUI.GCommonWindow;
	import com.commUI.RemindBubble;
	import game.core.user.UserData;
	import game.manager.SignalBusManager;
	import game.manager.ViewManager;
	import game.module.trade.exchange.ExchangeManager;
	import game.module.trade.market.MarketPanel;
	import game.module.trade.sale.SalePanel;
	import gameui.containers.GPanel;
	import gameui.containers.GTabbedPanel;
	import gameui.core.GAlign;
	import gameui.data.GTabData;
	import gameui.data.GTabbedPanelData;
	import gameui.data.GTitleWindowData;
	import gameui.skin.SkinStyle;
	import net.AssetData;




	/**
	 * @author zhengyuhang
	 */
	public class TradeView extends GCommonWindow
	{
		// =====================
		// @定义
		// =====================
		public static const INDEX_MARKET : uint = 0;
		public static const INDEX_SALE : uint = 1;
		public static const INDEX_EXCHANGE : uint = 2;
		public static const INDEX_BUY : uint = 3;
		// =====================
		// @属性
		// =====================
		private var _tabbedPanel : GTabbedPanel;
		private var _marketPanel : MarketPanel;
		private var _salePanel : SalePanel;
		private var	_exchangeBubble : RemindBubble;

		// =====================
		// @创建
		// =====================
		public function TradeView()
		{
			_data = new GTitleWindowData();
			_data.width = 690;
			_data.height = 380;
			_data.parent = ViewManager.instance.uiContainer;
			_data.panelData.bgAsset = new AssetData(SkinStyle.emptySkin);
			_data.allowDrag = true;
			super(_data);
		}

		override protected function initViews() : void
		{
			super.initViews();

			this.title = "交易";

			addTabbedPanel();

			_exchangeBubble = new RemindBubble();
			_exchangeBubble.x = 192;
			_exchangeBubble.y = -8;

			addChild(_exchangeBubble);
		}

		private function addTabbedPanel() : void
		{
			var tabData : GTabData = new GTabData();
			tabData.padding = 15;
			tabData.gap = 1;

			var data : GTabbedPanelData = new GTabbedPanelData();
			data.align = new GAlign(5, -1, -1, -1, -1, -1);
			data.tabData = tabData;

			_marketPanel = new MarketPanel();
			_salePanel = new SalePanel();

			_tabbedPanel = new GTabbedPanel(data);
			_tabbedPanel.addTab("市场", _marketPanel);
			_tabbedPanel.addTab("我的摊位", _salePanel);
			_tabbedPanel.addTab("交易", ExchangeManager.instance.exchangePanel);
			_tabbedPanel.group.selectionModel.index = 0;

			contentPanel.add(_tabbedPanel);
		}

		// =====================
		// @更新
		// =====================
		public function switchPanel(index : uint) : GPanel
		{
			_tabbedPanel.group.selectionModel.index = index;
			return _tabbedPanel.group.model.getAt(index) as GPanel;
		}

		public function updateExchangeBubble() : void
		{
			if (UserData.instance.newExchangeCount == 0)
				_exchangeBubble.text = "";
			else
				_exchangeBubble.text = Math.min(99, UserData.instance.newExchangeCount).toString();
		}

		// =====================
		// @交互
		// =====================
		override protected function onShow() : void
		{
			super.onShow();
			_marketPanel.initState();
			updateExchangeBubble();
			SignalBusManager.changeNewExchangeCount.add(updateExchangeBubble);
		}

		override protected function onHide() : void
		{
			SignalBusManager.changeNewExchangeCount.remove(updateExchangeBubble);
			_marketPanel.saveState();
			super.onHide();
		}
	}
}