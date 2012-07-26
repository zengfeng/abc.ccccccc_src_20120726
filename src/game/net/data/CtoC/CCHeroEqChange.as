package game.net.data.CtoC {
	/**
	 * 客户端内部通信   协议号0xFFF3
	 **/
	import com.protobuf.*;
	public dynamic final class CCHeroEqChange extends com.protobuf.Message {
		 /**
		  *@uuid   uuid
		  **/
		public var uuid:uint;

		public static const CMD:uint=0xFFF3;
	}
}
