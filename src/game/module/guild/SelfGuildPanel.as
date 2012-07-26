package game.module.guild {
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.module.guild.action.GuildActionTab;
	import game.module.guild.ui.GuildBlockFrame;
	import game.module.guild.ui.GuildBlockFrameData;
	import game.module.guild.vo.VoGuild;

	import gameui.containers.GPanel;
	import gameui.containers.GTabbedPanel;
	import gameui.controls.GButton;
	import gameui.controls.GProgressBar;
	import gameui.data.GPanelData;
	import gameui.data.GProgressBarData;
	import gameui.data.GTabbedPanelData;
	import gameui.manager.GToolTipManager;
	import gameui.manager.UIManager;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	import com.commUI.alert.Alert;
	import com.commUI.button.KTButtonData;
	import com.commUI.tips.PlayerTip;
	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipManager;
	import com.utils.FilterUtils;
	import com.utils.StringUtils;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;
	import com.utils.UIUtil;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;





	/**
	 * @author zhangzheng
	 */
	public class SelfGuildPanel extends GPanel {
		
		private var _guildname:TextField ;
		private var _guildleader:TextField ;
		private var _guildlevel:TextField ;
		private var _guildrank:TextField ;
		private var _membercnt:TextField ;
		private var _announce:TextField ;
		private var _expbar:GProgressBar ;
		private var _expbartxt:TextField ;
		
		private var _votebtn:GButton ;
		private var _introbtn:GButton ;	//介绍按钮
		private var _quitbtn:GButton ;	//退出/解散按钮
		private var _otherguild:GButton ;
		private var _guildfield:GButton ;
		
		private var _tabpanel:GTabbedPanel ;
		private var _membertab:GuildMemberTab ;
		private var _audittab:GuildAuditTab ;
		private var _actiontab:GuildActionTab ;
		private var _trendtab:GuildTrendTab ;
		
		private var _manager:GuildManager = GuildManager.instance ;
		private var _vo:VoGuild ;
		
		//popup window
		private var _intrownd:GuildIntroWnd ;
		private var _votewnd:GuildVoteWindow ;
		
		public function SelfGuildPanel() {
			var data:GPanelData = new GPanelData() ;
			data.width = 735 ;
			data.height = 417 ;
			data.bgAsset = new AssetData( SkinStyle.emptySkin );
			super(data);
			initView();
		}
		
		private function initView():void {
			//base info background 
			var bg:Sprite = UICreateUtils.createSprite( GuildUtils.clanBack,272,410,5,0 );
			addChild(bg);
			
			var blockdata:GuildBlockFrameData = new GuildBlockFrameData() ;
			blockdata.width = 254 ;
			blockdata.height = 144 ;
			blockdata.x = 14 ;
			blockdata.y = 9 ;
			blockdata.title = "家族信息" ;
			var block:GuildBlockFrame = new GuildBlockFrame(blockdata);
			addChild(block);
			
			blockdata.height = 198 ;
			blockdata.y = 161 ;
			blockdata.title = "家族公告" ;
			block = new GuildBlockFrame(blockdata);
			addChild(block);
			
			var basefmt:TextFormat = TextFormatUtils.panelContent;
//			basefmt.size = 12 ;
//			basefmt.color =  ColorUtils.PANELTEXT0X;
			//guild name text 
			_guildname = UICreateUtils.createTextField("家族名字:",null,150,18,27,44,basefmt);
			addChild(_guildname);
			
			var txt:TextField = UICreateUtils.createTextField( "家族族长:",null,100,18,27,62,basefmt );
			addChild(txt);
			
			_guildleader = UICreateUtils.createTextField(null,null,104,18,81,62,basefmt);
			_guildleader.selectable = false ;
			_guildleader.mouseEnabled = true ;
			_guildleader.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverLeader);
			_guildleader.addEventListener(MouseEvent.MOUSE_OUT, onMouseLeaveLeader);
			_guildleader.addEventListener(TextEvent.LINK, onClickLeader);
			addChild(_guildleader);
			
			_guildrank = UICreateUtils.createTextField("家族排名:",null,100,18,27,80,basefmt);
			addChild(_guildrank);

			_membercnt = UICreateUtils.createTextField("家族人数:",null,100,18,27,98,basefmt);
			addChild(_membercnt);

			_guildlevel = UICreateUtils.createTextField("家族等级:",null,100,18,27,116,basefmt);
			addChild(_guildlevel);
			
			_announce = UICreateUtils.createTextField(null,null,232,130,27,200,basefmt);
//			_announce.maxChars = 130 ;
			_announce.wordWrap = true ;
			_announce.multiline = true ;
//			_announce.addEventListener(FocusEvent.FOCUS_IN, onFocusInAnnounce);
//			_announce.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutAnnounce);
			addChild(_announce);
			//投票按钮
			_votebtn = UICreateUtils.createGButton("投票", 50, 22, 210, 62, KTButtonData.SMALL_BUTTON);
			_votebtn.addEventListener(MouseEvent.CLICK, onClickVote);
			addChild(_votebtn);

			//介绍按钮
			_introbtn = UICreateUtils.createGButton("设置", 50, 22, 210, 86, KTButtonData.SMALL_BUTTON);
			_introbtn.addEventListener(MouseEvent.CLICK, onClickIntro);
			addChild(_introbtn);

			//退出按钮
			_quitbtn = UICreateUtils.createGButton("退出", 50, 22, 210, 110, KTButtonData.SMALL_BUTTON);
			_quitbtn.addEventListener(MouseEvent.CLICK, onClickQuit);
			addChild(_quitbtn);
			
			//其他家族按钮
			_otherguild = UICreateUtils.createGButton( "其他家族",80,30,50,368 );
			_otherguild.addEventListener(MouseEvent.CLICK, onClickOtherGuild);
			addChild(_otherguild);
			
			//进入家园按钮
			_guildfield = UICreateUtils.createGButton( "进入家园",80,30,149,368 );
			_guildfield.addEventListener(MouseEvent.CLICK, onClickGuildField);
			addChild(_guildfield);
			
			//经验条
			var pbdata:GProgressBarData = new GProgressBarData() ;
			pbdata.x = 19 ;
			pbdata.y = 138 ;
			pbdata.width = 244 ;
			pbdata.height = 12 ;
			pbdata.max = 100 ;
			pbdata.padding = 4 ;
			pbdata.trackAsset = new AssetData(GuildUtils.progressTrack);
			pbdata.barAsset = new AssetData(GuildUtils.progressBar);
			pbdata.paddingY = pbdata.padding = 3 ;
			pbdata.paddingX = 3 ;
			_expbar = new GProgressBar(pbdata);
			_expbar.toolTip = ToolTipManager.instance.getToolTip(ToolTip);
			_expbar.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverExpBar);
			_expbar.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutExpBar);
			addChild(_expbar);
			
			var ebfmt:TextFormat = new TextFormat() ;
			ebfmt.size =12 ;
			ebfmt.color = 0xFFFFFF ;
			ebfmt.align = "center";
			ebfmt.font = UIManager.defaultFont ;
			_expbartxt = UICreateUtils.createTextField(null,null,244,12,19,138,ebfmt);
			_expbartxt.filters = [FilterUtils.defaultTextEdgeFilter];
			_expbartxt.autoSize = "center";
			_expbartxt.mouseEnabled = false ;
			addChild(_expbartxt);
			_expbartxt.visible = false ;
			
			_membertab = new GuildMemberTab() ;
			_audittab = new GuildAuditTab() ;
			_actiontab = new GuildActionTab();
			_trendtab = new GuildTrendTab();
			
			_membertab.addEventListener(GuildEvent.CLOSE_VIEW, onCloseView );
			_audittab.addEventListener(GuildEvent.CLOSE_VIEW, onCloseView );
			_actiontab.addEventListener(GuildEvent.CLOSE_VIEW, onCloseView );
			_trendtab.addEventListener(GuildEvent.CLOSE_VIEW, onCloseView );
			
			_manager.addEventListener(GuildEvent.GUILD_BASE_CHANGE, onGuildBaseChange);
			_manager.addEventListener(GuildEvent.GUILD_MEMBER_LIST_CHANGE, onMemberListChange);
			_manager.addEventListener(GuildEvent.SELF_POSITION_CHANGE, onSelfPositionChange);
		}
		
