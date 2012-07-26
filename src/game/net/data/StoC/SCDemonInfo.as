package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x88
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class SCDemonInfo extends com.protobuf.Message {
		 /**
		  *@openedDemon   openedDemon
		  **/
		public var openedDemon:uint;

		 /**
		  *@maxResetCount   maxResetCount
		  **/
		public var maxResetCount:uint;

		 /**
		  *@corpseId   corpseId
		  **/
		private var corpseId$field:uint;

		private var hasField$0:uint = 0;

		public function removeCorpseId():void {
			hasField$0 &= 0xfffffffe;
			corpseId$field = new uint();
		}

		public function get hasCorpseId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set corpseId(value:uint):void {
			hasField$0 |= 0x1;
			corpseId$field = value;
		}

		public function get corpseId():uint {
			return corpseId$field;
		}

		 /**
		  *@items   items
		  **/
		public var items:Vector.<uint> = new Vector.<uint>();

		 /**
		  *@progress   progress
		  **/
		public var progress:Vector.<uint> = new Vector.<uint>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var openedDemon$count:uint = 0;
			var maxResetCount$count:uint = 0;
			var corpseId$count:uint = 0;
			items = new Vector.<uint>();

			progress = new Vector.<uint>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (openedDemon$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCDemonInfo.openedDemon cannot be set twice.');
					}
					++openedDemon$count;
					openedDemon = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (maxResetCount$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCDemonInfo.maxResetCount cannot be set twice.');
					}
					++maxResetCount$count;
					maxResetCount = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (corpseId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCDemonInfo.corpseId cannot be set twice.');
					}
					++corpseId$count;
					corpseId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, items);
						break;
					}
					items.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				case 5:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, progress);
						break;
					}
					progress.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
