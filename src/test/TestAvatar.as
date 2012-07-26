package test
{
	import game.config.StaticConfig;
	import game.core.avatar.AvatarManager;
	import game.core.avatar.AvatarPlayer;
	import game.core.avatar.AvatarThumb;
	import game.core.avatar.AvatarType;

	import gameui.manager.UIManager;

	import net.LibData;
	import net.SWFLoader;

	import project.Game;

	import flash.events.Event;
	import flash.events.MouseEvent;






	/**
	 * @author yangyiqiang
	 */
	public class TestAvatar extends Game
	{
		private var _npc : AvatarPlayer;

		private var _moster : AvatarThumb;

		private function initAvatar() : void
		{
			UIManager.setRoot(this);
			this.graphics.beginFill(0xffee00);
			this.graphics.drawRect(0, 0, 300, 200);
			this.graphics.endFill();
			_npc = new AvatarPlayer();
			_npc.x = 300;
			_npc.y = 200;
//			_npc.setId(100);
//			_npc.setName("asffff");
			// _npc.setId(AvatarManager.instance.getUUId(5, AvatarType.PLAYER_BATT_BACK));
//			 _npc.setId(AvatarManager.instance.getUUId(5, AvatarType.PLAYER_RUN));
//			 addChild(_npc);
//			 _npc.changeCloth(21);
			_moster = AvatarManager.instance.getAvatar(106, AvatarType.PLAYER_RUN, 0);
			_moster.initAvatar(4170, AvatarType.MONSTER_TYPE);
//			 _moster = AvatarManager.instance.getAvatar(105, AvatarType.NPC_TYPE, 0) as AvatarThumb;
			_moster.x = 300;
			_moster.y = 200;
			_moster.setName("_moster4150");
			_moster.setAction(1);
			addChild(_moster);
			// _avatar.setAction(3,0);
//			SecondsTimer.addFunction(onFrame);
			// this.addEventListener(Event.ENTER_FRAME, onFrame);
		}

		private var _num : int = 0;

		private function onFrame() : void
		{
			_num++;
			// _npc.changeModel(_num % 3);
			// _npc.changeModel(AvatarType.PLAYER_BATT_FRONT);
			// _npc.changeModel(AvatarType.PLAYER_BATT_BACK);
			_npc.setAction(_num % 2 == 0 ? 20 : 1);
		}

		private function onClick(event : MouseEvent) : void
		{
			// _npc.run(mouseX-300, mouseY-200, 0, 0);
//			_moster.run(mouseX - 300, mouseY - 200, 0, 0);
			// _moster.stand();
			// if(mouseX>450){
			// _npc.setId(AvatarManager.instance.getUUId(5, AvatarType.PLAYER_BATT_BACK));
			// _npc.setAction(3,0);
			// return;
			// }
			// _npc.setId(AvatarManager.instance.getUUId(5, AvatarType.PLAYER_RUN));
			// _npc.go(mouseX-300, mouseY-200, 0, 0);
			// _moster.die();
		}

		override protected function initGame() : void
		{
			_res.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + "assets/quest/quest.swf", "quest")));
			_res.addEventListener(Event.COMPLETE, completeHandler);
			_res.startLoad();
		}

		private function completeHandler(event : Event) : void
		{
			_res.removeEventListener(Event.COMPLETE, completeHandler);
			initAvatar();
		}

		public function TestAvatar()
		{
			super();
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
	}
}
