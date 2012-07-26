package game.net.data.CtoC {
	/**
	 * 客户端内部通信   协议号0xFFF6
	 **/
	import com.protobuf.*;
	public dynamic final class CCHeroLevelUp extends com.protobuf.Message {
		 /**
		  *@heroId   heroId
		  **/
		public var heroId:uint;

		 /**
		  *@level   level
		  **/
		public var level:uint;

		 /**
		  *@oldLevel   oldLevel
		  **/
		public var oldLevel:uint;

		public static const CMD:uint=0xFFF6;
	}
}
