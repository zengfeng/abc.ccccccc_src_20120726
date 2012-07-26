package worlds.maps.resets
{
	import worlds.mediators.PlayerMediator;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-22
	 */
	public class ResetCapital extends ResetNormal
	{
		/** 单例对像 */
		private static var _instance : ResetCapital;

		/** 获取单例对像 */
		public static function get instance() : ResetCapital
		{
			if (_instance == null)
			{
				_instance = new ResetCapital(new Singleton());
			}
			return _instance;
		}

		public function ResetCapital(singleton : Singleton)
		{
		}

		override protected function addSignals() : void
		{
			super.addSignals();
//			PlayerMediator.MODEL_CONVOY_IN.add(playerControl.convoyModelIn);
//			PlayerMediator.MODEL_CONVOY_OUT.add(playerControl.convoyModelOut);
//			PlayerMediator.MODEL_CONVOY_CHANGE.add(playerControl.convoyChangeSpeed);
		}

		override protected function removeSignals() : void
		{
			super.removeSignals();
//			PlayerMediator.MODEL_CONVOY_IN.remove(playerControl.convoyModelIn);
//			PlayerMediator.MODEL_CONVOY_OUT.remove(playerControl.convoyModelOut);
//			PlayerMediator.MODEL_CONVOY_CHANGE.remove(playerControl.convoyChangeSpeed);
		}
	}
}
class Singleton
{
}