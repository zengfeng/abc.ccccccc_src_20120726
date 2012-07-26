package game.module.giftTicket {
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.definition.UI;
	import game.manager.ViewManager;
	import game.net.core.Common;
	import game.net.data.CtoS.CSEnterCode;
	import game.net.data.StoC.SCEnterCode;

	import gameui.controls.GButton;
	import gameui.controls.GTextInput;
	import gameui.core.GAlign;
	import gameui.data.GTitleWindowData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.GCommonWindow;
	import com.commUI.alert.Alert;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author ZHENGYUHANG
	 */
	public class VerificationView extends GCommonWindow {
		public function VerificationView() {
			var data : GTitleWindowData = new GTitleWindowData();
			data.width = 345;
			data.height = 205;
			data.parent = ViewManager.instance.uiContainer;
			data.align = new GAlign(-1, -1, -1, -1, 1, 1);
			super(data);
		}

		override protected function create() : void {
			super.create();
			this.title = "领取礼包";
			addBackground();
			addText();
			addButtons();
			addTextInput();
		}

		private var _bgSkin : Sprite;

		private function addBackground() : void {
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

		private function addText() : void {
			_text = UICreateUtils.createTextField("", null, 255, 20, 13, 20, TextFormatUtils.panelContent);
			_text.htmlText = "请输入礼品码";
			addChild(_text);

			// _name = UICreateUtils.createTextField("", null, 255, 20, 13, 53, TextFormatUtils.panelContent);
			// _name.htmlText = "姓名：";
			// addChild(_name);

			_num = UICreateUtils.createTextField("", null, 255, 20, 13, 68, TextFormatUtils.panelContent);
			_num.htmlText = "礼品码：";
			addChild(_num);
		}

		private var _selectBt : GButton;

		private function addButtons() : void {
			_selectBt = UICreateUtils.createGButton("提交", 0, 0, 129, 160);
			addChild(_selectBt);
		}

		private var _numsInput : GTextInput;
		private var _nameInput : GTextInput;

		private function addTextInput() : void {
			// _nameInput = UICreateUtils.createGTextInput({text:"", width:200, height:25, x:63, y:51, restrict:"", maxChars:20, selectAll:true});
			// addChild(_nameInput);
			_numsInput = UICreateUtils.createGTextInput({text:"", width:200, height:25, x:63, y:65, restrict:"0-9A-Za-z", maxChars:20, selectAll:true});
			addChild(_numsInput);
		}

		private function startButton_clickHandler(event : MouseEvent) : void {
			var cmd : CSEnterCode = new CSEnterCode();
			cmd.code = _numsInput.text;
			Common.game_server.sendMessage(0x0D, cmd);
			// MenuManager.getInstance().closeMenuView(MenuType.WALLOW);
		}

		// 结果  0 - 成功   1 - 已经使用过   2 - 无效
		private function checkMesg(msg : SCEnterCode) : void {
			if (msg.result == 0) {
				Alert.show("兑换元宝成功");
				MenuManager.getInstance().closeMenuView(MenuType.VERIFICATION);
			} else if (msg.result == 1) {
				Alert.show("此礼品券已经使用过，请重新输入");
			} else if (msg.result == 2) {
				Alert.show("此礼品券号无效，请重新输入");
			}
		}

		override protected function onShow() : void {
			super.onShow();
			GLayout.layout(this);
			_selectBt.addEventListener(MouseEvent.CLICK, startButton_clickHandler);
			_numsInput.setFocus(true);
			Common.game_server.addCallback(0x0D, checkMesg);
		}

		override protected function onHide() : void {
			super.onHide();
			_selectBt.removeEventListener(MouseEvent.CLICK, startButton_clickHandler);
		}
	}
}
