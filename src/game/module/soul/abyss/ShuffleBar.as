package game.module.soul.abyss
{
	import gameui.core.GComponent;
	import gameui.core.GComponentData;

	import com.greensock.TweenLite;
	import com.greensock.easing.Quint;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * @author jian
	 */
	public class ShuffleBar extends GComponent
	{
		private static const SHUFFLE_STEPS:uint = 5;
		private var _left : int;
		private var _size : int;
		
		public function get visibleChildren():Array
		{ 
			var children:Array = [];
			var min:Number = Math.max(0, numChildren - _left - _size);
			for (var index:int = numChildren -1 - _left; index >= min; index--)
			{
				children.push(getChildAt(index));
			}
			return children;
		}
		
		public function get allChildren():Array
		{
			var children:Array = [];
			for (var index:int = numChildren - 1; index >= 0 ; index--)
			{
				children.push(getChildAt(index));
			}
			return children;
		}

		public function ShuffleBar(size : int)
		{
			_size = size;
			_left = 0;

			super(new GComponentData());
		}

		public function shuffleLeft() : void
		{		
			if (_left + _size < numChildren)
			{
				_left += Math.min(SHUFFLE_STEPS, numChildren - _left - _size);
			}

			shuffle();
		}

		public function shuffleRight() : void
		{
			_left -= SHUFFLE_STEPS;
			
			if (_left < 0)
				_left = 0;

			shuffle();
		}

		public function shuffleLeftMost() : void
		{
			if (numChildren < _size)
				_left = 0;
			else
				_left = numChildren - _size;

			shuffle();
		}

		public function shuffleRightMost() : void
		{
			_left = 0;
			shuffle();
		}
		
		public function removeAllChild():void
		{
			for (var index:int = numChildren - 1; index >= 0 ; index--)
			{
				super.removeChildAt(index);
			}
		}

		public function get moreLeft() : Boolean
		{
			return _left > 0;
		}

		public function get moreRight() : Boolean
		{
			return _left + _size < numChildren;
		}

		public function shuffle() : void
		{
			var lastX : Number = 0;
			var lastY : Number = 0;
			var index : int;
			var child : DisplayObject;
			var maxHeight : Number = 0;
			var maxWidth : Number = 0;

			if (numChildren < _size)
				_left = 0;
			else if (_left + _size > numChildren )
				_left = numChildren - _size;

			//trace("LEFT " + _left);

			for (index = numChildren - 1 - _left; index >= 0 ; index--)
			{
				child = getChildAt(index);
				//trace("index " + index);

				if (child.x != lastX || child.y != lastY)
					TweenLite.to(child, 0.4, {x:lastX, y:lastY, ease:Quint.easeOut});

				lastX += child.width;

				if (numChildren - _left - index <= _size)
				{
					maxHeight = Math.max(maxHeight, child.height);
					maxWidth = lastX;
				}
			}
			


			scrollRect = new Rectangle(0, 0, maxWidth, maxHeight);
			width = maxWidth;
			height = maxHeight;

			lastX = 0;
			lastY = 0;

			for (index = numChildren - _left; index < numChildren ; index++)
			{
				child = getChildAt(index);

				//trace("index " + index);

				lastX -= child.width;

				if (child.x != lastX || child.y != lastY)
					TweenLite.to(child, 0.4, {x:lastX, y:lastY, ease:Quint.easeOut});
			}
			
			var e : Event = new Event(Event.RESIZE);
			dispatchEvent(e);
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			var ret:DisplayObject = super.addChild(child);
			child.addEventListener(MouseEvent.CLICK, cell_clickHandler);
			
			return ret;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			var ret:DisplayObject = super.removeChild(child);
			child.removeEventListener(MouseEvent.CLICK, cell_clickHandler);
			
			return ret;
		}
		
		override protected function onShow() : void
		{
			for (var index : int = numChildren - 1; index >= 0; index--)
			{
				getChildAt(index).addEventListener(MouseEvent.CLICK, cell_clickHandler, true);
			}
		}

		override protected function onHide() : void
		{
			for (var index : int = numChildren - 1; index >= 0; index--)
			{
				getChildAt(index).removeEventListener(MouseEvent.CLICK, cell_clickHandler, true);
			}
		}

		private function cell_clickHandler(event : MouseEvent) : void
		{
			var e : ShuffleBarEvent = new ShuffleBarEvent(ShuffleBarEvent.SELECT);
			e.cell = event.currentTarget as DisplayObject;
			dispatchEvent(e);
		}
	}
}
