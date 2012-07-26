package worlds.players
{
	import worlds.apis.ModelId;
	import worlds.mediators.PlayerMediator;

	import flash.utils.Dictionary;

	/** 
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-6-25
	 */
	public class ModelIn
	{
		/** 单例对像 */
		private static var _instance : ModelIn;

		/** 获取单例对像 */
		static public function get instance() : ModelIn
		{
			if (_instance == null)
			{
				_instance = new ModelIn(new Singleton());
			}
			return _instance;
		}

		function ModelIn(singleton : Singleton) : void
		{
			singleton;
			for (var i : int = ModelId.MIN_CONVORY; i <= ModelId.MAX_CONVORY;i++)
			{
				dic[i] = PlayerMediator.MODEL_CONVOY_IN.dispatch;
				inDic[i] = PlayerMediator.MODEL_IN.dispatch;
			}

			dic[ModelId.FISHING] = PlayerMediator.MODEL_FISHING_IN.dispatch;
			dic[ModelId.MINGING] = PlayerMediator.MODEL_MINGING_IN.dispatch;
			dic[ModelId.PRACTICE] = PlayerMediator.sitDown.dispatch;

			for (i = ModelId.FEAST_MIN; i <= ModelId.FEAST_PARTNER; i++)
			{
				// dic[i] = PlayerMediator.MODEL_CONVOY_IN.dispatch;
				dic[i] = PlayerMediator.MODEL_FEAST_IN.dispatch ;
				inDic[i] = PlayerMediator.MODEL_IN.dispatch;
			}
			
			inDic[ModelId.FISHING] = PlayerMediator.MODEL_IN.dispatch;
			inDic[ModelId.MINGING] = PlayerMediator.MODEL_IN.dispatch;
		}

		private var dic : Dictionary = new Dictionary();
		private var inDic : Dictionary = new Dictionary();

		public function execute(playerId : int, modelId : int) : void
		{
			var fun : Function = inDic[modelId];
			if(fun != null)
			{
				fun(playerId);
			}
			
			fun = dic[modelId];
			if (fun != null)
			{
				fun(playerId, modelId);
			}
		}
	}
}
class Singleton
{
}