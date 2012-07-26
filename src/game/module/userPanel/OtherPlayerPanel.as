package game.module.userPanel {
	import game.core.hero.HeroManager;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.manager.VersionManager;
	import game.manager.ViewManager;
	import game.module.chatwhisper.ManagerWhisper;
	import game.module.friend.ManagerFriend;
	import game.module.trade.exchange.ExchangeManager;

	import gameui.controls.GButton;
	import gameui.controls.GImage;
	import gameui.controls.GLabel;
	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;
	import gameui.data.GImageData;
	import gameui.data.GLabelData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.utils.StringUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;

	/**
	 * @author yangyiqiang
	 */
	public class OtherPlayerPanel extends GComponent {
		public function OtherPlayerPanel() {
			_base = new GComponentData();
			_base.parent = ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER);
			_base.align = new GAlign(0);
			_base.x = 3;
			_base.width = 245;
			_base.height = 96;
			super(_base);
			initView();
		}

		private var _userHead : GImage ;
		private var _name : GLabel;
		private var _level : GLabel;
		private var _lookMessage : TextField;
		private var _sendMessage : TextField;
		private var _addFriend : TextField;
		private var _trade:TextField;
		protected var _closeButton : GButton;
		private var _array : Array = [10, 6, 2];

		private function initView() : void {
			var back:Sprite = UIManager.getUI(new AssetData("PlayerHeadPhoto_Bg_TargetPlayer"));
			addChild(back);
			var _imgData : GImageData = new GImageData();
			_imgData.x =-4;
			_imgData.y = -52;
			_imgData.iocData.align = new GAlign(0);
			_userHead = new GImage(_imgData);
			addChild(_userHead);

			var bag : Sprite = UIManager.getUI(new AssetData("PlayerHeadPhoto_Fg"));
			bag.y = 10;
			addChild(bag);

			var data : GLabelData = new GLabelData();
			data.textColor = 0xffcc00;
			data.textFormat = UIManager.getTextFormat(14);
			data.textFormat.align = TextFormatAlign.CENTER;
			data.x = 100;
			data.y = 4;
			_name = new GLabel(data);
			addChild(_name);

			data = data.clone();
			data.x = _array[data.text.length - 1];
			data.y = 12;
			data.width = 30;
			data.text = String(10);
			data.textFormat.align = TextFormatAlign.CENTER;
			_level = new GLabel(data);
			addChild(_level);
			
			_lookMessage=UICreateUtils.createTextField(null,"",100,20,114,30);
			_lookMessage.htmlText = StringUtils.addEvent(StringUtils.addLine(StringUtils.addColor("查看信息", "#FFE400")), "lookMessage");
			_lookMessage.addEventListener(TextEvent.LINK, onLink);
			_lookMessage.filters = UIManager.getEdgeFilters(0x000000, 0.7);
			_lookMessage.mouseEnabled=true;
			addChild(_lookMessage);

			_sendMessage=UICreateUtils.createTextField(null,"",100,20,114,50);
			_sendMessage.htmlText = StringUtils.addEvent(StringUtils.addLine(StringUtils.addColor("发送私聊", "#FFE400")), "sendMessage");
			_sendMessage.addEventListener(TextEvent.LINK, onLink);
			_sendMessage.filters = UIManager.getEdgeFilters(0x000000, 0.7);
			_sendMessage.mouseEnabled=true;
			addChild(_sendMessage);

			_addFriend=UICreateUtils.createTextField(null,"",100,20,180,30);
			_addFriend.htmlText = StringUtils.addEvent(StringUtils.addLine(StringUtils.addColor("加为知己", "#FFE400")), "friend");
			_addFriend.addEventListener(TextEvent.LINK, onLink);
			_addFriend.filters = UIManager.getEdgeFilters(0x000000, 0.7);
			_addFriend.mouseEnabled=true;
			addChild(_addFriend);
			
			_trade=UICreateUtils.createTextField(null,"",100,20,180,50);
			_trade.mouseEnabled=true;
			_trade.htmlText=StringUtils.addEvent(StringUtils.addLine(StringUtils.addColor("发起交易", "#FFE400")), "trade");
			_trade.filters = UIManager.getEdgeFilters(0x000000, 0.7);
			addChild(_trade);

			var closeButtonData : GButtonData = new GButtonData();
			closeButtonData.width = closeButtonData.height = 15;
			closeButtonData.downAsset = new AssetData("close_button_down_skin");
			closeButtonData.upAsset = new AssetData("close_button_up_skin");
			closeButtonData.disabledAsset = new AssetData("close_button_down_skin");
			closeButtonData.overAsset = new AssetData("close_button_over_skin");
			closeButtonData.x = 223;
			closeButtonData.y = 8;
			_closeButton = new GButton(closeButtonData);
			addChild(_closeButton);
		}

		private function clickClose(event : MouseEvent) : void {
			_closeButton.enabled = false;
			this.hide();
		}

		override public function set source(value : *) : void {
			if (!value || !_name) return;
			_name.htmlText = StringUtils.addBold(StringUtils.addColor(value["name"], value["color"]));
			_userHead.url = VersionManager.instance.getUrl("assets/ico/halfBody/" + value["heroId"] + ".png");
			_level.text = value["level"];
			super.source = value;
		}

		override public function show() : void {
			_lookMessage.addEventListener(TextEvent.LINK, onLink);
			_sendMessage.addEventListener(TextEvent.LINK, onLink);
			_addFriend.addEventListener(TextEvent.LINK, onLink);
			_trade.addEventListener(TextEvent.LINK, onLink);
			_closeButton.addEventListener(MouseEvent.CLICK, clickClose);
			this.align = new GAlign(315);
			super.show();
			GLayout.layout(this);
			_closeButton.enabled = true;
			if(MenuManager.getInstance().checkOpen(MenuType.FRIEND)){
				_sendMessage.visible=true;
				_addFriend.visible=true;
			}else{
				_sendMessage.visible=false;
				_addFriend.visible=false;
			}
			if(MenuManager.getInstance().checkOpen(MenuType.TRADE)){
				_trade.visible=true;
			}else{
				_trade.visible=false;
			}
		}

		override public function hide() : void {
			_lookMessage.removeEventListener(TextEvent.LINK, onLink);
			_sendMessage.removeEventListener(TextEvent.LINK, onLink);
			_addFriend.removeEventListener(TextEvent.LINK, onLink);
			_trade.removeEventListener(TextEvent.LINK, onLink);
			_closeButton.removeEventListener(MouseEvent.CLICK, clickClose);
			super.hide();
		}

		private function onLink(event : TextEvent) : void {
			if (event.text == "lookMessage") {
				HeroManager.instance.sendViewOtherInfo(_source["name"]);
			} else if (event.text == "sendMessage") {
				ManagerWhisper.instance.showWindowByPlayerName(_source["name"]);
			} else if (event.text == "friend") {
				ManagerFriend.getInstance().addFriendByPlayerName(_source["name"]);
			}else if(event.text=="trade"){
				ExchangeManager.instance.startExchangeWithPlayer(_source["name"], 0);
			}
		}
	}
}
