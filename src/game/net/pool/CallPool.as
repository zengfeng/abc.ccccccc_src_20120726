package game.net.pool {
	import game.net.core.RequestData;

	import log4a.Logger;

	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	/**
	 * CallPool
	 */
	public class CallPool {
		private var _callbacks : Dictionary;
		private var _delay : int = 20;

		public function CallPool() {
			_callbacks = new Dictionary();
			_timer = new Timer(_delay);
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
		}

		private var _requestList : Vector.<RequestData>=new Vector.<RequestData>();
		protected var _timer : Timer;

		public function addReqestData(request : RequestData) : void {
			_requestList.push(request);
			if (!_timer.running) {
				_timer.reset();
				_timer.start();
			}
		}

		public function addCallback(method : uint, callback : Function) : void {
			if (_callbacks[method] == null) {
				_callbacks[method] = new PoolElement();
			}
			PoolElement(_callbacks[method]).addFunction(callback);
		}

		public function removeCallback(method : uint, fun : Function = null) : void {
			if (!_callbacks[method]) {
				Logger.error("删除回调函数出错!原因:没有此回调函数    cmd=" + method);
				return;
			}
			if (fun != null) PoolElement(_callbacks[method]).removeFunction(fun);
			if (PoolElement(_callbacks[method]).size() <= 0 || fun == null) {
				delete _callbacks[method];
			}
		}

		public function executeCCRequest(request : RequestData) : void {
			if (!request || !_callbacks[request.method]) {
				if (!request) return;
				Logger.error("执行executeCCRequest出错!原因:没有此回调函数    cmd=" + request.method);
				return;
			}
			PoolElement(_callbacks[request.method]).execute(request.args);
		}

		private var _max : int;
		private var i : int = 0;

		private function timerHandler(event : TimerEvent) : void {
			_max = _requestList.length * 0.1;
			_max = _max < 1 ? 1 : _max;
			for (i = 0;i < _max;i++) {
				execute(_requestList.shift());
			}
			if (_requestList.length <= 0 && _timer.running) {
				_timer.stop();
			}
		}

		private function execute(request : RequestData) : void {
			if (!request || !_callbacks[request.method]) {
				if (!request) return;
				Logger.error("执行回调函数出错!原因:没有此回调函数    cmd=" + request.method);
				return;
			}
			request.parse();
			var element : PoolElement = PoolElement(_callbacks[request.method]);
			if (!element) return;
			element.execute(request.args);
		}
	}
}
import com.protobuf.Message;

class PoolElement {
	private var _elements : Vector.<Function>;

	public function PoolElement() {
		_elements = new Vector.<Function>();
	}

	public function execute(args : Message) : void {
		if (!_elements) return;
		var temp : Vector.<Function>=_elements.slice();
		for each (var call:Function in temp) {
			call.apply(null, [args]);
		}
		// ObjectPool.disposeObject(args);
	}

	public function addFunction(callback : Function) : void {
		if (findAt(callback) == -1)
			_elements.push(callback);
	}

	public function removeFunction(callback : Function) : void {
		var index : int = findAt(callback);
		if (index >= 0)
			_elements.splice(index, 1);
	}

	public function getFunctions() : Vector.<Function> {
		return _elements;
	}

	public function findAt(fun : Function) : int {
		return _elements.indexOf(fun);
	}

	public function reset() : void {
		_elements = new Vector.<Function>();
	}

	public function size() : int {
		return _elements ? _elements.length : -1;
	}

	public function clean() : void {
		_elements = null;
	}
}