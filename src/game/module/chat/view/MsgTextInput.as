package game.module.chat.view
{
    import com.utils.StringUtils;
    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;
    import flash.text.TextField;
    import flash.text.TextFieldType;
    import flash.text.TextFormat;
    import flash.ui.Keyboard;
    import game.module.chat.ChatUntils;
    import game.module.chat.EventChat;
    import game.module.chat.config.ChatConfig;
    import gameui.core.GComponent;
    import gameui.core.GComponentData;




    public class MsgTextInput extends GComponent
    {
        /** 用户区块 */
        public var playerBox : PlayerBox;
        /** 内容输入框 */
        public var contentTextInput : TextField;
        /** 内容缓存 */
        protected var contentCache : ContentCache;
        /** 是否显示用户名 */
        protected var _isShowPlayerBox : Boolean = false;
        /** 请输入内容 */
        public static var TEXT_INTPU_PROMPT_CONTENT : String = "请输入内容";
        /** 请输入玩家 */
        public static var TEXT_INTPU_PROMPT_PLAYER : String = "请输入玩家";

        public function MsgTextInput()
        {
            _base = new GComponentData();
            _base.width = 100;
            _base.height = 20;
            super(_base);
            initEvents();
        }

        /** 初始化子组件 */
        override protected function create() : void
        {
            // 用户区块
            playerBox = new PlayerBox(130, this.height);
            addChild(playerBox);
            // 内容输入框
            var textFormat : TextFormat = new TextFormat();
            textFormat.size = 12;
//            textFormat.kerning = true;
            textFormat.color = 0xFFFFFF;
			textFormat.font = ChatUntils.font;
            contentTextInput = new TextField();
            contentTextInput.defaultTextFormat = textFormat;
            contentTextInput.maxChars = ChatConfig.contentMaxLength;
            contentTextInput.type = TextFieldType.INPUT;
             contentTextInput.filters = ChatUntils.textEdgeFilter;
            contentTextInput.height = this.height;
			contentTextInput.y = 2;
            addChild(contentTextInput);
            contentTextInput.text = TEXT_INTPU_PROMPT_CONTENT;
            contentTextInput.alpha = 0.7;
			contentTextInput.y = 2;

            // 内容缓存
            contentCache = new ContentCache(contentTextInput);
        }

        /** 布局 */
        override protected function layout() : void
        {
            // 内容输入框
            updateContentTextInputLayout();
        }

        /** 更新 内容输入框布局 */
        private function updateContentTextInputLayout() : void
        {
            playerBox.visible = isShowPlayerBox;
            if (isShowPlayerBox == false)
            {
                contentTextInput.x = 0;
                contentTextInput.width = this.width;
            }
            else
            {
                contentTextInput.x = playerBox.width;
                contentTextInput.width = this.width - playerBox.width;
            }
        }

        /** 添加事件监听 */
        protected function initEvents() : void
        {
            addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
            contentTextInput.addEventListener(FocusEvent.FOCUS_OUT, textInput_focusOutHandler);
            contentTextInput.addEventListener(FocusEvent.FOCUS_IN, textInput_focusInHandler);
            contentTextInput.addEventListener(KeyboardEvent.KEY_UP, checkout);
        }

        /** 验证 */
        private function checkout(event : Event = null) : void
        {
            var str : String = contentTextInput.text;
            if (StringUtils.UTFLength(str) > ChatConfig.contentMaxLength)
            {
                contentTextInput.text = StringUtils.UTFSubstr(str, ChatConfig.contentMaxLength);
            }
        }

        private function textInput_focusInHandler(event : FocusEvent) : void
        {
            if (content == TEXT_INTPU_PROMPT_CONTENT)
            {
                content = "";
                contentTextInput.alpha = 1;
            }
        }

        private function textInput_focusOutHandler(event : FocusEvent) : void
        {
            if (content == "")
            {
                content = TEXT_INTPU_PROMPT_CONTENT;
                contentTextInput.alpha = 0.7;
            }
        }

        private function keyDownHandler(event : KeyboardEvent) : void
        {
            if (event.keyCode == Keyboard.ENTER)
            {
                var eventChat : EventChat = new EventChat(EventChat.SEND_MSG, true);
                dispatchEvent(eventChat);
            }
        }

        /** 添加缓存内容 */
        public function pushContentCache(str : String) : void
        {
            contentCache.push(str);
        }

        /** 插入消息内容 */
        public function  insertContent(str : String) : void
        {
            if (content == MsgTextInput.TEXT_INTPU_PROMPT_CONTENT)
            {
                content = "";
                contentTextInput.alpha = 1;
            }
            
            var beginIndex:int = contentTextInput.selectionBeginIndex;
            var endIndex:int = beginIndex + str.length;
            var leftStr : String = contentTextInput.text.substring(0, beginIndex);
            var rightStr : String = contentTextInput.text.substring(contentTextInput.selectionEndIndex, contentTextInput.text.length);
            str = leftStr + str + rightStr;
            contentTextInput.text = str;
            contentTextInput.stage.focus = contentTextInput;
            contentTextInput.setSelection(endIndex, endIndex);
        }

        // // // // // // // // // // // // // // // // //                 /
        // getter/setters
        // // // // // // // // // // // // // // // // //                 /
        /** 是否显示用户名输入框 */
        public function get isShowPlayerBox() : Boolean
        {
            return _isShowPlayerBox;
        }

        /**
         * @private
         */
        public function set isShowPlayerBox(value : Boolean) : void
        {
            if (value == _isShowPlayerBox) return;
            playerBox.visible = value;
            _isShowPlayerBox = value;
            // 更新 消息输入框布局
            updateContentTextInputLayout();
        }

        /*----------------------------------------*/
        /** 设置颜色 */
        public function set color(value : uint) : void
        {
            contentTextInput.textColor = value;
        }

        public function get color() : uint
        {
            return contentTextInput.textColor;
        }

        /*----------------------------------------*/
        /** 获取消息 */
        public function get content() : String
        {
            return StringUtils.trim(contentTextInput.text);
        }

        /** 设置消息 */
        public function set content(str : String) : void
        {
            contentTextInput.text = str;
        }

        /*----------------------------------------*/
        /** 获取玩家名称 */
        public function get playerName() : String
        {
            return playerBox.playerName;
        }

        /** 设置玩家名称 */
        public function set playerName(name : String) : void
        {
            playerBox.playerName = name;
        }

        /** 获取玩家服务器Id */
        public function get serverId() : int
        {
            return playerBox.serverId;
        }

        /** 设置玩家服务器Id */
        public function set serverId(id : int) : void
        {
            playerBox.serverId = id;
        }
    }
}
import com.utils.DrawUtils;
import com.utils.StringUtils;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.ui.Keyboard;
import game.module.chat.EventChat;
import game.module.chat.view.MsgTextInput;
import game.module.chat.view.PlayerList;
import gameui.controls.GButton;
import gameui.core.GComponent;
import gameui.core.GComponentData;
import gameui.data.GButtonData;
import gameui.manager.UIManager;
import net.AssetData;





