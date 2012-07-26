package game.module.chat.vo
{
	public class MessageVo
	{
		/** 频道Id */
		public var channelId:uint = 0;
		/** 服务器Id */
		public var serverId:uint = 0;
		/** 发送玩家名称 */
		public var playerName:String;
		/** 发送玩家颜色判断值 */
		public var playerColorValue:uint = 0;
		/** 接收服务器Id */
		public var receiveServerId:uint = 0;
		/** 接收玩家名称 */
		public var receivePlayerName:String;
		/** 接收玩家颜色判断值 */
		public var receivePlayerColorValue:uint = 0;
		
		/** 内容 */
		public var content:String;
		/** 颜色 */
		public var color:Number = -1;
		
		public function MessageVo()
		{
		}
	}
}