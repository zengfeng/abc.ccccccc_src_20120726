package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x1D
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCLearn extends com.protobuf.Message {
		 /**
		  *@id   id
		  **/
		public var id:uint;

		 /**
		  *@level   level
		  **/
		public var level:uint;

		 /**
		  *@position   position
		  **/
		public var position:Vector.<uint> = new Vector.<uint>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			var level$count:uint = 0;
			position = new Vector.<uint>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCLearn.id cannot be set twice.');
					}
					++id$count;
					id = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCLearn.level cannot be set twice.');
					}
					++level$count;
					level = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, position);
						break;
					}
					position.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
