package game.net.data.CtoC {
	/**
	 * 客户端内部通信   协议号0xFFF1
	 **/
	import com.protobuf.*;
	public dynamic final class CCUserDataChangeUp extends com.protobuf.Message {
		 /**
		  *@level   level
		  **/
		public var level:uint;

		 /**
		  *@oldLevel   oldLevel
		  **/
		public var oldLevel:uint;

		public static const CMD:uint=0xFFF1;
	}
}
