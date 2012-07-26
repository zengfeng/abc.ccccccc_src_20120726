package test
{
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	import game.core.avatar.AvatarManager;
	import game.core.avatar.AvatarPlayer;
	import game.core.avatar.AvatarType;
	import game.manager.RSSManager;
	import gameui.data.GStatsData;
	import gameui.monitor.GStatus;
	import project.Game;
	import utils.MathUtil;
	import utils.ObjectPool;





	/**
	 * @author yangyiqiang
	 */
	[ SWF ( frameRate="60" , backgroundColor=0x000000,width="1200" , height="1000" ) ]
	public class TestObjectPool extends Game
	{
		override protected function initGame() : void
		{
			RSSManager.getInstance().startLoad();
		}


		private var _list : Vector.<AvatarPlayer>;

		private function initAvatar() : void
		{
			_list = new Vector.<AvatarPlayer>();
			for (var i : int = 0;i < 500;i++)
			{
				_index = i;
				createAvatar();
			}
			this.stage.addEventListener(MouseEvent.CLICK, onClick);
			addChild(new GStatus(new GStatsData()));
		}

		private function onClick(event : MouseEvent) : void
		{
			//trace("" + ObjectPool.getSize(AvatarPlayer));
			removeAvatar();
			//trace(ObjectPool.getSize(AvatarPlayer));
			createAvatar();
			//trace(ObjectPool.getSize(AvatarPlayer));
		}

		private var _avatar : AvatarPlayer;

		private var _index : int;

		private function createAvatar() : void
		{
			_avatar = AvatarManager.instance.getAvatar(1, AvatarType.PLAYER_RUN) as AvatarPlayer;
			_avatar.x = MathUtil.random(100, 1000);
			_avatar.y = MathUtil.random(100, 800);
			_avatar.setName(_index + "_avatar");
			_list.push(_avatar);
			addChild(_avatar);
		}

		private function removeAvatar() : void
		{
			_index = MathUtil.random(0, _list.length - 1);
			_avatar = _list[_index];
			_avatar.hide();
			_avatar.dispose();
			_list.splice(_index, 1);
		}

		public function TestObjectPool()
		{
			super();
			setTimeout(initAvatar, 5000);
		}
	}
}
