package game.module.chatwhisper
{
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import game.net.core.Common;
    import game.net.data.CtoS.CSWhisper;
    import game.net.data.CtoS.CSWhisperPtnInfo;


    /**
     * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-13  ����2:36:49 
     */
    public class ProtoCtoSWhisper extends EventDispatcher
    {
        /** 单例对像 */
        private static var _instance : ProtoCtoSWhisper;

        public function ProtoCtoSWhisper(target : IEventDispatcher = null)
        {
            super(target);
        }

        /** 获取单例对像 */
        static public function get instance() : ProtoCtoSWhisper
        {
            if (_instance == null)
            {
                _instance = new ProtoCtoSWhisper();
            }
            return _instance;
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        /** [0x96]  请求私聊对象情报 */
        public function cs_WhisperPtnInfo(playerName : String) : void
        {
            var msg : CSWhisperPtnInfo = new CSWhisperPtnInfo();
            msg.targe = playerName;
            Common.game_server.sendMessage(0x96, msg);
        }

        /** [0x90] 密语*/
        public function cs_Whisper(recPlayerName:String, content:String) : void
        {
            var msg : CSWhisper = new CSWhisper();
            msg.target = recPlayerName;
            msg.content = content;
            Common.game_server.sendMessage(0x90, msg);
        }
    }
}
