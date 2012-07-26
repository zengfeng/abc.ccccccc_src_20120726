package game.module.userPanel
{
	import game.core.menu.MenuType;
	import game.core.menu.MenuManager;
	import game.core.user.StateManager;
	import game.definition.UI;
	import game.manager.ViewManager;
	import game.net.core.Common;
	import game.net.data.CtoS.CSWallowInfo;

	import gameui.controls.GButton;
	import gameui.controls.GTextInput;
	import gameui.core.GAlign;
	import gameui.data.GTitleWindowData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.GCommonWindow;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author yangyiqiang
	 */
	public class WallowPanel extends GCommonWindow
	{
		public function WallowPanel()
		{
			var data : GTitleWindowData = new GTitleWindowData();
			data.width = 345;
			data.height = 205;
			data.parent = ViewManager.instance.uiContainer;
			data.align = new GAlign(-1, -1, -1, -1, 1, 1);
			super(data);
		}

		override protected function create() : void
		{
			super.create();
			this.title = "防沉迷认证";
			addBackground();
			addText();
			addButtons();
			addTextInput();
		}

		private var _bgSkin : Sprite;

		private function addBackground() : void
		{
			_bgSkin = UIManager.getUI(new AssetData(UI.PANEL_BACKGROUND));
			_bgSkin.x = 5;
			_bgSkin.y = 0;
			_bgSkin.width = 330;
			_bgSkin.height = 202;
			_contentPanel.addChild(_bgSkin);
		}

		private var _text : TextField;

		private var _name : TextField;

		private var _num : TextField;

		private function addText() : void
		{
			_text = UICreateUtils.createTextField("", null, 255, 20, 13, 10, TextFormatUtils.panelContent);
			_text.htmlText = "请填写防沉迷信息";
			addChild(_text);

			_name = UICreateUtils.createTextField("", null, 255, 20, 13, 53, TextFormatUtils.panelContent);
			_name.htmlText = "姓名：";
			addChild(_name);

			_num = UICreateUtils.createTextField("", null, 255, 20, 13, 84, TextFormatUtils.panelContent);
			_num.htmlText = "身份证：";
			addChild(_num);
		}

		private var _selectBt : GButton;

		private function addButtons() : void
		{
			_selectBt = UICreateUtils.createGButton("提交", 0, 0, 129, 160);
			addChild(_selectBt);
		}

		private var _numsInput : GTextInput;

		private var _nameInput : GTextInput;

		private function addTextInput() : void
		{
			_nameInput = UICreateUtils.createGTextInput({text:"", width:200, height:25, x:63, y:51, restrict:"", maxChars:20, selectAll:true});
			addChild(_nameInput);
			_numsInput = UICreateUtils.createGTextInput({text:"", width:200, height:25, x:63, y:80, restrict:"0-9xX", maxChars:20, selectAll:true});
			addChild(_numsInput);
		}

		private function startButton_clickHandler(event : MouseEvent) : void
		{
			if (!checkMesg())
			{
				StateManager.instance.checkMsg(348);
				return ;
			}
			var cmd : CSWallowInfo = new CSWallowInfo();
			cmd.name = _nameInput.text;
			cmd.identify = _numsInput.text;
			Common.game_server.sendMessage(0x0e, cmd);
			MenuManager.getInstance().closeMenuView(MenuType.WALLOW);
		}

		private function checkMesg() : Boolean
		{
			if (_nameInput.text.length < 2) return false;
			if (_numsInput.text.length != 15 && _numsInput.text.length != 18) return false;
			var max : int = _numsInput.text.length;
			for (var i : int = 0;i < max;i++)
			{
				if ((_numsInput.text.charCodeAt(i) == 120||_numsInput.text.charCodeAt(i) ==88) && i != 17) return false;
				if (_numsInput.text.charCodeAt(i) < 48 || _numsInput.text.charCodeAt(i) > 57) return false;
			}
			return true;
		}

		override protected function onShow() : void
		{
			super.onShow();
			GLayout.layout(this);
			_selectBt.addEventListener(MouseEvent.CLICK, startButton_clickHandler);
			_nameInput.setFocus(true);
		}

		override protected function onHide() : void
		{
			super.onHide();
			_selectBt.removeEventListener(MouseEvent.CLICK, startButton_clickHandler);
		}
	}
}
