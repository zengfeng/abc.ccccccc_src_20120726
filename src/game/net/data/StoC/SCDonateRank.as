package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x101
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCDonateRank extends com.protobuf.Message {
		 /**
		  *@count   count
		  **/
		public var count:uint;

		 /**
		  *@rank   rank
		  **/
		public var rank:uint;

		 /**
		  *@level   level
		  **/
		public var level:uint;

		 /**
		  *@donateCount   donateCount
		  **/
		public var donateCount:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var count$count:uint = 0;
			var rank$count:uint = 0;
			var level$count:uint = 0;
			var donateCount$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (count$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCDonateRank.count cannot be set twice.');
					}
					++count$count;
					count = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (rank$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCDonateRank.rank cannot be set twice.');
					}
					++rank$count;
					rank = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCDonateRank.level cannot be set twice.');
					}
					++level$count;
					level = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (donateCount$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCDonateRank.donateCount cannot be set twice.');
					}
					++donateCount$count;
					donateCount = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
