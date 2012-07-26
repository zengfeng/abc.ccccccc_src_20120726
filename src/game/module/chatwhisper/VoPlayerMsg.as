package game.module.chatwhisper
{
    import game.module.chat.VoChatMsg;
    import game.module.chatwhisper.config.WhisperConfig;
    import game.module.friend.VoFriendItem;

    /**
     * @author ZengFeng Email:zengfeng75[AT]163.com)  2011  2011-11-21 ����12:12:06
     */
    public class VoPlayerMsg
    {
        /** 消息列表 */
        public var msgs : Vector.<VoChatMsg> = new Vector.<VoChatMsg>();
        /** 玩家信息 */
        public var voPlayer : VoFriendItem;
        /** 新消息数量 */
        public var newMsgNum : uint = 0;

        /** 加入消息 */
        public function appendMsg(voMsg : VoChatMsg) : void
        {
            while (msgs.length > WhisperConfig.playerMsgMaxRow)
            {
                msgs.shift();
            }
            msgs.push(voMsg);
        }
    }
}
