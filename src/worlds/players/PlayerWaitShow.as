package worlds.players
{
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import worlds.roles.cores.Player;

	import flash.utils.Dictionary;

	/**
	 * @author ZengFeng (zengfeng75[at]163.com) 2012-7-26
	 */
	public class PlayerWaitShow
	{
		/** 单例对像 */
		private static var _instance : PlayerWaitShow;

		/** 获取单例对像 */
		static public function get instance() : PlayerWaitShow
		{
			if (_instance == null)
			{
				_instance = new PlayerWaitShow(new Singleton());
			}
			return _instance;
		}

		function PlayerWaitShow(singleton : Singleton) : void
		{
			singleton;
		}

		private var list : Vector.<Player> = new Vector.<Player>();
		private var dic : Dictionary = new Dictionary();

		public function add(player : Player) : void
		{
			if (dic[player.id]) return;
			list.push(player);
			dic[player.id] = player;
			if (!isStar) start();
		}

		public function remove(player : Player) : void
		{
			if (!dic[player.id]) return;
			var index : int = list.indexOf(player);
			list.splice(index, 1);
			dic[player.id] = null;
			delete dic[player.id];
		}

		private var isStar : Boolean = false;

		private function start() : void
		{
			clearTimeout(timer);
			if (list.length > 0)
			{
				isStar = true;
				startLimit();
			}
			else
			{
				isStar = false;
			}
		}

		private var timer : uint;
		private var limitNum : int;
		private var tempPlayer : Player;

		private function startLimit() : void
		{
			while (list.length > 0)
			{
				tempPlayer = list.shift();
				tempPlayer.limitShowExe();
				dic[tempPlayer.id] = null;
				delete dic[tempPlayer.id];
				limitNum++;
				if (limitNum > 0) break;
			}
			tempPlayer = null;
			timer = setTimeout(start, 30);
		}

		public function clearup() : void
		{
			clearTimeout(timer);
			while (list.length > 0)
			{
				list.shift();
			}

			var keyArr : Array = [];
			var key : *;
			for (key in dic)
			{
				keyArr.push(key);
			}

			while (keyArr.length > 0)
			{
				key = keyArr.shift();
				dic[key] = null;
				delete dic[key];
			}
		}
	}
}
class Singleton
{
}