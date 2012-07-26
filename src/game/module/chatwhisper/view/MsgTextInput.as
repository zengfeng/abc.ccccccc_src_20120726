package game.module.chatwhisper.view
{
	import com.utils.StringUtils;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import game.core.user.StateManager;
	import game.module.chat.EventChat;
	import game.module.chat.config.ChatConfig;
	import game.module.chat.view.FacePanel;
	import game.module.chatwhisper.EventWhisper;
	import gameui.controls.GButton;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;
	import gameui.manager.UIManager;
	import net.AssetData;








	/**
	 * @author ZengFeng Email:zengfeng75[AT]163.com)  2011  2011-11-21 ����10:17:27
	 */
	public class MsgTextInput extends GComponent
	{
		/** 消息输入框 */
		public var contentTextInput : TextField;
		/** 发送按钮 */
		public var sendButton : GButton;
		/** 内容缓存 */
		protected var contentCache : ContentCache;
		/** 表情按钮 */
		protected var faceButton : GButton;
		/** 请输入内容 */
		public static var TEXT_INTPU_PROMPT_CONTENT : String = "请输入文字内容";

		public function MsgTextInput(base : GComponentData)
		{
			super(base);
			initViews();
			initEvents();
		}

		protected function initViews() : void
		{
			// 发送按钮

			var buttonData : GButtonData = new GButtonData();
			buttonData.x = _width - buttonData.width - 5;
			buttonData.y = _height - buttonData.height + 20;
			buttonData.width = 70;
			buttonData.height = 25;
			buttonData.labelData.text = "发送";
			sendButton = new GButton(buttonData);
			addChild(sendButton);
			// 表情按钮
			buttonData = new GButtonData();
			buttonData.width = 20;
			buttonData.height = 24;
			buttonData.x = sendButton.x - buttonData.width - 13;
			buttonData.y = _height - buttonData.height + 20;
			buttonData.upAsset = new AssetData("FaceButtonSkin_Up");
			buttonData.overAsset = new AssetData("FaceButtonSkin_Over");
			buttonData.downAsset = new AssetData("FaceButtonSkin_Down");
			faceButton = new GButton(buttonData);
			faceButton.addEventListener(MouseEvent.CLICK, faceButton_clickHandler);
			addChild(faceButton);

			// 消息输入框背景
			var textInputBg : Sprite = UIManager.getUI(new AssetData("Whisper_View_Input_Bg"));
			textInputBg.x = 0;
			textInputBg.y = 0;
			textInputBg.width = 316;
			textInputBg.height = 72;
			addChild(textInputBg);

			// 消息输入框
			var textFormat : TextFormat = new TextFormat();
			textFormat.size = 12;
			textFormat.kerning = true;
			textFormat.color = 0x2F1F00;
			contentTextInput = new TextField();
			// contentTextInput.border = true;
			// contentTextInput.borderColor =0xff0000;
			contentTextInput.defaultTextFormat = textFormat;
			contentTextInput.type = TextFieldType.INPUT;
			contentTextInput.wordWrap = true;
			contentTextInput.x = 5;
			contentTextInput.y = 2;
			contentTextInput.width = 316 - 5 * 2;
			contentTextInput.height = 72 - 2 * 2;
			addChild(contentTextInput);
			contentTextInput.text = TEXT_INTPU_PROMPT_CONTENT;
			contentTextInput.alpha = 1.0;
			// 内容缓存
			contentCache = new ContentCache(contentTextInput);
		}

		/** 添加事件监听 */
		protected function initEvents() : void
		{
			addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			contentTextInput.addEventListener(FocusEvent.FOCUS_OUT, textInput_focusOutHandler);
			contentTextInput.addEventListener(FocusEvent.FOCUS_IN, textInput_focusInHandler);
			contentTextInput.addEventListener(KeyboardEvent.KEY_UP, checkout);
			// 发送按钮点击事件
			sendButton.addEventListener(MouseEvent.CLICK, sendButton_enterHandler);
		}

		/** 发送按钮点击事件 */
		private function sendButton_enterHandler(event : Event) : void
		{
			if (contentTextInput.text == "")
			{
				StateManager.instance.checkMsg(306);
			}
			else
			{
				// 抛出发送消息事件
				dispatchEvent_SendMsg();
			}
		}

		/** 表情面板 */
		private var _facePanel : FacePanel;

		/** 表情按钮点击事件 */
		private function faceButton_clickHandler(event : MouseEvent) : void
		{
			var point : Point = faceButton.localToGlobal(new Point(0, 0));
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
				// content = TEXT_INTPU_PROMPT_CONTENT;
				content = "";
				contentTextInput.alpha = 0.7;
			}
		}

		private function keyDownHandler(event : KeyboardEvent) : void
		{
			if (event.keyCode == Keyboard.ENTER)
			{
				if (contentTextInput.text == "")
				{
					StateManager.instance.checkMsg(306);
				}
				else
				{
					// 抛出发送消息事件
					dispatchEvent_SendMsg();
				}
			}
		}

		/** 抛出发送消息事件 */
		private function dispatchEvent_SendMsg() : void
		{
			var eventWhisper : EventWhisper = new EventWhisper(EventWhisper.SEND_MSG, true);
			dispatchEvent(eventWhisper);
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
			var leftStr : String = contentTextInput.text.substring(0, contentTextInput.selectionBeginIndex);
			var rightStr : String = contentTextInput.text.substring(contentTextInput.selectionEndIndex, contentTextInput.text.length);
			str = leftStr + str + rightStr;
			contentTextInput.text = str;
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
	}
}
import flash.events.KeyboardEvent;
import flash.text.TextField;
import flash.ui.Keyboard;
import game.module.chatwhisper.view.MsgTextInput;


class ContentCache
{
	public var contents : Vector.<String> = new Vector.<String>();
	public var max : uint = 2;
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