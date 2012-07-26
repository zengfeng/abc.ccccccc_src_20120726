package game.module.friend.view
{
	import game.core.user.StateManager;
	import game.manager.ViewManager;
	import game.net.core.Common;
	import game.net.data.StoC.SCContactList;

	import gameui.containers.GViewStack;
	import gameui.core.GComponentData;
	import gameui.data.GTitleWindowData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.GCommonSmallWindow;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;





	/**
	 * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-3  ����7:57:44 
	 */
	public class FriendSearchView extends GCommonSmallWindow
	{
		public static const NAME : String = "FriendSearchView";
		public static const OK : String = "ok";
		/** 步骤1 */
		private var _step1Panel : Step1Panel;
		/** 步骤2 */
		private var _step2Panel : Step2Panel;
		/** 切换组件 */
		private var viewStack : GViewStack;

		function FriendSearchView() : void
		{
			this.name = NAME;
			_data = new GTitleWindowData();
			_data.width = 250;
			_data.height = 117;
			_data.parent = UIManager.root;
			_data.modal = false;
			_data.allowDrag = false;
			_data.parent = ViewManager.instance.uiContainer;

			// 添加背景
			var bg : Sprite = UIManager.getUI(new AssetData("common_background_02"));
			bg.x = 5;
			bg.y = 0;
			bg.width = 240;
			bg.height = 112;
			addChild(bg);

			initData();
			super(_data);
			initEvents();
			sToC();
		}

		private var _defaultPostion : Point;

		/** 默认位置 */
		public function get defaultPostion() : Point
		{
			if (_defaultPostion) return _defaultPostion;
			if (ViewManager.instance.uiContainer.stage == null) return null;
			var displayObject : DisplayObject = ViewManager.instance.uiContainer.getChildByName(FriendView.NAME);
			var displayObject2 : DisplayObject = ViewManager.instance.uiContainer.getChildByName(FriendCreateGroupView.NAME);
			_defaultPostion = new Point();
			if (displayObject.x > ViewManager.instance.uiContainer.stage.stageWidth / 2)
			{
				_defaultPostion.x = displayObject.x - this.width - 20;
				if (displayObject2)
				{
					_defaultPostion.x -= displayObject2.width + 20;
				}
			}
			else
			{
				_defaultPostion.x = displayObject.x + displayObject.width + 20;
				if (displayObject2)
				{
					_defaultPostion.x += displayObject2.width + 20;
				}
			}

			_defaultPostion.y = displayObject.y + (displayObject.height - this.height) / 2;
			return _defaultPostion;
		}

		/** 移动到默认位置 */
		public function moveToDefaultPostion() : void
		{
			// _defaultPostion = null;
			// this.x = defaultPostion.x;
			// this.y = defaultPostion.y;
			this.x = (UIManager.stage.stageWidth - this.width) / 2;
			this.y = (UIManager.stage.stageHeight - this.height) / 2;
		}

		/** 初始化视图 */
		override protected function initViews() : void
		{
			super.initViews();
			// title = "添加知己";
			title = "添加好友";
			this.x = ViewManager.instance.uiContainer.stage.stageWidth - _base.width - 740;
			this.y = 35;
			// 切换组件
			var componentData : GComponentData = new GComponentData();
			viewStack = new GViewStack(componentData);

			// 步骤1
			componentData = new GComponentData();
			componentData.x = 32;
			componentData.y = 5;
			componentData.width = _base.width - componentData.x * 2;
			componentData.height = _base.height - componentData.y;
			_step1Panel = new Step1Panel(componentData);
			viewStack.add(_step1Panel);
			// 步骤2
			_step2Panel = new Step2Panel(componentData);
			viewStack.add(_step2Panel);

			viewStack.selectionModel.index = 0;
			addChild(viewStack);
		}

		/** 初始化事件（添加事件监听） */
		private function initEvents() : void
		{
		}

		/** 协议监听 */
		private function sToC() : void
		{
			// 协议监听 -- 通过名字添加好友
//			Common.game_server.addCallback(0x44, sc_FollowName);
			Common.game_server.addCallback(0x41, sc_FollowName);
		}

		/** 协议监听 -- 通过名字添加好友 */
		private function sc_FollowName(message : SCContactList) : void
		{
			message;
			if( message.hasOperation && message.operation == 1 )
			{
//				StateManager.instance.checkMsg(71);
				hide();
			}
		}

		private function cancelButton_clickHandler(event : MouseEvent) : void
		{
			this.hide();
		}

		override public function show() : void
		{
			// 协议监听 -- 通过名字添加好友
			Common.game_server.addCallback(0x41, sc_FollowName);
			_step1Panel.addEventListener(OK, function(event : Event) : void
			{
				viewStack.selectionModel.index = 1;
			});
			_step2Panel.addEventListener(OK, function(event : Event) : void
			{
				viewStack.selectionModel.index = 0;
			});
			_step1Panel.cancelButton.addEventListener(MouseEvent.CLICK, cancelButton_clickHandler);
			moveToDefaultPostion();
			super.show();
			// 更新数据
			_step1Panel.updateView();
			if (_step1Panel.stage)
			{
				_step1Panel.stage.focus = _step1Panel.textInput.textField;
			}
		}

		override public function hide() : void
		{
			// if (_step1Panel.promptTip) _step1Panel.promptTip.hide();
			// 协议监听 -- 通过名字添加好友
			Common.game_server.removeCallback(0x41, sc_FollowName);
			_step1Panel.removeEventListener(OK, function(event : Event) : void
			{
				viewStack.selectionModel.index = 1;
			});
			_step2Panel.removeEventListener(OK, function(event : Event) : void
			{
				viewStack.selectionModel.index = 0;
			});
			_step1Panel.cancelButton.removeEventListener(MouseEvent.CLICK, cancelButton_clickHandler);
			super.hide();

			delete this;
		}
	}
}
import game.module.friend.CheckAddFriend;
import game.module.friend.ModelFriend;
import game.module.friend.ProtoCtoSFriend;
import game.module.friend.view.FriendSearchView;

