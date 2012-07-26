package game.net.data.CtoC {
	/**
	 * 客户端内部通信   协议号0xFFF5
	 **/
	import com.protobuf.*;
	public dynamic final class CCHeroPanelOpen extends com.protobuf.Message {
		 /**
		  *@status   status
		  **/
		public var status:Boolean;

		public static const CMD:uint=0xFFF5;
	}
}
