package test.avatar
{
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;

	import com.sociodox.theminer.TheMiner;

	import game.core.avatar.AvatarThumb;

	import utils.MathUtil;

	import game.core.avatar.AvatarType;
	import game.core.avatar.AvatarManager;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author yangyiqiang
	 */
	[ SWF ( frameRate="60" ,width="800" , height="500" ) ]
	public class AvatarGC extends Sprite
	{
		public function AvatarGC()
		{
			addChild(new TheMiner());
			initAvatar();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}

		private function onKeyDown(event : KeyboardEvent) : void
		{
			switch(event.keyCode)
			{
				case Keyboard.SPACE:
					stop();
					break;
				case Keyboard.H:
					hide();
					break;
				case Keyboard.S:
					show();
					break;
				case Keyboard.R:
					run();
					break;
				case Keyboard.T:
					stand();
					break;
			}
		}

		private var _avatarList : Vector.<AvatarThumb>=new Vector.<AvatarThumb>;

		private function initAvatar() : void
		{
			for (var i : int = 0;i < _max;i++)
			{
				_avatar = AvatarManager.instance.getAvatar(MathUtil.random(1, 6), 0);
				_avatar.setName("name" + i);
				_avatar.x = MathUtil.random(200, 800);
				_avatar.y = MathUtil.random(200, 500);
				// _avatar.addSeat(1);
				_avatarList.push(_avatar);
				addChild(_avatar);
			}
			this.stage.addEventListener(MouseEvent.CLICK, onClick);
		}

		public function stop() : void
		{
			for (var i : int = 0; i < _avatarList.length; i++)
			{
				_avatar = _avatarList[i];
				_avatar.stop();
			}
		}

		public function hide() : void
		{
			for (var i : int = 0; i < _avatarList.length; i++)
			{
				_avatar = _avatarList[i];
				if (_avatar.parent) _avatar.parent.removeChild(_avatar);
			}
		}

		public function show() : void
		{
			for (var i : int = 0; i < _avatarList.length; i++)
			{
				_avatar = _avatarList[i];
				addChild(_avatar);
			}
		}

		public function run() : void
		{
			for (var i : int = 0; i < _avatarList.length; i++)
			{
				_avatar = _avatarList[i];
				_avatar.run(0, 300, 0, 0);
			}
		}
		
		
		public function stand() : void
		{
			for (var i : int = 0; i < _avatarList.length; i++)
			{
				_avatar = _avatarList[i];
				_avatar.run(0, 0, 300, 0);
			}
		}

		private var _avatar : AvatarThumb;
		private var _max : int = 10;

		private function onClick(event : MouseEvent) : void
		{
			var i : int = _max;
			for (var k : int = 0;k < i;k++)
			{
				AvatarManager.instance.removeAvatar(_avatarList[k]);
				_avatarList[k].hide();
			}
			_avatarList = new Vector.<AvatarThumb>();
			for (i = 0;i < _max;i++)
			{
				_avatar = AvatarManager.instance.getAvatar(MathUtil.random(1, 6), AvatarType.PLAYER_RUN);
				_avatar.setName("name" + i);
				_avatar.x = MathUtil.random(200, 500);
				_avatar.y = MathUtil.random(200, 500);
				_avatar.addSeat(1);
				_avatarList.push(_avatar);
				addChild(_avatar);
			}
		}
	}
}
