package game.core.avatar
{

    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-5-7 ����7:07:39
     */
    public class AvatarXiangLu extends AvatarThumb
    {
        public function AvatarXiangLu()
        {
            super();
			initAvatar(5014, AvatarType.MONSTER_TYPE,0);
        }

//        override protected function setUUID(value : int) : void
//        {
//            value;
//            super.setUUID(AvatarManager.instance.getUUId(5014, AvatarType.MONSTER_TYPE));
//        }

        override public function standDirection(targetX : int, targetY : int, x : int = 0, y : int = 0) : void
        {
            if (x == 0 && y == 0)
            {
                x = this.x;
                y = this.y;
            }
            var x_distance : Number = targetX - x;
            var y_distance : Number = targetY - y;

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

            setAction(_direction);
        }

        override public function stand() : void
        {
			changeType(AvatarType.MONSTER_TYPE);
            setAction(_direction);
        }

//        override public function stop() : void
//        {
//            changeModel(AvatarType.MONSTER_TYPE);
//            setAction(_direction);
//        }

        override public function run(goX : int, goY : int, targetX : int, targetY : int) : void
        {
			var x_distance : Number = goX - targetX;
			var y_distance : Number = goY - targetY;
			if(x_distance==0&&y_distance==0){
				setAction(_direction+5);
				return;      
			}
            standDirection(goX, goY, targetX, targetY);
        }
    }
}
