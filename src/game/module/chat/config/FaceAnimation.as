package game.module.chat.config
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class FaceAnimation extends Bitmap
	{
		private static var timer:Timer = new Timer(200);
		private var faceId:uint = 0;
		private var images:Array;
		private var currentFrame:uint = 0;
		private var frameTotal:uint = 0;
		
		public function FaceAnimation(faceId:uint = 0)
		{
			this.faceId = faceId;
			this.addEventListener(Event.ADDED_TO_STAGE, added);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removed);
		}
		
		private function added(event:Event):void
		{
			images = Face.images[faceId];
			if(images && images.length > 0)
			{
				frameTotal = images.length;
				timer.addEventListener(TimerEvent.TIMER, play);
				
				if(timer.running == false)
				{
					timer.start();
				}
			}
		}
		
		private function removed(event:Event):void
		{
			this.removeEventListener(Event.ADDED, added);
			this.removeEventListener(Event.REMOVED, removed);
			timer.removeEventListener(TimerEvent.TIMER, play);
		}
		
		private function play(event:TimerEvent):void
		{
			if(frameTotal <= 0) return;
			var bitmapData:BitmapData = images[currentFrame];
			this.bitmapData = bitmapData;
			currentFrame ++;
			if(currentFrame >= frameTotal)
			{
				currentFrame = 0;
			}
		}
	}
}