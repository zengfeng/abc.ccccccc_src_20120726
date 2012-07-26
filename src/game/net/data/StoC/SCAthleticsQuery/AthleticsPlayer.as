package game.net.data.StoC.SCAthleticsQuery {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	public dynamic final class AthleticsPlayer extends com.protobuf.Message {
		 /**
		  *@rank   rank
		  **/
		public var rank:uint;

		 /**
		  *@name   name
		  **/
		public var name:String;

		 /**
		  *@color   color
		  **/
		public var color:uint;

		 /**
		  *@job   job
		  **/
		public var job:uint;

		 /**
		  *@level   level
		  **/
		public var level:uint;

		 /**
		  *@battlePoints   battlePoints
		  **/
		public var battlePoints:uint;

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, rank);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.protobuf.WriteUtils.write$TYPE_STRING(output, name);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, color);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 4);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, job);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 5);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, level);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 6);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, battlePoints);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var rank$count:uint = 0;
			var name$count:uint = 0;
			var color$count:uint = 0;
			var job$count:uint = 0;
			var level$count:uint = 0;
			var battlePoints$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (rank$count != 0) {
						throw new flash.errors.IOError('Bad data format: AthleticsPlayer.rank cannot be set twice.');
					}
					++rank$count;
					rank = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: AthleticsPlayer.name cannot be set twice.');
					}
					++name$count;
					name = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (color$count != 0) {
						throw new flash.errors.IOError('Bad data format: AthleticsPlayer.color cannot be set twice.');
					}
					++color$count;
					color = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (job$count != 0) {
						throw new flash.errors.IOError('Bad data format: AthleticsPlayer.job cannot be set twice.');
					}
					++job$count;
					job = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: AthleticsPlayer.level cannot be set twice.');
					}
					++level$count;
					level = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (battlePoints$count != 0) {
						throw new flash.errors.IOError('Bad data format: AthleticsPlayer.battlePoints cannot be set twice.');
					}
					++battlePoints$count;
					battlePoints = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
