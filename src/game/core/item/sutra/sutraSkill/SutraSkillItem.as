package game.core.item.sutra.sutraSkill {
	/**
	 * @author Lv
	 */
	public class SutraSkillItem {
		/*名仙id*/
		public var heroID:int;
		/*开启等级*/
		public var openStep:int;
		/*符文编号*/
		public var runetotemID:int;
		/*符文名称*/
		public var runetotemName:String;
		/*技能id*/
		public var skillID:int;
		/*符文说明*/
		public var runetotem:String;
		
		private var count : int = 0;
		public function parse(arr : Array) : void
		{
			if (!arr) return;
			heroID = arr[count++];
			openStep = arr.length > count ? arr[count++] :0;
			runetotemID = arr.length > count ? arr[count++] :0;
			runetotemName = arr.length > count ? arr[count++] :"";
			skillID = arr.length > count ? arr[count++] :0;
			runetotem = arr.length > count ? arr[count++] :"";
		}
	}
}
