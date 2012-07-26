package worlds.players
{
	import worlds.apis.ModelId;
	import worlds.mediators.PlayerMediator;

	import flash.utils.Dictionary;

	/** 
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-6-25
	 */
	public class ModelOut
	{
		/** 单例对像 */
		private static var _instance : ModelOut;

		/** 获取单例对像 */
		static public function get instance() : ModelOut
		{
			if (_instance == null)
			{
				_instance = new ModelOut(new Singleton());
			}
			return _instance;
		}

		function ModelOut(singleton : Singleton) : void
		{
			singleton;
			for (var i : int = ModelId.MIN_CONVORY; i <= ModelId.MAX_CONVORY;i++)
			{
				dic[i] = PlayerMediator.MODEL_CONVOY_OUT.dispatch;
				outDic[i] = PlayerMediator.MODEL_OUT.dispatch;
			}

			dic[ModelId.FISHING] = PlayerMediator.MODEL_FISHING_OUT.dispatch;
			dic[ModelId.MINGING] = PlayerMediator.MODEL_MINGING_OUT.dispatch;
			dic[ModelId.PRACTICE] = PlayerMediator.sitUp.dispatch;

			for (i = ModelId.FEAST_MIN; i <= ModelId.FEAST_PARTNER; i++)
			{
				dic[i] = PlayerMediator.MODEL_FEAST_OUT.dispatch;
				outDic[i] = PlayerMediator.MODEL_OUT.dispatch;
			}

			outDic[ModelId.FISHING] = PlayerMediator.MODEL_OUT.dispatch;
			outDic[ModelId.MINGING] = PlayerMediator.MODEL_OUT.dispatch;
		}

		private var dic : Dictionary = new Dictionary();
		private var outDic : Dictionary = new Dictionary();

		public function execute(playerId : int, modelId : int) : void
		{
			var fun : Function = dic[modelId];
			if (fun != null)
			{
				fun(playerId);
			}

			fun = outDic[modelId];
			if (fun != null)
			{
				fun(playerId);
			}
		}
	}
}
class Singleton
{
}