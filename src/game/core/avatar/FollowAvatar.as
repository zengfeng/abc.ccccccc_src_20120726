package game.core.avatar
{

	/**
	 * @author yangyiqiang
	 */
	public class FollowAvatar extends AvatarThumb
	{
		public function FollowAvatar()
		{
			super();
		}

		override public function run(goX : int, goY : int, targetX : int, targetY : int) : void
		{
			var x_distance : Number = goX - targetX;
			var y_distance : Number = goY - targetY;
			
			if(x_distance==0&&y_distance==0){
				setAction(_direction+5);
				return;      
			}

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
			//trace("setAction(_direction + 5)===>" + String(_direction + 5));
			setAction(_direction + 5);
		}

		override  public function stand() : void
		{
			setAction(_direction);
		}
	}
}
