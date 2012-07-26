package game.manager
{
	import flash.events.ErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Dictionary;
	import game.config.StaticConfig;
	import log4a.Logger;




	/**
	 * @author yangyiqiang
	 */
	public class SoundManager
	{
		public static const EVIL : String = "evil";

		public static const heaven : String = "heaven";

		public static const mSea1 : String = "mSea1";

		public static const mSea2 : String = "mSea2";

		public static const theme : String = "theme";

		private var _soundsDict : Dictionary = new Dictionary();

		private static var _instance : SoundManager;

		public function SoundManager()
		{
			if (_instance)
			{
				throw Error("---SoundManager--is--a--single--model---");
			}
		}

		public static function get instance() : SoundManager
		{
			if (_instance == null)
			{
				_instance = new SoundManager();
			}
			return _instance;
		}

		public function init() : void
		{
			addStreamSound(StaticConfig.cdnRoot + "assets/sounds/evil.m4a", "evil");
			addStreamSound(StaticConfig.cdnRoot + "assets/sounds/heaven.m4a", "heaven");
			addStreamSound(StaticConfig.cdnRoot + "assets/sounds/mSea1.m4a", "mSea1");
			addStreamSound(StaticConfig.cdnRoot + "assets/sounds/mSea2.m4a", "mSea2");
			addStreamSound(StaticConfig.cdnRoot + "assets/sounds/theme.m4a", "theme");
		}

		public function addStreamSound(path : String, name : String, buffer : Number = 1) : void
		{
			try
			{
				var nc : NetConnection = new NetConnection();
				nc.connect(null);
				try
				{
					var stream : NetStream = new NetStream(nc);
				}
				catch (error : ErrorEvent)
				{
				}
				stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				stream.bufferTime = buffer;
				stream.play(path);
				stream.pause();
				var sndObj : StreamClient = new StreamClient();
				sndObj.name = name;
				sndObj.channel = stream;
				sndObj.paused = true;
				sndObj.type = "stream";
				sndObj.volume = 1;
				sndObj.startTime = 0;
				sndObj.loops = 0;
				sndObj.pausedByAll = false;
				_soundsDict[name] = sndObj;
			}
			catch (error : Error)
			{
				Logger.error("playSound  error===>" + error.message);
			}
		}

		public function removeSound(name : String) : void
		{
			delete this._soundsDict[name];
		}

		public function playSound(name : String, volume : Number = 1, startTime : Number = 0, loops : int = 0) : void
		{
			try
			{
				var snd : StreamClient = this._soundsDict[name];
				if (!snd) return;
				snd.volume = volume;
				snd.startTime = startTime;
				snd.loops = loops;
				if (snd.type == "stream")
				{
					if (snd.paused)
						snd.channel.resume();
					else
						snd.channel.pause();
					snd.channel = snd.channel;
				}
				snd.paused = false;
			}
			catch (error : Error)
			{
				Logger.error("playSound  error===>" + error.message);
			}
		}

		public function stopSound(name : String) : void
		{
			try
			{
				var snd : StreamClient = this._soundsDict[name];
				snd.paused = true;
				if (snd.type == "stream")
				{
					snd.channel.pause();
				}
			}
			catch (error : Error)
			{
				//trace("SoundManager.stopSound(name) [error] --> ", error, name);
			}
		}

		public function pauseSound(name : String) : void
		{
			var snd : StreamClient = this._soundsDict[name];
			if (!snd) return;
			snd.paused = true;
			if (snd.type == "stream")
				snd.channel.pause();
		}

		private function netStatusHandler(event : NetStatusEvent) : void
		{
			switch (event.info["code"])
			{
				case "NetStream.Play.Stop":
					NetStream(event.target).seek(0);
					for each (var obj:StreamClient in _soundsDict)
						if (event.target == obj.channel && obj.loops == 0)
						{
							NetStream(event.target).pause();
							return;
						}
			}
		}
	}
}
import flash.net.NetStream;

class StreamClient
{
	public var name : String;

	public var channel : NetStream;

	public var paused : Boolean = true;

	public var type : String = "stream";

	public var volume : Number = 1;

	public var startTime : Number = 0;

	public var loops : int = 0;

	public var pausedByAll : Boolean = false;
}

