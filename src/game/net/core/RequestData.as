package game.net.core {
	import gameui.manager.UIManager;

	import log4a.Logger;

	import com.protobuf.Message;

	import flash.utils.ByteArray;

	/**
	 */
	public class RequestData {
		private var _msgCmd : int;
		private var _args : *;

		public function RequestData(msgCmd : int, args : *) {
			_msgCmd = msgCmd;
			_args = args;
		}

		public function get method() : int {
			return _msgCmd;
		}

		public function get args() : * {
			return _args;
		}

		public function toString() : String {
			return "MsgCmd=" + _msgCmd + "ByteArray=" + String(_args);
		}

		public  function parse() : void {
			var value : ByteArray = _args as  ByteArray;
			if (!value) return;
			_msgCmd = value.readUnsignedShort();
			if (_msgCmd != 32)
				Logger.debug("接收到==>msgCmd=0x" + _msgCmd.toString(16));
			try {
				var _class : Message = new (UIManager.appDomain.getDefinition(Common.messageDic[_msgCmd]) as Class) as Message;
			} catch(e : Error) {
				Logger.error("Request::parse解析消息出错！0x" + _msgCmd.toString(16));
			}
			if (!_class) return ;
			_class.readFromSlice(value, 1);
			value.clear();
			_args = _class;
		}
	}
}
