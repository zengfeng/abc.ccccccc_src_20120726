package game.module.mapGroupBattle.uis
{
	import game.module.mapGroupBattle.auxiliarys.Status;

	import flash.display.Bitmap;
	import flash.display.Sprite;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-1-17 ����10:29:26
	 */
	public class UiPlayerStatusIcon extends Sprite
	{
		private var _status : int = Status.UNKNOW;
		private var bitmap : Bitmap = new Bitmap();

		public function UiPlayerStatusIcon()
		{
			status = Status.UNKNOW;
			addChild(bitmap);
		}

		public function get status() : int
		{
			return _status;
		}

		public function set status(status : int) : void
		{
			_status = status;
			bitmap.y = 0;
			switch(_status)
			{
				case Status.WAIT:
					bitmap.bitmapData = UIStatusIcon.waitIcon;
					break;
				case Status.REST:
					bitmap.bitmapData = UIStatusIcon.restIcon;
					bitmap.y = -2;
					break;
				case Status.VS:
					bitmap.bitmapData = UIStatusIcon.vsIcon;
					break;
				case Status.DIE:
					bitmap.bitmapData = UIStatusIcon.dieIcon;
					break;
				// 移动状态
				case Status.MOVE:
					bitmap.bitmapData = null;
					break;
				default:
					bitmap.bitmapData = null;
					break;
			}
			// bitmap.scaleX = bitmap.scaleY = 0.5;
		}
	}
}
