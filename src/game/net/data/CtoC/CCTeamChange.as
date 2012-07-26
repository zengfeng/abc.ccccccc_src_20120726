package game.net.data.CtoC {
	/**
	 * 客户端内部通信   协议号0xFFF4
	 **/
	import com.protobuf.*;
	public dynamic final class CCTeamChange extends com.protobuf.Message {
		 /**
		  *@uuid   uuid
		  **/
		public var uuid:uint;

		 /**
		  *@type   type
		  **/
		public var type:uint;

		public static const CMD:uint=0xFFF4;
	}
}
