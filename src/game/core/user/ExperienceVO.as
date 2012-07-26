package game.core.user
{
	/**
	 * @author jian
	 */
	public class ExperienceVO
	{
		/** 当前等级 **/
		public var level : uint;
		/** 当前等级需要的经验 **/
		public var upExp : uint;
		/** 挂机经验 **/
		public var practiceExp : uint;
		public var totalExp :Number;
		private var count : int = 0; 

		public function parse(arr : Array) : void
		{
			if (!arr) return;
			level = arr[count++];
			upExp = arr.length > count ? arr[count++] : 0;
			totalExp=arr.length > count ? arr[count++] : 0;
			practiceExp = arr.length > count ? arr[count++] : 0;
		}
	}
}
