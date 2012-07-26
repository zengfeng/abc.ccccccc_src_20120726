package test
{
	import flash.utils.getTimer;
	import flash.events.Event;
	import flash.display.Sprite;

	/**
	 * @author jian
	 */
	public class TestEnterFrameRender extends Sprite
	{
		public function TestEnterFrameRender()
		{
			addEventListener(Event.ENTER_FRAME, eventHandler);
			addEventListener(Event.EXIT_FRAME, eventHandler);
			addEventListener(Event.RENDER, eventHandler);
			stage.invalidate();
		}
		
		private function eventHandler(event:Event):void
		{
			//trace("Event type: " + event.type + " at:" + getTimer());
			
			if (event.type == Event.ENTER_FRAME)
				stage.invalidate();
		}
	}
}
