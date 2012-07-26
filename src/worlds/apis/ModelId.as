package worlds.apis
{
	/** 
	* @author ZengFeng (zengfeng75[AT]163.com) 2012-6-6
	*/
	public class ModelId
	{
		/** 最小龟拜值 */
		public static const MIN_CONVORY : int = 1;
		/** 最大龟拜值 */
		public static const MAX_CONVORY : int = 10;
		/** 钓鱼 */
		public static const FISHING : int = 11;
		/** 采矿 */
		public static const MINGING:int = 12;
		/** 修炼 */
		public static const PRACTICE : int = 20;
		/** 派对变身1 */
		public static const FEAST_MIN : int = 30;
		/** 派对变身6 */
		public static const FEAST_MAX : int = 35;
		/** 派对合体1 */
		public static const FEAST_MATCH_MIN : int = 40 ;
		/** 派对合体3 */
		public static const FEAST_MATCH_MAX : int = 42 ;
		/** 派对舞伴 */
		public static const FEAST_PARTNER : int = 45 ;

		public static function isNormal(model : int) : Boolean
		{
			return model == 0;
		}

		public static function isPractice(model : int) : Boolean
		{
			return model == PRACTICE;
		}

		public static function isConvory(model : int) : Boolean
		{
			return model >= MIN_CONVORY && model <= MAX_CONVORY;
		}

		public static function isFishing(model : int) : Boolean
		{
			return model == FISHING;
		}
		
		public static function isFeastSingle(model : int) : Boolean
		{
			return model >= FEAST_MIN && model <= FEAST_MAX ;
		}
		
		public static function isFeastMatch(model : int) : Boolean
		{
			return model >= FEAST_MATCH_MIN && model <= FEAST_MATCH_MAX ;
		}
		
		public static function isFeastPartner(model : int) : Boolean {
			return model == FEAST_PARTNER ;
		}
	}
}
