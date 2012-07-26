package test {
	import game.module.quest.QuestUtil;

	import net.RESManager;

	import flash.display.Sprite;
	import flash.events.Event;




	/**
	 * @author yangyiqiang
	 */
	public class TestConfig extends Sprite {
		
		public function TestConfig() {
			var str:String=QuestUtil.parseRegExpStr("谢谢[10:2]，[10:2]的故事好好听，以后也经常讲故事给我听吧！");
			trace(str);
		}
	}
}
