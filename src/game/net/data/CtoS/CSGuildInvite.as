package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x2C8
	 **/
	import com.protobuf.*;
	public dynamic final class CSGuildInvite extends com.protobuf.Message {
		 /**
		  *@id   id
		  **/
		private var id$field:uint;

		private var hasField$0:uint = 0;

		public function removeId():void {
			hasField$0 &= 0xfffffffe;
			id$field = new uint();
		}

		public function get hasId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set id(value:uint):void {
			hasField$0 |= 0x1;
			id$field = value;
		}

		public function get id():uint {
			return id$field;
		}

		 /**
		  *@name   name
		  **/
		private var name$field:String;

		public function removeName():void {
			name$field = null;
		}

		public function get hasName():Boolean {
			return name$field != null;
		}

		public function set name(value:String):void {
			name$field = value;
		}

		public function get name():String {
			return name$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			if (hasId) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, id$field);
			}
			if (hasName) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.protobuf.WriteUtils.write$TYPE_STRING(output, name$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
