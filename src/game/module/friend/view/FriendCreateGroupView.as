package game.module.friend.view
{
	import com.commUI.GCommonSmallWindow;
	import com.commUI.PromptTip;
	import com.utils.LabelUtils;
	import com.utils.StringUtils;
	import com.utils.TextFormatUtils;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import game.manager.ViewManager;
	import game.module.friend.EventFriend;
	import game.module.friend.ModelFriend;
	import game.module.friend.ProtoCtoSFriend;
	import gameui.controls.GButton;
	import gameui.controls.GTextInput;
	import gameui.data.GButtonData;
	import gameui.data.GTextInputData;
	import gameui.data.GTitleWindowData;
	import gameui.manager.UIManager;











    /**
     * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-3  ����9:43:15 
     */
    public class FriendCreateGroupView extends GCommonSmallWindow
    {
		public static const NAME:String = "FriendCreateGroupView";
        /** 提示Label */
        private var _promptLabel:TextField;
        /** 输入框 */
        private var _textInput:GTextInput;
        /** 确定按钮 */
        private var _okButton:GButton;
        /** 取消按钮 */
        private var _cancelButton:GButton;
        
        public function FriendCreateGroupView()
        {
            this.name = NAME;
            _data = new GTitleWindowData();
            _data.width = 300;
            _data.height = 150;
            _data.parent = UIManager.root;
			_data.modal = false;
            _data.allowDrag = false;
            initData();
            super(_data);
            initEvents();
        }
		
        private var _defaultPostion:Point;
		/** 默认位置 */
		public function get defaultPostion():Point
		{
			if(_defaultPostion) return _defaultPostion;
			if(ViewManager.instance.uiContainer.stage == null) return null;
            var displayObject:DisplayObject = ViewManager.instance.uiContainer.getChildByName(FriendView.NAME);
            var displayObject2:DisplayObject = UIManager.root.getChildByName(FriendSearchView.NAME);
			_defaultPostion = new Point();
            if(displayObject.x > ViewManager.instance.uiContainer.stage.stageWidth / 2)
            {
                _defaultPostion.x = displayObject.x - this.width - 20;
                if(displayObject2)
                {
                    _defaultPostion.x -= displayObject2.width + 20;
                }
            }
            else
            {
                _defaultPostion.x = displayObject.x + displayObject.width + 20; 
                if(displayObject2)
                {
                    _defaultPostion.x += displayObject2.width + 20;
                }
            }
            
            _defaultPostion.y = displayObject.y + (displayObject.height - this.height) / 2; 
            
            
			return _defaultPostion;
		}
		/** 移动到默认位置 */
        public function moveToDefaultPostion():void
        {
//            _defaultPostion = null;
//			this.x = defaultPostion.x;
//			this.y = defaultPostion.y;
			this.x = (UIManager.stage.stageWidth - this.width) / 2;
			this.y = (UIManager.stage.stageHeight - this.height) / 2;
        }
            
        override protected function initViews() : void
        {
			super.initViews();
            title = "创建分组";
            
            //提示Label
            _promptLabel = LabelUtils.createPrompt1();
            _promptLabel.x = 15;
            _promptLabel.y = 50;
            _promptLabel.width = _base.width - _promptLabel.x * 2;
            _promptLabel.text = "组名:";
            addChild(_promptLabel);
            
            //输入框
            var textInputData:GTextInputData = new GTextInputData();
            textInputData.x = 15;
            textInputData.y = 70;
            textInputData.width = _base.width - textInputData.x * 2;
            _textInput = new GTextInput(textInputData);
            addChild(_textInput);
            
            //确定按钮
            var buttonData:GButtonData = new GButtonData();
            buttonData.width = 50;
            buttonData.y = 100;
            buttonData.x = _base.width /2 - buttonData.width - 5;
            buttonData.labelData.text = "确定";
            _okButton = new GButton(buttonData);
            addChild(_okButton);
            
            //取消按钮
            buttonData.x = _base.width /2 + 5;
            buttonData.labelData.text = "取消";
            _cancelButton = new GButton(buttonData);
            addChild(_cancelButton);
        }
        
        /** 协议发送 */
        private function cs_AddFriendGrp(event:Event = null):void
        {
			//验证
			if(check() == false)
			{
				return ;
			}
			
            // 向服务器发送协议 -- 新增好友组
            var groupName:String = StringUtils.trim(_textInput.text);
//            ProtoCtoSFriend.instance.cs_AddFriendGrp(groupName);
        }
		private var promptTip:PromptTip;
		
		/** 验证 */
		private function check():Boolean
		{
			var isOk:Boolean = true;
			if(_textInput.text == TEXT_INTPU_PROMPT || StringUtils.trim(_textInput.text) == "")
			{
				var postion:Point = this.localToGlobal(new Point(100, 0));
				if(promptTip == null)
				{
					promptTip = PromptTip.showTip(postion,TEXT_INTPU_PROMPT );
				}
				else
				{
					promptTip.showTip(postion, TEXT_INTPU_PROMPT);
				}
					
				isOk = false;
			}
					
			return isOk;
		}
        
        /** 初始化事件（添加事件监听） */
        private function initEvents() : void
        {
        }


        private function textInput_keyDownHandler(event : KeyboardEvent) : void
        {
            if(event.keyCode == Keyboard.ENTER)
            {
                cs_AddFriendGrp();
            }
        }
        
        private function cancelButton_clickHandler(event : MouseEvent) : void
        {
            this.hide();
        }
        
        private const TEXT_INTPU_PROMPT:String = "请输入组名"; 
        private function textInput_focusInHandler(event : FocusEvent) : void
        {
			if(promptTip) promptTip.hide();
            if(_textInput.textField.text == TEXT_INTPU_PROMPT)
            {
           		_textInput.textField.text = "";
            }
            _textInput.textField.textColor = TextFormatUtils.textInputNormal.color as uint;
        }

        private function textInput_focusOutHandler(event : FocusEvent) : void
        {
            if(!_textInput.textField.text || StringUtils.trim(_textInput.textField.text) == "")
            {
           		_textInput.textField.text = TEXT_INTPU_PROMPT;
            	_textInput.textField.textColor = TextFormatUtils.textInputPrompt.color as uint;
            }
			
			check();
        }
        
        /** 数据模型 -- 添加好友事件 */
        private function modelFriend_addGroupHandler(event:EventFriend = null):void
        {
            hide();
        }
        
        
        override public function show():void
        {
            _okButton.addEventListener(MouseEvent.CLICK, cs_AddFriendGrp);
            _cancelButton.addEventListener(MouseEvent.CLICK, cancelButton_clickHandler);
            _textInput.textField.addEventListener(FocusEvent.FOCUS_IN, textInput_focusInHandler);
            _textInput.textField.addEventListener(FocusEvent.FOCUS_OUT, textInput_focusOutHandler);
            _textInput.textField.addEventListener(KeyboardEvent.KEY_DOWN, textInput_keyDownHandler);
            //数据模型 -- 添加好友事件
            ModelFriend.instance.addEventListener(EventFriend.ADD_GROUP, modelFriend_addGroupHandler);
//            _textInput.textField.text = TEXT_INTPU_PROMPT;
//            _textInput.textField.textColor = TextFormatUtils.textInputPrompt.color as uint;
			moveToDefaultPostion();
            super.show();
            if(_textInput.stage)
            {
                _textInput.stage.focus = _textInput.textField;
            }
        }
        
        override public function hide():void
        {
			
			if(promptTip) promptTip.hide();
            //数据模型 -- 添加好友事件
            ModelFriend.instance.removeEventListener(EventFriend.ADD_GROUP, modelFriend_addGroupHandler);
            _okButton.removeEventListener(MouseEvent.CLICK, cs_AddFriendGrp);
            _cancelButton.removeEventListener(MouseEvent.CLICK, cancelButton_clickHandler);
            _textInput.textField.removeEventListener(FocusEvent.FOCUS_IN, textInput_focusInHandler);
            _textInput.textField.removeEventListener(FocusEvent.FOCUS_OUT, textInput_focusOutHandler);
            _textInput.textField.removeEventListener(KeyboardEvent.KEY_DOWN, textInput_keyDownHandler);
            super.hide();
            delete this;
        }
            
    }
}
