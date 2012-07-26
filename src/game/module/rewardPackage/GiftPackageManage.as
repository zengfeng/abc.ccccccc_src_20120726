package game.module.rewardPackage {
	import game.core.item.Item;
	import game.core.item.ItemService;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.core.menu.TopMenuButton;
	import game.module.notification.ActionIcoMenu;
	import game.module.notification.ICOMenuManager;
	import game.module.notification.VoICOButton;
	import game.net.core.Common;
	import game.net.data.CtoS.CSGiftList;
	import game.net.data.CtoS.CSGiftTake;
	import game.net.data.StoC.SCGiftCount;
	import game.net.data.StoC.SCOnlineGift;
	import game.net.data.StoC.SCTakeOnlineGift;

	import com.utils.StringUtils;

	import flash.utils.Dictionary;

	/**
	 * @author zheng
	 */
	public class GiftPackageManage {
		/**********************************************************
		 * 定义
		 ********************************************************/
		private static var _instance : GiftPackageManage;
		private var _iocDic : Dictionary = new Dictionary();
		private var _menu : ActionIcoMenu;
		private var _giftList : Vector.<VoPackReward>=new Vector.<VoPackReward>();
		private var _itemList:Vector.<uint>=new Vector.<uint>();
		
		public function GiftPackageManage() : void {
			if (_instance) {
				throw Error("GiftPackageManage 是单类，不能多次初始化!");
			}
			initiate();
		}

		public static function get instance() : GiftPackageManage {
			if (_instance == null) {
				_instance = new GiftPackageManage();
			}
			return _instance;
		}

		private function initiate() : void {
			Common.game_server.addCallback(0x72, updataGiftNum);
			// 礼包数量更新
			Common.game_server.addCallback(0x74, updataOnlineGift);
			// 在线礼包
			Common.game_server.addCallback(0x75, takeOnlineGift);
			// 在线礼包
		}
		
		private var _gifNum:int=0;
		public function updataGiftNum(msg : SCGiftCount) : void {
			setGifNum(msg.count);
		}
		
		public function getGifNum():int
		{
			return _gifNum;
		}
		
		public function setGifNum(value:int):void
		{
			_gifNum=value;
			(MenuManager.getInstance().getMenuButton(MenuType.GIFTALL) as TopMenuButton).updateNum(_gifNum);
			MenuManager.getInstance().getMenu(0,true);
		}
		
		public function removeGifNum():void
		{
			_gifNum-=1;
			setGifNum(_gifNum<0?0:_gifNum);
		}
		
		public var showOnlineGift:Boolean=false;
		public function updataOnlineGift(msg : SCOnlineGift) : void {
			if(msg.timeLeft==0&&msg.itemlist.length==0){
				showOnlineGift=false;
				MenuManager.getInstance().getMenu(0,true);
				return;
			}
			
			_itemList=msg.itemlist;  //保存itemList

			
			showOnlineGift=true;
			var tips : String = "可获得在线奖励:\r";
			var max : int = msg.itemlist.length;
			var item : Item;
			for (var i : int = 0;i < max;i++) {
				item = ItemService.createItem(msg.itemlist[i]);
				if (!item) continue;
				if (i == 0) tips += item.htmlName + StringUtils.addColorById("×" + String(item.nums), item.color);
				else
					tips += "，" + item.htmlName + StringUtils.addColorById("×" + String(item.nums), item.color);
			}
			if (max <= 0) tips = null;
			(MenuManager.getInstance().getMenuButton(MenuType.ONLINE_GIFT) as TopMenuButton).updataTime(msg.timeLeft, tips);
			MenuManager.getInstance().getMenu(0,true);
		}
		

		public function takeOnlineGift(msg : SCTakeOnlineGift) : void {
		}
		
		public function getOnlineGiftItemList():Vector.<uint>
		{
			return _itemList;
		}

		public static function sendResGift(id : int) : void {
			var cmd : CSGiftTake = new CSGiftTake();
			// cmd.type = type;
			// cmd.id = 0<<16|id;
			cmd.id = id;
			Common.game_server.sendMessage(0x71, cmd);
		}

		private function getInfoByID(id : int) : VoICOButton {
			var vo : VoICOButton;
			vo = ICOMenuManager.getInstance().getIcoVo(id);
			return vo;
		}

		public function sendReqListMsg() : void {
			var cmd : CSGiftList = new CSGiftList();
			Common.game_server.sendMessage(0x70, cmd);
		}
	}
}
