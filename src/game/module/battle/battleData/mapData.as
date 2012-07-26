package game.module.battle.battleData
{
	public class mapData
	{		
		public var mapId:uint;  //地图id
		public var type:uint;   //配置类型
		public var urlStr:String; //url地址
		public var pointX:uint; //x坐标
		public var pointY:uint; //y坐标
		
		public function mapData(mapId:uint, type:uint, urlStr:String, pointX:uint, pointY:uint)
		{
			this.mapId = mapId;
			this.type = type;
			this.urlStr = urlStr;
			this.pointX = pointX;
			this.pointY = pointY;
		}
	}
}