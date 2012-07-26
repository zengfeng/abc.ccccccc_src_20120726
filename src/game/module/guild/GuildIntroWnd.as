package game.module.guild {
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.core.user.StateManager;
	import game.module.guild.vo.VoGuild;

	import gameui.controls.GButton;
	import gameui.controls.GTextInput;
	import gameui.data.GTitleWindowData;
	import gameui.manager.UIManager;

	import com.commUI.GCommonSmallWindow;
	import com.commUI.button.KTButtonData;
	import com.utils.RegExpUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;





	/**
	 * @author zhangzheng
	 */
	public class GuildIntroWnd extends GCommonSmallWindow {

		private var modifyButton : GButton;
		private var introInput : GTextInput;
		private var announceInput : GTextInput ;

		public function GuildIntroWnd() {
			var data:GTitleWindowData = new GTitleWindowData() ;
			data.width = 320;
			data.height = 370;
			data.parent = MenuManager.getInstance().getMenuTarget(MenuType.CLANLIST);
			data.modal =  true ;
			data.allowDrag = true ;
			data.x = ( data.parent.width - data.width ) / 2 ;
			data.y = ( data.parent.height - data.height ) / 2 ;
			super(data);
		}

		override protected function create() : void
		{
			super.create();
			this.title = "家族信息设置";
			var bg:Sprite = UICreateUtils.createSprite(GuildUtils.clanBack,310,367,5,0);
			addChild(bg);
			
//			bg = UICreateUtils.createSprite( UI.GUILD_INPUT,278,116,18,38 );
//			addChild(bg);
//			
//			bg = UICreateUtils.createSprite( UI.GUILD_INPUT,278,116,18,183);
//			addChild(bg);
//			
			
			var fmt:TextFormat = new TextFormat() ;
			fmt.font = UIManager.defaultFont ;
			fmt.size = 13 ;
			fmt.bold = true ;
			var txt:TextField = UICreateUtils.createTextField("公告:",null,43,21,18,18,fmt);
			addChild(txt);
			
			txt = UICreateUtils.createTextField( "介绍:",null,43,21,18,163,fmt );
			addChild(txt);

			introInput = UICreateUtils.createGTextInput({x:18, y:183, width:278, height:116, hintText:"请输入家族介绍", maxChars:130, wordWrap:true});
			addChild(introInput);
			
			announceInput = UICreateUtils.createGTextInput({x:18, y:38, width:278, height:116, hintText:"请输入家族介绍", maxChars:130, wordWrap:true});
			addChild(announceInput);
			
			modifyButton = UICreateUtils.createGButton("确定",80,30,119,315,KTButtonData.SMALL_BUTTON);
			addChild(modifyButton);
			
			modifyButton.addEventListener(MouseEvent.CLICK, onClickConfirm);
		}

		private function onClickConfirm(event : MouseEvent) : void {
			
			if( RegExpUtils.checkStr(introInput.text) ){

				StateManager.instance.checkMsg(244);
				//wordfilterbg.visible = true ;
				//wordfiltertxt.visible = true ;
				// 敏感词提示
			}
			else 
			{
				//wordfilterbg.visible = false ;
				//wordfiltertxt.visible = false ;
//				GuildProxy.cs_guildintro( introInput.text );
				
				GuildManager.instance.sendIntroChange( introInput.text , announceInput.text );
				hide();
			}
		}
		
		override public function show():void
		{
			//隐藏敏感词提示
			//wordfilterbg.visible = false ;
			//wordfiltertxt.visible = false ;
			var vo:VoGuild = GuildManager.instance.selfguild;
			introInput.text = vo == null || vo.intro == null ? "" : vo.intro ;
			announceInput.text = vo == null || vo.announce == null ? "" : vo.announce ;
			super.show();
		}
	}
}
