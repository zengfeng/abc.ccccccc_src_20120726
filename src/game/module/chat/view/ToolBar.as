package game.module.chat.view
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import game.module.chat.EventChat;
    import gameui.controls.GButton;
    import gameui.data.GButtonData;
    import net.AssetData;




    /**
     * 工具栏
     * */
    public class ToolBar extends Sprite
    {
        /** GM按钮 */
        private var _gmButton : GButton;
        // /** 颜色按钮 */
        // private var _colorButton:GButton;
        /** 表情按钮 */
        private var _faceButton : GButton;
        private var gap : uint = 2;

        public function ToolBar()
        {
            // 初始化子组件
            installChild();
            // 布局
            layout();
        }

        /** 初始化子组件 */
        protected function installChild() : void
        {
            var buttonData : GButtonData = new GButtonData();
			buttonData.y = 2;
            buttonData.width = 20;
            buttonData.height = 21;
            // GM按钮
            buttonData.upAsset = new AssetData("GMButtonSkin_Up");
            buttonData.overAsset = new AssetData("GMButtonSkin_Over");
            buttonData.downAsset = new AssetData("GMButtonSkin_Down");
            _gmButton = new GButton(buttonData);
            _gmButton.addEventListener(MouseEvent.CLICK, clearButton_clickHandler);
//            addChild(_gmButton);
            //			// 颜色按钮
            // buttonData = buttonData.clone();
            // buttonData.upAsset = new AssetData("ColorButtonSkin_Up");
            // buttonData.overAsset = new AssetData("ColorButtonSkin_Over");
            // buttonData.downAsset = new AssetData("ColorButtonSkin_Down");
            // _colorButton = new GButton(buttonData);
            // _colorButton.addEventListener(MouseEvent.CLICK, colorButton_clickHandler);
            // addChild(_colorButton);
            // 表情按钮
            buttonData = buttonData.clone();
			buttonData.y = 0;
            buttonData.width = 20;
            buttonData.height = 24;
            buttonData.upAsset = new AssetData("FaceButtonSkin_Up");
            buttonData.overAsset = new AssetData("FaceButtonSkin_Over");
            buttonData.downAsset = new AssetData("FaceButtonSkin_Down");
            _faceButton = new GButton(buttonData);
            _faceButton.addEventListener(MouseEvent.CLICK, faceButton_clickHandler);
            addChild(_faceButton);
        }

        /** 布局 */
        protected function layout() : void
        {
            var postionX : uint = 0;
            for (var i : int = 0; i < numChildren; i++)
            {
                var button : DisplayObject = getChildAt(i);
                if (button)
                {
                    button.x = postionX;
                    postionX += button.width + gap;
                }
            }
        }

        // /** 颜色面板 */
        // private var _colorPanel:ColorPanel;
        // /** 颜色按钮点击事件 */
        // private function colorButton_clickHandler(event:MouseEvent):void
        // {
        // var point:Point = _colorButton.localToGlobal(new Point(0, 0));
        // if(_colorPanel == null)
        // {
        // _colorPanel = new ColorPanel(this.stage, point);
        // _colorPanel.addEventListener(ChatEvent.SELECTED_COLOR, colorPanel_selectedColorHandler);
        // }
        // _colorPanel.globalPoint = point;
        // _colorPanel.isOpen = !_colorPanel.isOpen;
        // }
        //
        // private function colorPanel_selectedColorHandler(event:ChatEvent):void
        // {
        // var e:ChatEvent = new ChatEvent(ChatEvent.SELECTED_COLOR);
        // e.data = event.data;
        // dispatchEvent(e);
        // }

        private function clearButton_clickHandler(event : MouseEvent = null) : void
        {
            var eventChat : EventChat = new EventChat(EventChat.CLEAR_MSG, true);
            dispatchEvent(eventChat); 
        }
        
        /** 表情面板 */
        private var _facePanel : FacePanel;

        /** 表情按钮点击事件 */
        private function faceButton_clickHandler(event : MouseEvent) : void
        {
            var point : Point = _faceButton.localToGlobal(new Point(0, 0));
            if (_facePanel == null)
            {
                _facePanel = new FacePanel(this.stage, point);
                _facePanel.addEventListener(EventChat.SELECTED_FACE, selectedFaceHandler);
            }
            _facePanel.globalPoint = point;
            _facePanel.isOpen = !_facePanel.isOpen;
        }

        /** 选择面情 */
        private function selectedFaceHandler(event : EventChat) : void
        {
            var eventChat : EventChat = new EventChat(EventChat.SELECTED_FACE, true);
            eventChat.faceId = event.faceId;
            dispatchEvent(eventChat);
        }

        // /** 颜色面板 */
        // public function get colorPanel():ColorPanel
        // {
        // return _colorPanel;
        // }
        /** 表情面板 */
        public function get facePanel() : FacePanel
        {
            return _facePanel;
        }
    }
}