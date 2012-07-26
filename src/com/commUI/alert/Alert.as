package com.commUI.alert
{
	import flash.utils.setTimeout;
	import flash.display.DisplayObjectContainer;

	import com.utils.TextFormatUtils;

	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import game.definition.UI;

	import gameui.controls.GButton;
	import gameui.controls.GCheckBox;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;
	import gameui.data.GCheckBoxData;
	import gameui.manager.UIManager;

	import net.AssetData;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2011 2011-12-20 ����2:45:29
	 */
	public class Alert extends GComponent
	{
		public static var NORMAL : int = 0;
		public static var RADIO : int = 1;
		/** 是 按钮 */
		public static var YES_TEXT : String = "是";
		/** 否 按钮 文本 */
		public static var NO_TEXT : String = "否";
		/** 确定 按钮 文本 */
		public static var OK_TEXT : String = "确认";
		/** 取消 按钮 文本 */
		public static var CANCEL_TEXT : String = "取消";
		/** 关闭 按钮 文本 */
		public static var CLOSE_TEXT : String = "关闭";
		// // // // // // // //        /
		/** 是否显示 是 按钮 */
		public static const YES : int = 2;
		/** 是否显示 否 按钮 */
		public static const NO : int = 4;
		/** 是否显示 确定 按钮 */
		public static const OK : int = 8;
		/** 是否显示 取消 按钮 */
		public static const CANCEL : int = 16;
		/** 是否显示 关闭 按钮 */
		public static const CLOSE : int = 32;
		// // // // // // // //        /
		/** 点击 是按钮 事件 */
		public static const YES_EVENT : String = "yesEvent";
		/** 点击 否按钮 事件 */
		public static const NO_EVENT : String = "noEvent";
		/** 点击 确定按钮 事件 */
		public static const OK_EVENT : String = "okEvent";
		/** 点击 取消按钮 事件 */
		public static const CANCEL_EVENT : String = "cancelEvent";
		/** 点击 取消按钮 事件 */
		public static const CLOSE_EVENT : String = "closeEvent";
		// // // // // // // //        /
		/** 关闭 按钮 */
		public var closeButton : GButton;
		/** 是 按钮 */
		public var yesButton : GButton;
		/** 否 按钮 */
		public var noButton : GButton;
		/** 确认 按钮 */
		public var okButton : GButton;
		/** 取消 按钮 */
		public var cancelButton : GButton;
		// // // // // // // //        /
		protected var bg : DisplayObject;
		protected var bodyBg : DisplayObject;
		protected var titleTF : TextField;
		protected var bodyContainer : GComponent;
		protected var buttonContainer : GComponent;
		protected var textTF : TextField;
		// // // // // // // //        /
		public static var leftPadding : int = 10;
		public static var rightPadding : int = 10;
		public static var bottomPadding : int = 15;
		public static const minWidth : int = 100;
		public static const minHeight : int = 70;
		public static var titleHeight : int = 28;
		public static var buttonContainerHeight : int = 25;
		public var buttonHGap : int = 10;
		public var callFun : Function;
		/** 是否为模态 */
		protected var _modal : Boolean = false;
		/** 是否能拖动 */
		protected var _enDrag : Boolean = true;
		public static var showedModalCount : int = 0;
		protected static var modalDisplayObject : Sprite;
		public static const MODAL_DISPLAY_OBJECT_NAME : String = "alertModal";
		protected  var preStageWH : Point = new Point();
		private static var _complexBox : GCheckBox;

		public function Alert(base : GComponentData, enDrag : Boolean = true)
		{
			_enDrag = enDrag;
			super(base);
			initViews();
			initEvents();
		}

		protected function initEvents() : void
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		private static var showAlertArr : Array = [];

		private static function addShowAlert(alert : Alert) : void
		{
			if (alert.modal)
			{
				var index : int = showAlertArr.indexOf(alert);
				if (index == -1)
				{
					showAlertArr.push(alert);
				}
				setTimeout(checkModelLayer, 1000);
			}
		}

		private static function removeShowAlert(alert : Alert) : void
		{
			if (alert.modal)
			{
				var index : int = showAlertArr.indexOf(alert);
				if (index != -1)
				{
					showAlertArr.splice(index, 1);
				}
			}
		}

		private static function checkModelLayer() : void
		{
			var parent : DisplayObjectContainer = modalDisplayObject.parent;
			if (parent && showAlertArr.length > 0)
			{
				var alert : Alert;
				alert = showAlertArr[0];
				if (alert.parent == parent)
				{
					if (parent.getChildIndex(modalDisplayObject) > parent.getChildIndex(alert))
					{
						parent.addChildAt(modalDisplayObject, parent.getChildIndex(alert));
					}
				}

				// for (var i : int = 0; i < showAlertArr.length; i++)
				// {
				// alert = showAlertArr[i];
				// if(alert.parent)
				// {
				// if(alert.parent == parent)
				// {
				// if(parent.getChildIndex(modalDisplayObject) > parent.getChildIndex(alert))
				// {
				// parent.swapChildren(modalDisplayObject, alert);
				// }
				// }
				// }
				// }
			}
		}

		private function onRemovedFromStage(event : Event) : void
		{
			if (modal) showedModalCount--;
			if (_enDrag) this.removeEventListener(MouseEvent.MOUSE_DOWN, myStartDrag);
			if (_enDrag) this.removeEventListener(MouseEvent.MOUSE_MOVE, onDraging);
			if (stage) stage.removeEventListener(Event.RESIZE, onStageResize);
			if (showedModalCount <= 0)
			{
				showedModalCount = 0;
				if (modalDisplayObject && modalDisplayObject.parent) modalDisplayObject.parent.removeChild(modalDisplayObject);
			}
			removeShowAlert(this);
		}

		private function onAddToStage(event : Event) : void
		{
			if (modal) showedModalCount++;
			if (_enDrag) this.addEventListener(MouseEvent.MOUSE_DOWN, myStartDrag);
			if (_enDrag) this.addEventListener(MouseEvent.MOUSE_MOVE, onDraging);
			if (stage)
			{
				preStageWH.x = stage.stageWidth;
				preStageWH.y = stage.stageHeight;
				stage.addEventListener(Event.RESIZE, onStageResize);
				if (modal)
				{
					if (modalDisplayObject == null)
					{
						modalDisplayObject = new Sprite();
						modalDisplayObject.name = MODAL_DISPLAY_OBJECT_NAME;
						var g : Graphics = modalDisplayObject.graphics;
						g.beginFill(0x000000, 0.1);
						g.drawRect(0, 0, 100, 100);
						g.endFill();
					}
					modalDisplayObject.width = stage.stageWidth;
					modalDisplayObject.height = stage.stageHeight;
					modalDisplayObject.x = 0;
					modalDisplayObject.y = 0;
					if (modalDisplayObject.parent == null)
					{
						this.parent.addChildAt(modalDisplayObject, this.parent.getChildIndex(this));
					}
					addShowAlert(this);
				}
			}
		}

		private function onDraging(event : MouseEvent = null) : void
		{
			if (this.x < 0) this.x = 0;
			else if (this.x > stage.stageWidth - this.width) this.x = stage.stageWidth - this.width;

			if (this.y < 0) this.y = 0;
			else if (this.y > stage.stageHeight - this.height) this.y = stage.stageHeight - this.height;
		}

		private function onStageResize(event : Event) : void
		{
			if (modalDisplayObject && modalDisplayObject.parent)
			{
				modalDisplayObject.x = 0;
				modalDisplayObject.y = 0;
				modalDisplayObject.width = modalDisplayObject.stage.stageWidth;
				modalDisplayObject.height = modalDisplayObject.stage.stageHeight;
			}

			if (stage)
			{
				this.x *= stage.stageWidth / preStageWH.x;
				this.y *= stage.stageHeight / preStageWH.y;

				onDraging();

				preStageWH.x = stage.stageWidth;
				preStageWH.y = stage.stageHeight;
			}
		}

		private function myStartDrag(event : MouseEvent) : void
		{
			if ((this.globalToLocal(new Point(stage.mouseX, stage.mouseY))).y > titleHeight)
			{
				return;
			}
			this.removeEventListener(MouseEvent.MOUSE_DOWN, myStartDrag);
			stage.addEventListener(MouseEvent.MOUSE_UP, myStopDrag);
			this.startDrag();
		}

		private function myStopDrag(event : MouseEvent) : void
		{
			this.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, myStopDrag);
			onDraging();
			this.addEventListener(MouseEvent.MOUSE_DOWN, myStartDrag);
		}

		protected function initViews() : void
		{
			bg = UIManager.getUI(new AssetData(UI.COMMON_BACKGROUND05));
			if (bg)
			{
				bg.width = _base.width;
				bg.height = _base.height;
				bg.x = 0;
				bg.y = 0;
				addChild(bg);
			}
			bodyBg = UIManager.getUI(new AssetData(UI.COMMON_BACKGROUND03));
			if (bodyBg)
			{
				bodyBg.width = _base.width - leftPadding - rightPadding;
				bodyBg.height = _base.height - titleHeight - buttonContainerHeight - bottomPadding;
				bodyBg.x = leftPadding;
				bodyBg.y = titleHeight;
				addChild(bodyBg);
			}
			// 标题
			var textFormat : TextFormat = new TextFormat();
			textFormat.font = UIManager.defaultFont;
			textFormat.size = 12;
			textFormat.color = 0xFFBB00;
			textFormat.bold = true;
			textFormat.align = TextFormatAlign.CENTER;
			var tempTF : TextField = new TextField();
			tempTF.selectable = false;
			tempTF.defaultTextFormat = textFormat;
			tempTF.width = _base.width;
			tempTF.height = titleHeight;
			tempTF.x = 0;
			tempTF.y = 3;
			tempTF.text = "";
			addChild(tempTF);
			titleTF = tempTF;

			// 内容容器
			var componentData : GComponentData = new GComponentData();
			componentData.width = _base.width - leftPadding - rightPadding;
			componentData.height = _base.height - titleHeight - buttonContainerHeight;
			componentData.x = leftPadding;
			componentData.y = titleHeight;
			var tempComponent : GComponent = new GComponent(componentData);
			addChild(tempComponent);
			bodyContainer = tempComponent;
			// 按钮容器
			componentData.width = bodyContainer.width;
			componentData.height = buttonContainerHeight;
			componentData.x = leftPadding;
			componentData.y = _base.height - componentData.height - bottomPadding;
			tempComponent = new GComponent(componentData);
			addChild(tempComponent);
			buttonContainer = tempComponent;

			var dataR : GCheckBoxData = new GCheckBoxData();
			dataR.x = (this.width - 60) / 2;
			dataR.labelData.text = "不再提醒";
			dataR.labelData.textColor = 0x2f1f00;
			dataR.labelData.textFieldFilters = [];
			dataR.y = 90;
			dataR.parent = this;
			_complexBox = new GCheckBox(dataR);
			_complexBox.selected = false;
		}

		protected function initButtons(flags : uint) : void
		{
			var buttonData : GButtonData ;
			var tempButton : GButton;
			// 关闭
			if ((flags & CLOSE ) != 0)
			{
				buttonData = new GButtonData();
				buttonData.width = buttonData.height = 20;
				buttonData.downAsset = new AssetData("close_button_down_skin");
				buttonData.upAsset = new AssetData("close_button_up_skin");
				buttonData.disabledAsset = new AssetData("close_button_down_skin");
				buttonData.overAsset = new AssetData("close_button_over_skin");
				tempButton = new GButton(buttonData);
				tempButton.x = _base.width - buttonData.width - 10;
				tempButton.y = 5;
				tempButton.addEventListener(MouseEvent.CLICK, close);
				addChild(tempButton);
				closeButton = tempButton;
			}

			buttonData = new GButtonData();
			buttonData.width = 80;
			buttonData.height = 25;
			// 是
			if ((flags & YES ) != 0)
			{
				buttonData.labelData.text = YES_TEXT;
				tempButton = new GButton(buttonData);
				buttonContainer.addChild(tempButton);
				tempButton.addEventListener(MouseEvent.CLICK, onYes);
				yesButton = tempButton;
			}
			// 否
			if ((flags & NO ) != 0)
			{
				buttonData.labelData.text = NO_TEXT;
				tempButton = new GButton(buttonData);
				buttonContainer.addChild(tempButton);
				tempButton.addEventListener(MouseEvent.CLICK, onNo);
				noButton = tempButton;
			}
			// 确定
			if ((flags & OK ) != 0)
			{
				buttonData.labelData.text = OK_TEXT;
				tempButton = new GButton(buttonData);
				buttonContainer.addChild(tempButton);
				tempButton.addEventListener(MouseEvent.CLICK, onOk);
				okButton = tempButton;
			}
			// 取消
			if ((flags & CANCEL ) != 0)
			{
				buttonData.labelData.text = CANCEL_TEXT;
				tempButton = new GButton(buttonData);
				buttonContainer.addChild(tempButton);
				tempButton.addEventListener(MouseEvent.CLICK, onCancel);
				cancelButton = tempButton;
			}
			buttonLayout();
		}

		/** 按钮布局 */
		public function buttonLayout() : void
		{
			var button : DisplayObject;
			var totalWidth : uint = 0;
			for (var i : int = 0; i < buttonContainer.numChildren; i++)
			{
				button = buttonContainer.getChildAt(i);
				button.x = i * (button.width + buttonHGap);
				button.y = 5;
				totalWidth += button.width + buttonHGap;
			}
			totalWidth = totalWidth - buttonHGap;
			buttonContainer.width = totalWidth;
			buttonContainer.x = leftPadding + (_base.width - leftPadding - rightPadding - buttonContainer.width) / 2;
		}

		protected function onCallFun(type : String) : Boolean
		{
			if (callFun != null)
			{
				return callFun(type);
			}
			return true;
		}

		/** 点击 取消 按钮 */
		protected function onCancel(event : MouseEvent) : void
		{
			if (onCallFun(CANCEL_EVENT) == false) return;
			var alertEvent : Event = new Event(CANCEL_EVENT, true);
			dispatchEvent(alertEvent);
			close();
			event.stopPropagation();
		}

		/** 点击 确定 按钮 */
		protected function onOk(event : MouseEvent) : void
		{
			if (onCallFun(OK_EVENT) == false) return;
			var alertEvent : Event = new Event(OK_EVENT, true);
			dispatchEvent(alertEvent);
			close();
			event.stopPropagation();
		}

		/** 点击 否 按钮 */
		protected function onNo(event : MouseEvent) : void
		{
			if (onCallFun(NO_EVENT) == false) return;
			var alertEvent : Event = new Event(NO_EVENT, true);
			dispatchEvent(alertEvent);
			close();
			event.stopPropagation();
		}

		/** 点击 是 按钮 */
		protected function onYes(event : MouseEvent) : void
		{
			if (onCallFun(YES_EVENT) == false) return;
			var alertEvent : Event = new Event(YES_EVENT, true);
			dispatchEvent(alertEvent);
			close();
			event.stopPropagation();
		}

		/** 关闭 */
		public function close(event : MouseEvent = null) : void
		{
			if (onCallFun(CLOSE_EVENT) == false) return;
			this.hide();
			var alertEvent : Event = new Event(CLOSE_EVENT, true);
			dispatchEvent(alertEvent);
		}

		override public function show() : void
		{
			if (yesButton) yesButton.addEventListener(MouseEvent.CLICK, onYes);
			if (noButton) noButton.addEventListener(MouseEvent.CLICK, onNo);
			if (okButton) okButton.addEventListener(MouseEvent.CLICK, onOk);
			if (cancelButton) cancelButton.addEventListener(MouseEvent.CLICK, onCancel);
			if (closeButton) closeButton.addEventListener(MouseEvent.CLICK, close);
			super.show();
		}

		override public function hide() : void
		{
			if (yesButton) yesButton.removeEventListener(MouseEvent.CLICK, onYes);
			if (noButton) noButton.removeEventListener(MouseEvent.CLICK, onNo);
			if (okButton) okButton.removeEventListener(MouseEvent.CLICK, onOk);
			if (cancelButton) cancelButton.removeEventListener(MouseEvent.CLICK, onCancel);
			if (closeButton) closeButton.removeEventListener(MouseEvent.CLICK, close);
			super.hide();
		}

		/** 是否为模态 */
		public function get modal() : Boolean
		{
			return _modal;
		}

		/** 是否为模态 */
		public function set modal(value : Boolean) : void
		{
			_modal = value;
		}

		/** 设置标题 */
		public function set title(str : String) : void
		{
			titleTF.htmlText = (str == null ? "" : str);
		}

		/** 设置文本内容 */
		public function set text(str : String) : void
		{
			if (textTF == null)
			{
				var tempTF : TextField = new TextField();
				tempTF.selectable = true;
				tempTF.defaultTextFormat = TextFormatUtils.panelContent;
				tempTF.wordWrap = true;
				tempTF.multiline = true;
				tempTF.width = bodyContainer.width - 14;
				tempTF.height = bodyContainer.height - 14;
				tempTF.x = 7;
				tempTF.y = 7;
				bodyContainer.addChild(tempTF);
				textTF = tempTF;
			}
			textTF.htmlText = str;
		}

		public function get text() : String
		{
			if (textTF) return textTF.htmlText;
			return "";
		}

		public function get selected() : Boolean
		{
			return _complexBox.selected;
		}

		/** 设置内容显示对像 */
		public function set contentDO(displayObject : DisplayObject) : void
		{
			if (displayObject)
			{
				if (displayObject.x == 0) displayObject.x = 7;
				if (displayObject.y == 0) displayObject.y = 7;
				bodyContainer.addChild(displayObject);
			}
		}

		/** 显示一个文本对话框 */
		public static function show(content : Object = null, title : String = "", flags : uint = 8, callFun : Function = null, type : int = 0, enDrag : Boolean = true, model : Boolean = true, width : int = -1, height : int = -1, parent : Sprite = null) : Alert
		{
			// flags = Alert.CLOSE_BUTTON | Alert.YES_BUTTON | Alert.NO_BUTTON | Alert.OK_BUTTON | Alert.CANCEL_BUTTON;
			// flags = Alert.OK_BUTTON | Alert.CANCEL_BUTTON;

			var text : String;
			if (content == null)
			{
				text = "请不要传空对像";
			}
			else if (content is DisplayObject)
			{
				var displayObject : DisplayObject = content as DisplayObject;
				return showDisplayObject(displayObject, title, flags, callFun, enDrag, model, width, height, parent);
			}
			else if (content is String)
			{
				text = content as String;
			}
			else
			{
				text = content + "";
			}

			var baseData : GComponentData = new GComponentData();
			var textWH : Point = getTextWH(text);
			baseData.parent = parent ? parent : UIManager.root;
			baseData.width = width;
			baseData.height = height;
			if (baseData.width < Alert.minWidth ) baseData.width = 18 + Alert.leftPadding + Alert.rightPadding + Math.max(Alert.minWidth, textWH.x);
			if (baseData.height < Alert.minHeight ) baseData.height = 14 + bottomPadding + Alert.titleHeight + Alert.buttonContainerHeight + Math.max(Alert.minHeight, textWH.y);
			baseData.x = (UIManager.stage.stageWidth - baseData.width) / 2;
			baseData.y = (UIManager.stage.stageHeight - baseData.height) / 2;
			var alert : Alert = new Alert(baseData, enDrag);
			alert.callFun = callFun;
			alert.title = title;
			alert.text = text;
			alert.modal = model;
			alert.initButtons(flags);
			alert.show();
			if (type == NORMAL)
				_complexBox.hide();
			else
				_complexBox.show();
			return alert;
		}

		public static function showDisplayObject(displayObject : DisplayObject = null, title : String = "", flags : uint = 8, callFun : Function = null, enDrag : Boolean = true, model : Boolean = true, width : int = -1, height : int = -1, parent : Sprite = null) : Alert
		{
			if (displayObject == null)
			{
				var textFormat : TextFormat = new TextFormat();
				textFormat.size = 12;
				textFormat.color = 0x000000;
				textFormat.align = TextFormatAlign.LEFT;
				var tempTF : TextField = new TextField();
				tempTF.selectable = true;
				tempTF.defaultTextFormat = textFormat;
				tempTF.wordWrap = true;
				tempTF.width = 200;
				tempTF.height = 30;
				tempTF.htmlText = "请不要传空对像";

				displayObject = tempTF;
			}

			var baseData : GComponentData = new GComponentData();
			baseData.parent = parent ? parent : UIManager.root;
			baseData.width = width;
			baseData.height = height;
			if (baseData.width < Alert.minWidth )
			{
				var contentHPadding : int = 18;
				if (displayObject.x != 0) contentHPadding = 0;
				baseData.width = contentHPadding + Alert.leftPadding + Alert.rightPadding + Math.max(Alert.minWidth, displayObject.width);
			}

			if (baseData.height < Alert.minHeight )
			{
				var contentVPadding : int = 14;
				if (displayObject.x != 0) contentVPadding = 0;
				baseData.height = contentVPadding + bottomPadding + Alert.titleHeight + Alert.buttonContainerHeight + Math.max(Alert.minHeight, displayObject.height);
			}
			baseData.x = (UIManager.stage.stageWidth - baseData.width) / 2;
			baseData.y = (UIManager.stage.stageHeight - baseData.height) / 2;
			var alert : Alert = new Alert(baseData, enDrag);
			alert.callFun = callFun;
			alert.contentDO = displayObject;
			alert.title = title;
			alert.modal = model;
			alert.initButtons(flags);
			alert.show();
			return alert;
		}

		/** 获取文本宽高 */
		public static function getTextWH(text : String) : Point
		{
			var wh : Point = new Point();
			var rowLength : int = 20 + Math.ceil(text.length / 30) * 1;
			var rowCount : int = Math.ceil(text.length / rowLength);
			wh.x = rowLength * 12;
			wh.y = rowCount * 17;
			return wh;
		}
	}
}


