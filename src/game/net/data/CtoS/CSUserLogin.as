package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x02
	 **/
	import com.protobuf.*;
	public dynamic final class CSUserLogin extends com.protobuf.Message {
		 /**
		  *@id   id
		  **/
		public var id:String;

		 /**
		  *@key   key
		  **/
		private var key$field:String;

		public function removeKey():void {
			key$field = null;
		}

		public function get hasKey():Boolean {
			return key$field != null;
		}

		public function set key(value:String):void {
			key$field = value;
		}

		public function get key():String {
			return key$field;
		}

		 /**
		  *@wallow   wallow
		  **/
		private var wallow$field:uint;

		private var hasField$0:uint = 0;

		public function removeWallow():void {
			hasField$0 &= 0xfffffffe;
			wallow$field = new uint();
		}

		public function get hasWallow():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set wallow(value:uint):void {
			hasField$0 |= 0x1;
			wallow$field = value;
		}

		public function get wallow():uint {
			return wallow$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.protobuf.WriteUtils.write$TYPE_STRING(output, id);
			if (hasKey) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.protobuf.WriteUtils.write$TYPE_STRING(output, key$field);
			}
			if (hasWallow) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, wallow$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
