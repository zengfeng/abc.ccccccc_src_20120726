package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x301
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCFeastStatus extends com.protobuf.Message {
		 /**
		  *@status   status
		  **/
		public var status:uint;

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

		 /**
		  *@color   color
		  **/
		private var color$field:uint;

		public function removeColor():void {
			hasField$0 &= 0xfffffffd;
			color$field = new uint();
		}

		public function get hasColor():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set color(value:uint):void {
			hasField$0 |= 0x2;
			color$field = value;
		}

		public function get color():uint {
			return color$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var status$count:uint = 0;
			var id$count:uint = 0;
			var name$count:uint = 0;
			var color$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (status$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCFeastStatus.status cannot be set twice.');
					}
					++status$count;
					status = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCFeastStatus.id cannot be set twice.');
					}
					++id$count;
					id = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCFeastStatus.name cannot be set twice.');
					}
					++name$count;
					name = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (color$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCFeastStatus.color cannot be set twice.');
					}
					++color$count;
					color = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