import gameui.controls.GButton;
import gameui.controls.GComboBox;
import gameui.controls.GTextInput;
import gameui.core.GComponent;
import gameui.core.GComponentData;
import gameui.data.GButtonData;
import gameui.data.GComboBoxData;
import gameui.data.GTextInputData;

import com.utils.LabelUtils;
import com.utils.StringUtils;

import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.text.TextField;




/** 步骤1面板 */
class Step1Panel extends GComponent
{
	/** 数量提示Label */
	public var numPromptLabel : TextField;
	/** 友情提示Label */
	public var friendshipPromptLabel : TextField;
	/** 输入框 */
	public var textInput : GTextInput;
	/** 确定按钮 */
	public var okButton : GButton;
	/** 取消按钮 */
	public var cancelButton : GButton;
	/** 请输入玩家名 */
	public const PROMPT_PLEASE_INPUT_NAME : String = "请输入对方名字";
	/** 当前知己数量 `Count`/`Max` */
	public const PROMPT_CURRENT_FRIEND_COUNT : String = "当前好友数量: `Count`/`Max`";

	function Step1Panel(base : GComponentData) : void
	{
		super(base);
		initViews();
		updateView();
		initEvents();
	}

	/** 初始化视图 */
	protected function initViews() : void
	{
		// 数量提示Label
		numPromptLabel = LabelUtils.createPrompt1();
		numPromptLabel.filters = null;
		numPromptLabel.textColor = 0x3C3424;
		numPromptLabel.mouseEnabled = false;
		numPromptLabel.width = _base.width;
		numPromptLabel.text = "当前好友数量: 1/30";
		addChild(numPromptLabel);

		// 输入框
		var textInputData : GTextInputData = new GTextInputData();
		textInputData.x = 18;
		textInputData.y = numPromptLabel.textHeight + 9;
		textInputData.width = 150;
		textInputData.hintText = "请输入对方名字";
		textInputData.maxChars = 12;
		textInput = new GTextInput(textInputData);
		addChild(textInput);

		// 友情提示Label
		friendshipPromptLabel = LabelUtils.createPrompt2();
		friendshipPromptLabel.width = _base.width;
		friendshipPromptLabel.y = textInputData.y + textInputData.height + 5;
		friendshipPromptLabel.text = "友情提示:知己升级后可获得礼包（互为知已）";
		// 不显示友情提示
		// addChild(friendshipPromptLabel);

		// 确定按钮
		var buttonData : GButtonData = new GButtonData();
		buttonData.width = 80;
		buttonData.height = 30;
		buttonData.x = -1;
		buttonData.y = _base.height - buttonData.height - 22;
		buttonData.labelData.text = "添加";
		okButton = new GButton(buttonData);
		addChild(okButton);

		// 取消按钮
		buttonData.x = _base.width / 2 + 14;
		buttonData.labelData.text = "取消";
		cancelButton = new GButton(buttonData);
		addChild(cancelButton);
	}

	/** 更新视图 */
	public function updateView() : void
	{
		// 当前知己数量 `Count`/`Max`
		var str : String = PROMPT_CURRENT_FRIEND_COUNT;
		str = str.replace(/`Count`/, ModelFriend.instance.friendCount);
		str = str.replace(/`Max`/, ModelFriend.instance.friendMax);
		numPromptLabel.text = str;
	}

