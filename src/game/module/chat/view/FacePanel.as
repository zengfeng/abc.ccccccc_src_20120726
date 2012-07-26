package game.module.chat.view
{
    import flash.display.DisplayObjectContainer;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import game.module.chat.EventChat;
    import game.module.chat.config.Face;
    import gameui.data.GPanelData;
    import net.AssetData;



	
	public class FacePanel extends PoupPanel
	{
		
		/** 列数 */
		private var _columnCount:uint = 8;
		/** 横间距 */
		private var _hGap:uint = 10;
		/** 竖间距 */
		private var _vGap:uint = 10;
		/** 边距 */
		private var _padding:uint = 10;
		private var _itemWidth:uint = 23;
		private var _itemHeight:uint = 23;
		
		public function FacePanel(parentContainer:DisplayObjectContainer, globalPoint:Point, panelData:GPanelData = null)
		{
			if(panelData == null)
			{
				panelData = new GPanelData();
				panelData.bgAsset = new AssetData("GToolTip_backgroundSkin");
				panelData.width = 200;
				panelData.height = 150;
			}
			super(parentContainer, globalPoint);
		}
		
		/** 初始化子组件 */
		override protected function installChild():void
		{
			var arr:Array = Face.images;
			var u:uint = 0;
			var v:uint = 0;
			for(var i:int = 0; i < arr.length; i++)
			{
				u = i % _columnCount;
				v = int(i / _columnCount);
				var item:FaceItem = new FaceItem(i);
				item.x = _padding + (_itemWidth + _hGap) * u ;
				item.y = _padding + (_itemHeight + _vGap) * v;
				item.addEventListener(MouseEvent.MOUSE_DOWN, item_mouseDownHandler);
				add(item);
			}
			
			this.width = (_itemWidth + _hGap) * (_columnCount) + _padding * 2 - _hGap;
			this.height = (_itemHeight + _vGap) * (v + 1) + _padding * 2 - _vGap;
		}
		
		
		private function item_mouseDownHandler(event:MouseEvent):void
		{
			var eventChat:EventChat = new EventChat(EventChat.SELECTED_FACE, true);
			var item:FaceItem = event.target as FaceItem;
			if(item)
			{
				eventChat.faceId = item.faceId;
				dispatchEvent(eventChat);
				isOpen = false;
			}
		}
	}
}