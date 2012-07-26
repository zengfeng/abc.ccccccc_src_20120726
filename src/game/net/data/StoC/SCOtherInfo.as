package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x14
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.SCOtherInfo.OtherHeroInfo;
	public dynamic final class SCOtherInfo extends com.protobuf.Message {
		 /**
		  *@name   name
		  **/
		public var name:String;

		 /**
		  *@level   level
		  **/
		public var level:uint;

		 /**
		  *@heroes   heroes
		  **/
		public var heroes:Vector.<OtherHeroInfo> = new Vector.<OtherHeroInfo>();

		 /**
		  *@formationId   formationId
		  **/
		public var formationId:uint;

		 /**
		  *@formationHeroes   formationHeroes
		  **/
		public var formationHeroes:Vector.<uint> = new Vector.<uint>();

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var name$count:uint = 0;
			var level$count:uint = 0;
			heroes = new Vector.<OtherHeroInfo>();

			var formationId$count:uint = 0;
			formationHeroes = new Vector.<uint>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCOtherInfo.name cannot be set twice.');
					}
					++name$count;
					name = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 2:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCOtherInfo.level cannot be set twice.');
					}
					++level$count;
					level = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					heroes.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.SCOtherInfo.OtherHeroInfo()));
					break;
				case 5:
					if (formationId$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCOtherInfo.formationId cannot be set twice.');
					}
					++formationId$count;
					formationId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, formationHeroes);
						break;
					}
					formationHeroes.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
