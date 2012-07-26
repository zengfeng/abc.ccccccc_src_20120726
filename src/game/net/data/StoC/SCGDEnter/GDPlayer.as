package game.net.data.StoC.SCGDEnter {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class GDPlayer extends com.protobuf.Message {
		 /**
		  *@player   player
		  **/
		public var player:uint;

		 /**
		  *@color   color
		  **/
		public var color:uint;

		 /**
		  *@name   name
		  **/
		public var name:String;

		 /**
		  *@dmg   dmg
		  **/
		public var dmg:uint;

		 /**
		  *@state   state
		  **/
		public var state:uint;

		 /**
		  *@gold   gold
		  **/
		private var gold$field:uint;

		private var hasField$0:uint = 0;

		public function removeGold():void {
			hasField$0 &= 0xfffffffe;
			gold$field = new uint();
		}

		public function get hasGold():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set gold(value:uint):void {
			hasField$0 |= 0x1;
			gold$field = value;
		}

		public function get gold():uint {
			return gold$field;
		}

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, player);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 2);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, color);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 3);
			com.protobuf.WriteUtils.write$TYPE_STRING(output, name);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 4);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, dmg);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 5);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, state);
			if (hasGold) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 6);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, gold$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var player$count:uint = 0;
			var color$count:uint = 0;
			var name$count:uint = 0;
			var dmg$count:uint = 0;
			var state$count:uint = 0;
			var gold$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (player$count != 0) {
						throw new flash.errors.IOError('Bad data format: GDPlayer.player cannot be set twice.');
					}
					++player$count;
					player = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (color$count != 0) {
						throw new flash.errors.IOError('Bad data format: GDPlayer.color cannot be set twice.');
					}
					++color$count;
					color = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: GDPlayer.name cannot be set twice.');
					}
					++name$count;
					name = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (dmg$count != 0) {
						throw new flash.errors.IOError('Bad data format: GDPlayer.dmg cannot be set twice.');
					}
					++dmg$count;
					dmg = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (state$count != 0) {
						throw new flash.errors.IOError('Bad data format: GDPlayer.state cannot be set twice.');
					}
					++state$count;
					state = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (gold$count != 0) {
						throw new flash.errors.IOError('Bad data format: GDPlayer.gold cannot be set twice.');
					}
					++gold$count;
					gold = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
