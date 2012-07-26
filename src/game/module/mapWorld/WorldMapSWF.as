package game.module.mapWorld
{
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	public class WorldMapSWF extends Sprite 
	{
		public var leaveButton : DisplayObject;
		public var buttonDic : Dictionary = new Dictionary();
		public var button_1 : DisplayObject;
		public var button_2 : DisplayObject;
		public var button_3 : DisplayObject;
		public var button_4 : DisplayObject;
		public var button_5 : DisplayObject;
		public var button_6 : DisplayObject;
		public var button_20 : DisplayObject;
		public var standDic : Dictionary = new Dictionary();
		public var stand_1 : DisplayObject;
		public var stand_2 : DisplayObject;
		public var stand_3 : DisplayObject;
		public var stand_4 : DisplayObject;
		public var stand_5 : DisplayObject;
		public var stand_6 : DisplayObject;
		public var stand_20 : DisplayObject;

		public function WorldMapSWF()
		{
			buttonDic[1] = button_1;
			buttonDic[2] = button_2;
			buttonDic[3] = button_3;
			buttonDic[4] = button_4;
			buttonDic[5] = button_5;
			buttonDic[6] = button_6;
			buttonDic[20] = button_20;

			standDic[1] = stand_1;
			standDic[2] = stand_2;
			standDic[3] = stand_3;
			standDic[4] = stand_4;
			standDic[5] = stand_5;
			standDic[6] = stand_6;
			standDic[20] = stand_20;
			leaveButton.addEventListener(MouseEvent.CLICK, leaveButton_clickHandler);

			var button : DisplayObject;
			for each (button in  buttonDic)
			{
				button.addEventListener(MouseEvent.CLICK, mapBtnOnClick);
			}
			
			var stand:DisplayObject;
			for each (stand in  standDic)
			{
				stand.visible = false;
			}
		}

		/** 点击离开按钮 */
		private function leaveButton_clickHandler(event : MouseEvent) : void
		{
			if (leaveClickCall != null) leaveClickCall.apply();
		}

		/** 离开按钮回调 */
		private var _leaveClickCall : Function;

		public function get leaveClickCall() : Function
		{
			return _leaveClickCall;
		}

		public function set leaveClickCall(fun : Function) : void
		{
			_leaveClickCall = fun;
		}

		/** 去某个地图回调 */
		private var _toMapCall : Function;

		public function set toMapCall(fun : Function) : void
		{
			_toMapCall = fun;
		}

		public function get toMapCall() : Function
		{
			return _toMapCall;
		}

		/** 开放某个地图 */
		public function mapOn(mapId : int) : void
		{
			mapSwitch(mapId, true);
		}

		/** 封印某个地图 */
		public function mapOff(mapId : int) : void
		{
			mapSwitch(mapId, false);
		}

		private var mapOnOffDic : Dictionary = new Dictionary();

		/** 设置是否显示 */
		public function mapSwitch(mapId : int, on : Boolean) : void
		{
			if (mapOnOffDic[mapId] != null && mapOnOffDic[mapId] == on)
			{
				return;
			}

			mapOnOffDic[mapId] = on;
			// 获取开放地图图标
			var displayObject : DisplayObject = getbutton(mapId);
			if (displayObject == null) return;
			displayObject.visible = on;
		}

		private function mapBtnOnClick(event : MouseEvent) : void
		{
			var displayObject : DisplayObject = event.target as DisplayObject;
			var arr : Array = displayObject.name.split("_");
			var mapId : int = parseInt(arr[arr.length - 1]);
			if (toMapCall != null) toMapCall.apply(null, [mapId]);
		}

		/** 获取开放地图图标 */
		public function getbutton(mapId : int) : DisplayObject
		{
			return buttonDic[mapId];
		}

		/** 获取地图位置 */
		public function getMapPosition(mapId : int) : Point
		{
			var displayObject : DisplayObject = standDic[mapId];
			if (displayObject == null) return null;
			var point : Point = new Point(displayObject.x, displayObject.y);
			return point;
		}
	}
}
