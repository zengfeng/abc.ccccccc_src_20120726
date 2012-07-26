/**
 *攻击表管理 
 */
package game.module.battle.battleData
{

	public class Area
	{
		public function Area(s:uint = 0)
		{
			_side = s;
		}
		public function getCount():int
		{
			return _data.length;
		}
		public function add(d:Data):void
		{
			_data.push(d);
		}
		public function setSide(s:uint):void
		{
			_side = s;
		}
		public function getSide():uint
		{
			return _side;
		}
		
		public function setType(t:Number):void
		{
			_type = t;
		}
		public function getType():Number
		{
			return _type;
		}
		
		public function getDataArray():Array
		{
			return _data;
		}
		private var _type:Number;                //种类：中毒，眩晕，。。。。
		private var _side:uint;    //边
		private var _data:Array = [];   
	}
}
