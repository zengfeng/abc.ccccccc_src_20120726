package game.module.guild {
	import com.utils.TextFormatUtils;
	import game.core.user.UserData;
	import game.module.guild.vo.VoGuild;
	import game.module.guild.vo.VoGuildMember;

	import gameui.controls.GButton;

	import com.commUI.button.KTButtonData;
	import com.commUI.tips.PlayerTip;
	import com.utils.ColorUtils;
	import com.utils.StringUtils;
	import com.utils.UICreateUtils;
	import com.utils.UIUtil;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;





	/**
	 * @author zhangzheng
	 */
	public class GuildListItem extends Sprite {
		
		private var _bg:Sprite ;
		private var _bgover:Sprite ;
		private var _guildrank:TextField ;
		private var _guildname:TextField ;
		private var _leadername:TextField ;
		private var _guildlevel:TextField ;
		private var _membercnt:TextField ;
		private var _applyButton:GButton ;
		private var _viewButton:GButton ;
		private var _applyText:TextField ;
		private var _vo:VoGuild ;
		private var _manager:GuildManager = GuildManager.instance ;
		private var _viewwnd:ViewGuildWnd = ViewGuildWnd.instance ;
		
		public function GuildListItem( seq:int ) {
			addbg(seq);
			initView();
		}
		
		private function addbg( seq:int ):void{
			_bg = UICreateUtils.createSprite( (seq & 1) == 0 ? GuildUtils.clanDeepBar : GuildUtils.clanLightBar, 710 , 25 );
			_bgover = UICreateUtils.createSprite( GuildUtils.mouseOverBar , 710 , 25 );
			addChild(_bg);
		}
		
		private function initView():void{
			
			var fmt:TextFormat = TextFormatUtils.panelContentCenter ;
//			fmt.size = 12 ;
//			fmt.align = TextFormatAlign.CENTER ;
//			fmt.color =  ColorUtils.PANELTEXT0X; 
			_guildrank = UICreateUtils.createTextField(null,null,58,18,0,4,fmt);
			addChild(_guildrank);
			
			_guildname = UICreateUtils.createTextField(null,null,100,25,79,4,fmt);
			addChild(_guildname);
			
			_leadername = UICreateUtils.createTextField(null,null,100,25,244,4,fmt);
			_leadername.mouseEnabled = true ;
			_leadername.selectable = false ;
			_leadername.autoSize = "center";
			_leadername.addEventListener(MouseEvent.CLICK , onClickLeader);
			_leadername.addEventListener(MouseEvent.ROLL_OVER, onMouseOverLeader);
			_leadername.addEventListener(MouseEvent.ROLL_OUT, onMouseLeaveLeader);
			addChild(_leadername);
			
			_guildlevel = UICreateUtils.createTextField(null,null,50,25,402,4,fmt);
			_guildlevel.selectable = false ;
			addChild(_guildlevel);
			
			_membercnt = UICreateUtils.createTextField(null,null,50,25,506,4,fmt);
			_membercnt.selectable = false ;
			addChild(_membercnt);
			
			_applyButton = UICreateUtils.createGButton("申请", 50, 22, 595, 1, KTButtonData.SMALL_BUTTON);
			_applyButton.addEventListener(MouseEvent.CLICK, onClickApply);
			addChild(_applyButton);
			
			_viewButton = UICreateUtils.createGButton("查看", 50, 22, 652, 1, KTButtonData.SMALL_BUTTON);
			_viewButton.addEventListener(MouseEvent.CLICK, onClickView);
			addChild(_viewButton);
			
			_applyText = UICreateUtils.createTextField("正在申请中...",null,90,25,571,4,fmt);
			addChild(_applyText);

			_applyButton.visible = false ;
			_viewButton.visible = false ;
			_applyText.visible = false ;
			
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			addEventListener(MouseEvent.ROLL_OUT, onMouseLeave);
			addEventListener(MouseEvent.CLICK, onClickView ) ;
			_bg.addEventListener(MouseEvent.CLICK, onClickView);
			_bgover.addEventListener(MouseEvent.CLICK, onClickView);
			
		}
		
		public function set vo(value:VoGuild):void{
			if( value != null ){
				_vo = value ;

				_guildrank.visible = true ;
				_guildname.visible = true ;
				_leadername.visible = true ;
				_guildlevel.visible = true ;
				_membercnt.visible = true ;
				
				_guildrank.text = _vo.seq.toString() ;
				_guildname.text = _vo.name ;
				_leadername.htmlText = _vo.leader == null ? 
				"no leader" : StringUtils.addEvent( _vo.leader.colorname() , "to" );
				_guildlevel.text = _vo.level.toString() ;
				_membercnt.text = _vo.membercnt.toString() ;
				
				if( _manager.selfguild != null )
				{
					_applyText.visible = false ;
					_applyButton.visible = false ;
					_viewButton.visible = true ;
					
				}
				else if( _vo.isApply )
				{
					_applyText.visible = true ;
					_applyButton.visible = false ;
					_viewButton.visible = true ;
				}
				else 
				{
					_applyText.visible = false ;
					_applyButton.visible = true ;
					_viewButton.visible = true ;					
				}
			}
			else{
				_vo = null ; 
				_guildrank.visible = false ;
				_guildname.visible = false ;
				_leadername.visible = false ;
				_guildlevel.visible = false ;
				_membercnt.visible = false ;
				_applyText.visible = false ;
				_applyButton.visible = false ;
				_viewButton.visible = false ;
			}
		}
		
		public function get vo():VoGuild
		{
			return _vo ;
		}
		
		public function updateStatus():void{

			if( _vo == null )
				return ;
			if( _manager.selfguild != null )
			{
				_applyText.visible = false ;
				_applyButton.visible = false ;
				_viewButton.visible = true ;	
			}
			else if( _vo.isApply )
			{
				_applyText.visible = true ;
				_applyButton.visible = false ;
				_viewButton.visible = true ;
			}
			else 
			{
				_applyText.visible = false ;
				_applyButton.visible = true ;
				_viewButton.visible = true ;					
			}
		}

		private function onMouseLeave(event : MouseEvent) : void {
			
			removeChildAt(0);
			addChildAt(_bg, 0);
		}

		private function onMouseOver(event : MouseEvent) : void {

			removeChildAt(0);
			addChildAt(_bgover, 0);
		}

		private function onClickView(event : MouseEvent) : void {
			
			removeChildAt(0);
			addChildAt(_bg,0);
			if( _vo != null )
			{
				_viewwnd.show() ;
//				UIUtil.alignStageCenter(_viewwnd);
				_viewwnd.vo = _vo ;
				if( !_vo.isComplete )
				{
					GuildProxy.cs_viewGuild( _vo.id );
				}
			}
			event.stopPropagation() ;
			//show guild info view 
		}

		private function onClickApply(event : MouseEvent) : void {
			if( _vo != null )
				GuildProxy.cs_guildrequest( _vo.id );
			event.stopPropagation() ;
		}

		private function onMouseLeaveLeader(event : MouseEvent) : void {
			if( _vo != null && _vo.leader != null )
				_leadername.htmlText =  StringUtils.addEvent( _vo.leader.colorname() , "to") ;
		}

		private function onMouseOverLeader(event : MouseEvent) : void {
			if( _vo != null && _vo.leader != null )
				_leadername.htmlText =  StringUtils.addEvent( _vo.leader.linecolorname() , "to") ;
		}

		private function onClickLeader(event :Event) : void {
			
			if( _vo == null )
				return ;
			var vom:VoGuildMember = _vo.leader ;
			if( vom == null )
				return ;
			if(_vo.leaderId != UserData.instance.playerId)
				PlayerTip.show( vom.id,vom.name, GuildUtils.tiplist[GuildUtils.TL_GUILDLIST] ) ;
			event.stopPropagation();
			
		}
	}
}
