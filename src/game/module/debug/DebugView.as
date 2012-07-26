package game.module.debug
{
	import flash.net.SharedObject;
	import game.manager.ViewManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import game.core.user.UserData;
	import game.module.chat.ProtoCtoSChat;
	import game.module.chat.VoChatMsg;
	import game.module.chat.config.ChannelId;
	import gameui.containers.GTitleWindow;
	import gameui.controls.GButton;
	import gameui.controls.GTextArea;
	import gameui.controls.GTextInput;
	import gameui.core.GAlign;
	import gameui.data.GButtonData;
	import gameui.data.GTextAreaData;
	import gameui.data.GTextInputData;
	import gameui.data.GTitleWindowData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;
	import log4a.CSSLogFormatter;
	import log4a.IAppender;
	import log4a.ILogFormatter;
	import log4a.Logger;
	import log4a.LoggingData;
	import net.AssetData;





	public class DebugView extends GTitleWindow implements IAppender
	{
		public static const CLEAR : String = "clear";

		public static const QUIT : String = "quit";

		public static const SHOWALL : String = "ohmygod";
		
		public static const VERSION:String="version";

		protected var _formatter : ILogFormatter;

		private var _debug_ta : GTextArea;

		private var _command_ti : GTextInput;

		private var _run_btn : GButton;

		private var commandList : Vector.<String>;

		private var commandIndex : int = 0;

		private function initData() : void
		{
			_data.allowDrag = true;
			_data.titleBarData.backgroundAsset = new AssetData("GTitleBar_backgroundSkin_alpha");
			_data.panelData.bgAsset = new AssetData("GPanel_backgroundSkin_alpha");
			_data.width = 700;
			_data.height = 500;
			_data.align = new GAlign(-1, -1, -1, -1, 0, 0);
			_data.titleBarData.labelData.text = "系统调试";
			_data.titleBarData.labelData.align = new GAlign(8, -1, -1, -1, -1, 1);
		}

		private var _adminMethod : AdminMethod;

		private var _gmMethod : GMMethod;

		private function initView() : void
		{
			createTextArea();
			createTextInput();
			createButton();
			_formatter = new CSSLogFormatter();
			_adminMethod = new AdminMethod();
			_gmMethod = new GMMethod();
		}

		private function initEvents() : void
		{
//			UIManager.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}

		private function createTextArea() : void
		{
			var data : GTextAreaData = new GTextAreaData();
			data.textFormat.leading = 3;
			data.styleSheet.parseCSS(CSSLogFormatter.cssText);
			data.textFieldFilters = UIManager.getEdgeFilters(0x000000, 1);
			data.editable = false;
			data.align = new GAlign(5, 5, 5, 30, -1, -1);
			data.maxLines = 500;
			data.edlim = "</p>";
			_debug_ta = new GTextArea(data);
			_contentPanel.add(_debug_ta);
		}

		private function createTextInput() : void
		{
			var data : GTextInputData = new GTextInputData();
			data.textColor = 0xFFFFFF;
			data.textFieldFilters = UIManager.getEdgeFilters(0x000000, 1);
			data.maxChars = 100;
			data.align = new GAlign(5, 70, -1, 5, -1, -1);
			_command_ti = new GTextInput(data);
			_contentPanel.add(_command_ti);
		}

		private function createButton() : void
		{
			var data : GButtonData = new GButtonData();
			data.labelData.text = "执行";
			data.width = 50;
			data.height = 24;
			data.align = new GAlign(-1, 10, -1, 4, -1, -1);
			_run_btn = new GButton(data);
			_contentPanel.add(_run_btn);
		}

		private function textInputHandler(event : TextEvent) : void
		{
			if (event.text.charCodeAt(0) == 4)
			{
				event.preventDefault();
			}
		}

		private function enterHandler(event : Event) : void
		{
			run();
		}

		private function keyUpHandler(event : KeyboardEvent) : void
		{
			if (UserData.instance.power <= 0) return;
			if (event.ctrlKey)
			{
				if (event.keyCode == 191)
				{
					if (parent == null)
					{
						show();
						_command_ti.setFocus();
						GLayout.layout(this);
					}
					else
					{
						hide();
					}
				}
			}
		}

		private function commondHandler(event : KeyboardEvent) : void
		{
			if (event.keyCode != 38 && event.keyCode != 40) return;
			if (event.keyCode == 38)// up
			{
				commandIndex > 0 ? commandIndex-- : 0;
			}
			else if (event.keyCode == 40)// down
			{
				commandIndex >= commandList.length - 1 ? 0 : ++commandIndex;
			}
			_command_ti.text = commandList.length > 0 ? commandList[commandIndex] : "";
			_command_ti.setFocus();
		}

		private function run_clickHandler(event : MouseEvent) : void
		{
			run();
		}
//		private var _version:String="";
		
//		CONFIG::debug
//        public function createVersion():void
//        {
//			_version=new Date().toDateString();
//        }
        
//        CONFIG::Date
//        public function createVersion():void
//        {
//		  
//           _version=new Date().toDateString();
//        }

		private function run() : void
		{
			addcommand(_command_ti.text);
			var params : Array = _command_ti.text.split(" ");
			if (params.length == 0) return;
            if([GMMethod.CHAT_PROMPT, GMMethod.CHAT_SYSTEM, GMMethod.CHAT_SYSTEM_NOTIC].indexOf(params[1]) != -1)
            {
                params[2] =  _command_ti.text;
            }
			var perfix : String = params.shift();
			switch(perfix)
			{
				case CLEAR:
					_debug_ta.clear();
					break;
				case QUIT:
					hide();
					break;
				case GMMethod.PREFIX:
					_gmMethod.run(params);
					break;
				case AdminMethod.PREFIX:
					_adminMethod.run(params);
					break;
				case SHOWALL:
					vo = new VoChatMsg();
					vo.content = ".level 100 ";
					vo.channelId = ChannelId.WORLD;
					ProtoCtoSChat.instance.sendmsg(vo);
					
					vo = new VoChatMsg();
					vo.content = "/setquest 103306";
					vo.channelId = ChannelId.WORLD;
					ProtoCtoSChat.instance.sendmsg(vo);
					vo = new VoChatMsg();
					vo.content = "/vip 12";
					vo.channelId = ChannelId.WORLD;
					ProtoCtoSChat.instance.sendmsg(vo);
					vo = new VoChatMsg();
					vo.content = "/gold 999999";
					vo.channelId = ChannelId.WORLD;
					ProtoCtoSChat.instance.sendmsg(vo);
					break;
				case VERSION:
					_debug_ta.appendHtmlText("3.1.11");
				break;
				default :
					var firstStr : String = _command_ti.text.charAt(0);
					if (firstStr != "." && firstStr != "/") break;
					var vo : VoChatMsg = new VoChatMsg();
					vo.content = _command_ti.text;
					vo.channelId = ChannelId.WORLD;
					ProtoCtoSChat.instance.sendmsg(vo);
					break;
			}
			_command_ti.clear();
		}
		
		private function addcommand(value : String) : void
		{
			Logger.debug(value);
			commandList.push(value);
			if (commandList.length > 500)
				commandList.splice(0, 200);
			commandIndex = commandList.length - 1;
		}

		public function reset() : void
		{
			_data = new GTitleWindowData();
			initData();
		}

		public function DebugView(game : Sprite)
		{
			_data = new GTitleWindowData();
			_data.parent = game;
			initData();
			super(_data);
			initView();
			initEvents();
			commandList = new Vector.<String>();
		}
		
		public function append(data : LoggingData) : void
		{
            if(isStartup == false)
			{
				cacheApped(data);
				return;
			}
			var message : String = _formatter.format(data);
			_debug_ta.appendHtmlText(message);
		}

		override public function show() : void
		{
			super.show();
			_command_ti.addEventListener(TextEvent.TEXT_INPUT, textInputHandler);
			_command_ti.addEventListener(GTextInput.ENTER, enterHandler);
			addEventListener(KeyboardEvent.KEY_UP, commondHandler);
			_run_btn.addEventListener(MouseEvent.CLICK, run_clickHandler);
		}

		override public function hide() : void
		{
			super.hide();
			_command_ti.removeEventListener(TextEvent.TEXT_INPUT, textInputHandler);
			_command_ti.removeEventListener(GTextInput.ENTER, enterHandler);
			removeEventListener(KeyboardEvent.KEY_UP, commondHandler);
			_run_btn.removeEventListener(MouseEvent.CLICK, run_clickHandler);
		}
		
		private var isStartup:Boolean = true;
		public function startup():void
		{
//			Logger.addAppender(ViewManager.debugView);
			isStartup = true;
			historyStartup = true;
			UIManager.stage.addEventListener(KeyboardEvent.KEY_UP, ViewManager.debugView.keyUpHandler);
			cacheShow();
		}
		
		public function exit():void
		{
			UIManager.stage.removeEventListener(KeyboardEvent.KEY_UP, ViewManager.debugView.keyUpHandler);
			isStartup = false;
			historyStartup = false;
//			Logger.removeAppender();
		}
		
        /** 本地消息缓存对像 */
		private var _sharedObject:SharedObject;
        private function get sharedObject() : SharedObject
		{
			if(_sharedObject == null)
			{
				_sharedObject = SharedObject.getLocal("ktpd_gmdebug");
			}
			return _sharedObject;
		}
		
		public function get historyStartup() :Boolean
        {
            var obj : Object = sharedObject.data["isStartup"];
            if (obj == null) return false;
            return obj == "true";
        }

        public function set historyStartup(value : Boolean) : void
        {
            sharedObject.data["isStartup"] = value ? "true" : "false";
			sharedObject.flush();
        }
		
		public function checkStartup():void
		{
			if(historyStartup)
			{
				startup();
			}
			else
			{
				exit();
			}
		}
		
		
		private var cacheMsgList:Vector.<LoggingData> = new Vector.<LoggingData>();
		private function cacheApped(data:LoggingData):void
		{
			if( cacheMsgList.length > 500)
			{
				cacheMsgList.shift();
			}
			cacheMsgList.push(data);
		}
		
		private function cacheShow():void
		{
			var data:LoggingData;
			var message : String;
			while(cacheMsgList.length > 0)
			{
				data = cacheMsgList.shift();
				message = _formatter.format(data);
				_debug_ta.appendHtmlText(message);
			}
		}
		
//		private function 
	}
}
