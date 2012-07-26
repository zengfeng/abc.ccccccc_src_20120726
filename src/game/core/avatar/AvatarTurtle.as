package game.core.avatar
{
	import com.utils.ColorChange;

	import flash.filters.ColorMatrixFilter;
	import flash.utils.Dictionary;

    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-5-7 ����1:57:59
     */
    public class AvatarTurtle extends AvatarThumb
    {
        /** 香炉 */
        public var xianglu : AvatarXiangLu;

        public function AvatarTurtle()
        {
            xianglu = new AvatarXiangLu();
            super();
            addChildAt(xianglu, 2);
        }

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
            //trace(angle);
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

            //trace(_direction);

            setAction(_direction);
        }

        // loop:0 循环播放  n:播放n遍
        override public function setAction(value : int, loop : int = 0, index : int = -1, arr : Array = null,onComplete:Function=null,onCompleteParams:Array=null) : void
        {
            super.setAction(value, loop, index, arr);
            if (player) xianglu.player.flipH = player.scaleX > 0;
            xianglu.setAction(value, loop, index, arr,onComplete,onCompleteParams);
        }

        override public function stand() : void
        {
//            changeModel(AvatarType.MONSTER_TYPE);
            setAction(_direction);
        }

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
        

        public function setQuality(value : int) : void
        {
            xianglu.filters = getQualityColorMatrixFilter(value);
        }

        public static var  _qualityColorMatrixFilter : Dictionary = new Dictionary();

        public static function  getQualityColorMatrixFilter(value : int) : Array
        {
            var arr : Array = _qualityColorMatrixFilter[value];
            if (arr == null)
            {
                var colorChange : ColorChange;
                switch(value)
                {
                    case 1:
                        colorChange = new ColorChange();
                        colorChange.adjustColor(9, 29, -100, 43);
                        arr = [new ColorMatrixFilter(colorChange)];
                        break;
                    case 2:
                        colorChange = new ColorChange();
                        colorChange.adjustColor(0, 0, 0, 43);
                        arr = [new ColorMatrixFilter(colorChange)];
                        break;
                    case 3:
                        colorChange = new ColorChange();
                        colorChange.adjustColor(0, 0, 29, -179);
                        arr = [new ColorMatrixFilter(colorChange)];
                        break;
                    case 4:
                    default:
                        arr = [];
                        break;
                }
                _qualityColorMatrixFilter[value] = arr;
            }
            return arr;
        }
    }
}
