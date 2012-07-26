package game.module.trade.exchange
{
	import com.commUI.alert.Alert;
	import com.utils.PotentialColorUtils;
	import flash.geom.Point;
	import game.core.item.IUnique;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.item.equipable.EquipableItem;
	import game.core.item.equipment.Equipment;
	import game.core.item.soul.Soul;
	import game.core.menu.IMenuButton;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.manager.SignalBusManager;
	import game.net.core.Common;
	import game.net.data.CtoS.CSBConfirm;
	import game.net.data.CtoS.CSBeginTrade;
	import game.net.data.CtoS.CSListTrade;
	import game.net.data.CtoS.CSPlayerId;
	import game.net.data.CtoS.CSTradeStatus;
	import game.net.data.StoC.EquipAttribute;
	import game.net.data.StoC.SCBConfirm;
	import game.net.data.StoC.SCBeginTrade;
	import game.net.data.StoC.SCBeginTradeAck;
	import game.net.data.StoC.SCListTrade;
	import game.net.data.StoC.SCListTrade.TradeInfo;
	import game.net.data.StoC.SCPlayerId;
	import game.net.data.StoC.SCTradeStatus;
	import gameui.layout.GLayout;
	import log4a.Logger;





	/**
	 * ...
	 * @author qiujian
	 */
	public class ExchangeManager
	{
		// =====================
		// @单例
		// =====================
		private static var __instance : ExchangeManager;

		public static function get instance() : ExchangeManager
		{
			if (!__instance)
				__instance = new ExchangeManager();

			return __instance;
		}

		public function ExchangeManager()
		{
			if (__instance)
				throw(Error("单例错误！"));

			// TODO: 服务器
			Common.game_server.addCallback(0xB0, onTradeRequest);
			Common.game_server.addCallback(0xB3, onListRecords);
			Common.game_server.addCallback(0xB2, onChangeTradeStatus);
			Common.game_server.addCallback(0xBF, onTradeStart);
			Common.game_server.addCallback(0xB1, onParterReply);
			SignalBusManager.changeNewExchangeCount.add(updateTradeMenuMC);
		}

		// =====================
		// @属性
		// =====================
		private var _exchangePanel : ExchangePanel;
		private var _exchangeSheet : ExchangeSheet;
		private var _panelRecords : Array;
		private var _begin : uint;
		private var _cachedPartnerName : String;

		// =====================
		// @操作
		// =====================
		public function dispose() : void
		{
			Common.game_server.removeCallback(0xB0, onTradeRequest);
			Common.game_server.removeCallback(0xB3, onListRecords);
			Common.game_server.removeCallback(0xB2, onChangeTradeStatus);
			Common.game_server.removeCallback(0xBF, onTradeStart);
			Common.game_server.removeCallback(0xB1, onParterReply);
			__instance = null;
		}

		public function get exchangePanel() : ExchangePanel
		{
			if (!_exchangePanel)
				_exchangePanel = new ExchangePanel();
			return _exchangePanel;
		}

		public function get exchangeSheet() : ExchangeSheet
		{
			if (!_exchangeSheet)
				_exchangeSheet = new ExchangeSheet();
			return _exchangeSheet;
		}

		public function openExchangeSheet(vo : ExchangeVO) : void
		{
			if (vo.newTrade)
			{
				vo.newTrade = false;
				ExchangeManager.instance.firstReview(vo);
			}

			exchangeSheet.source = vo;

			if (_exchangePanel && _exchangePanel.parent)
			{
				var global : Point = _exchangePanel.localToGlobal(new Point(10, 10));
				_exchangeSheet.x = global.x;
				_exchangeSheet.y = global.y;
				exchangeSheet.show();
			}
			else
			{
				exchangeSheet.show();
				GLayout.layout(exchangeSheet);
			}
		}

		// 发起交易
		public function startExchange(vo : ExchangeVO) : void
		{
			if (vo.status != ExchangeVO.NOT_START)
			{
				//trace("已开始的交易" + vo.status);
				return;
			}

			var msg : CSBeginTrade = new CSBeginTrade();
			for each (var item:Item in vo.myItems)
			{
				if (item is IUnique)
					msg.equipments.push((item as IUnique).uuid);
				else
				{
					msg.items.push(item.nums << 16 | item.id);
				}
			}

			msg.target = vo.partnerId;
			msg.money = vo.myPrice;
			msg.remark = vo.myMessage;

			// TODO: 生成LocalID的机制
			msg.localid = 21;

			Common.game_server.sendMessage(0xB0, msg);
			Logger.info("发起交易");
		}

		// 确认交易
		public function acceptExchange(vo : ExchangeVO) : void
		{
			if (vo.status != ExchangeVO.HE_START)
			{
				//trace("无法确认不是对方发起的交易" + vo.status);
				return;
			}

			var msg : CSBConfirm = new CSBConfirm();
			for each (var item:Item in vo.myItems)
			{
				if (item is IUnique)
					msg.equipments.push((item as IUnique).uuid);
				else
					msg.items.push(item.nums << 16 | item.id);
			}

			msg.tradeid = vo.tradeId;
			msg.money = vo.myPrice;
			msg.remark = vo.myMessage;

			Common.game_server.sendMessage(0xB1, msg);
			Logger.info("确认交易" + " tradeID:" + msg.tradeid);
		}

		// 删除交易
		public function deleteExchange(vo : ExchangeVO) : void
		{
			var msg : CSTradeStatus = new CSTradeStatus();
			msg.tradeid = vo.tradeId;
			msg.status = 4;

			Common.game_server.sendMessage(0xB2, msg);
			Logger.info("删除交易" + " tradeID:" + msg.tradeid);
		}

		// 取消交易
		private var _tempVO : ExchangeVO;

		public function cancelExchange(vo : ExchangeVO) : void
		{
			_tempVO = vo;
			StateManager.instance.checkMsg(133, null, cancelExchangeConfirm);
		}

		private function cancelExchangeConfirm(type : String) : Boolean
		{
			if (type == Alert.OK_EVENT)
			{
				var msg : CSTradeStatus = new CSTradeStatus();
				msg.tradeid = _tempVO.tradeId;
				msg.status = 2;

				Common.game_server.sendMessage(0xB2, msg);
				Logger.info("取消交易" + " tradeID:" + msg.tradeid);

				if (_exchangeSheet)
					_exchangeSheet.hide();
			}
			return true;
		}

		// 完成交易
		public function finishExchange(vo : ExchangeVO) : void
		{
			var msg : CSTradeStatus = new CSTradeStatus();
			msg.tradeid = vo.tradeId;
			msg.status = 1;

			Common.game_server.sendMessage(0xB2, msg);
			Logger.info("结束交易" + " tradeID:" + msg.tradeid);
		}

		// 收取包裹
		public function receiveExchange(vo : ExchangeVO) : void
		{
			var msg : CSTradeStatus = new CSTradeStatus();
			msg.tradeid = vo.tradeId;
			msg.status = 3;

			Common.game_server.sendMessage(0xB2, msg);
			Logger.info("收取包裹" + " tradeID:" + msg.tradeid);
		}

		// 第一次打开
		public function firstReview(vo : ExchangeVO) : void
		{
			var msg : CSTradeStatus = new CSTradeStatus();
			msg.tradeid = vo.tradeId;
			msg.status = 5;

			Common.game_server.sendMessage(0xB2, msg);
			Logger.info("初次查看" + " tradeID:" + msg.tradeid);
		}

		// 查询交易
		public function listRecords(begin : uint, count : uint) : void
		{
			var msg : CSListTrade = new CSListTrade();
			msg.begin = begin - 1;
			// 服务器从0开始计数
			msg.count = count;

			Common.game_server.sendMessage(0xB3, msg);
		}

		public function startExchangeWithPlayer(name : String, serverId : uint) : void
		{
			var msg : CSPlayerId = new CSPlayerId();
			msg.name = name;
			msg.server = serverId;

			_cachedPartnerName = name;
			Common.game_server.addCallback(0x0F, playerNameCheckCallback);
			Common.game_server.sendMessage(0x0F, msg);
		}

		private function playerNameCheckCallback(msg : SCPlayerId) : void
		{
			Common.game_server.removeCallback(0x0F, playerNameCheckCallback);
			// if (_cachedPartnerName && msg.name == _cachedPartnerName)
			// TODO:
			if (_cachedPartnerName && _cachedPartnerName == msg.name)
			{
				_cachedPartnerName == "";

				// 玩家名字不存在
				if (msg.id == 0)
				{
					StateManager.instance.checkMsg(46);
					return;
				}

				exchangeSheet.clear();

				var vo : ExchangeVO = new ExchangeVO();
				vo.partnerName = msg.name;
				vo.partnerId = msg.id;
				vo.partnerLevel = msg.level;
				vo.partnerColor = PotentialColorUtils.getColor(msg.potential);
				vo.status = ExchangeVO.NOT_START;

				openExchangeSheet(vo);
			}
		}

		// ==============================================================
		// @交互
		// ==============================================================
		private function onListRecords(msg : SCListTrade) : void
		{
			Logger.info("交易列表");
			if (_exchangePanel)
			{
				_panelRecords = [];

				for each (var info:TradeInfo in msg.tradeList)
				{
					var vo : ExchangeVO = parseTradeInfo(info);
					_panelRecords.push(vo);
				}

				_begin = msg.begin + 1;
				_exchangePanel.setRecords(_panelRecords, msg.begin + 1, msg.total);
			}
		}

		public function onTradeRequest(msg : SCBeginTrade) : void
		{
			Logger.info("对方请求交易" + " tradeID:" + msg.tradeid);

			// var tradeView : TradeView = MenuManager.getInstance().openMenuView(MenuManager.ID_TRADE).target as TradeView;
			// _exchangePanel = tradeView.switchPanel(TradeView.INDEX_EXCHANGE) as ExchangePanel;

			// 刷新面板
			if (_begin == 1)
				listRecords(1, 7);
		}

		private function onChangeTradeStatus(msg : SCTradeStatus) : void
		{
			Logger.info("交易状态改变" + msg.status + " tradeID:" + msg.tradeid);
			var vo : ExchangeVO;

			if (msg.status != ExchangeVO.DELETED && msg.status != ExchangeVO.HE_REPLIED)
			{
				if (msg.status == ExchangeVO.CANCELLED)
					StateManager.instance.checkMsg(49);
				if (msg.status == ExchangeVO.SUCCEDED)
					StateManager.instance.checkMsg(50);

				if (_exchangeSheet)
				{
					vo = _exchangeSheet.exchangeVO;
					if (vo.tradeId == msg.tradeid)
					{
						vo.packFull = (msg.status & 0x40) != 0;
						vo.newTrade = (msg.status & 0x10) != 0;
						vo.status = msg.status & 0xF;
						_exchangeSheet.source = vo;
					}
				}

				if (_exchangePanel)
				{
					for each (vo in _panelRecords)
					{
						if (vo.tradeId == msg.tradeid)
						{
							vo.packFull = (msg.status & 0x40) != 0;
							vo.newTrade = (msg.status & 0x10) != 0;
							vo.status = msg.status & 0xF;
							_exchangePanel.updateExchange(vo);
							break;
						}
					}
				}
			}
			// TODO:这里可以优化
			listRecords(_begin, 7);
		}

		private function onTradeStart(msg : SCBeginTradeAck) : void
		{
			Logger.info("交易开始" + " tradeID:" + msg.tradeid);
			var vo : ExchangeVO = _exchangeSheet.exchangeVO;
			if (vo && vo.status == ExchangeVO.NOT_START)
			{
				vo.tradeId = msg.tradeid;
				vo.status = ExchangeVO.I_START;
				_exchangeSheet.updateView();
			}

			// TODO: 刷新第一页列表
			listRecords(1, 7);
		}

		private function onParterReply(msg : SCBConfirm) : void
		{
			Logger.info("对方确认交易" + " tradeID:" + msg.tradeid);
			var vo : ExchangeVO;
			if (_exchangeSheet)
			{
				vo = _exchangeSheet.exchangeVO;

				if (vo.tradeId == msg.tradeid)
				{
					vo.newTrade = true;
					vo.partnerItems = getItemsByKeys(msg.items).concat(getEqsByAttrs(msg.equipments));
					vo.partnerPrice = (msg.hasMoney) ? msg.money : 0;
					vo.partnerMessage = (msg.hasRemark) ? msg.remark : "";
					vo.status = ExchangeVO.HE_REPLIED;
					_exchangeSheet.source = vo;
				}
			}

			if (_exchangePanel)
			{
				for each (vo in _panelRecords)
				{
					if (vo.tradeId == msg.tradeid)
					{
						vo.newTrade = true;
						vo.partnerItems = getItemsByKeys(msg.items).concat(getEqsByAttrs(msg.equipments));
						vo.partnerPrice = (msg.hasMoney) ? msg.money : 0;
						vo.partnerMessage = (msg.hasRemark) ? msg.remark : "";
						vo.status = ExchangeVO.HE_REPLIED;
						_exchangePanel.updateExchange(vo);
						break;
					}
				}
			}
		}

		public function updateTradeMenuMC() : void
		{
			var button : IMenuButton = MenuManager.getInstance().getMenuButton(MenuType.TRADE);
			if (UserData.instance.newExchangeCount == 0)
			{
				button.removeMenuMc();
			}
			else
			{
				button.addMenuMc(2, UserData.instance.newExchangeCount.toString());
			}
		}

		// ==============================================================
		// @其它
		// ==============================================================
		private static function parseTradeInfo(info : TradeInfo) : ExchangeVO
		{
			var vo : ExchangeVO = new ExchangeVO();
			vo.tradeId = info.tradeid;
			vo.partnerName = info.partner;
			vo.partnerColor = PotentialColorUtils.getColorLevel(info.potential);
			vo.partnerLevel = info.plevel;

			if (info.hasRemarkA) vo.myMessage = info.remarkA;
			if (info.hasRemarkB) vo.partnerMessage = info.remarkB;

			vo.sendtime = info.sendtime;
			vo.packFull = (info.status & 0x40) != 0;
			vo.iamPartA = (info.status & 0x20) == 0;
			vo.newTrade = (info.status & 0x10) != 0;
			vo.status = info.status & 0xF;

			if (vo.iamPartA)
			{
				vo.myPrice = (info.hasGoldsA) ? info.goldsA : 0;
				vo.partnerPrice = (info.hasGoldsB) ? info.goldsB : 0;

				vo.myMessage = (info.hasRemarkA) ? info.remarkA : "";
				vo.partnerMessage = (info.hasRemarkB) ? info.remarkB : "";

				vo.myItems = getItemsByKeys(info.itemsA).concat(getEqsByAttrs(info.equipA));
				vo.partnerItems = getItemsByKeys(info.itemsB).concat(getEqsByAttrs(info.equipB));
			}
			else
			{
				vo.partnerPrice = (info.hasGoldsA) ? info.goldsA : 0;
				vo.myPrice = (info.hasGoldsB) ? info.goldsB : 0;

				vo.partnerMessage = (info.hasRemarkA) ? info.remarkA : "";
				vo.myMessage = (info.hasRemarkB) ? info.remarkB : "";

				vo.partnerItems = getItemsByKeys(info.itemsA).concat(getEqsByAttrs(info.equipA));
				vo.myItems = getItemsByKeys(info.itemsB).concat(getEqsByAttrs(info.equipB));
			}

			return vo;
		}

		public static function getItemsByKeys(keys : Vector.<uint>) : Array /* of Item */
		{
			var items : Array = [];
			for each (var key:uint in keys)
			{
				var id : uint = key & 0x7FFF;
				var nums : uint = key >> 16;
				var item : Item = ItemManager.instance.newItem(id);
				// Fix服务器端的Bug
				if (item is IUnique)
					item.nums = 1;
				else
					item.nums = nums;
				items.push(item);
			}

			return items;
		}

		public static function getEqsByAttrs(attrs : Vector.<EquipAttribute>) : Array /* of EquipableItem */
		{
			var eqs : Array = [];
			for each (var attr:EquipAttribute in attrs)
			{
				var key : uint = attr.typeID;
				var id : uint = key & 0x7FFF;
				// var nums : uint = (key & 0x7FFF0000) >> 16;

				var item : EquipableItem = ItemManager.instance.newItem(id, false);
				item.uuid = attr.uniqueID;
				item.nums = 1;

				if (attr.hasEnchantlv)
				{
					if (item is Equipment)
						(item as Equipment).enhanceLevel = attr.enchantlv;
					else if (item is Soul)
						(item as Soul).exp = attr.enchantlv;
				}

				eqs.push(item);
			}
			return eqs;
		}
	}
}