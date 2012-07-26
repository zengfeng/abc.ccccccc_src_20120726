package game.core.item.prop {
	/**
	 * @author Lv
	 */
	public class ItemSutraAppend {
		/*名仙configID*/
		public var id:int;
		/*法宝阶数*/
		public var step:int;
		/*技能id*/
		public var skillID:int;
		/*阶数特效*/
		public var stepEffectStr:String;
		/*法宝阶数tips*/
		public var story:String;
		
		private var count : int = 0;
		public function parse(arr : Array) : void
		{
			if (!arr) return;
			id = arr[count++];
			step = arr.length > count ? arr[count++] :0;
			skillID = arr.length > count ? arr[count++] :0;
			stepEffectStr = arr.length > count ? arr[count++] :"";
			story = arr.length > count ? arr[count++] :"";
			story = story.replace(/\\n/ig, "\n");
		}
	}
}
