package game.module.guild {
	import com.utils.TextFormatUtils;
	import game.core.user.StateManager;
	import game.module.guild.vo.VoGuildApply;

	import gameui.controls.GButton;

	import com.commUI.button.KTButtonData;
	import com.commUI.tips.PlayerTip;
	import com.utils.ColorUtils;
	import com.utils.StringUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * @author zhangzheng
	 */
	public class GuildAuditItem extends Sprite {

		private var agreeButton : GButton;
		private var refuseButton : GButton;
		private var levelText : TextField;
		private var rankText : TextField;
		private var nameText : TextField;
		private var _vo:VoGuildApply ;
		private var manager:GuildManager = GuildManager.instance ;
		private var deepbg:Sprite ;
		private var lightbg:Sprite ;

		public function GuildAuditItem() {
			addBg();
			initView();
		}
		
		private function addBg():void {
			
			deepbg = UICreateUtils.createSprite(GuildUtils.clanDeepBar , 422,25,0,0);
			lightbg = UICreateUtils.createSprite(GuildUtils.clanLightBar , 422,25,0,0);
			addChild(deepbg);
		}
		
		private function initView():void {
			
			var font:TextFormat = TextFormatUtils.panelContentCenter ;
//			font.size = 12 ;
//			font.align = TextFormatAlign.CENTER ;
//			font.color =  ColorUtils.PANELTEXT0X ;
			
			nameText = UICreateUtils.createTextField(null,null,135,25,0,4,font);
			nameText.selectable = false ;
			nameText.mouseEnabled = true ;
			addChild(nameText) ;
			nameText.addEventListener(TextEvent.LINK, onClickName);
			nameText.addEventListener(MouseEvent.ROLL_OVER, onMouseOverName);
			nameText.addEventListener(MouseEvent.ROLL_OUT, onMouseLeaveName);
			
			levelText = UICreateUtils.createTextField(null,null,24,25,140,4,font);
			levelText.selectable = false ;
			addChild(levelText);
			
			rankText = UICreateUtils.createTextField(null,null,130,25,170,4,font) ;
			rankText.selectable = false ;
			addChild(rankText);
			
			agreeButton = UICreateUtils.createGButton("同意",50,22,310,1,KTButtonData.SMALL_BUTTON);
			agreeButton.addEventListener(MouseEvent.CLICK, onApply);
			addChild(agreeButton);
			refuseButton = UICreateUtils.createGButton("拒绝",50,22,370,1,KTButtonData.SMALL_BUTTON);
			refuseButton.addEventListener(MouseEvent.CLICK, onReject);
			addChild(refuseButton);
			
			agreeButton.visible = false ;
			refuseButton.visible = false ;
			
		}

		private function onReject(event : MouseEvent) : void {
			GuildProxy.cs_guildpass( _vo.id , false );
		}

		private function onApply(event : MouseEvent) : void {
			if (manager.selfguild.memberList.length >= 20)
			{
				StateManager.instance.checkMsg(151);
				return;
			}

			GuildProxy.cs_guildpass( _vo.id, true );
		}

		private function onMouseLeaveName(event : MouseEvent) : void {
			if( _vo != null )
				nameText.htmlText = StringUtils.addEvent( _vo.colorname() , "to") ;
		}

		private function onMouseOverName(event : MouseEvent) : void {
			if( _vo != null )
				nameText.htmlText = StringUtils.addEvent( _vo.linecolorname() , "to") ;
		}

		private function onClickName(event : TextEvent) : void {
			if( _vo != null )
				PlayerTip.show( _vo.id , _vo.name , GuildUtils.tiplist[GuildUtils.TL_AUDIT] );
		}
		
		public function set vo( value:VoGuildApply ):void
		{
			_vo = value ;
			if( _vo != null )
			{
				nameText.visible = true ;
				levelText.visible = true ;
				rankText.visible = true ;
				nameText.htmlText = StringUtils.addEvent(_vo.colorname() , "to") ;
				levelText.text = _vo.level.toString() ;
				rankText.text = _vo.rank.toString();
				agreeButton.visible = true ;
				refuseButton.visible = true ;
			}
			else 
			{
				nameText.visible = false ;
				levelText.visible = false ;
				rankText.visible = false ;
				agreeButton.visible = false ;
				refuseButton.visible = false ;
			}
		}
		
		public function updatebg(seq:int):void
		{
			removeChildAt(0);
			addChildAt( ( seq & 1 ) == 0 ? lightbg : deepbg , 0);
		}
	}
}
