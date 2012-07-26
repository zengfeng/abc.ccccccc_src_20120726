package game.module.mapConvoy
{
	import game.manager.SignalBusManager;
	import game.definition.ID;
	import game.manager.DailyInfoManager;
	import game.module.daily.DailyManage;

	import com.utils.ColorUtils;

	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 * @author ZengFeng (Email:zengfeng75[AT]163.com) 2012-3-7   ����5:29:22 
	 */
	public class ConvoyConfig
	{
		/** 香炉品质id 1 */
		public static const XIANG_LU_1 : int = 1;
		public static const XIANG_LU_2 : int = 2;
		public static const XIANG_LU_3 : int = 3;
		public static const XIANG_LU_4 : int = 4;
		private static var _xiangLuGoodsDic : Dictionary;

		public static function get xiangLuGoodsDic() : Dictionary
		{
			if (_xiangLuGoodsDic == null)
			{
				_xiangLuGoodsDic = new Dictionary();
				_xiangLuGoodsDic[XIANG_LU_1] = ID.XIANG_LU_1;
				_xiangLuGoodsDic[XIANG_LU_2] = ID.XIANG_LU_2;
				_xiangLuGoodsDic[XIANG_LU_3] = ID.XIANG_LU_3;
				_xiangLuGoodsDic[XIANG_LU_4] = ID.XIANG_LU_4;
			}
			return _xiangLuGoodsDic;
		}

		/** 加速的位置 */
		public static const SPEED_UP_MULTIPLE : Number = 5;
		/** 正常速度 */
		public static const NORMAL_SPEED : Number = 0.8;
		/** 加速的速度 */
		public static const FAST_SPEED : Number = 15;
		/** 路线总点数 */
		public static const WAY_POINT_COUNT : int = 4;
		/** 路线 */
		private static var _wayPointDic : Dictionary;

		/** 路线 */
		private static function get wayPointDic() : Dictionary
		{
			if (_wayPointDic == null)
			{
				_wayPointDic = new Dictionary();
				_wayPointDic[0] = new Point(5616, 3104);
				_wayPointDic[1] = new Point(3100, 2192);
				_wayPointDic[2] = new Point(1456, 3264);
				_wayPointDic[3] = new Point(4496, 4528);
				_wayPointDic[4] = new Point(6384, 3744);
			}
			return _wayPointDic;
		}

		/** 获取指定路线点 */
		public static function getWayPoint(pointId : int) : Point
		{
			return wayPointDic[pointId];
		}

		/** 路点名称 */
		private static var _wayPointNameDic : Dictionary;

		/** 路点名称 */
		private static function get wayPointNameDic() : Dictionary
		{
			if (_wayPointNameDic == null)
			{
				_wayPointNameDic = new Dictionary();
				_wayPointNameDic[0] = "接任务NPC";
				_wayPointNameDic[1] = "青龙神像";
				_wayPointNameDic[2] = "玄武神像";
				_wayPointNameDic[3] = "白虎神像";
				_wayPointNameDic[4] = "朱雀神像";
			}
			return _wayPointNameDic;
		}

		/** 获取指定路点名称 */
		public static function getWayPointNameDic(pointId : int) : String
		{
			return wayPointNameDic[pointId];
		}

		/** 仙龟Avatar */
		private static var _avatarDic : Dictionary;

		/** 仙龟Avatar */
		private static function get avatarDic() : Dictionary
		{
			if (_avatarDic == null)
			{
				_avatarDic = new Dictionary();
				_avatarDic[0] = 5012;
				_avatarDic[1] = 5012;
				_avatarDic[2] = 5012;
				_avatarDic[3] = 5012;
				_avatarDic[4] = 5012;
			}
			return _avatarDic;
		}

		/** 获取仙龟Avatar */
		public static function getAvatar(quality : int) : int
		{
			return avatarDic[quality];
		}

		/** 仙龟名称 */
		private static var _turtleNameDic : Dictionary;

		private static function get turtleNameDic() : Dictionary
		{
			if (_turtleNameDic == null)
			{
				_turtleNameDic = new Dictionary();
				_turtleNameDic[1] = "普通仙龟";
				_turtleNameDic[2] = "初级仙龟";
				_turtleNameDic[3] = "中级仙龟";
				_turtleNameDic[4] = "高级仙龟";
			}
			return _turtleNameDic;
		}

		public static function getTurtleName(quality : int) : String
		{
			return turtleNameDic[quality];
		}

		/** 品质颜色 */
		public static function getQualityColorStr(quality : int) : String
		{
			return ColorUtils.TEXTCOLOR[quality];
		}
		
		public static var convoyNum:int = 0;
		public static var attackNum:int = 0;
		public static function initNum():void
		{
			convoyNum = DailyInfoManager.instance.getDailyVar(DailyManage.ID_CONVOY,0);
			attackNum = DailyInfoManager.instance.getDailyVar(DailyManage.ID_CONVOY,1);
		}
		
		public static function setNum(convoyNum:int, attackNum:int):void
		{
			ConvoyConfig.convoyNum = convoyNum;
			ConvoyConfig.attackNum = attackNum;
			SignalBusManager.updateDaily.dispatch(DailyManage.ID_CONVOY, 2, convoyNum, attackNum);
		}
	}
}