class PlayerBox extends GComponent
{
    /** 用户选择按钮 */
    public var playerSelectButton : GButton;
    /** 服务器Id 背景 */
    public var serverIdBg : Sprite;
    /** 服务器Id Label */
    public var serverIdLabel : TextField;
    /** 用户名输入框 */
    public var playerTextInput : TextField;
    /** 用户弹出列表 */
    public var poupList : PlayerList;
    public var gap : uint = 2;
    private var _isShowSeverId : Boolean = false;
    public var TEXT_INTPU_PROMPT : String = MsgTextInput.TEXT_INTPU_PROMPT_PLAYER;

    function PlayerBox(width : uint, height : uint) : void
    {
        _base = new GComponentData();
        _base.width = width;
        _base.height = height;
        super(_base);

        playerTextInput.addEventListener(FocusEvent.FOCUS_OUT, textInput_focusOutHandler);
        playerTextInput.addEventListener(FocusEvent.FOCUS_IN, textInput_focusInHandler);
        playerSelectButton.addEventListener(MouseEvent.CLICK, playerSelectButton_clickHandler);
        this.addEventListener(MouseEvent.MOUSE_DOWN, eventStopPropagation);
    }

    /** 阻止事件流传递 */
    protected function eventStopPropagation(event : MouseEvent) : void
    {
        event.stopPropagation();
    }

    private function playerSelectButton_clickHandler(event : MouseEvent) : void
    {
        if (poupList == null)
        {
            var globalPoint : Point = playerSelectButton.localToGlobal(new Point(0, 0));
            poupList = new PlayerList(this.stage, globalPoint);
            poupList.addEventListener(EventChat.SELECTED_PLAYER, poupList_selectedPlayerHandler);
        }
        poupList.isOpen = !poupList.isOpen;
    }

    private function poupList_selectedPlayerHandler(event : EventChat) : void
    {
        // 抛出事件
        var eventChat : EventChat = new EventChat(EventChat.SELECTED_PLAYER, true);
        eventChat.playerName = event.playerName;
        dispatchEvent(eventChat);
    }

    private function textInput_focusInHandler(event : FocusEvent) : void
    {
        if (playerName == TEXT_INTPU_PROMPT)
        {
            playerName = "";
            playerTextInput.alpha = 1;
        }
    }

    private function textInput_focusOutHandler(event : FocusEvent) : void
    {
        if (playerName == "")
        {
            playerName = TEXT_INTPU_PROMPT;
            playerTextInput.alpha = 0.7;
        }
    }

