package game.module.quest
{
	/**
	 * @author yangyiqiang
	 */
	public class VoDialogue
	{
		public var id : int = -1;

		public var str : String = "";

		public function  getDialogue() : String
		{
			return QuestUtil.parseRegExpStr(str);
		}
	}
}
