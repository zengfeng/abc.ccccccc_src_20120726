package game.core.avatar {
	import flash.events.Event;

	/**
	 * @author zhangzheng
	 */
	public class AvatarDray extends AvatarThumb {
		
		
		
		public function AvatarDray() {
			super();
			mouseEnabled = false ;
			mouseChildren = false ;
		}
		
//		private var _direction : int = 0;
		
		override public function run(goX : int, goY : int, targetX : int, targetY : int) : void
        {
			if (targetX == 0 && targetY == 0)
			{
				targetX = this.x;
				targetY = this.y;
			}
			
			var x_distance : Number = goX - targetX;
			var y_distance : Number = goY - targetY;

			var angle : Number = Math.atan2(y_distance, x_distance) * 180 / Math.PI;
			if (angle < 0)
			{
				angle += 360;
			}
			if (angle >= 337.5 || angle < 22.5)
			{
				_direction = 3;
				player.flipH = false;
			}
			else if (angle >= 22.5 && angle < 67.5)
			{
				_direction = 2;
				player.flipH = false;
			}
			else if (angle >= 67.5 && angle < 112.5)
			{
				_direction = 1;
				player.flipH = false;
			}
			else if (angle >= 112.5 && angle < 157.5)
			{
				_direction = 2;
				player.flipH = true;
			}
			else if (angle >= 157.5 && angle < 202.5)
			{
				_direction = 3;
				player.flipH = true;
			}
			else if (angle >= 202.5 && angle < 247.5)
			{
				_direction = 4;
				player.flipH = true;
			}
			else if (angle >= 247.5 && angle < 292.5)
			{
				_direction = 5;
				player.flipH = false;
			}
			else if (angle >= 292.5 && angle < 337.5)
			{
				_direction = 4;
				player.flipH = false;
			}
			_player.removeEventListener(Event.COMPLETE, onPreDefend);
			setAction(_direction);
        }
		
		public function defend():void{
			
			if( _currentAction.action < 7 )
			{
				setAction(7,1);
				_player.addEventListener(Event.COMPLETE, onPreDefend);
			}
		}

		private function onPreDefend(event : Event) : void {
			_player.removeEventListener(Event.COMPLETE, onPreDefend );
			setAction(8);
		}
		
		override protected function initComplete(event : Event) : void
		{
			if( _currentAction.action == 7 )
				setAction(_currentAction.action,1);
			else 
				setAction(_currentAction.action);
			if (_avatarBd)
				_avatarBd.removeEventListener(Event.COMPLETE, initComplete);
			updateDisplays();
			playShowAction();
			change();
		}

		override public function stand() : void
		{
			if( _currentAction.action < 7 )
			{
				_player.flipH = false ;
				setAction(6);
			}
//			changeModel(AvatarType.PLAYER_RUN);
//			setAction(1);
		}
		
//		override public function setAction(value : int, loop : int = 0, index : int = -1, arr : Array = null) :void
//		{
//			super.setAction(value,loop,index,arr);
//		}
		
	}
}
