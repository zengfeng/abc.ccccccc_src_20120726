package game.module.chat
{
	import com.utils.RegExpUtils;
	public class VoChatMsg
	{
		/** 频道Id */
		public var channelId:uint = 0;
		/** 服务器Id */
		public var serverId:uint = 0;
		/** 发送玩家名称 */
		public var playerName:String;
		/** 发送玩家颜色判断值 */
		public var playerColorPropertyValue:uint = 0;
		/** 接收服务器Id */
		public var recServerId:uint = 0;
		/** 接收玩家名称 */
		public var recPlayerName:String;
		/** 接收玩家颜色判断值 */
		public var recPlayerColorPropertyValue:uint = 0;
		
		/** 内容 */
		public var content:String;
		/** 颜色 */
		public var color:Number = -1;
        public var isHTMLFormat : Boolean = false;
		
		public function VoChatMsg()
		{
		}
        
        public function mirrorValue(obj:Object):void
        {
            this.channelId = obj["channelId"];
            this.serverId = obj["serverId"];
            this.playerName = obj["playerName"];
            this.playerColorPropertyValue = obj["playerColorPropertyValue"];
            this.recServerId = obj["recServerId"];
            this.recPlayerName = obj["recPlayerName"];
            this.recPlayerColorPropertyValue = obj["recPlayerColorPropertyValue"];
            this.content = obj["content"];
			this.content=RegExpUtils.getFilterStr(content);
            this.color = obj["color"];
        }
	}
}