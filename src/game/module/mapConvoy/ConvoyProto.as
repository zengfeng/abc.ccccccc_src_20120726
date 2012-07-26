package game.module.mapConvoy
{
	import game.net.core.Common;
	import game.net.data.CtoS.CSArrivePoint;
	import game.net.data.CtoS.CSAttackConvoy;
	import game.net.data.CtoS.CSConoyBegin;
	import game.net.data.CtoS.CSConvoyInfo;
	import game.net.data.CtoS.CSInstantConvoy;
	import game.net.data.CtoS.CSStopConvoy;
	import game.net.data.StoC.SCArrivePonitRes;
	import game.net.data.StoC.SCConvoyBeginRes;
	import game.net.data.StoC.SCConvoyInfoRes;
	import game.net.data.StoC.SCConvoyNumUpdate;
	import game.net.data.StoC.SCInstantConvoyRes;
	import game.net.data.StoC.SCSTopConvoyRes;

	/**
	 * @author ZengFeng (Email:zengfeng75[AT]163.com) 2012-3-6   ����4:54:00 
	 */
	public class ConvoyProto
	{
		public function ConvoyProto(singleton : Singleton)
		{
			singleton;
			sToC();
		}

		/** 单例对像 */
		private static var _instance : ConvoyProto;

		/** 获取单例对像 */
		static public function get instance() : ConvoyProto
		{
			if (_instance == null)
			{
				_instance = new ConvoyProto(new Singleton());
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 协议监听 */
		private function sToC() : void
		{
			// 协议监听 -- 0xD0 开始运镖返回
			Common.game_server.addCallback(0xD0, sc_start);
			// 协议监听 -- 0xD1 到达指定地点返回
			Common.game_server.addCallback(0xD1, sc_arrivePonit);
			// 协议监听 -- 0xD2 玩家香炉信息返回
			Common.game_server.addCallback(0xD2, sc_convoyInfo);
			// 协议监听 -- 0xD4 打断运镖返回
			Common.game_server.addCallback(0xD4, sc_stopConvoy);
			// 协议监听 -- 0xD5 玩家香炉信息返回
			Common.game_server.addCallback(0xD5, sc_instantConvoy);
			// 协议监听 -- 0xD6 运镖次数更新
			Common.game_server.addCallback(0xD6, sc_convoyNumUpdate);
		}

		/** 协议监听 -- 0xD0 开始运镖返回 */
		private function sc_start(msg : SCConvoyBeginRes) : void
		{
			// Alert.show("协议监听 -- 0xD0 开始运镖返回 msg.leftTime=" + msg.leftTime + "     msg.quality=" + msg.quality);
			ConvoyControl.instance.sc_start(msg.quality, msg.leftTime, msg.isRate);
		}

		/** 协议监听 -- 0xD1 到达指定地点返回*/
		private function sc_arrivePonit(msg : SCArrivePonitRes) : void
		{
			ConvoyControl.instance.sc_arrivePonit(msg.ponit, msg.ret);
		}

		/** 协议监听 -- 0xD2 玩家香炉信息返回*/
		private function sc_convoyInfo(msg : SCConvoyInfoRes) : void
		{
			ConvoyControl.instance.sc_convoyInfo(msg);
		}

		/** 协议监听 -- 0xD4 打断运镖返回*/
		private function sc_stopConvoy(msg : SCSTopConvoyRes) : void
		{
			msg;
			ConvoyControl.instance.sc_over();
		}

		/** 协议监听 -- 0xD5 加速运镖*/
		private function sc_instantConvoy(msg : SCInstantConvoyRes) : void
		{
			// Alert.show("协议监听 -- 0xD5 加速运镖 msg.flag =" + msg.flag + "   msg.leftTime=" + msg.leftTime );
			// 加速类型0:直接到达 1:加速到达
			var fastForward : Boolean = msg.flag == 0 ? false : true;
			ConvoyControl.instance.sc_instantConvoy(fastForward, msg.leftTime);
		}

		/** 协议监听 -- 协议监听 -- 0xD6 运镖次数更新 */
		private function sc_convoyNumUpdate(msg : SCConvoyNumUpdate) : void
		{
			// A + (B << 4 ) A:运镖次数 B:打劫次数
			var attackNum : int = msg.convoyNum >> 4;
			var convoyNum : int = msg.convoyNum - (attackNum << 4);
			ConvoyConfig.setNum(convoyNum, attackNum);
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		/** 发送协议[0xD0] -- 开始运镖 */
		public function cs_start(quality : int) : void
		{
			var msg : CSConoyBegin = new CSConoyBegin();
			msg.quality = quality;
			// Alert.show("发送协议[0xD0]开始运镖 quality=" +quality );
			Common.game_server.sendMessage(0xD0, msg);
		}

		/** 发送协议[0xD1] -- 到达地点 */
		public function cs_arrivePoint() : void
		{
			// Alert.show("发送协议[0xD1] -- 到达地点");
			var msg : CSArrivePoint = new CSArrivePoint();
			Common.game_server.sendMessage(0xD1, msg);
		}

		/** 发送协议[0xD2] -- 请求香炉信息 */
		public function cs_convoyInfo(playerId : int) : void
		{
			var msg : CSConvoyInfo = new CSConvoyInfo();
			msg.playerId = playerId;
			Common.game_server.sendMessage(0xD2, msg);
		}

		/** 发送协议[0xD3] -- 劫镖 */
		public function cs_attackConvoy(playerId : int) : void
		{
			if (ConvoyControl.instance.selfConvoying == true) return;
			var msg : CSAttackConvoy = new CSAttackConvoy();
			msg.playerId = playerId;
			Common.game_server.sendMessage(0xD3, msg);
		}

		/** 发送协议[0xD4] -- 打断运镖 */
		public function cs_stopConvoy() : void
		{
			var msg : CSStopConvoy = new CSStopConvoy();
			Common.game_server.sendMessage(0xD4, msg);
		}

		/** 发送协议[0xD5] -- 加速运镖 */
		public function cs_instantConvoy(fastForward : Boolean) : void
		{
			var msg : CSInstantConvoy = new CSInstantConvoy();
			// 加速类型0:直接到达 1:加速到达
			msg.flag = fastForward ? 1 : 0;
			// Alert.show(" 发送协议[0xD5] -- 加速运镖  msg.flag=" + msg.flag);
			Common.game_server.sendMessage(0xD5, msg);
		}
	}
}
class Singleton
{
}