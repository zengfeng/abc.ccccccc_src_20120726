package game.module.trade.exchange
{
	import com.commUI.button.KTButtonData;
	import com.commUI.tooltip.ExchangeTip;
	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipManager;
	import com.utils.StringUtils;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import game.definition.UI;
	import gameui.cell.GCell;
	import gameui.cell.GCellData;
	import gameui.controls.GButton;
	import gameui.manager.UIManager;
	import net.AssetData;





	/**
	 * @author jian
	 */
	public class ExchangeCell extends GCell
	{
		// =====================
		// @定义
		// =====================
		// =====================
		// @属性
		// =====================
		private var _serverText : TextField;
		// private var _partnerText : GLabel;
		private var _partnerText : TextField;
		// private var _messageText : GLabel;
		private var _messageText : TextField;
		private var _newTradeIcon : Sprite;
		private var _packFullIcon : Sprite;
		// private var _statusText : GLabel;
		private var _statusText : TextField;
		private var _reviewButton : GButton;
		private var _deleteButton : GButton;
		private var _cancelButton : GButton;
		private var _receiveButton : GButton;

		// =====================
		// @添加
		// =====================
		public function ExchangeCell(data : GCellData)
		{
			super(data);
		}

		override protected function create() : void
		{
			super.create();

			//trace("ExchangeCell create start: " + getTimer());
			addServerLabel();
			addPartnerName();
			addMessage();
			addIcons();
			addStatusText();
			addButtons();
			//trace("ExchangeCell create end: " + getTimer());
		}

		private function addServerLabel() : void
		{
			// TODO 这个功能在合服后开启
			_serverText = UICreateUtils.createTextField(null, null, 0, 0, 16, 4, TextFormatUtils.panelContent);
		}

		private function addPartnerName() : void
		{
			// _partnerText = UICreateUtils.createGLabel({x:45, y:12, textFormat:TextFormatUtils.panelContent});
			_partnerText = UICreateUtils.createTextField(null, null, 150, 19, 0, 4, TextFormatUtils.panelContentCenter);
			_partnerText.mouseEnabled = true;
			addChild(_partnerText);
		}

		private function addMessage() : void
		{
			// _messageText = UICreateUtils.createGLabel({x:200, y:12, textFormat:TextFormatUtils.panelContentCenter});
			_messageText = UICreateUtils.createTextField(null, null, 200, 19, 150, 4, TextFormatUtils.panelContentCenter);
			_messageText.mouseEnabled = true;
			addChild(_messageText);
		}

		private function addIcons() : void
		{
			// 交易状态栏 New字样ICON
			_newTradeIcon = UIManager.getUI(new AssetData(UI.EXCHANGE_PANEL_ICON_NEW));
			_newTradeIcon.x = 360;
			_newTradeIcon.y = 3;
			_newTradeIcon.visible = false;
			addChild(_newTradeIcon);

			// 交易状态栏 感叹号字样ICON
			_packFullIcon = UIManager.getUI(new AssetData(UI.EXCHANGE_PANEL_ICON_WARNNING));
			_packFullIcon.x = 365;
			_packFullIcon.y = 3;
			_packFullIcon.visible = false;
			addChild(_packFullIcon);
		}

		private function addStatusText() : void
		{
			// _statusText = UICreateUtils.createGLabel({width:160, x:360, y:12, textFormat:TextFormatUtils.panelContent});
			_statusText = UICreateUtils.createTextField(null, null, 200, 19, 350, 4, TextFormatUtils.panelContentCenter);
			_statusText.mouseEnabled = true;
			addChild(_statusText);
		}

		private function addButtons() : void
		{
			_reviewButton = UICreateUtils.createGButton("查看", 50, 22, 545, 1, KTButtonData.SMALL_BUTTON);
			_receiveButton = UICreateUtils.createGButton("收取", 50, 22, 545, 1, KTButtonData.SMALL_BUTTON);
			_cancelButton = UICreateUtils.createGButton("取消", 50, 22, 605, 1, KTButtonData.SMALL_BUTTON);
			_deleteButton = UICreateUtils.createGButton("删除", 50, 22, 605, 1, KTButtonData.SMALL_BUTTON);
						
			_reviewButton.visible = false;
			_receiveButton.visible = false;
			_cancelButton.visible = false;
			_deleteButton.visible = false;
			addChild(_reviewButton);
			addChild(_receiveButton);
			addChild(_cancelButton);
			addChild(_deleteButton);
		}

		// =====================
		// @更新
		// =====================
		override public function set source(value : *) : void
		{
			_source = value;

			if (_source)
			{
				var vo : ExchangeVO = value;
				_serverText.text = vo.serverId.toString();
				_partnerText.htmlText = StringUtils.addColorById(vo.partnerName, vo.partnerColor);
				_messageText.text = (vo.iamPartA) ? vo.myMessage : vo.partnerMessage;

				if (_messageText.text.length >= 15)
				{
					_messageText.text = _messageText.text.substring(0, 15) + "...";
				}

				ToolTipManager.instance.registerToolTip(_partnerText, ToolTip, parterToolTipString);
				ToolTipManager.instance.registerToolTip(_messageText, ToolTip, messageToolTipString);
				ToolTipManager.instance.registerToolTip(_statusText, ExchangeTip, provideStatusToolTipData);

				updateStatusText();
				updateButtons();
				updateIcons();
				this.enabled = true;
				// addEvents();
			}
			else
			{
				clear();
				this.enabled = false;
			}
		}

		private function clear() : void
		{
			// removeEvents();
			ToolTipManager.instance.destroyToolTip(_partnerText);
			ToolTipManager.instance.destroyToolTip(_messageText);
			ToolTipManager.instance.destroyToolTip(_statusText);

			_serverText.text = "";
			_partnerText.htmlText = "";
			_messageText.text = "";
			_statusText.text = "";
			_cancelButton.visible = false;
			_receiveButton.visible = false;
			_reviewButton.visible = false;
			_deleteButton.visible = false;

			_newTradeIcon.visible = false;
			_packFullIcon.visible = false;
		}

		private function updateStatusText() : void
		{
			var statusText : String;
			var status : uint = (_source as ExchangeVO).status;

			if ( (_source as ExchangeVO).packFull)
			{
				statusText = "包裹已满，未自动收取";
//				_receiveButton.addEventListener(MouseEvent.CLICK, _receiveButton_clickHandler);
			}
			else if (status == ExchangeVO.I_START)
				statusText = "等待对方回复";
			else if (status == ExchangeVO.HE_REPLIED)
				statusText = "请确认对方回复";
			else if (status == ExchangeVO.HE_START)
				statusText = "向你发起交易";
			else if (status == ExchangeVO.I_REPLIED)
				statusText = "等待对方确认";
			else if (status == ExchangeVO.CANCELLED)
				statusText = "对方/我取消了交易";
			else if (status == ExchangeVO.OUT_OF_DATE)
				statusText = "已超过24小时，系统自动取消交易";
			else if (status == ExchangeVO.SUCCEDED)
				statusText = "交易成功";
			else
				statusText = "未知状态";

			_statusText.text = statusText;
		}

		private function updateButtons() : void
		{
			var vo : ExchangeVO = _source as ExchangeVO;

			if (vo.packFull)
			{
				_reviewButton.visible = false;
				_cancelButton.visible = false;
				_deleteButton.visible = false;
				_receiveButton.visible = true;
			}
			else if (vo.status == ExchangeVO.SUCCEDED || vo.status == ExchangeVO.CANCELLED || vo.status == ExchangeVO.OUT_OF_DATE)
			{
				_reviewButton.visible = false;
				_cancelButton.visible = false;
				_deleteButton.visible = true;
				_receiveButton.visible = false;
			}
			else
			{
				_reviewButton.visible = true;
				_cancelButton.visible = true;
				_deleteButton.visible = false;
				_receiveButton.visible = false;
			}
		}

		private function updateIcons() : void
		{
			var vo : ExchangeVO = _source as ExchangeVO;
			_newTradeIcon.visible = vo.newTrade;
			if((_source as ExchangeVO).packFull)
			{
				_newTradeIcon.visible = false;
			}//包裹已满，为自动收取时，只显示感叹号 ICON，不显示New ICON

			_packFullIcon.visible = vo.packFull;
		}

		// =====================
		// @交互
		// =====================
		override protected function onShow() : void
		{
			super.onShow();
			addEvents();
		}

		override protected function onHide() : void
		{
			removeEvents();
			super.onHide();
		}

		private function addEvents() : void
		{
			// _reviewButton.addEventListener(MouseEvent.CLICK, clickReviewHandler);
			// _cancelButton.addEventListener(MouseEvent.CLICK, clickCancelHandler);
			// _deleteButton.addEventListener(MouseEvent.CLICK, clickDeleteHandler);
			// _receiveButton.addEventListener(MouseEvent.CLICK, clickReceiveHandler);
			addEventListener(MouseEvent.CLICK, mouseClickHandler);
		}

		private function removeEvents() : void
		{
			// _reviewButton.removeEventListener(MouseEvent.CLICK, clickReviewHandler);
			// _cancelButton.removeEventListener(MouseEvent.CLICK, clickCancelHandler);
			// _deleteButton.removeEventListener(MouseEvent.CLICK, clickDeleteHandler);
			// _receiveButton.removeEventListener(MouseEvent.CLICK, clickReceiveHandler);
			removeEventListener(MouseEvent.CLICK, mouseClickHandler);
//			_receiveButton.removeEventListener(MouseEvent.CLICK, _receiveButton_clickHandler);
			super.onHide();
		}

		private function mouseClickHandler(event : MouseEvent) : void
		{
			var eventType : String;
			switch (event.target)
			{
				case _cancelButton:
					eventType = ExchangeEvent.CANCEL;
					break;
				case _deleteButton:
					eventType = ExchangeEvent.DELETE;
					break;
				case _receiveButton:
					eventType = ExchangeEvent.RECEIVE;
					break;
				case _receiveButton:
					eventType = ExchangeEvent.REVIEW;
					break;
				default:
					if (!_reviewButton.visible) return;
					eventType = ExchangeEvent.REVIEW;
			}
			var e : ExchangeEvent = new ExchangeEvent(eventType);
			e.exchangeVO = _source;
			dispatchEvent(e);
		}

//		private function _receiveButton_clickHandler(event : MouseEvent) : void
//		{
//			StateManager.instance.checkMsg(153);
//		}

		// private function clickReviewHandler(event : MouseEvent) : void
		// {
		// if (_source && (!(event.currentTarget is GButton) && _reviewButton.visible || event.currentTarget == _reviewButton))
		// {
		// event.stopPropagation();
		// }
		// }
		//
		// private function clickCancelHandler(event : MouseEvent) : void
		// {
		// var e : ExchangeEvent = new ExchangeEvent(ExchangeEvent.CANCEL);
		// e.exchangeVO = _source;
		// dispatchEvent(e);
		// }
		//
		// private function clickDeleteHandler(event : MouseEvent) : void
		// {
		// var e : ExchangeEvent = new ExchangeEvent(ExchangeEvent.DELETE);
		// e.exchangeVO = _source;
		// dispatchEvent(e);
		// }
		//
		// private function clickReceiveHandler(event : MouseEvent) : void
		// {
		// var e : ExchangeEvent = new ExchangeEvent(ExchangeEvent.RECEIVE);
		// e.exchangeVO = _source;
		// dispatchEvent(e);
		// }
		// =====================
		// @其它
		// =====================
		public function parterToolTipString() : String
		{
			// var days : uint = (new Date().time / 1000 - (_source as ExchangeVO).sendtime) / 86400;
			var days : uint = (_source as ExchangeVO).sendtime / 86400;
			return (days == 0 ? "今天" : (days + "天前")) + "与你发起交易";
		}

		private function messageToolTipString() : String
		{
			var vo : ExchangeVO = _source as ExchangeVO;
			var string : String = (vo.iamPartA) ? vo.myMessage : vo.partnerMessage;
			return string != " " ? string : "对方没有留言";
		}

		private function provideStatusToolTipData() : ExchangeVO
		{
			return _source;
		}
	}
}
