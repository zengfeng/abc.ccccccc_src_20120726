package game.net.data.StoC {
	import com.protobuf.*;
	import flash.utils.IDataInput;
	import flash.errors.IOError;
	import game.net.data.StoC.GuildMember;
	public dynamic final class GuildInfo extends com.protobuf.Message {
		 /**
		  *@id   id
		  **/
		public var id:uint;

		 /**
		  *@name   name
		  **/
		public var name:String;

		 /**
		  *@exp   exp
		  **/
		public var exp:uint;

		 /**
		  *@seq   seq
		  **/
		public var seq:uint;

		 /**
		  *@leader   leader
		  **/
		private var leader$field:uint;

		private var hasField$0:uint = 0;

		public function removeLeader():void {
			hasField$0 &= 0xfffffffe;
			leader$field = new uint();
		}

		public function get hasLeader():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set leader(value:uint):void {
			hasField$0 |= 0x1;
			leader$field = value;
		}

		public function get leader():uint {
			return leader$field;
		}

		 /**
		  *@vice   vice
		  **/
		private var vice$field:uint;

		public function removeVice():void {
			hasField$0 &= 0xfffffffd;
			vice$field = new uint();
		}

		public function get hasVice():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set vice(value:uint):void {
			hasField$0 |= 0x2;
			vice$field = value;
		}

		public function get vice():uint {
			return vice$field;
		}

		 /**
		  *@announce   announce
		  **/
		private var announce$field:String;

		public function removeAnnounce():void {
			announce$field = null;
		}

		public function get hasAnnounce():Boolean {
			return announce$field != null;
		}

		public function set announce(value:String):void {
			announce$field = value;
		}

		public function get announce():String {
			return announce$field;
		}

		 /**
		  *@intro   intro
		  **/
		private var intro$field:String;

		public function removeIntro():void {
			intro$field = null;
		}

		public function get hasIntro():Boolean {
			return intro$field != null;
		}

		public function set intro(value:String):void {
			intro$field = value;
		}

		public function get intro():String {
			return intro$field;
		}

		 /**
		  *@apply   apply
		  **/
		private var apply$field:Boolean;

		public function removeApply():void {
			hasField$0 &= 0xfffffffb;
			apply$field = new Boolean();
		}

		public function get hasApply():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set apply(value:Boolean):void {
			hasField$0 |= 0x4;
			apply$field = value;
		}

		public function get apply():Boolean {
			return apply$field;
		}

		 /**
		  *@action   action
		  **/
		private var action$field:uint;

		public function removeAction():void {
			hasField$0 &= 0xfffffff7;
			action$field = new uint();
		}

		public function get hasAction():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set action(value:uint):void {
			hasField$0 |= 0x8;
			action$field = value;
		}

		public function get action():uint {
			return action$field;
		}

		 /**
		  *@actionconfig   actionconfig
		  **/
		private var actionconfig$field:uint;

		public function removeActionconfig():void {
			hasField$0 &= 0xffffffef;
			actionconfig$field = new uint();
		}

		public function get hasActionconfig():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set actionconfig(value:uint):void {
			hasField$0 |= 0x10;
			actionconfig$field = value;
		}

		public function get actionconfig():uint {
			return actionconfig$field;
		}

		 /**
		  *@actionremain   actionremain
		  **/
		private var actionremain$field:uint;

		public function removeActionremain():void {
			hasField$0 &= 0xffffffdf;
			actionremain$field = new uint();
		}

		public function get hasActionremain():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set actionremain(value:uint):void {
			hasField$0 |= 0x20;
			actionremain$field = value;
		}

		public function get actionremain():uint {
			return actionremain$field;
		}

		 /**
		  *@status   status
		  **/
		private var status$field:uint;

		public function removeStatus():void {
			hasField$0 &= 0xffffffbf;
			status$field = new uint();
		}

		public function get hasStatus():Boolean {
			return (hasField$0 & 0x40) != 0;
		}

		public function set status(value:uint):void {
			hasField$0 |= 0x40;
			status$field = value;
		}

		public function get status():uint {
			return status$field;
		}

		 /**
		  *@cause   cause
		  **/
		private var cause$field:uint;

		public function removeCause():void {
			hasField$0 &= 0xffffff7f;
			cause$field = new uint();
		}

		public function get hasCause():Boolean {
			return (hasField$0 & 0x80) != 0;
		}

		public function set cause(value:uint):void {
			hasField$0 |= 0x80;
			cause$field = value;
		}

		public function get cause():uint {
			return cause$field;
		}

		 /**
		  *@member   member
		  **/
		public var member:Vector.<GuildMember> = new Vector.<GuildMember>();

		
		override public final function writeToBuffer(output:com.protobuf.WritingBuffer):void {
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 1);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, id);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.protobuf.WriteUtils.write$TYPE_STRING(output, name);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 3);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, exp);
			com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 4);
			com.protobuf.WriteUtils.write$TYPE_UINT32(output, seq);
			if (hasLeader) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 5);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, leader$field);
			}
			if (hasVice) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 6);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, vice$field);
			}
			if (hasAnnounce) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 7);
				com.protobuf.WriteUtils.write$TYPE_STRING(output, announce$field);
			}
			if (hasIntro) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 8);
				com.protobuf.WriteUtils.write$TYPE_STRING(output, intro$field);
			}
			if (hasApply) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 9);
				com.protobuf.WriteUtils.write$TYPE_BOOL(output, apply$field);
			}
			if (hasAction) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 10);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, action$field);
			}
			if (hasActionconfig) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 11);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, actionconfig$field);
			}
			if (hasActionremain) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 12);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, actionremain$field);
			}
			if (hasStatus) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 13);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, status$field);
			}
			if (hasCause) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.VARINT, 14);
				com.protobuf.WriteUtils.write$TYPE_UINT32(output, cause$field);
			}
			for (var memberIndex:uint = 0; memberIndex < member.length; ++memberIndex) {
				com.protobuf.WriteUtils.writeTag(output, com.protobuf.WireType.LENGTH_DELIMITED, 15);
				com.protobuf.WriteUtils.write$TYPE_MESSAGE(output, member[memberIndex]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			var name$count:uint = 0;
			var exp$count:uint = 0;
			var seq$count:uint = 0;
			var leader$count:uint = 0;
			var vice$count:uint = 0;
			var announce$count:uint = 0;
			var intro$count:uint = 0;
			var apply$count:uint = 0;
			var action$count:uint = 0;
			var actionconfig$count:uint = 0;
			var actionremain$count:uint = 0;
			var status$count:uint = 0;
			var cause$count:uint = 0;
			member = new Vector.<GuildMember>();

			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildInfo.id cannot be set twice.');
					}
					++id$count;
					id = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildInfo.name cannot be set twice.');
					}
					++name$count;
					name = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (exp$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildInfo.exp cannot be set twice.');
					}
					++exp$count;
					exp = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 4:
					if (seq$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildInfo.seq cannot be set twice.');
					}
					++seq$count;
					seq = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 5:
					if (leader$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildInfo.leader cannot be set twice.');
					}
					++leader$count;
					leader = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 6:
					if (vice$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildInfo.vice cannot be set twice.');
					}
					++vice$count;
					vice = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 7:
					if (announce$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildInfo.announce cannot be set twice.');
					}
					++announce$count;
					announce = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 8:
					if (intro$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildInfo.intro cannot be set twice.');
					}
					++intro$count;
					intro = com.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 9:
					if (apply$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildInfo.apply cannot be set twice.');
					}
					++apply$count;
					apply = com.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 10:
					if (action$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildInfo.action cannot be set twice.');
					}
					++action$count;
					action = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 11:
					if (actionconfig$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildInfo.actionconfig cannot be set twice.');
					}
					++actionconfig$count;
					actionconfig = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 12:
					if (actionremain$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildInfo.actionremain cannot be set twice.');
					}
					++actionremain$count;
					actionremain = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 13:
					if (status$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildInfo.status cannot be set twice.');
					}
					++status$count;
					status = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 14:
					if (cause$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildInfo.cause cannot be set twice.');
					}
					++cause$count;
					cause = com.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 15:
					member.push(com.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new game.net.data.StoC.GuildMember()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
