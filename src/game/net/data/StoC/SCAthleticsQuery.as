package game.net.data.StoC {
	/**
	 * Server to Client 协议号0x1A0
	 **/
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.SCAthleticsQuery.AthleticsPlayer;
	public dynamic final class SCAthleticsQuery extends com.protobuf.Message {
		 /**
		  *@players   players
		  **/
		public var players:Vector.<AthleticsPlayer> = new Vector.<AthleticsPlayer>();

		 /**
		  *@myRank   myRank
		  **/
		public var myRank:uint;

		 /**
		  *@todayCountLeft   todayCountLeft
		  **/
		public var todayCountLeft:uint;

		 /**
		  *@winStreak   winStreak
		  **/
		public var winStreak:uint;

		 /**
		  *@honorGot   honorGot
		  **/
		public var honorGot:uint;

		 /**
		  *@honorTotal   honorTotal
		  **/
		public var honorTotal:uint;

		 /**
		  *@silverGot   silverGot
		  **/
		public var silverGot:uint;

		 /**
		  *@silverTotal   silverTotal
		  **/
		public var silverTotal:uint;

		 /**
		  *@bestRank   bestRank
		  **/
		public var bestRank:uint;

		 /**
		  *@nextRewardTime   nextRewardTime
		  **/
		public var nextRewardTime:uint;

		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			players = new Vector.<AthleticsPlayer>();

			var myRank$count:uint = 0;
			var todayCountLeft$count:uint = 0;
			var winStreak$count:uint = 0;
			var honorGot$count:uint = 0;
			var honorTotal$count:uint = 0;
			var silverGot$count:uint = 0;
			var silverTotal$count:uint = 0;
			var bestRank$count:uint = 0;
			var nextRewardTime$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					players.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.SCAthleticsQuery.AthleticsPlayer()));
					break;
				case 2:
					if (myRank$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCAthleticsQuery.myRank cannot be set twice.');
					}
					++myRank$count;
					myRank = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 3:
					if (todayCountLeft$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCAthleticsQuery.todayCountLeft cannot be set twice.');
					}
					++todayCountLeft$count;
					todayCountLeft = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (winStreak$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCAthleticsQuery.winStreak cannot be set twice.');
					}
					++winStreak$count;
					winStreak = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 7:
					if (honorGot$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCAthleticsQuery.honorGot cannot be set twice.');
					}
					++honorGot$count;
					honorGot = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 8:
					if (honorTotal$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCAthleticsQuery.honorTotal cannot be set twice.');
					}
					++honorTotal$count;
					honorTotal = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 9:
					if (silverGot$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCAthleticsQuery.silverGot cannot be set twice.');
					}
					++silverGot$count;
					silverGot = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 10:
					if (silverTotal$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCAthleticsQuery.silverTotal cannot be set twice.');
					}
					++silverTotal$count;
					silverTotal = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 11:
					if (bestRank$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCAthleticsQuery.bestRank cannot be set twice.');
					}
					++bestRank$count;
					bestRank = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 12:
					if (nextRewardTime$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCAthleticsQuery.nextRewardTime cannot be set twice.');
					}
					++nextRewardTime$count;
					nextRewardTime = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
