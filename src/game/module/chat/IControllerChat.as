package game.module.chat
{
    import flash.display.DisplayObjectContainer;

    /**
     * @author yangyiqiang
     */
    public interface IControllerChat
    {
        function get view() : DisplayObjectContainer;

        function setPlayerName(playerName : String) : void

        function setInputChannel(channelId : uint) : void

        function setOutputChannel(channelId : uint) : void

        function prompt(str : String, isHTMLFormat : Boolean = false) : void

        function system(str : String, isHTMLFormat:Boolean = false) : void

        function clanPrompt(str : String) : void

        function set isShowWhisper(value : Boolean) : void

        function get isShowWhisper() : Boolean

        /** 输入框插入内容 */
        function msgTextInputInsertContent(str : String) : void

        /** 发送到当前频道消息 */
        function sendMsgToCurrentChannel(str : String) : void
    }
}
