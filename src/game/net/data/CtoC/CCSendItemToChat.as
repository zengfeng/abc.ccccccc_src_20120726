package game.net.data.CtoC {
	/**
	 * 客户端内部通信   协议号0xFFF8
	 **/
	import com.protobuf.*;
	public dynamic final class CCSendItemToChat extends com.protobuf.Message {
		 /**
		  *@id   id
		  **/
		public var id:uint;

		 /**
		  *@name   name
		  **/
		public var name:String;

		 /**
		  *@color   color
		  **/
		public var color:uint;

		public static const CMD:uint=0xFFF8;
	}
}
