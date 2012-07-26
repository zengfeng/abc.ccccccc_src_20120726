package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x02
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCUserLogin extends com.protobuf.Message {
		 /**
		  *@result   result
		  **/
		public var result:uint;

		 /**
		  *@playerId   playerId
		  **/
		private var playerId$field:uint;

		private var hasField$0:uint = 0;

		public function removePlayerId():void {
			hasField$0 &= 0xfffffffe;
			playerId$field = new uint();
		}

		public function get hasPlayerId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set playerId(value:uint):void {
			hasField$0 |= 0x1;
			playerId$field = value;
		}

		public function get playerId():uint {
			return playerId$field;
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
		  *@vipLevel   vipLevel
		  **/
		private var vipLevel$field:uint;

		public function removeVipLevel():void {
			hasField$0 &= 0xfffffffd;
			vipLevel$field = new uint();
		}

		public function get hasVipLevel():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set vipLevel(value:uint):void {
			hasField$0 |= 0x2;
			vipLevel$field = value;
		}

		public function get vipLevel():uint {
			return vipLevel$field;
		}

		 /**
		  *@banTime   banTime
		  **/
		private var banTime$field:uint;

		public function removeBanTime():void {
			hasField$0 &= 0xfffffffb;
			banTime$field = new uint();
		}

		public function get hasBanTime():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set banTime(value:uint):void {
			hasField$0 |= 0x4;
			banTime$field = value;
		}

		public function get banTime():uint {
			return banTime$field;
		}

		 /**
		  *@mapId   mapId
		  **/
		private var mapId$field:uint;

		public function removeMapId():void {
			hasField$0 &= 0xfffffff7;
			mapId$field = new uint();
		}

		public function get hasMapId():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set mapId(value:uint):void {
			hasField$0 |= 0x8;
			mapId$field = value;
		}

		public function get mapId():uint {
			return mapId$field;
		}

		 /**
		  *@steps   steps
		  **/
		public var steps:Vector.<uint> = new Vector.<uint>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var result$count:uint = 0;
			var playerId$count:uint = 0;
			var name$count:uint = 0;
			var vipLevel$count:uint = 0;
			var banTime$count:uint = 0;
			var mapId$count:uint = 0;
			steps = new Vector.<uint>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (result$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCUserLogin.result cannot be set twice.');
					}
					++result$count;
					result = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (playerId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCUserLogin.playerId cannot be set twice.');
					}
					++playerId$count;
					playerId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCUserLogin.name cannot be set twice.');
					}
					++name$count;
					name = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (vipLevel$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCUserLogin.vipLevel cannot be set twice.');
					}
					++vipLevel$count;
					vipLevel = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (banTime$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCUserLogin.banTime cannot be set twice.');
					}
					++banTime$count;
					banTime = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (mapId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCUserLogin.mapId cannot be set twice.');
					}
					++mapId$count;
					mapId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 7:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, steps);
						break;
					}
					steps.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
