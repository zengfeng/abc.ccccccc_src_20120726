package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x1C
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCSetSquad extends com.protobuf.Message {
		 /**
		  *@formation   formation
		  **/
		public var formation:uint;

		 /**
		  *@heroId   heroId
		  **/
		public var heroId:uint;

		 /**
		  *@position   position
		  **/
		public var position:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var formation$count:uint = 0;
			var heroId$count:uint = 0;
			var position$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (formation$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCSetSquad.formation cannot be set twice.');
					}
					++formation$count;
					formation = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (heroId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCSetSquad.heroId cannot be set twice.');
					}
					++heroId$count;
					heroId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (position$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCSetSquad.position cannot be set twice.');
					}
					++position$count;
					position = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
