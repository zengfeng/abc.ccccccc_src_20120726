package game.net.data.CtoS {
	/**
	 * Client to Server  协议号0x4A
	 **/
	import com.protobuf.*;
	public dynamic final class CSUnblock extends com.protobuf.Message {
		 /**
		  *@blockId   blockId
		  **/
		private var blockId$field:uint;

		private var hasField$0:uint = 0;

		public function removeBlockId():void {
			hasField$0 &= 0xfffffffe;
			blockId$field = new uint();
		}

		public function get hasBlockId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set blockId(value:uint):void {
			hasField$0 |= 0x1;
			blockId$field = value;
		}

		public function get blockId():uint {
			return blockId$field;
		}

		 /**
		  *@blockName   blockName
		  **/
		private var blockName$field:String;

		public function removeBlockName():void {
			blockName$field = null;
		}

		public function get hasBlockName():Boolean {
			return blockName$field != null;
		}

		public function set blockName(value:String):void {
			blockName$field = value;
		}

		public function get blockName():String {
			return blockName$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			if (hasBlockId) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, blockId$field);
			}
			if (hasBlockName) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.protobuf.WriteUtils.write$TYPE_STRING(output, blockName$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
	}
}