	/** 初始化事件（添加事件监听） */
	private function initEvents() : void
	{
		/** 确定按钮点击事件 */
		okButton.addEventListener(MouseEvent.CLICK, okButton_clickHandler);
		// 输入框 -- 获取焦点事件
		textInput.textField.addEventListener(FocusEvent.FOCUS_IN, textInput_focusInHandler);
		// 输入框 -- 失去焦点事件
		textInput.textField.addEventListener(FocusEvent.FOCUS_OUT, textInput_focusOutHandler);
		// 输入框 -- 按下键事件
		textInput.textField.addEventListener(KeyboardEvent.KEY_DOWN, textInput_keyDownHandler);
	}

	/** 输入框 -- 获取焦点事件 */
	private function textInput_focusInHandler(event : FocusEvent) : void
	{
		// if (promptTip) promptTip.hide();
		// if (textInput.textField.text == PROMPT_PLEASE_INPUT_NAME)
		// {
		// textInput.textField.text = "";
		// }
		// textInput.textField.textColor = TextFormatUtils.textInputNormal.color as uint;
	}

	/** 输入框 -- 失去焦点事件 */
	private function textInput_focusOutHandler(event : FocusEvent) : void
	{
		// if (!textInput.textField.text || StringUtils.trim(textInput.textField.text) == "")
		// {
		// textInput.textField.text = PROMPT_PLEASE_INPUT_NAME;
		//			//  textInput.textField.textColor = TextFormatUtils.textInputPrompt.color as uint;
		// }
		// check();
	}

	/** 输入框 -- 按下键事件 */
	private function textInput_keyDownHandler(event : KeyboardEvent) : void
	{
		// if (event.keyCode == Keyboard.ENTER)
		// {
		//			//  发送到服务器 -- 通过名字添加好友
		// cs_FollowName();
		// }
	}

	/** 确定按钮点击事件 */
	private function okButton_clickHandler(event : MouseEvent) : void
	{
		if (CheckAddFriend.check(textInput.text) == false)
		{
			return;
		}
		else
		{
			// 其余的滚屏交由服务器来处理
			// 发送到服务器 -- 通过名字添加好友
			cs_FollowName();
		}
	}

	/** 发送到服务器 -- 通过名字添加好友 */
	private function cs_FollowName() : void
	{
		if (check() == false) return;
		var playerName : String = StringUtils.trim(textInput.text);

		ProtoCtoSFriend.instance.cs_FollowName(playerName);
	}

	// public var promptTip : PromptTip;
	/** 验证 */
	private function check() : Boolean
	{
		var isOk : Boolean = true;
		if (textInput.text == PROMPT_PLEASE_INPUT_NAME || StringUtils.trim(textInput.text) == "")
		{
			var postion : Point = this.localToGlobal(new Point(150, -50));
			// if (promptTip == null)
			// {
			// promptTip = PromptTip.showTip(postion, PROMPT_PLEASE_INPUT_NAME);
			// }
			// else
			// {
			// promptTip.showTip(postion, PROMPT_PLEASE_INPUT_NAME);
			// }

			isOk = false;
		}

		return isOk;
	}
}
/** 步骤2面板 */
class Step2Panel extends GComponent
{
	/** 提示Label */
	private var _promptLabel : TextField;
	/** 下拉框 */
	private var _comboBox : GComboBox;
	/** 确定按钮 */
	private var _okButton : GButton;

	function Step2Panel(base : GComponentData) : void
	{
		super(base);
		initViews();
		initEvents();
	}

	protected function initViews() : void
	{
		// 提示Label
		_promptLabel = LabelUtils.createPrompt1();
		_promptLabel.width = _base.width;
		_promptLabel.text = "你想添加为知己的哪一位";
		addChild(_promptLabel);
		// 下拉框
		var comboBoxData : GComboBoxData = new GComboBoxData();
		comboBoxData.y = _promptLabel.textHeight + 5;
		comboBoxData.width = _base.width;
		_comboBox = new GComboBox(comboBoxData);
		addChild(_comboBox);
		// 确定按钮
		var buttonData : GButtonData = new GButtonData();
		buttonData.width = 50;
		buttonData.y = _base.height;
		buttonData.x = (_base.width - buttonData.width) / 2;
		buttonData.labelData.text = "确定";
		_okButton = new GButton(buttonData);
		addChild(_okButton);
	}

	/** 初始化事件（添加事件监听） */
	private function initEvents() : void
	{
		_okButton.addEventListener(MouseEvent.CLICK, okButton_clickHandler);
	}

	private function okButton_clickHandler(event : MouseEvent) : void
	{
		dispatchEvent(new Event(FriendSearchView.OK));
	}
}
