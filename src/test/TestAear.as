package test
{
	import flash.events.Event;
	import flash.utils.getTimer;
	import framerate.SecondsTimer;
	import flash.display.Sprite;

	/**
	 * @author 1
	 */
	public class TestAear extends Sprite
	{
		private var _list : Vector.<mapMessage>=new Vector.<mapMessage>();

		public function TestAear()
		{
			init();
			this.addEventListener(Event.ENTER_FRAME, run);
		}

		private function init() : void
		{
			var map : mapMessage;
			for (var i : int = 0;i < 200000;i++)
			{
				map = new mapMessage();
				map.initPoint();
				_list.push(map);
			}
//			SecondsTimer.addFunction(run);
		}
		private var _time:int=0;
		private function run(event:Event) : void
		{
			_time=getTimer();
			for each(var message:mapMessage in _list ){
				message.math();
			}
//			for (var i : int = 0;i < 200000;i++)
//			{
//				_list[i].math();
//			}
			//trace(_time,getTimer(),(getTimer()-_time).toString());
		}
	}
}
import flash.display.Sprite;
class mapMessage extends Sprite
{
	private var _x : Number = 0;

	private var _y : Number = 0;

	private var _state : int = 0;

	public static const maxX : int = 1000;

	public static const maxY : int = 600;

	public function mapMessage()
	{
	}

	public function initPoint() : void
	{
		x=_x = Math.random() * 5000;
		y=_y = Math.random() * 5000;
		_state=Math.random()*1000%2;
		
	}
	
	public function math() : Boolean
	{
		x+=x*y/565646.0*Math.random();
		y+=x*y/565646.0*Math.random();
		if(_state)return false;
		if ((_x < mapMessage.maxX && _x > 0) || (_y < mapMessage.maxY && _y / 1000)) return false;
		if ((_x < mapMessage.maxX && _x > 0) || (_y < mapMessage.maxY && _y > 0)) return false;
		return true;
	}
}
