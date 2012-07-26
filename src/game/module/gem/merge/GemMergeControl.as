package game.module.gem.merge
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import game.core.item.Item;
	import game.core.item.ItemManager;
	import game.core.item.gem.Gem;
	import game.net.core.Common;
	import game.net.data.CtoS.CSGemMerge;
	import game.net.data.StoC.SCGemMergeResult;
	import log4a.Logger;



	/**
	 * @author jian
	 */
	public class GemMergeControl extends EventDispatcher
	{
		private var _fragments : Array = []/* of Item */;
		private var _product : Item;
		private var _lock : Boolean = false;
		private var _gemType:uint = 0;
		
		public function get fragments():Array /* of Item */
		{
			return _fragments;
		}
		
		public function get product():Item
		{
			return _product;
		}

		public function addFragment(item : Gem) : void
		{				
			if (_gemType && item.id != _gemType)
			{
				_fragments = [];
			}
			else if (item.isEquipped)
			{
				for each (var frag:Gem in _fragments)
				{
					if (frag.heroId != 0 && frag.heroId != item.heroId)
					{
						_fragments = [];
						break;
					}
				}
			}

			if (_fragments.length >= 3)
				return;
			
			_gemType = item.id;
			_fragments.push(item);
		}
		

		public function removeFragment(item : Item) : void
		{
			_fragments.splice(_fragments.indexOf(item), 1);
			if (_fragments.length == 0)
				_gemType = 0;
		}
		
		public function clear():void
		{
			_fragments = [];
			_product = null;
			_gemType = 0;
		}

		public function merge() : void
		{
			if (_fragments.length != 3)
				return;

			sendGemMergeMessage();
		}

		private function sendGemMergeMessage() : void
		{
			if (_lock)
			{
				Logger.warn("服务器未返回！");
//				return;
			}

			_lock = true;
			
			var msg : CSGemMerge = new CSGemMerge();
			for (var i : uint = 0; i < 3; i++)
			{
				var gem:Gem = _fragments[i];
				msg["gemId"+i] = gem.equipId;
			}

			Common.game_server.addCallback(0x2A1, mergeResultHandler);
			Common.game_server.sendMessage(0x2A1, msg);
		}

		private function mergeResultHandler(msg : SCGemMergeResult) : void
		{
			Common.game_server.removeCallback(0x2A1, mergeResultHandler);
			var id : uint = msg.compactId & 0x7FFF;
			var binding : Boolean = (msg.compactId >> 15 & 0x1) != 0;

			_product = ItemManager.instance.newItem(id, binding);
			notifyMergeResult();

			_lock = false;
		}

		private function notifyMergeResult() : void
		{
			var event : Event = new Event(Event.COMPLETE);
			dispatchEvent(event);
		}
	}
}
