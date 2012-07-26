package game.module.chat.view
{
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import game.module.chat.ControllerChat;
    import game.module.chat.EventChat;
    import game.module.chat.ManagerChat;
    import game.module.chat.config.ChannelId;
    import gameui.core.GComponent;
    import gameui.core.GComponentData;
    import gameui.manager.UIManager;
    import net.AssetData;




    /**
     * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-14  ����9:56:48 
     */
    public class BoxInput extends GComponent
    {
        /** 背景 */
        protected var bg : DisplayObject;
        protected var fillBitmapData : BitmapData;
        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        /** 频道选择按钮 */
        public var channelComboBox : ChannelComboBox;
        /** 消息输入框 */
        public var msgTextInput : MsgTextInput;
        /** 发送按钮 */
        public var sendButton : EnterButton;
        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        protected var paddingLeft : Number = 3;
        protected var paddingRight : Number = 3;
        protected var paddingTop : Number = 3;
        protected var paddingBottom : Number = 3;
        protected var gap : Number = 2;
        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        /** 控制器 */
        public var controller : ControllerChat ;

        public function BoxInput()
        {
            _base = new GComponentData();
            _base.height = 32;
            super(_base);
            // 添加事件监听
            initEvents();
            // 设置控制器元件
            setController();
        }

        /** 设置控制器元件 */
        private function setController() : void
        {
            controller = ManagerChat.instance.controllerChat as ControllerChat;
            if (!controller) return;
            controller.channelComboBox = channelComboBox;
            controller.msgTextInput = msgTextInput;
            controller.sendButton = sendButton;
        }

        /** 初始化视图 */
        override protected function create() : void
        {
            // 背景
            bg = UIManager.getUI(new AssetData("ChatInputBoxBg"));
            bg.x = 0;
            bg.y = 0;
            bg.width = this.width;
            bg.height = 32;
            addChild(bg);

            // 频道选择按钮
            channelComboBox = new ChannelComboBox();
            channelComboBox.x = paddingLeft;
            channelComboBox.y = paddingTop;
            addChild(channelComboBox);

            // 发送按钮
            sendButton = new EnterButton();
            sendButton.x = this.width - paddingRight - sendButton.width;
            sendButton.y = paddingTop;
            addChild(sendButton);
            // 输入框
            msgTextInput = new MsgTextInput();
            msgTextInput.x = 56;
            msgTextInput.y = 5;
            msgTextInput.width = this.width - msgTextInput.x - gap;
            msgTextInput.height = 20;
            addChild(msgTextInput);
        }

        /** 布局 */
        override protected function layout() : void
        {
            // 背景
            if (bg)
            {
                bg.width = this.width;
            }
            // 发送按钮
            sendButton.x = this.width - paddingRight - sendButton.width;

            // 输入框
            msgTextInput.width = sendButton.x - msgTextInput.x - gap * 2;
        }

        /** 添加事件监听 */
        protected function initEvents() : void
        {
            // 频道发生改变事件
            channelComboBox.addEventListener(EventChat.CHANNEL_CHANGE, channelComboBox_channelChange);
            // 抛出发送事件
            sendButton.addEventListener(EnterButton.ENTER, sendHandler);
        }

        /** 抛出发送事件 */
        private function sendHandler(event : Event) : void
        {
            var eventChat : EventChat = new EventChat(EventChat.SEND_MSG, true);
            dispatchEvent(eventChat);
        }

        /** 频道发生改变事件 */
        protected function channelComboBox_channelChange(event : EventChat) : void
        {
            msgTextInput.isShowPlayerBox = (event.voChannel.id == ChannelId.WHISPER);
        }
    }
}
