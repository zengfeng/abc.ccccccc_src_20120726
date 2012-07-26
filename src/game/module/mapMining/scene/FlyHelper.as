package game.module.mapMining.scene
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;

	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.setTimeout;

	/**
	 * @author jian
	 */
	public class FlyHelper
	{
		// 出生点
		public var appearPoint : Point;
		// 悬浮点
		public var hoverPoint : Point;
		// 终点
		public var endPoint : Point;
		// 延迟
		public var delay : Number;
		// 目标对象
		public var target : DisplayObject;
		// 持续时间
		public var duration : Number;
		// 完成后回调函数
		private var _onComplete : Function;

		public function run(onComplete : Function = null) : void
		{
			_onComplete = onComplete;

			target.x = appearPoint.x;
			target.y = appearPoint.y;
			target.scaleX = 0.3;
			target.scaleY = 0.3;

			TweenLite.to(target, duration, {scaleX:1, scaleY:1, ease:Sine.easeOut});
			TweenMax.to(target, duration, {delay:delay, bezierThrough:[{x:(target.x + endPoint.x) * 0.5, y:(target.y + endPoint.y) * 0.5 - 200}, {x:endPoint.x, y:endPoint.y}], ease:Sine.easeInOut, onComplete:onReachEnd});
		}

		private function onFlyToHover() : void
		{
			// setTimeout(onHoverToEnd, 1000);
			onHoverToEnd();
		}

		private function onHoverToEnd() : void
		{
			TweenMax.to(target, 0.6, {delay:delay, bezierThrough:[{x:endPoint.x, y:Math.min(target.y, endPoint.y)}, {x:endPoint.x, y:endPoint.y}], ease:Sine.easeIn, onComplete:onReachEnd});
		}

		private function onReachEnd() : void
		{
			if (_onComplete != null)
			{
				_onComplete(target);
			}
		}
	}
}
