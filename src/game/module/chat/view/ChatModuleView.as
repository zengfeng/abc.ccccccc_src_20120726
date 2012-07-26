package game.module.chat.view
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import game.manager.ViewManager;
    import game.module.chat.ControllerChat;
    import game.module.chat.ManagerChat;
    import gameui.controls.GButton;
    import gameui.core.GComponent;
    import gameui.core.GComponentData;
    import gameui.data.GButtonData;
    import gameui.manager.UIManager;
    import net.AssetData;
    
    
    

    /**
     * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-14  ����9:52:01 
     */
    public class ChatModuleView extends GComponent
    {
        /** 公告栏 */
        public var boxNotic : BoxNotic;
        /** 输出(消息)栏 */
        public var boxOutput : BoxOutput;
        /** 输入(消息)栏 */
        public var boxInput : BoxInput;
        /** 工具栏 */
        public var barTool : ToolBar;
        /** 拉大拉小按钮 */
        public var sizeButton : GButton;
        /** 拉大拉小显示区块 */
        protected var sizeBox : Sprite;
        /** 私聊还原按钮 */
        public var whisperRRestoreButton : GButton;
        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        /* 默认宽高  */
//        public var defaultWidth : Number = 800;
//        public var defaultHeight : Number = 800;
		public var defaultWidth : Number = 406;
		public var defaultHeight : Number = 245;
        /* 最小宽高  */
        public var minWidth : Number = 300;
        public var minHeight : Number = 250;
        /* 最大宽高  */
		public var maxWidth : Number = 600;
		public var maxHeight : Number = 500;
        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        /** 控制器 */
        public var controller : ControllerChat ;

        public function ChatModuleView()
        {
            _base = new GComponentData();
            _base.width = defaultWidth;
            _base.height = defaultHeight;
            _base.x = 0;
            _base.y = UIManager.stage.stageHeight - _base.height;
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
            controller.boxNotic = boxNotic;
            controller.boxOutput = boxOutput;
            controller.toolBar = boxOutput.toolBar;
            controller.view = this;
        }

        /** 初始化视图 */
        override protected function create() : void
        {
            super.create();
            // 输入(消息)栏
            boxInput = new BoxInput();
            boxInput.width = this.width;
            boxInput.x = 0;
            boxInput.y = this.height - boxInput.height;
            addChild(boxInput);
            // 公告区块
            boxNotic = new BoxNotic();
            boxNotic.y = 0;
            addChild(boxNotic);

            // 输出(消息)栏
            boxOutput = new BoxOutput();
            boxOutput.width = this.width;
            boxOutput.height = this.height - boxInput.height - boxNotic.height;
            boxOutput.y = boxNotic.height + 5;
            addChildAt(boxOutput, 0);

            // 拉大拉小按钮
            var buttonData : GButtonData = new GButtonData();
            buttonData.upAsset = new AssetData("DragSizeButtonSkin_Up");
            buttonData.overAsset = buttonData.upAsset;
            buttonData.downAsset = buttonData.upAsset;
            buttonData.width = buttonData.height = 12;
            buttonData.x = boxOutput.width - buttonData.width;
            buttonData.y = boxOutput.y;
            sizeButton = new GButton(buttonData);
            sizeButton.doubleClickEnabled = true;
            addChild(sizeButton);
            sizeButton.visible = false;

            // 拉大拉小显示区块
            // sizeBox = DrawUtils.roundRect(null, boxOutput.width, this.height - boxOutput.y, 0, 0, 0x000000, 0, 0.3, 0) as Sprite;
            sizeBox = UIManager.getUI(new AssetData("common_background_12"));
            sizeBox.width = boxOutput.width;
            sizeBox.height = this.height - boxOutput.y;
            sizeBox.x = boxOutput.x;
            sizeBox.y = boxOutput.y;

            // 私聊还原按钮
            buttonData = new GButtonData();
            buttonData.width = 41;
            buttonData.height = 22;
            // buttonData.upAsset = new AssetData("WhisperRestoreButtonSkin_Up");
            // buttonData.overAsset = new AssetData("WhisperRestoreButtonSkin_Over");
            // buttonData.downAsset = new AssetData("WhisperRestoreButtonSkin_Down");
            whisperRRestoreButton = new GButton(buttonData);
            addChild(whisperRRestoreButton);
            whisperRRestoreButton.visible = false;
            this.mouseEnabled = false;
            bgVisible = true;
        }

        /** 布局 */
        override protected function layout() : void
        {
            // 公告区块
            // boxNotic.width = this.width;

            // 输入(消息)栏
            boxInput.width = this.width;
            boxInput.y = this.height - boxInput.height;
            // 输出(消息)栏
            boxOutput.width = this.width;
            boxOutput.height = this.height - boxInput.height - boxNotic.height;
            boxOutput.y = boxNotic.height + 5;
            // 拉大拉小按钮
            sizeButton.x = boxOutput.width - sizeButton.width;
            sizeButton.y = boxOutput.y;
            // 私聊还原按钮
            whisperRRestoreButton.x = this.width - whisperRRestoreButton.width;
            whisperRRestoreButton.y = boxInput.y - whisperRRestoreButton.height + 5;
        }

        // ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
        protected var mX : Number;
        protected var mY : Number;
        protected var oldX : Number;
        protected var oldY : Number;
        protected var offestX : Number;
        protected var offestY : Number;

        /** 添加事件监听 */
        protected function initEvents() : void
        {
            /** 拉大拉小按钮 鼠标按下事件 */
            // sizeButton.addEventListener(MouseEvent.MOUSE_DOWN, sizeButton_mouseDownHandler);
            // sizeButton.addEventListener(MouseEvent.DOUBLE_CLICK, sizeButton_doubleClickHandler);
            sizeButton.addEventListener(MouseEvent.CLICK, sizeButton_clickHandler);
            UIManager.stage.addEventListener(Event.RESIZE, stage_resizeHandler);
//            this.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
//            this.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
        }

        private function onMouseOut(event : MouseEvent) : void
        {
            if(bgVisible == false) return;
            bgVisible = false;
        }

        private function onMouseOver(event : MouseEvent) : void
        {
            if(bgVisible == true) return;
            bgVisible = true;
        }

        private var _bgVisible : Boolean = false;

        public function get bgVisible() : Boolean
        {
            return _bgVisible;
        }

        public function set bgVisible(value : Boolean) : void
        {
            if (_bgVisible == value) return;
            _bgVisible = value;
            boxOutput.bgVisible = value;
            sizeButton.visible = value;
        }

        private function stage_resizeHandler(event : Event) : void
        {
            this.x = 0;
            this.y = UIManager.stage.stageHeight - _height;
        }

        protected function sizeButton_clickHandler(event : MouseEvent) : void
        {
            var w : uint = defaultWidth;
            var h : uint;
            // var arr : Array = [minHeight, defaultHeight, maxHeight];
            // if (arr.indexOf(this.height) == -1 || this.height == maxHeight)
            // {
            // h = defaultHeight;
            // }
            // else if (this.height == defaultHeight)
            // {
            // h = minHeight;
            // }
            // else if (this.height == minHeight)
            // {
            // h = maxHeight;
            // }
            h = this.height == defaultHeight ? maxHeight : defaultHeight;
            offestY = h - this.height;
            setSize(w, h);
            y -= offestY;
        }

        protected function sizeButton_doubleClickHandler(event : MouseEvent) : void
        {
            setSize(defaultWidth, defaultHeight);
            this.x = 0;
            this.y = this.stage.stageHeight - this.height;
        }

        protected function sizeButton_mouseDownHandler(event : MouseEvent) : void
        {
            sizeButton.removeEventListener(MouseEvent.CLICK, sizeButton_clickHandler);
            mX = stage.mouseX;
            mY = stage.mouseY;
            oldX = mX;
            oldY = mY;

            sizeBox.x = boxOutput.x;
            sizeBox.y = boxOutput.y;
            sizeBox.width = boxOutput.width;
            sizeBox.height = this.height - boxOutput.y;
            addChildAt(sizeBox, 0);

            stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
            stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
        }

        protected function stage_mouseMoveHandler(event : MouseEvent) : void
        {
            var offestX : Number = stage.mouseX - mX;
            var offestY : Number = stage.mouseY - mY;
            sizeButton.x += offestX;
            sizeButton.y += offestY;
            sizeBox.width += offestX;
            sizeBox.height -= offestY;
            sizeBox.y += offestY;
            mX = stage.mouseX;
            mY = stage.mouseY;
        }

        protected function stage_mouseUpHandler(event : MouseEvent) : void
        {
            offestX = stage.mouseX - oldX;
            offestY = stage.mouseY - oldY;
            var w : uint = width + offestX;
            var h : uint = height - offestY;
            if (w >= maxWidth) w = maxWidth;
            if (w <= minWidth) w = minWidth;
            if (h >= maxHeight) h = maxHeight;
            if (h <= minHeight) h = minHeight;
            this.y += height - h;
            setSize(w, h);
            // 拉大拉小按钮
            sizeButton.x = boxOutput.width - sizeButton.width;
            sizeButton.y = boxOutput.y;

            stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
            stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
            removeChild(sizeBox);
        }
    }
}
