package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x29
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCHeroPotential extends com.protobuf.Message {
		 /**
		  *@heroID   heroID
		  **/
		public var heroID:uint;

		 /**
		  *@result   result
		  **/
		public var result:Boolean;

		 /**
		  *@potential   potential
		  **/
		private var potential$field:uint;

		private var hasField$0:uint = 0;

		public function removePotential():void {
			hasField$0 &= 0xfffffffe;
			potential$field = new uint();
		}

		public function get hasPotential():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set potential(value:uint):void {
			hasField$0 |= 0x1;
			potential$field = value;
		}

		public function get potential():uint {
			return potential$field;
		}

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var heroID$count:uint = 0;
			var result$count:uint = 0;
			var potential$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (heroID$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCHeroPotential.heroID cannot be set twice.');
					}
					++heroID$count;
					heroID = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (result$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCHeroPotential.result cannot be set twice.');
					}
					++result$count;
					result = com.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 3:
					if (potential$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCHeroPotential.potential cannot be set twice.');
					}
					++potential$count;
					potential = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
