package worlds.players
{
	import worlds.apis.ModelId;
	import flash.utils.Dictionary;
	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-9
	 */
	public class ModelType
	{
		/** 单例对像 */
		private static var _instance : ModelType;

		/** 获取单例对像 */
		static public function get instance() : ModelType
		{
			if (_instance == null)
			{
				_instance = new ModelType(new Singleton());
			}
			return _instance;
		}

		function ModelType(singleton : Singleton) : void
		{
			singleton;
			for (var i : int = ModelId.MIN_CONVORY; i <= ModelId.MAX_CONVORY;i++)
			{
				dic[i] =ModelId.MIN_CONVORY;
			}

			dic[ModelId.FISHING] = ModelId.FISHING;
			dic[ModelId.MINGING] = ModelId.MINGING;
			dic[ModelId.PRACTICE] = ModelId.PRACTICE;

			for (i = ModelId.FEAST_MIN; i <= ModelId.FEAST_PARTNER; i++)
			{
				dic[i] = ModelId.FEAST_MIN ;
			}
		}

		private var dic : Dictionary = new Dictionary();

		public function getType(modelId : int) : int
		{
			return dic[modelId];
		}
	}
}
class Singleton
{
}