package game.module.mapMining.scene
{
	import framerate.FrameTimer;
	import framerate.IFrame;

	import gameui.controls.BDPlayer;

	import com.greensock.TweenLite;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.utils.getTimer;

	/**
	 * @author jian
	 */
	public class JumpHelper implements IFrame
	{
		// 目标对象
		public var target : DisplayObject;
		// 跳跃高度
		public var jumpHeight : Number;
		// 跳跃时间（秒）
		public var duration : Number;
		// 跳跃时间（系统毫秒）
		private var durationM : int;
		// 半程时间（系统毫秒）
		private var durationHalfM : int;
		// 起跳时间（系统毫秒）
		private var startTime : int;
		// 保存原始高度
		private var startY : Number;
		// 回调
		private var _onComplete : Function;
		// 上次残影创建时间
		private var _lastGhostTime : int;

		public function jump(onComplete : Function = null) : void
		{
			_onComplete = onComplete;
			durationM = duration * 1000;
			durationHalfM = duration * 500;
			startTime = getTimer();
			startY = target.y;
			_lastGhostTime = startTime;

			FrameTimer.add(this);
		}

		public function action(time : uint) : void
		{
			var t : int = getTimer() - startTime;

			if (t > durationM)
			{
				onComplete();
				return;
			}

			var tGhost : int = getTimer() - _lastGhostTime;

			if (tGhost > 200)
			{
				if (target is BDPlayer && target.parent)
				{
					var bitmap : Bitmap = (target as BDPlayer).getBitMap();
					tGhost = getTimer();
					var ghost : Bitmap = new Bitmap(bitmap.bitmapData);
					ghost.scaleX = target.scaleX;
					ghost.alpha = 0.6;
					ghost.x = target.x + bitmap.x * target.scaleX;
					ghost.y = target.y + bitmap.y ;
					target.parent.addChildAt(ghost, target.parent.getChildIndex(target));
					TweenLite.to(ghost, 0.2, {alpha:0, onComplete:onGhostComplete, onCompleteParams:[ghost]});
				}
			}

			if (t < durationHalfM)
				target.y = startY - jumpHeight * (1 - (durationHalfM - t) / durationHalfM * (durationHalfM - t) / durationHalfM);
			else
				target.y = startY - jumpHeight * (1 - (t - durationHalfM) / durationHalfM * (t - durationHalfM) / durationHalfM);
		}

		private function onComplete() : void
		{
			FrameTimer.remove(this);
			target.y = startY;
			if (_onComplete is Function)
				_onComplete();
		}

		private function onGhostComplete(ghost : Bitmap) : void
		{
			ghost.parent.removeChild(ghost);
		}
	}
}
