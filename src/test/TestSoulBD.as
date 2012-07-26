package test
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import game.core.item.config.ItemConfig;
	import game.core.item.soul.Soul;
	import game.module.soul.soulBD.SoulBD;
	import gameui.controls.GButton;
	import gameui.data.GButtonData;
	import project.Game;





	/**
	 * @author jian
	 */
	public class TestSoulBD extends Game
	{
		public function TestSoulBD()
		{
			super();
			
			addSoulBD();
		}
		
		private var _bd:SoulBD;
		
		private function addSoulBD():void
		{
			_bd = new SoulBD();
			var soul:Soul = new Soul();
			soul.config = new ItemConfig();
			
			_bd.x = 100;
			_bd.y = 100;
			_bd.source = soul;
			addChild(_bd);
			
			var button:GButton = new GButton(new GButtonData());
			button.text = "点我";
			button.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			addChild(button);

		}
		
		private function onMouseClick (event:MouseEvent):void
		{
			_centerX = 200;
			_centerY = 200;
			_targetX = 500;
			_targetY = 500;
			_radius = 150;
			_duration = 8 * 1000;
			_factor = 0.5;
			_rounds = 4;
			_startTime = getTimer();
			drawAxis();
			addEventListener(Event.ENTER_FRAME, circleMove);
		}
		
		private var _centerX:Number;
		private var _centerY:Number;
		private var _radius:Number;
		private var _duration:Number;
		private var _startTime:Number;
		private var _factor:Number;
		private var _targetX:Number;
		private var _targetY:Number;
		private var _rounds:Number;
		
		private function drawAxis ():void
		{
//			graphics.beginFill(0x601010);
			graphics.lineStyle(2, 0x601010);
			graphics.moveTo(_centerX - 200, _centerY);
			graphics.lineTo(_centerX + 200, _centerY);
			graphics.moveTo(_centerX, _centerY - 200);
			graphics.lineTo(_centerX, _centerY + 200);
		}
		
		private function circleMove (event:Event):void
		{
			var deltaTime:Number = getTimer()-_startTime;
			
			var ang:Number = Math.PI * 2 * deltaTime / _duration * _rounds;
			var rad:Number = _radius * (1 - deltaTime / _duration);
			
			if (rad < 0)
			{
				removeEventListener(Event.ENTER_FRAME, circleMove);
			}
			
			var pX:Number = _centerX + (_targetX - _centerX) * deltaTime/_duration;
			var pY:Number = _centerY + (_targetY - _centerY) * deltaTime/_duration;
			
			_bd.x = pX + rad * Math.sin(ang) - rad * 0.5 * Math.cos(ang);
			_bd.y = pY + rad * Math.cos(ang) * _factor;
			
		}
	}
}