//		private function get defannounce():String
//		{
//			return _vo != null && _manager.selfmember.position > 0 ? _defannounce : "" ;
//		}

		private function onMouseOutExpBar(event : MouseEvent) : void {
			_expbartxt.visible = false ;
		}

//		private function onFocusOutAnnounce(event : FocusEvent) : void {
//			if( _announce.text != "" )
//				_showdefann = false ;
//			else 
//			{
//				_showdefann = true ;
//				_announce.htmlText = defannounce ;
//			}
//		}

//		private function onFocusInAnnounce(event : FocusEvent) : void {
//			
//			if( _announce.type == TextFieldType.INPUT && _showdefann ){
//				_announce.text = "" ;
//			}
//		}

		private function onSelfPositionChange(event : GuildEvent) : void {
			refreshTabbedPanel();
			_introbtn.visible = _manager.selfmember.position > 0 ;
		}

		private function onMemberListChange(event : GuildEvent) : void {
				_membercnt.text = "家族人数:" + _vo.memberList.length.toString() + "/20";
				_quitbtn.label.text = _vo.memberList.length <= 1 ? "解散" : "退出" ;
				
			}

		private function onGuildBaseChange(event : GuildEvent) : void {
			if( _vo != null )
			{
				_guildname.text = "家族名字:" + _vo.name ;
				_guildleader.htmlText = _vo.leader == null ? "" : StringUtils.addEvent( _vo.leader.colorname(), "to") ;
				_guildlevel.text = "家族等级:" + _vo.level.toString() ;
				_guildrank.text = "家族排名:" + _vo.seq.toString() ;
				_membercnt.text = "家族人数:" + _vo.memberList.length.toString() + "/20";
				_announce.htmlText = ( _vo.announce == null || _vo.announce == "" ) ? "<font color='#999999'>暂无公告</font>" : _vo.announce ;
				_expbar.value = _vo.levelexp == 0 ? 100 :
				 ( _vo.exp - _vo.prelevelexp )*100/( _vo.levelexp - _vo.prelevelexp );
				_votebtn.visible = _vo.status == 1 ;
			}
		}

		private function onClickLeader(event : TextEvent) : void {
			
			if( _vo != null && _vo.leader != null && _vo.leaderId != UserData.instance.playerId )
			{
				PlayerTip.show( _vo.leader.id, _vo.leader.name , GuildUtils.tiplist[GuildUtils.TL_MEMBER_NORM] );
			}
		}

		private function onMouseLeaveLeader(event : MouseEvent) : void {
			if( _vo != null && _vo.leader != null )
				_guildleader.htmlText = StringUtils.addEvent(_vo.leader.colorname(), "to");
		}

		private function onMouseOverLeader(event : MouseEvent) : void {
			if( _vo != null && _vo.leader != null )
				_guildleader.htmlText = StringUtils.addEvent(_vo.leader.linecolorname(), "to");
		}
		
		private function onCloseView( evt:Event ):void{
			dispatchEvent(evt);
		}

		private function onClickGuildField(event : MouseEvent) : void {
			GuildProxy.cs_enterguildcity() ;
			var evt:GuildEvent = new GuildEvent(GuildEvent.CLOSE_VIEW);
			dispatchEvent(evt);
		}

		private function onClickOtherGuild(event : MouseEvent) : void {
			var evt:GuildEvent = new GuildEvent(GuildEvent.CHANGE_STATE);
			evt.param = 0 ;
			dispatchEvent(evt);
		}
