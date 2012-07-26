package game.module.shop
{
	import game.net.data.StoC.SCStoreBuyRet;
	import game.net.core.Common;
	import game.net.data.CtoS.CSStoreBuy;

	import flash.utils.Dictionary;

	/**
	 * @author 1
	 */
	public class ShopManager
	{
		public static var __instance : ShopManager;

		public function ShopManager() : void
		{
			if (__instance)
			{
				throw Error("是单类，不能多次初始化!");
			}

			initiate();
		}

		public static function getInstance() : ShopManager
		{
			if (__instance == null)
			{
				__instance = new ShopManager();
			}
			return __instance;
		}

		private var _uniqueId : uint = 1;
		private var _callbacks : Dictionary = new Dictionary();

		private function initiate() : void
		{
			Common.game_server.addCallback(0x1C1, onStoreBuyRet);
		}

		private function onStoreBuyRet(msg : SCStoreBuyRet) : void
		{
			if (_callbacks[msg.opId])
			{
				(_callbacks[msg.opId] as Function)(msg.result);

				delete _callbacks[msg.opId];
			}
		}

		public function sendStoreBuyMessage(itemId : uint, itemCount : uint, storeType : uint, callback : Function = null) : void
		{
			var msg : CSStoreBuy = new CSStoreBuy();
			msg.itemId = itemId;
			msg.itemCount = itemCount;
			msg.storeType = storeType;
			
			if (callback != null)
			{
				_callbacks[_uniqueId] = callback;
				msg.opId = _uniqueId;
				_uniqueId++;
			}
			
			Common.game_server.sendMessage(0x1C1, msg);
		}
	}
}
