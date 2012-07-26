package worlds.apis
{
	import flash.utils.Dictionary;
	import game.module.mapConvoy.ConvoyControl;
	import game.module.mapMining.MiningManager;
	import worlds.maps.configs.MapId;



	/** 
	* @author ZengFeng (zengfeng75[AT]163.com) 2012-6-27
	*/
	public class MActive
	{
		/** 单例对像 */
		private static var _instance : MActive;

		/** 获取单例对像 */
		private static  function get instance() : MActive
		{
			if (_instance == null)
			{
				_instance = new MActive(new Singleton());
			}
			return _instance;
		}

		function MActive(singleton : Singleton) : void
		{
			singleton;
			dic[MapId.CLAN_HKEE] = true;
			dic[MapId.CLAN_BOSS] = true;
			dic[MapId.CLAN_ESCORT] = true;

			dic[MapId.BOSSWAR] = true;
			dic[MapId.FEAST] = true;
			dic[MapId.GROUPBATTLE] = true;
			dic[MapId.MINING] = true;
		}

		private var dic : Dictionary = new Dictionary();

		private function get isActiveMap() : Boolean
		{
			return dic[MapUtil.currentMapId] == true;
		}

		private function get isActiveing() : Boolean
		{
			if (isActiveMap)
			{
				return true;
			}
			else if (MapUtil.isCapitalMap(MapId.CAPITAL))
			{
				return ConvoyControl.instance.selfConvoying == true || MiningManager.instance.selfIsMining == true;
			}
			return false;
		}

		public static function get isActiveing() : Boolean
		{
			return instance.isActiveing;
		}
	}
}
class Singleton
{
}