//
//		private function onClickAnnounce(event : MouseEvent) : void {
//			if( _showdefann )
//			{
//				GuildProxy.cs_guildannounce("") ;
//				return ;
//			}
//			if( !RegExpUtils.checkStr(_announce.text) ){
//				GuildProxy.cs_guildannounce( _announce.text );
//			}
//			else {
//				StateManager.instance.checkMsg(244);
//			}
//		}

		private function onClickQuit(event : MouseEvent) : void {
			if( _vo != null )
			{
				if( _vo.memberList.length == 1 )
					StateManager.instance.checkMsg(238,null,onQuitOk);
				else 
					StateManager.instance.checkMsg(239,null,onQuitOk);
			}
		}

		private function onQuitOk( evt:String ) : Boolean {
			if ( evt == Alert.OK_EVENT )
			{
				if( _vo == null )
					return true ;
				if( _vo.memberList.length == 1 ){
					GuildProxy.cs_guilddisband() ;
				}
				else {
					GuildProxy.cs_guildleave() ;
				}
			}
			return true ;
		}

		private function onClickIntro(event : MouseEvent) : void {
			if( _intrownd == null )
				_intrownd = new GuildIntroWnd() ;
//			UIUtil.alignStageCenter(_intrownd);
			_intrownd.show();
//			_manager.showIntroWindow() ;
		}

		private function onClickVote(event : MouseEvent) : void {
			if( _votewnd == null )
				_votewnd = new GuildVoteWindow() ;
//			UIUtil.alignStageCenter(_votewnd);
			_votewnd.show() ;
//			_manager.showVoteWindow() ;
		}

		private function onMouseOverExpBar(event : MouseEvent) : void {
			
			if( _vo != null ){
				_expbar.toolTip.source = _vo.levelexp == 0 ? "已满级" : "还需_EXP_经验升级".replace(/_EXP_/g,_vo.levelexp == 0 ? 0 : _vo.levelexp - _vo.exp );
				
				_expbartxt.visible = true ;
				_expbartxt.text = _vo.levelexp == 0 ? "已满级": (_vo.exp - _vo.prelevelexp).toString() + "/" + ( _vo.levelexp - _vo.prelevelexp ).toString();
			}
		}
		
		public function set vo( value:VoGuild ):void
		{
			_vo = value ;
			if( _vo == null )
			{
				_guildname.text =   "家族名字:";
				_guildleader.text = "" ;
				_guildlevel.text = "家族等级:" ;
				_guildrank.text = "家族排名:" ;
				_membercnt.text = "家族人数:0/20" ;
				_announce.text = "" ;
				_expbar.value = 0 ;
				_trendtab.clearTrends();
			}
			else 
			{
				_guildname.text = "家族名字:" + _vo.name ;
				_guildleader.htmlText = _vo.leader == null ? "" : StringUtils.addEvent( _vo.leader.colorname(), "to") ;
				_guildlevel.text = "家族等级:" + _vo.level.toString() ;
				_guildrank.text = "家族排名:" + _vo.seq.toString() ;
				_membercnt.text = "家族人数:" + _vo.memberList.length.toString() + "/20";
				_announce.htmlText = ( _vo.announce == null || _vo.announce == "" ) ? "<font color='#999999'>暂无公告</font>" : _vo.announce ;
				_introbtn.visible = _manager.selfmember.position > 0 ;
				_expbar.value = _vo.levelexp == 0 ? 100 :
				 ( _vo.exp - _vo.prelevelexp )*100/( _vo.levelexp - _vo.prelevelexp );
				_membertab.initMembers() ;
				
				_quitbtn.label.text = _vo.memberList.length <= 1 ? "解散" : "退出" ;
				_votebtn.visible = _vo.status == 1 ;
				refreshTabbedPanel();
			}
		}
		
		override protected function onShow():void{
			
			GToolTipManager.registerToolTip(_expbar);
			_tabpanel.group.selectionModel.index = 0 ;
		}
		
		override protected function onHide():void{
			GToolTipManager.destroyToolTip(_expbar);
		}
		
		private function refreshTabbedPanel():void{
			
			if( _tabpanel != null )
				removeChild(_tabpanel);
				
			var tpdata:GTabbedPanelData = new GTabbedPanelData() ;
			tpdata.x = 282 ;
			tpdata.y = 0 ;
			tpdata.tabData.gap = 1 ;
			_tabpanel = new GTabbedPanel(tpdata);
			addChild(_tabpanel);

			_tabpanel.addTab("族员", _membertab);
			if( _manager.selfmember.position > 1 )
				_tabpanel.addTab("审核", _audittab);
			_tabpanel.addTab("活动",_actiontab);
			_tabpanel.addTab("动态",_trendtab);
			_tabpanel.group.selectionModel.index = 0 ;
		}
	}
}
