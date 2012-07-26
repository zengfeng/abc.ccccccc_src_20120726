package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x01
	 **/
	import com.protobuf.*;
	public dynamic final class CSUserRegister extends com.protobuf.Message {
		 /**
		  *@id   id
		  **/
		public var id:String;

		 /**
		  *@isMale   isMale
		  **/
		public var isMale:Boolean;

		 /**
		  *@job   job
		  **/
		public var job:uint;

		 /**
		  *@name   name
		  **/
		public var name:String;

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
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_BOOL(output, isMale);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, job);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 4);
			com.protobuf.WriteUtils.write$TYPE_STRING(output, name);
			if (hasWallow) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 5);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, wallow$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
