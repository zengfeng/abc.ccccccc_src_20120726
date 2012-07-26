package test
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import game.config.StaticConfig;
	import gameui.controls.GScrollBar;
	import gameui.data.GScrollBarData;
	import gameui.events.GScrollBarEvent;
	import net.LibData;
	import net.SWFLoader;
	import project.Game;

	/**
	 * @author Administrator
	 */
	public class TestGScrollBar extends Game
	{
		private var _bar : GScrollBar;

		private var _barData : GScrollBarData;
		
		private var _viewRect:Rectangle = new Rectangle();
		
		private var _bd:Sprite;

		override protected function initGame() : void
		{
			_res.add(new SWFLoader(new LibData(StaticConfig.cdnRoot + "assets/swf/ui.swf","ui")));
			_res.addEventListener(Event.COMPLETE, completeHandler);
			_res.startLoad();
		}

		private function completeHandler(event : Event) : void
		{
			addScrollBar();
			addEvent();
		}
		

		private function addScrollBar() : void
		{
			_viewRect.width=300;
			_viewRect.height=300;
			_bd=new Sprite();
			_bd.graphics.beginFill(0xffff00);
			_bd.graphics.drawRect(0, 0, 200, 50);
			_bd.graphics.endFill();
			_bd.graphics.beginFill(0xff0000);
			_bd.graphics.drawRect(0, 25, 200, 50);
			_bd.graphics.endFill();
			_bd.graphics.beginFill(0xff00ff);
			_bd.graphics.drawRect(0, 50, 200, 50);
			_bd.graphics.endFill();
			_bd.graphics.beginFill(0x0000ff);
			_bd.graphics.drawRect(0, 75, 200, 50);
			_bd.graphics.endFill();
//			addChild(_bd);
			_barData = new GScrollBarData();
			_barData.x=180;
			_barData.width=50;
			_barData.height=300;
			_bar = new GScrollBar(_barData);
			addChild(_bar);
			_bar.resetValue(10, 0, 10, 5);
			_bar.addEventListener(GScrollBarEvent.SCROLL, scrollHandler);
			this.scrollRect=_viewRect;
		}
		
		private function addEvent():void
		{
			this.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		private function onMouseWheel(event:MouseEvent) : void
		{
//			var delta:int=event.delta>0?10:-10;
//			_bar.scroll(delta);
//			_viewRect.y+=delta;
//			this.scrollRect=_viewRect;
//			//trace("event.delta===>"+_bar.position.y);
		}

		private function scrollHandler(event : GScrollBarEvent) : void
		{
			//trace(event.direction,event.delta,event.position);
		}

		public function TestGScrollBar()
		{
			super();
		}
	}
}
