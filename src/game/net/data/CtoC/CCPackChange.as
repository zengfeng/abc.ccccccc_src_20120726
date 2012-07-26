package game.net.data.CtoC {
	/**
	 * 客户端内部通信   协议号0xFFF2
	 **/
	import com.protobuf.*;
	public dynamic final class CCPackChange extends com.protobuf.Message {
		 /**
		  *@topType   topType
		  **/
		public var topType:uint;

		public static const CMD:uint=0xFFF2;
	}
}
