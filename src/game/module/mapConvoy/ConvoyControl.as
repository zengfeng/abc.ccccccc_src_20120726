package game.module.mapConvoy
{
	import flash.utils.Dictionary;

	import game.module.mapConvoy.elements.Convoyer;
	import game.module.mapConvoy.elements.SelfConvoyer;
	import game.module.mapConvoy.ui.ConvoyInfoBox;
	import game.net.data.StoC.SCConvoyInfoRes;

	import worlds.apis.MPlayer;
	import worlds.apis.MSelfPlayer;

	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-6-28
	 */
	public class ConvoyControl
	{
		/** 单例对像 */
		private static var _instance : ConvoyControl;

		/** 获取单例对像 */
		static public function get instance() : ConvoyControl
		{
			if (_instance == null)
			{
				_instance = new ConvoyControl(new Singleton());
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		private var dic : Dictionary = new Dictionary();
		public var selfConvoy : SelfConvoyer;
		public var selfConvoying : Boolean = false;

		function ConvoyControl(singleton : Singleton) : void
		{
			singleton;
		}

		// ====================
		// 模式消息监听
		// ====================
		public function addModelListener() : void
		{
			ConvoyConfig.initNum();
			MPlayer.MODEL_CONVOY_IN.add(modelIn);
			MPlayer.MODEL_CONVOY_OUT.add(modelOut);
			MPlayer.MODEL_CONVOY_CHANGE.add(modelChange);
		}

		public function removeModelListener() : void
		{
			MPlayer.MODEL_CONVOY_IN.remove(modelIn);
			MPlayer.MODEL_CONVOY_OUT.remove(modelOut);
			MPlayer.MODEL_CONVOY_CHANGE.remove(modelChange);
			
			unstall();
		}

		public function unstall() : void
		{
			var keyArr : Array = [];
			for (var key:* in dic)
			{
				keyArr.push(key);
			}

			while (keyArr.length > 0)
			{
				modelOut(keyArr.shift());
			}
		}

		public function getConvoyer(playerId : int) : Convoyer
		{
			return dic[playerId];
		}

		// ====================
		// 模式消息处理函数
		// ====================
		/** 进入模式 */
		public function modelIn(playerId : int, modelId : int) : void
		{
			if (dic[playerId]) return;
			var convoyer : Convoyer;
			if (playerId != MSelfPlayer.id)
			{
				convoyer = new Convoyer();
				convoyer.reset(playerId, modelId);
				dic[playerId] = convoyer;
			}
			else
			{
				convoyer = new SelfConvoyer();
				convoyer.reset(playerId, modelId);
				dic[playerId] = convoyer;
				selfConvoy = convoyer as SelfConvoyer;
				selfConvoying = true;
				if (infoBox)
				{
					infoBox.getItemIconContentCall = selfConvoy.getTipContent;
				}
			}
		}

		/** 退出模式 */
		public function modelOut(playerId : int, destoryed : Boolean = false) : void
		{
			if (playerId == MSelfPlayer.id)
			{
				selfConvoying = false;
				selfConvoy = null;
			}

			if (destoryed)
			{
				delete dic[playerId];
				return;
			}

			var convoyer : Convoyer = getConvoyer(playerId);
			if (convoyer)
			{
				convoyer.destory(true);
			}
			delete dic[playerId];
		}

		/** 改变模式 */
		public function modelChange(playerId : int, modelId : int) : void
		{
			var convoyer : Convoyer = getConvoyer(playerId);
			if (convoyer == null)
			{
				modelIn(playerId, modelId);
				return;
			}
			convoyer.changeModel(modelId);
			if (playerId == MSelfPlayer.id)
			{
				if (infoBox)
				{
					infoBox.buttonEnabled = modelId < 5;
				}
			}
		}

		// ====================
		// 服务器交互
		// ====================
		/** 协议监听 -- 0xD2 玩家香炉信息返回*/
		public function sc_convoyInfo(msg : SCConvoyInfoRes) : void
		{
			var convoyer : Convoyer = getConvoyer(msg.playerId);
			if (convoyer == null) return;
			convoyer.sc_convoyInfo(msg);
			if (msg.playerId == MSelfPlayer.id)
			{
				if (infoBox) infoBox.updateItemIconTipContent();
			}
		}

		/** 协议监听 -- 0xD1 到达指定地点返回*/
		public function sc_arrivePonit(wayPointIndex : int, time : int) : void
		{
			if (selfConvoy == null) return;
			selfConvoy.scCheckArriveWayPoint(wayPointIndex, time);
			// Alert.show("wayPointIndex="+wayPointIndex + "   time="+time);
			if (wayPointIndex == ConvoyConfig.WAY_POINT_COUNT && time == 0)
			{
				sc_over();
			}

			if (infoBox && time == 0)
			{
				infoBox.immediatelyGold = 100 - wayPointIndex * 25;
			}
		}

		/** 协议监听 -- 0xD5 加速运镖*/
		public function sc_instantConvoy(fastForward : Boolean, time : int) : void
		{
			if (infoBox)
			{
				infoBox.time = time + selfConvoy.wayPointIndex * 2;
				infoBox.buttonEnabled = false;
			}

			if (selfConvoy) selfConvoy.toNextWayPoint();

			if (fastForward == false && selfConvoy != null)
			{
				selfConvoy.toCompleteWayPoint();
			}
		}

		// ====================
		// UI
		// ====================
		private var infoBox : ConvoyInfoBox;

		/** 服务器发来开始 */
		public function sc_start(quality : int, time : int, isRate : Boolean) : void
		{
			infoBox = ConvoyInfoBox.instance;
			infoBox.quality = quality;
			infoBox.time = time + 4 * 2;
			infoBox.buttonEnabled = true;
			infoBox.isShowIconCircle = isRate;
			infoBox.show();
			if (selfConvoy)
			{
				infoBox.getItemIconContentCall = selfConvoy.getTipContent;
			}
		}

		/** 服务器发来结束 */
		public function sc_over() : void
		{
			if (infoBox)
			{
				infoBox.stopTimer();
				infoBox.hide();
			}
		}
	}
}
class Singleton
{
}