    /** 初始化视图 */
    override protected function create() : void
    {
        // 用户选择按钮
        var buttonData : GButtonData = new GButtonData();
        buttonData.width = 16;
        buttonData.height = 24;
        buttonData.y = (this.height - buttonData.height) / 2;
        buttonData.upAsset = new AssetData("PoupListButtonSkin_Up");
        buttonData.overAsset = new AssetData("PoupListButtonSkin_Over");
        buttonData.downAsset = new AssetData("PoupListButtonSkin_Down");
        buttonData.disabledAsset = new AssetData("PoupListButtonSkin_Disable");
        playerSelectButton = new GButton(buttonData);
        addChild(playerSelectButton);

        // 服务器Id 背景
        serverIdBg = DrawUtils.roundRect(null, 25, 14, 1, 5, 0x5aaae8, 0x075d9f, 0.5, 1) as Sprite;
        serverIdBg.x = buttonData.width + gap;
        serverIdBg.y = (this.height - 14) / 2;
        serverIdBg.visible = isShowSeverId;
        addChild(serverIdBg);
        // 服务器Id Label
        serverIdLabel = new TextField();
        serverIdLabel.width = 25;
        serverIdLabel.height = 16;
        serverIdLabel.x = 0;
        serverIdLabel.y = 0;
        serverIdLabel.selectable = false;
        var textFormat : TextFormat = new TextFormat();
        textFormat.align = TextFormatAlign.CENTER;
        textFormat.font = UIManager.defaultFont;
        textFormat.size = 11;
        textFormat.color = 0x013c6d;
        serverIdLabel.defaultTextFormat = textFormat;
        serverIdBg.addChild(serverIdLabel);
        serverIdLabel.text = "123";
        // 用户名输入框
        textFormat = new TextFormat();
        textFormat.font = UIManager.defaultFont;
        textFormat.size = 12;
        textFormat.color = 0x113041;
        playerTextInput = new TextField();
        playerTextInput.x = playerSelectButton.width + gap;
        playerTextInput.y = 2;
        playerTextInput.width = this.width - playerTextInput.x;
        playerTextInput.height = this.height;
        playerTextInput.defaultTextFormat = textFormat;
        playerTextInput.maxChars = 20;
        playerTextInput.type = TextFieldType.INPUT;
        // playerTextInput.filters = [FilterUtils.defaultTextEdgeFilter];
        addChild(playerTextInput);
        playerTextInput.text = TEXT_INTPU_PROMPT;
        playerTextInput.alpha = 0.7;

        // 分隔线
        var line : DisplayObject = DrawUtils.roundRect(null, 3, 25, 1, 0, 0x8a8a6f, 0x254e6d, 1, 1);
        if (line)
        {
            line.x = this.width - 3;
            line.y = -3;
            addChild(line);
        }
    }

    /** 布局 */
    override protected function layout() : void
    {
        serverIdBg.visible = isShowSeverId;
        if (isShowSeverId = true)
        {
            playerTextInput.x = serverIdBg.x + 25 + gap;
            playerTextInput.width = this.width - playerTextInput.x;
        }
        else
        {
            playerTextInput.x = playerSelectButton.width + gap;
            playerTextInput.width = this.width - playerTextInput.x;
        }
    }

    public function get isShowSeverId() : Boolean
    {
        return _isShowSeverId;
    }

    public function set isShowSeverId(value : Boolean) : void
    {
        if (_isShowSeverId == value) return;
        _isShowSeverId = value;
        layout();
    }

    public function get playerName() : String
    {
        return StringUtils.trim(playerTextInput.text);
    }

    public function set playerName(name : String) : void
    {
        playerTextInput.text = name;
    }

    public function get serverId() : int
    {
        return parseInt(serverIdLabel.text);
    }

    public function set serverId(serverId : int) : void
    {
        serverIdLabel.text = serverId.toString();
    }
}
class ContentCache
{
    public var contents : Vector.<String> = new Vector.<String>();
    public var max : uint = 1;
    public var index : int = 0;
    public var textInput : TextField;

    function ContentCache(textInput : TextField) : void
    {
        this.textInput = textInput;
        if (textInput)
        {
            textInput.addEventListener(KeyboardEvent.KEY_DOWN, textInput_keyDownHandler);
        }
    }

    private function textInput_keyDownHandler(event : KeyboardEvent) : void
    {
        var content : String;
        if (event.keyCode == Keyboard.UP)
        {
            index--;
            if (index < 0)
            {
                index = contents.length - 1;
            }

            if (index >= 0 && index < contents.length)
            {
                content = contents[index];
                textInput.text = content;
            }
        }
        else if (event.keyCode == Keyboard.DOWN)
        {
            index++;
            if (index >= contents.length)
            {
                index = 0;
            }

            if (index >= 0 && index < contents.length)
            {
                content = contents[index];
                textInput.text = content;
            }
        }
    }

    public function push(str : String) : void
    {
        if (str == MsgTextInput.TEXT_INTPU_PROMPT_CONTENT) return;
        while (contents.length > max)
        {
            contents.shift();
        }

        if (contents.length == 0 || contents.indexOf(str) != (contents.length - 1))
        {
            if (contents.indexOf(str) != -1)
            {
                contents.splice(contents.indexOf(str), 1);
            }

            contents.push(str);
            index = 0;
        }
    }
}