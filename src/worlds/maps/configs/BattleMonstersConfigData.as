package worlds.maps.configs
{
	import flash.utils.Dictionary;
	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-11
	 */
	public class BattleMonstersConfigData
	{
		/** 单例对像 */
		private static var _instance : BattleMonstersConfigData;

		/** 获取单例对像 */
		static public function get instance() : BattleMonstersConfigData
		{
			if (_instance == null)
			{
				_instance = new BattleMonstersConfigData(new Singleton());
			}
			return _instance;
		}

		public function BattleMonstersConfigData(singleton : Singleton)
		{
		}
		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		public var dic:Dictionary = new Dictionary();
		
		public function getMonsters(npcId:int):Array
		{
			return dic[npcId];
		}
	}
}

class Singleton
{
}