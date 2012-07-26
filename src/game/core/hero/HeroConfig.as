package game.core.hero
{
	/**
	 * @author jian
	 */
	public class HeroConfig
	{
		public var id : int;

		public var name : String;

		public var headId : int = 1;

		public var sutraId : int;
		//法宝升阶上线
		public var sutraUp : int;

		// 可显示招募等级
		public var preRecruitLevel : int;

		// 可以招募等级
		public var recruitHeroLevel : int;
		//招募材料
		public var relic : int;
		//材料数量
		public var sutraValue : int;

		/** 将领法宝升阶（0-10）级 的天才地宝 id **/
		public var stepRelicLevel10 : int;

		/** 将领法宝升阶（0-10）级 每一级所需天才地宝个数 **/
		public var stepRelicLevel10_Num : int;

		/** 将领法宝升阶（11-20）级 的天才地宝 id **/
		public var stepRelicLevel20 : int;

		/** 将领法宝升阶（11-20）级 每一级所需天才地宝个数 **/
		public var stepRelicLevel20_Num : int;

		/** 将领法宝升阶（21-30）级 的天才地宝 id **/
		public var stepRelicLevel30 : int;

		/** 将领法宝升阶（21-30）级 每一级所需天才地宝个数 **/
		public var stepRelicLevel30_Num : int;

		/** 将领法宝升阶（31-40）级 的天才地宝 id **/
		public var stepRelicLevel40 : int;

		/** 将领法宝升阶（31-40）级 每一级所需天才地宝个数 **/
		public var stepRelicLevel40_Num : int;

		/** 将领法宝升阶（41-50）级 的天才地宝 id **/
		public var stepRelicLevel50 : int;

		/** 将领法宝升阶（41-50）级 每一级所需天才地宝个数 **/
		public var stepRelicLevel50_Num : int;

		/** 将领法宝升阶（51-60）级 的天才地宝 id **/
		public var stepRelicLevel60 : int;

		/** 将领法宝升阶（51-60）级 每一级所需天才地宝个数 **/
		public var stepRelicLevel60_Num : int;

		private var count : int = 0;

		public function parse(arr : Array) : void
		{
			if (!arr) return;
			id = arr[count++];
			name = arr.length > count ? arr[count++] : "";
			headId = arr.length > count ? arr[count++] : 1;
			sutraId = arr.length > count ? arr[count++] : 0;
			sutraUp = arr.length > count ? arr[count++] : 0;
			preRecruitLevel = arr.length > count ? arr[count++] : 0;
			recruitHeroLevel = arr.length > count ? arr[count++] : 0;
			relic = arr.length > count ? arr[count++] : 0;
			sutraValue = arr.length > count ? arr[count++] : 0;
//			stepRelicLevel10 = arr.length > count ? arr[count++] : 0;
//			stepRelicLevel10_Num = arr.length > count ? arr[count++] : 0;
//			stepRelicLevel20 = arr.length > count ? arr[count++] : 0;
//			stepRelicLevel20_Num = arr.length > count ? arr[count++] : 0;
//			stepRelicLevel30 = arr.length > count ? arr[count++] : 0;
//			stepRelicLevel30_Num = arr.length > count ? arr[count++] : 0;
//			stepRelicLevel40 = arr.length > count ? arr[count++] : 0;
//			stepRelicLevel40_Num = arr.length > count ? arr[count++] : 0;
		}
	}
}
