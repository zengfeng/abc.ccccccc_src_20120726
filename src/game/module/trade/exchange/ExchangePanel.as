package game.module.trade.exchange
{
	import com.commUI.button.KTButtonData;
	import com.commUI.pager.Pager;
	import com.utils.PotentialColorUtils;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getTimer;

	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.definition.UI;
	import game.net.core.Common;
	import game.net.data.CtoS.CSPlayerId;
	import game.net.data.StoC.SCPlayerId;

	import gameui.containers.GPanel;
	import gameui.controls.GButton;
	import gameui.controls.GList;
	import gameui.controls.GTextInput;
	import gameui.data.GButtonData;
	import gameui.data.GListData;
	import gameui.data.GPanelData;
	import gameui.data.GTextInputData;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	/**
	 * ...
	 * @author qiujian
	 */
	public class ExchangePanel extends GPanel
	{
		// =====================
		// @定义
		// =====================
		private static const PAGE_SIZE : uint = 10;
		private static const CELL_HEIGHT : uint = 25;
		// =====================
		// @属性
		// =====================
		private var _exchangeList : GList;
		private var _startExchangeButton : GButton;
		private var _parterNameInput : GTextInput;
		private var _serverIdText : TextField;
		private var _pager : Pager;

		// =====================
		// @方法
		// =====================
		public function ExchangePanel()
		{
			// trace("ExchangePanel Construct from:" + getTimer());
			var data : GPanelData = new GPanelData();
			data.width = 675;
			data.height = 350;
			data.bgAsset = new AssetData(UI.PANEL_BACKGROUND);

			super(data);
			// trace("ExchangePanel Construct to:" + getTimer());
		}

		// =====================
		// @创建
		// =====================
		override protected function create() : void
		{
			super.create();
			addHint();
			addPartNameInput();
			addRecordList();
			addServerId();
			addExchangeButton();
			addListHeader();
			addPager();
		}

		private function addHint() : void
		{
			var icon : Sprite = UIManager.getUI(new AssetData(UI.ICON_HINT));
			icon.x = 20;
			icon.y = 10;
			addChild(icon);

			addChild(UICreateUtils.createTextField("所有交易单，只保存10天", null, 162, 18, 37, 7, TextFormatUtils.panelContent));
		}

		private function addServerId() : void
		{
			_serverIdText = UICreateUtils.createTextField(null, null, 24, 12, 474, 12);
			// 合服前不显示
		}

		private function addPartNameInput() : void
		{
			var data : GTextInputData = new GTextInputData();
			data.x = 440;
			data.y = 3;
			data.width = 150;
			data.hintText = "请输入玩家姓名";
			// data.borderAsset = new AssetData(SkinStyle.emptySkin);
			data.maxChars = 24;
			data.indent = 4;
			_parterNameInput = new GTextInput(data);
			addChild(_parterNameInput);
		}

		private function addExchangeButton() : void
		{
			var data : GButtonData = new KTButtonData(KTButtonData.SMALL_BUTTON);
			data.x = 595;
			data.y = 3;
			data.width = 75;
			data.height = 24;

			_startExchangeButton = new GButton(data);
			_startExchangeButton.text = "发起交易";
			addChild(_startExchangeButton);
		}

		private function addListHeader() : void
		{
			addChild(UICreateUtils.createTextField("交易对象", null, 150, 19, 53, 33, TextFormatUtils.content));
			addChild(UICreateUtils.createTextField("交易留言", null, 200, 19, 228, 33, TextFormatUtils.content));
			addChild(UICreateUtils.createTextField("交易状态", null, 200, 19, 428, 33, TextFormatUtils.content));
			addChild(UICreateUtils.createTextField("操作", null, 110, 19, 592, 33, TextFormatUtils.content));
		}

		private function addRecordList() : void
		{
			// 标题列表背景
			var bg : Sprite = UIManager.getUI(new AssetData(UI.MARKET_PANEL_BG_1));
			bg.x = 5;
			bg.y = 30;
			bg.width = 665;
			bg.height = 25;
			addChild(bg);

			// 浅色横条背景
			var bg_1 : Sprite = UIManager.getUI(new AssetData(UI.MARKET_PANEL_BG_3));
			bg_1.x = 5;
			bg_1.y = 56;
			bg_1.width = 665;
			bg_1.height = CELL_HEIGHT;
			addChild(bg_1);

			// 深色横条背景
			var bg_2 : Sprite = UIManager.getUI(new AssetData(UI.MARKET_PANEL_BG_4));
			bg_2.x = 5;
			bg_2.y = 56 + CELL_HEIGHT;
			bg_2.width = 665;
			bg_2.height = CELL_HEIGHT;
			addChild(bg_2);

			// 浅色横条背景
			var bg_3 : Sprite = UIManager.getUI(new AssetData(UI.MARKET_PANEL_BG_3));
			bg_3.x = 5;
			bg_3.y = 56 + CELL_HEIGHT * 2;
			bg_3.width = 665;
			bg_3.height = CELL_HEIGHT;
			addChild(bg_3);

			// 深色横条背景
			var bg_4 : Sprite = UIManager.getUI(new AssetData(UI.MARKET_PANEL_BG_4));
			bg_4.x = 5;
			bg_4.y = 56 + CELL_HEIGHT * 3;
			bg_4.width = 665;
			bg_4.height = CELL_HEIGHT;
			addChild(bg_4);

			// 浅色横条背景
			var bg_5 : Sprite = UIManager.getUI(new AssetData(UI.MARKET_PANEL_BG_3));
			bg_5.x = 5;
			bg_5.y = 56 + CELL_HEIGHT * 4;
			bg_5.width = 665;
			bg_5.height = CELL_HEIGHT;
			addChild(bg_5);

			// 深色横条背景
			var bg_6 : Sprite = UIManager.getUI(new AssetData(UI.MARKET_PANEL_BG_4));
			bg_6.x = 5;
			bg_6.y = 56 + CELL_HEIGHT * 5;
			bg_6.width = 665;
			bg_6.height = CELL_HEIGHT;
			addChild(bg_6);

			// 浅色横条背景
			var bg_7 : Sprite = UIManager.getUI(new AssetData(UI.MARKET_PANEL_BG_3));
			bg_7.x = 5;
			bg_7.y = 56 + CELL_HEIGHT * 6;
			bg_7.width = 665;
			bg_7.height = CELL_HEIGHT;
			addChild(bg_7);

			// 深色横条背景
			var bg_8 : Sprite = UIManager.getUI(new AssetData(UI.MARKET_PANEL_BG_4));
			bg_8.x = 5;
			bg_8.y = 56 + CELL_HEIGHT * 7;
			bg_8.width = 665;
			bg_8.height = CELL_HEIGHT;
			addChild(bg_8);

			// 浅色横条背景
			var bg_9 : Sprite = UIManager.getUI(new AssetData(UI.MARKET_PANEL_BG_3));
			bg_9.x = 5;
			bg_9.y = 56 + CELL_HEIGHT * 8;
			bg_9.width = 665;
			bg_9.height = CELL_HEIGHT;
			addChild(bg_9);

			// 深色横条背景
			var bg_10 : Sprite = UIManager.getUI(new AssetData(UI.MARKET_PANEL_BG_4));
			bg_10.x = 5;
			bg_10.y = 56 + CELL_HEIGHT * 9;
			bg_10.width = 665;
			bg_10.height = CELL_HEIGHT;
			addChild(bg_10);

			// 小白条 标题列表 上侧
			var bg_11 : Sprite = UIManager.getUI(new AssetData(UI.EXCHANGE_PANEL_WHITELINE));
			bg_11.x = 5;
			bg_11.y = 29;
			bg_11.width = 665;
			bg_11.height = 1;
			addChild(bg_11);

			// 小白条 标题列表 下侧
			var bg_12 : Sprite = UIManager.getUI(new AssetData(UI.EXCHANGE_PANEL_WHITELINE));
			bg_12.x = 5;
			bg_12.y = 55;
			bg_12.width = 665;
			bg_12.height = 1;
			addChild(bg_12);

			// 小白条 交易列表 下侧
			var bg_13 : Sprite = UIManager.getUI(new AssetData(UI.EXCHANGE_PANEL_WHITELINE));
			bg_13.x = 5;
			bg_13.y = 56 + CELL_HEIGHT * 10 + 1;
			bg_13.width = 665;
			bg_13.height = 1;
			addChild(bg_13);

			// trace("ExchangePanel SELF CREATE LIST SKIN:" + getTimer());
			var data : GListData = new GListData();
			data.x = 5;
			data.y = 56;
			data.width = 665;
			data.height = 250;
			data.rows = PAGE_SIZE;
			data.hGap = 0;
			data.padding = 0;
			data.bgAsset = new AssetData(SkinStyle.emptySkin, AssetData.AS_LIB);
			data.cell = ExchangeCell;
			data.cellData.upAsset = new AssetData(SkinStyle.emptySkin, AssetData.AS_LIB);
			data.cellData.overAsset = new AssetData(UI.LIGHT_TRANSPARENT_BG);
			data.cellData.selected_upAsset = new AssetData(SkinStyle.emptySkin, AssetData.AS_LIB);
			data.cellData.selected_overAsset = new AssetData(UI.LIGHT_TRANSPARENT_BG);
			data.cellData.disabledAsset = new AssetData(SkinStyle.emptySkin, AssetData.AS_LIB);
			data.cellData.width = 665;
			data.cellData.height = CELL_HEIGHT;
			data.cellData.enabled = true;

			// trace("ExchangePanel SELF CREATE LIST DATA:" + getTimer());

			_exchangeList = new GList(data);
			// trace("ExchangePanel SELF CREATE LIST:" + getTimer());
			addChild(_exchangeList);
			// 加载交易列表
		}

		private function addPager() : void
		{
			_pager = new Pager(5, true);
			_pager.y = 320;
			_pager.setPage(1, 1);
			layoutPager();

			_content.addChild(_pager);
		}

		private function layoutPager() : void
		{
			_pager.x = _width - _pager.width - 14;
		}

		// =====================
		// @更新
		// =====================
		public function setRecords(records : Array, begin : uint, total : uint) : void
		{
			if (begin > total) begin = total;
			var currentpage : uint = begin / PAGE_SIZE + (begin % PAGE_SIZE == 0 ? 0 : 1);
			var totalPage : uint = total / PAGE_SIZE + (total % PAGE_SIZE == 0 ? 0 : 1);
			if (currentpage == 0) currentpage = 1;
			if (totalPage == 0) totalPage = 1;
			_pager.setPage(currentpage, totalPage);
			layoutPager();
			_exchangeList.model.source = records;
		}

		public function updateExchange(updateVo : ExchangeVO) : void
		{
			for each (var cell:ExchangeCell in _exchangeList._cells)
			{
				var vo : ExchangeVO = cell.source as ExchangeVO;
				if (vo && vo.tradeId == updateVo.tradeId)
				{
					cell.source = updateVo;
				}
			}
		}

		private function selectDefaultPage() : void
		{
			_pager.selectPage(1);
			layoutPager();
		}

		// =====================
		// @交互
		// =====================
		override protected function onShow() : void
		{
			super.onShow();
			_startExchangeButton.addEventListener(MouseEvent.CLICK, startExchangeHandler);
			_pager.addEventListener(Event.CHANGE, changePageHandler);
			_exchangeList.addEventListener(ExchangeEvent.REVIEW, exchangeEventHandler, true);
			_exchangeList.addEventListener(ExchangeEvent.CANCEL, exchangeEventHandler, true);
			_exchangeList.addEventListener(ExchangeEvent.DELETE, exchangeEventHandler, true);
			_exchangeList.addEventListener(ExchangeEvent.RECEIVE, exchangeEventHandler, true);
			selectDefaultPage();
		}

		override protected function onHide() : void
		{
			_startExchangeButton.removeEventListener(MouseEvent.CLICK, startExchangeHandler);
			_pager.removeEventListener(Event.CHANGE, changePageHandler);
			_exchangeList.removeEventListener(ExchangeEvent.REVIEW, exchangeEventHandler, true);
			_exchangeList.removeEventListener(ExchangeEvent.CANCEL, exchangeEventHandler, true);
			_exchangeList.removeEventListener(ExchangeEvent.DELETE, exchangeEventHandler, true);
			_exchangeList.removeEventListener(ExchangeEvent.RECEIVE, exchangeEventHandler, true);
			super.onHide();
		}

		private function startExchangeHandler(event : MouseEvent) : void
		{
			var name : String = _parterNameInput.text;

			// 玩家名字为空
			if (!name)
			{
				StateManager.instance.checkMsg(45);
				return;
			}

			// 玩家为自己
			if (name == UserData.instance.playerName)
			{
				StateManager.instance.checkMsg(200);
				return;
			}

			var serverId : uint = uint(_serverIdText.text);

			ExchangeManager.instance.startExchangeWithPlayer(name, serverId);
		}

		private function changePageHandler(event : Event) : void
		{
			var page : uint = _pager.model.page;
			var begin : uint = (page - 1) * PAGE_SIZE + 1;
			var count : uint = PAGE_SIZE;

			ExchangeManager.instance.listRecords(begin, count);
		}

		private function exchangeEventHandler(event : ExchangeEvent) : void
		{
			switch(event.type)
			{
				case ExchangeEvent.REVIEW:
					ExchangeManager.instance.openExchangeSheet(event.exchangeVO);
					break;
				case ExchangeEvent.CANCEL:
					ExchangeManager.instance.cancelExchange(event.exchangeVO);
					break;
				case ExchangeEvent.DELETE:
					ExchangeManager.instance.deleteExchange(event.exchangeVO);
					break;
				case ExchangeEvent.RECEIVE:
					ExchangeManager.instance.receiveExchange(event.exchangeVO);
					break;
			}
		}
	}
}