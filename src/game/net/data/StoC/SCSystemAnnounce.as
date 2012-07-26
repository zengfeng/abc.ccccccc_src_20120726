package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x97
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCSystemAnnounce extends com.protobuf.Message {
		 /**
		  *@content   content
		  **/
		public var content:String;

		 /**
		  *@type   type
		  **/
		private var type$field:uint;

		private var hasField$0:uint = 0;

		public function removeType():void {
			hasField$0 &= 0xfffffffe;
			type$field = new uint();
		}

		public function get hasType():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set type(value:uint):void {
			hasField$0 |= 0x1;
			type$field = value;
		}

		public function get type():uint {
			return type$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var content$count:uint = 0;
			var type$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (content$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCSystemAnnounce.content cannot be set twice.');
					}
					++content$count;
					content = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 2:
					if (type$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCSystemAnnounce.type cannot be set twice.');
					}
					++type$count;
					type = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
