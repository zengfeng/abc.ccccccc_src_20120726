package game.module.chat.view
{
    import com.utils.FilterUtils;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import game.module.chat.config.FaceAnimation;


	
	public class FaceItem extends Sprite
	{
		private var _faceId:uint = 0;
		public function FaceItem(faceId:uint)
		{
			_faceId = faceId;
			this.buttonMode = true;
			this.mouseChildren = true;
			
			var faceAnimation:FaceAnimation = new FaceAnimation(_faceId);
			if(faceAnimation)
			{
				addChild(faceAnimation);
			}
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}
		
		private function mouseOverHandler(event:MouseEvent):void
		{
			this.filters = [FilterUtils.defaultHightLightFilter];
		}
		
		private function mouseOutHandler(event:MouseEvent):void
		{
			this.filters = [];
		}
		
		public function get faceId():uint
		{
			return _faceId;
		}
	}
}