package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x2F2
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.GEDrayData;
	public dynamic final class SCGEInfo extends com.protobuf.Message {
		 /**
		  *@status   status
		  **/
		public var status:uint;

		 /**
		  *@path   path
		  **/
		private var path$field:uint;

		private var hasField$0:uint = 0;

		public function removePath():void {
			hasField$0 &= 0xfffffffe;
			path$field = new uint();
		}

		public function get hasPath():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set path(value:uint):void {
			hasField$0 |= 0x1;
			path$field = value;
		}

		public function get path():uint {
			return path$field;
		}

		 /**
		  *@revtime   revtime
		  **/
		private var revtime$field:uint;

		public function removeRevtime():void {
			hasField$0 &= 0xfffffffd;
			revtime$field = new uint();
		}

		public function get hasRevtime():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set revtime(value:uint):void {
			hasField$0 |= 0x2;
			revtime$field = value;
		}

		public function get revtime():uint {
			return revtime$field;
		}

		 /**
		  *@drayList   drayList
		  **/
		public var drayList:Vector.<GEDrayData> = new Vector.<GEDrayData>();

		 /**
		  *@diePlayerList   diePlayerList
		  **/
		public var diePlayerList:Vector.<uint> = new Vector.<uint>();

		 /**
		  *@battlePlayerList   battlePlayerList
		  **/
		public var battlePlayerList:Vector.<uint> = new Vector.<uint>();

		 /**
		  *@battlePlayerPath   battlePlayerPath
		  **/
		public var battlePlayerPath:Vector.<uint> = new Vector.<uint>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var status$count:uint = 0;
			var path$count:uint = 0;
			var revtime$count:uint = 0;
			drayList = new Vector.<GEDrayData>();

			diePlayerList = new Vector.<uint>();

			battlePlayerList = new Vector.<uint>();

			battlePlayerPath = new Vector.<uint>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (status$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGEInfo.status cannot be set twice.');
					}
					++status$count;
					status = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (path$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGEInfo.path cannot be set twice.');
					}
					++path$count;
					path = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (revtime$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCGEInfo.revtime cannot be set twice.');
					}
					++revtime$count;
					revtime = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					drayList.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.GEDrayData()));
					break;
				case 5:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, diePlayerList);
						break;
					}
					diePlayerList.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				case 6:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, battlePlayerList);
						break;
					}
					battlePlayerList.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				case 7:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, battlePlayerPath);
						break;
					}
					battlePlayerPath.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
