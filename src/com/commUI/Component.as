package com.commUI
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * @author jian
	 */
	public class Component extends Sprite
	{
		public function Component ()
		{
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		}
		
		private function addToStageHandler(event : Event) : void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			onShow();
		}

		private function removeFromStageHandler(event : Event) : void
		{
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			onHide();
		}
		
		protected function onShow():void
		{
			// abstract	
		}
		
		protected function onHide():void
		{
			// abstract
		}		
		
	}
}
