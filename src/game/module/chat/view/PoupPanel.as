package game.module.chat.view
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import gameui.containers.GPanel;
	import gameui.data.GPanelData;
	
	import net.AssetData;
	
	public class PoupPanel extends GPanel
	{
		/** 父级容器 */
		private var _parentContainer:DisplayObjectContainer;
		/** 是否打开 */
		private var _isOpen:Boolean = false;
		
		private var _globalPoint:Point;
		private var stageEndPoint:Point;
		public function PoupPanel(parentContainer:DisplayObjectContainer, globalPoint:Point, panelData:GPanelData = null)
		{
			_parentContainer = parentContainer;
			_globalPoint = globalPoint;
			if(panelData == null)
			{
				panelData = new GPanelData();
				panelData.bgAsset = new AssetData("GToolTip_backgroundSkin");
				panelData.width = 200;
				panelData.height = 150;
			}
				
			super(panelData);
			//初始化子组件
			installChild();
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
		}
		
		/** 初始化子组件 */
		protected function installChild():void
		{
		}
		
		/** 布局位置 */
		protected function layoutPostion():void
		{
			if(globalPoint)
			{
				this.x = globalPoint.x;
				this.y = globalPoint.y - this.height;
				
				if(stage)stageEndPoint = new Point(stage.stageWidth, stage.stageHeight);
			}
		}
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			event.stopPropagation();
		}
		
		protected function stage_mouseDownHandler(event:MouseEvent):void
		{
			isOpen = false;
		}
		
		protected function stage_resizeHandler(event:Event):void
		{
            if(stage == null) return;
//			globalPoint.x += stage.stageWidth - stageEndPoint.x;
			globalPoint.y += stage.stageHeight - stageEndPoint.y;
			layoutPostion();
		}
		
		
		
		/** 父级容器 */
		public function get parentContainer():DisplayObjectContainer
		{
			return _parentContainer;
		}

		/** 是否打开 */
		public function get isOpen():Boolean
		{
			return _isOpen;
		}

		/**
		 * @private
		 */
		public function set isOpen(value:Boolean):void
		{
			if(parentContainer == null) return;
			
			if(value == true)
			{
				if(this.parent == null)
				{
					layoutPostion();
					parentContainer.addChild(this);
					if(this.stage)
					{
						stageEndPoint = new Point(stage.stageWidth, stage.stageHeight);
						this.stage.addEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDownHandler);
						this.stage.addEventListener(Event.RESIZE, stage_resizeHandler);
					}
				}
			}
			else
			{
				if(this.parent != null)
				{
					this.stage.removeEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDownHandler);
					this.stage.addEventListener(Event.RESIZE, stage_resizeHandler);
					this.parent.removeChild(this);
				}
			}
			_isOpen = value;
		}

		public function get globalPoint():Point
		{
			return _globalPoint;
		}

		public function set globalPoint(value:Point):void
		{
			_globalPoint = value;
		}
		
		
	}
}