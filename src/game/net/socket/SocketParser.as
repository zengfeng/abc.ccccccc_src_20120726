package game.net.socket {
	import com.protobuf.Message;
	import flash.utils.ByteArray;
	import game.net.core.Common;
	import game.net.core.RequestData;
	import gameui.manager.UIManager;
	import log4a.Logger;

	/**
	 * @author yangyiqiang
	 */
	public final class SocketParser{
		
		public function readObject(style : int) : void {
			switch(style) {
			}
		}

		public static function writeObject(outBuffer : ByteArray,msgCmd:uint, obj : Object) : void {
			if (!outBuffer) return;
			var style : int = getStyle(obj);
			outBuffer.writeShort(msgCmd);
			switch(style) {
				case 1:
				try{
					Message(obj)?Message(obj).writeTo(outBuffer):0;
					break;
				}catch (e : Error){
				}
				break;
			}
		}
		
		public static function parse(value : ByteArray) : RequestData
		{
			if (value == null)
			{
				return null;
			}
			var msgCmd : uint = value.readUnsignedShort();
			if (msgCmd != 32)
				Logger.debug("接收到==>msgCmd=0x" + msgCmd.toString(16));
			try
			{
				var _class : Message = new (UIManager.appDomain.getDefinition(Common.messageDic[msgCmd]) as Class) as Message;
			}
			catch(e : Error)
			{
				Logger.error("Request::parse解析消息出错！0x" + msgCmd.toString(16));
			}
			if (!_class) return null;
			_class.readFromSlice(value, 1);
			return new RequestData(msgCmd, _class);
		}

		private static function getStyle(obj : Object) : int {
			if(obj==null)return 0;
			if (obj is Message) {
				return 1;
			}else if(obj is int){
				return 2;
			}else if(obj is String){
				return 3;
			}
			return 0;
		}
	}
}
