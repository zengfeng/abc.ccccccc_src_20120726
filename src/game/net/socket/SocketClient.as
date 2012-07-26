package game.net.socket {
	import framerate.SecondsTimer;

	import game.net.core.RequestData;
	import game.net.data.CtoS.CSPing;
	import game.net.data.StoC.SCPing;
	import game.net.pool.CallPool;

	import gameui.manager.UIManager;

	import log4a.Logger;

	import utils.ObjectPool;

	import com.protobuf.Message;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getTimer;







	/**
	 * Socket client
	 */
	public final class SocketClient extends EventDispatcher {
		public static const IO_ERROR : String = "ioError";
		public static const SECURITY_ERROR : String = "securityError";
		private var _requestPool : CallPool;
		private var _buffer : ByteArray;
		private var _parser : SocketParser;
		private var _socket : Socket;
		private var _vector : Vector.<Socket>;
		private var _data : SocketData;
		private var _length : uint;
		private var _writeBytes : uint = 0;
		private var _readBytes : uint = 0;
		private var _isJava : Boolean = false;

		private function init() : void {
			reset();
			_requestPool = new CallPool();
			_vector = new Vector.<Socket>();
			_parser = new SocketParser();
		}

		private function reset() : void {
			_buffer = new ByteArray();
			if (!_isJava) _buffer.endian = Endian.LITTLE_ENDIAN;
			_length = 0;
		}

		private function addSocketEvents(_socket : Socket) : void {
			_socket.addEventListener(IOErrorEvent.IO_ERROR, socket_ioErrorHandler);

			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, socket_securityErrorHandler);
			_socket.addEventListener(Event.CONNECT, socket_connectHandler);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, socket_dataHandler);
			_socket.addEventListener(Event.CLOSE, socket_closeHandler);
		}

		private function removeSocketEvents(_socket : Socket) : void {
			_socket.removeEventListener(IOErrorEvent.IO_ERROR, socket_ioErrorHandler);
			_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, socket_securityErrorHandler);
			_socket.removeEventListener(Event.CONNECT, socket_connectHandler);
			_socket.removeEventListener(ProgressEvent.SOCKET_DATA, socket_dataHandler);
			_socket.removeEventListener(Event.CLOSE, socket_closeHandler);
		}

		private function socket_ioErrorHandler(event : IOErrorEvent) : void {
			dispatchEvent(new Event(IO_ERROR));
			Logger.debug("连接出错了！" + IO_ERROR);
		}

		private function socket_securityErrorHandler(event : SecurityErrorEvent) : void {
			dispatchEvent(new Event(SECURITY_ERROR));
			Logger.debug("连接出错了！" + SECURITY_ERROR);
		}

		private function socket_connectHandler(event : Event) : void {
			this._socket = event.currentTarget as Socket;
			Logger.debug("连接成功！");
			for each (var _socket:Socket in _vector) {
				if (event.currentTarget != _socket) {
					_socket.close();
					removeSocketEvents(_socket);
				}
			}
			_vector = null;
			dispatchEvent(new Event(Event.CONNECT));
			SecondsTimer.addFunction(pingTimer);
			addCallback(0x00, pingCallBack);
		}

		private var _pingTimer : uint = 0;
		private var _pingGap : uint = 7200;
		private var _socketDelay : uint = 0;

		/** 服务器 ping **/
		private function pingCallBack(meg : SCPing) : void {
			_socketDelay = getTimer() - meg.ping;
			_pingGap = _pingGap / ((getTimer() - meg.ping) / 200);
		}

		/** 计时器，一秒钟运行一次 **/
		private function pingTimer() : void {
			if (++_pingTimer > _pingGap) {
				sendPingCmd();
				_pingTimer = 0;
			}
		}

		private function sendPingCmd() : void {
			var cmd : CSPing = ObjectPool.getObject(CSPing);
			cmd.ping = getTimer();
			sendMessage(0x00, cmd);
		}

		private function socket_dataHandler(event : ProgressEvent) : void {
			while (_socket.bytesAvailable > 5) {

				if (_length == 0) { 
					_length = _socket.readUnsignedInt() + 2;
				}
				if (_socket.bytesAvailable < _length) break;
				try {
					_buffer.clear();
					var temp:ByteArray=new ByteArray();
					 temp.endian = Endian.LITTLE_ENDIAN;
					_socket.readBytes(temp, 0, _length);
					_readBytes += _length + 4;
					_requestPool.addReqestData(new RequestData(0,temp));
					temp=null;
				} catch(e : Error) {
					Logger.error("解析消息出错！");
				}finally{
					_length = 0;
				}
			}
		}

		private function socket_closeHandler(event : Event) : void {
			dispatchEvent(new Event(Event.CLOSE));
		}

		public function SocketClient() {
			init();
		}

		public function get data() : SocketData {
			return _data;
		}

		public function addCallback(method : uint, callback : Function) : void {
			_requestPool.addCallback(method, callback);
		}

		public function removeCallback(method : uint, fun : Function = null) : void {
			_requestPool.removeCallback(method, fun);
		}

		public function executeCallback(request : RequestData) : void {
			_requestPool.executeCCRequest(request);
		}

		public function connect(data : SocketData) : void {
			if (_socket && _socket.connected) return ;
			_data = data;
			try {
				_vector[Number(data.name)] = new Socket();
				if (!_isJava) _vector[Number(data.name)].endian = Endian.LITTLE_ENDIAN;
				addSocketEvents(_vector[Number(data.name)]);
				Security.loadPolicyFile("xmlsocket://" + _data.host + ":" + _data.port);
				_vector[Number(data.name)].connect(_data.host, _data.port);
				Logger.debug("发送信息！" + "xmlsocket://" + _data.host + ":" + _data.port);
			} catch(e : Error) {
				Logger.debug("连接出错了！" + e.message);
			}
		}

		private var _sendLength : uint;

		/**  
		 * 向后台发送请求
		 * @param msgCmd   协议编号
		 * @param message  信息体
		 */
		public function sendMessage(msgCmd : uint, message : Message = null) : void {
			if (!_socket || !_socket.connected) {
				Logger.debug("socket 已经连接断开" + msgCmd);
				dispatchEvent(new Event(Event.CLOSE));
				return;
			}
			var ba : ByteArray = new ByteArray();
			if (!_isJava) ba.endian = Endian.LITTLE_ENDIAN;
			SocketParser.writeObject(ba, msgCmd, message);
			_sendLength = ba.length - 2;
			var mask : uint = getMask(ba);
			_sendLength = _sendLength | (mask << 24);
			_socket.writeUnsignedInt(_sendLength);
			_socket.writeBytes(ba, 0, ba.length);
			_socket.flush();
			_writeBytes += ba.length + 2;
			ba = null;
			if (msgCmd != 32)
				Logger.debug("发送信息！协议号===>0x" + msgCmd.toString(16));
		}

		private var _maskFun : Function;

		private function getMask(ba : ByteArray) : uint {
			if (_maskFun == null) {
				try {
					var cls:Class = (UIManager.appDomain.getDefinition("com.utils.Arithmetic") as Class);
				} catch(e : Error) {
					return 0;
				}
				_maskFun = cls["lib"]["genChecksum"];
			}
			if (_maskFun == null) return 0;
			return _maskFun(ba);
		}

		public function sendCCMessage(msgCmd : uint, message : * = null) : void {
			executeCallback(new RequestData(msgCmd, message));
		}

		public function get writeBytes() : uint {
			return _writeBytes;
		}

		public function get readBytes() : uint {
			return _readBytes;
		}

		public function get socketDelay() : uint {
			return _socketDelay;
		}
	}
}