package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x292
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCAbyssAward extends com.protobuf.Message {
		 /**
		  *@normal   normal
		  **/
		public var normal:uint;

		 /**
		  *@advanced   advanced
		  **/
		public var advanced:uint;

		 /**
		  *@boss   boss
		  **/
		public var boss:Vector.<uint> = new Vector.<uint>();

		 /**
		  *@awards   awards
		  **/
		public var awards:Vector.<uint> = new Vector.<uint>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var normal$count:uint = 0;
			var advanced$count:uint = 0;
			boss = new Vector.<uint>();

			awards = new Vector.<uint>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (normal$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCAbyssAward.normal cannot be set twice.');
					}
					++normal$count;
					normal = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (advanced$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCAbyssAward.advanced cannot be set twice.');
					}
					++advanced$count;
					advanced = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, boss);
						break;
					}
					boss.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				case 4:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, awards);
						break;
					}
					awards.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
