package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x22
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.PlayerPosition;
	public dynamic final class SCCityPlayers extends com.protobuf.Message {
		 /**
		  *@city_id   city_id
		  **/
		public var cityId:uint;

		 /**
		  *@my_x   my_x
		  **/
		public var myX:uint;

		 /**
		  *@my_y   my_y
		  **/
		public var myY:uint;

		 /**
		  *@players   players
		  **/
		public var players:Vector.<PlayerPosition> = new Vector.<PlayerPosition>();

		 /**
		  *@npcId   npcId
		  **/
		public var npcId:Vector.<uint> = new Vector.<uint>();

		 /**
		  *@model   model
		  **/
		public var model:uint;

		 /**
		  *@openBarriers   openBarriers
		  **/
		public var openBarriers:Vector.<uint> = new Vector.<uint>();

		 /**
		  *@cloth   cloth
		  **/
		public var cloth:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var city_id$count:uint = 0;
			var my_x$count:uint = 0;
			var my_y$count:uint = 0;
			players = new Vector.<PlayerPosition>();

			npcId = new Vector.<uint>();

			var model$count:uint = 0;
			openBarriers = new Vector.<uint>();

			var cloth$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (city_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCCityPlayers.cityId cannot be set twice.');
					}
					++city_id$count;
					cityId = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (my_x$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCCityPlayers.myX cannot be set twice.');
					}
					++my_x$count;
					myX = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (my_y$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCCityPlayers.myY cannot be set twice.');
					}
					++my_y$count;
					myY = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					players.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.PlayerPosition()));
					break;
				case 5:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, npcId);
						break;
					}
					npcId.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				case 7:
					if (model$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCCityPlayers.model cannot be set twice.');
					}
					++model$count;
					model = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 8:
					if ((tag & 7) == com.protobuf.WireType.LENGTH_DELIMITED) {
						com.protobuf.ReadUtils.readPackedRepeated(input, com.protobuf.ReadUtils.read$TYPE_UINT32, openBarriers);
						break;
					}
					openBarriers.push(com.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				case 9:
					if (cloth$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCCityPlayers.cloth cannot be set twice.');
					}
					++cloth$count;
					cloth = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
