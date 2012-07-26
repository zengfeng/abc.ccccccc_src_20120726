package worlds.players
{
	import worlds.apis.ModelId;
	import worlds.mediators.PlayerMediator;

	import flash.utils.Dictionary;

	/** 
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-6-25
	 */
	public class ModelChange
	{
		/** 单例对像 */
		private static var _instance : ModelChange;

		/** 获取单例对像 */
		static public function get instance() : ModelChange
		{
			if (_instance == null)
			{
				_instance = new ModelChange(new Singleton());
			}
			return _instance;
		}

		function ModelChange(singleton : Singleton) : void
		{
			singleton;

			for (var i : int = ModelId.MIN_CONVORY; i <= ModelId.MAX_CONVORY;i++)
			{
				dic[i] = PlayerMediator.MODEL_CONVOY_CHANGE.dispatch;
			}

			for (i = ModelId.FEAST_MIN; i <= ModelId.FEAST_PARTNER; i++)
			{
				dic[i] = PlayerMediator.MODEL_FEAST_CHANGE.dispatch;
			}
		}

		private var modelIn : ModelIn = ModelIn.instance;
		private var modelOut : ModelOut = ModelOut.instance;
		private var modelType : ModelType = ModelType.instance;
		private var dic : Dictionary = new Dictionary();

		public function execute(playerId : int, modelId : int, preModelId : int) : void
		{
			// 从正常模式进入特殊模式
			if (ModelId.isNormal(preModelId) && !ModelId.isNormal(modelId))
			{
				modelIn.execute(playerId, modelId);
			}
			// 从特殊模式进入正常模式
			else if (!ModelId.isNormal(preModelId) && ModelId.isNormal(modelId))
			{
				modelOut.execute(playerId, preModelId);
			}
			else if (!ModelId.isNormal(preModelId) && !ModelId.isNormal(modelId))
			{
				if (modelType.getType(preModelId) != modelType.getType(modelId) )
				{
					modelOut.execute(playerId, preModelId);
					modelIn.execute(playerId, modelId);
				}
				else
				{
					var fun : Function = dic[modelId];
					if (fun != null)
					{
						fun(playerId, modelId);
					}
				}
			}
			// 模式状态改变
			else
			{
				var fun2 : Function = dic[modelId];
				if (fun2 != null)
				{
					fun2(playerId, modelId);
				}
			}
		}
	}
}
class Singleton
{
}