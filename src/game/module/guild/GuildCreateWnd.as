package game.module.guild {
	import com.utils.TextFormatUtils;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.net.core.Common;
	import game.net.data.CtoS.CSCreateGuild;

	import gameui.controls.GButton;
	import gameui.controls.GTextInput;
	import gameui.data.GTitleWindowData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.GCommonSmallWindow;
	import com.commUI.alert.Alert;
	import com.commUI.button.KTButtonData;
	import com.utils.ColorUtils;
	import com.utils.RegExpUtils;
	import com.utils.StringUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;





	/**
	 * @author Rieman
	 */
	public class GuildCreateWnd extends GCommonSmallWindow
	{
		private var _makeButton : GButton;
		private var _cancelButton : GButton;
		private var _nameInput : GTextInput;
		private var _manager:GuildManager = GuildManager.instance;

		// private var _nameInput : DefaultInput;
		public function GuildCreateWnd() : void
		{
			_data = new GTitleWindowData();
			_data.width = 200;
			_data.height = 110;
			_data.parent = UIManager.root;
			_data.allowDrag = true;
			_data.modal = true;
			super(_data);
		}

		override protected function initViews() : void
		{
			title = "创建家族";
//			addBg(5, 0, 190, 105, ClanUtils.clanBack) ;
			var bg:Sprite = UIManager.getUI(new AssetData(GuildUtils.clanBack));
			bg.x = 5 ;
			bg.width = 190 ;
			bg.height = 105 ;
			addChild(bg);
			
			_makeButton = UICreateUtils.createGButton("创建", 50, 22, 45, 70, KTButtonData.SMALL_BUTTON);
			addChild(_makeButton);
			_cancelButton = UICreateUtils.createGButton("取消", 50, 22, 105, 70, KTButtonData.SMALL_BUTTON);
			addChild(_cancelButton);
			
			var fmt:TextFormat = TextFormatUtils.panelContent ;
//			fmt.size = 12 ;
//			fmt.color =  ColorUtils.PANELTEXT0X ;
			var tip:TextField = UICreateUtils.createTextField("家族名称最多为10个字符",null,138,18,33,42,fmt);
			addChild(tip);
			// _nameInput = new DefaultInput(12, 46 + dy, 175, 25);
			_nameInput = UICreateUtils.createGTextInput({x:12, y:17, width:175, height:25, hintText:"请输入想要创建的家族名称", maxChars:10});
			addChild(_nameInput);
			
			_makeButton.addEventListener(MouseEvent.CLICK, onMakeClanClick);
			_cancelButton.addEventListener(MouseEvent.CLICK, onCancelClick);
			_manager.addEventListener(GuildEvent.GUILD_ENTER, function(evt:GuildEvent):void{ hide(); });
		}

//		override public function show() : void
//		{
//			super.show();
//			initEvents();
//		}
//
//		override public function hide() : void
//		{
//			super.hide();
//			clearEvents();
//		}
//
//		private function initEvents() : void
//		{
//			_makeButton.addEventListener(MouseEvent.CLICK, onMakeClanClick);
//			_cancelButton.addEventListener(MouseEvent.CLICK, onCancelClick);
//		}
//
//		private function clearEvents() : void
//		{
//			_makeButton.removeEventListener(MouseEvent.CLICK, onMakeClanClick);
//			_cancelButton.removeEventListener(MouseEvent.CLICK, onCancelClick);
//		}

		private function onMakeClanClick(e : Event) : void
		{
			var n : int = StringUtils.UTFLength(_nameInput.text);
			if (UserData.instance.level < 21)
			{
				Alert.show('您的等级未达到21级,无法创建家族');
				return;
			}
			if (_nameInput.text == '')
			{
				// Alert.show('请给家族起个名字');
				StateManager.instance.checkMsg(146);
				return;
			}
			if ( n < 2 || n > 12)
			{
				// Alert.show('不可输入超过6个中文字或12个英文字母');
				StateManager.instance.checkMsg(145);
				return;
			}
			if (hasBanned())
			{
				// Alert.show('抱歉，名字中含有非法文字，请修改');
				StateManager.instance.checkMsg(147);
				return;
			}
			var msg : CSCreateGuild = new CSCreateGuild();
			msg.name = _nameInput.text;
			Common.game_server.sendMessage(0x2c0, msg);
		}

		private function hasBanned() : Boolean
		{
			return RegExpUtils.checkStr(_nameInput.text) ;
		}

		private function onCancelClick(e : Event) : void
		{
			hide();
		}
	}
}
