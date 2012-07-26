package game.module.quest
{
	import flash.display.Sprite;
	import game.core.user.StateManager;
	import game.core.user.StateType;
	import game.manager.ViewManager;


	/**
	 * @author yangyiqiang
	 */
	public class DialogueSprite extends Sprite
	{
		private var npcPanel : DialogueNpcPanel;

		private var _npc : VoBase;

		public function DialogueSprite()
		{
			npcPanel = new DialogueNpcPanel();
			addChild(npcPanel);
		}

		private var _quest : VoQuest;

		private var _str : String;

		public function setData(npc : VoBase, quest : VoQuest, str : String = "",flag:int=0) : void
		{
			_npc = npc;
			_quest = quest;
			_str = str;
			npcPanel.setData(npc, quest, str,flag);
		}

		public function show() : void
		{
			addChild(npcPanel);
			ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER).addChild(ViewManager.dialogueSprite);
			StateManager.instance.changeState(StateType.QUEST_DIALOG);
		}

		public function hide() : void
		{
			if (parent == null) return;
			ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER).removeChild(ViewManager.dialogueSprite);
			npcPanel.hide();
		}

		public function hideMySelf() : void
		{
			if (parent == null) return;
			ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER).removeChild(ViewManager.dialogueSprite);
		}
	}
}
