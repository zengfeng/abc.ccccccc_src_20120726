package game.module.guild {
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.definition.UI;
	import game.module.friend.ManagerFriend;
	import game.module.guild.ui.GuildBlockFrame;
	import game.module.guild.ui.GuildBlockFrameData;
	import game.module.guild.vo.VoGuild;

	import gameui.controls.GButton;
	import gameui.controls.GScrollBar;
	import gameui.data.GScrollBarData;
	import gameui.data.GTitleWindowData;
	import gameui.events.GScrollBarEvent;
	import gameui.manager.UIManager;

	import com.commUI.GCommonSmallWindow;
	import com.commUI.button.KTButtonData;
	import com.commUI.tips.PlayerTip;
	import com.utils.StringUtils;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;





	/**
	 * @author zhangzheng
	 */
	public class ViewGuildWnd extends GCommonSmallWindow {
		
		private static const PAGE_SIZE:int = 7 ;
		private var _closebtn:GButton ;
		
//		private var _guildname:TextField ;
		private var _infoblock:GuildBlockFrame ;
		private var _leadername:TextField ;
		private var _membercnt:TextField ;
		private var _guildLevel:TextField ;
		private var _guildRank:TextField ;
		private var _guildIntro:TextField ;
		private var _memberlist:Vector.<ViewGuildMemberItem> = new Vector.<ViewGuildMemberItem>();
		private var _scrollbar:GScrollBar ;
		
		private var _vo:VoGuild ;
		private static var _instance:ViewGuildWnd ;
		private var _manager:GuildManager = GuildManager.instance ;
		
		public function ViewGuildWnd(s:Singleton) {
			
			s;
			var data:GTitleWindowData = new GTitleWindowData();
			data.width = 320 ;
			data.height = 373 ;
			data.parent = MenuManager.getInstance().getMenuTarget(MenuType.CLANLIST);
			data.modal =  true ;
			data.allowDrag = true ;
			data.x = ( data.parent.width - data.width ) / 2 ;
			data.y = ( data.parent.height - data.height ) / 2 ;
			super(data);
		}
		
		public static function get instance():ViewGuildWnd{
			if( _instance == null )
				_instance = new ViewGuildWnd(new Singleton());
			return _instance ;
		}
		
		override protected function initViews() : void
		{
			title = "查看家族";
			
			var bg:Sprite = UICreateUtils.createSprite(GuildUtils.clanBack,310,367,5);
			addChild(bg);

			var dat:GuildBlockFrameData = new GuildBlockFrameData() ;
			dat.width = 298 ;
			dat.height = 121 ;
			dat.x = 10 ;
			dat.y = 4 ;
			_infoblock = new GuildBlockFrame(dat);
			addChild(_infoblock);

//			bg = UICreateUtils.createSprite( ClanUtils.listBg_7,290,168,10,166 );
//			addChild(bg);

			bg = UICreateUtils.createSprite( UI.GUILD_LIST_TITLE, 300, 26, 10, 130 );
			addChild(bg);

			var basefmt:TextFormat = TextFormatUtils.panelContent ;
//			basefmt.size = 12 ;
//			basefmt.color =  ColorUtils.PANELTEXT0X;

			var tablefmt : TextFormat = new TextFormat();
			tablefmt.font = UIManager.defaultFont;
			tablefmt.color = 0x2F1F00;
			tablefmt.size = 12;
			tablefmt.leading = 3;
			tablefmt.align = TextFormatAlign.CENTER ;
			tablefmt.bold = true ;

//			tablefmt.size = 12 ;
//			tablefmt.color = 0xFFFFFF ;
			
			var txt:TextField = UICreateUtils.createTextField( "家族族长:",null, 100, 24, 13 ,35 , basefmt );
			addChild(txt);
			
			_leadername = UICreateUtils.createTextField(null,null,100,24,71,35,basefmt);
			_leadername.mouseEnabled = true ;
			_leadername.selectable = false ;
			addChild(_leadername);
			_leadername.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverName);
			_leadername.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutName);
			_leadername.addEventListener(TextEvent.LINK, onClickName);
			
			_membercnt = UICreateUtils.createTextField( "家族人数:",null,100,24,188,35,basefmt);
			_membercnt.selectable = false ;
			addChild(_membercnt);
			
			_guildLevel = UICreateUtils.createTextField( "家族等级:",null,100,24,13,52,basefmt);
			_guildLevel.selectable = false ;
			addChild(_guildLevel);
			
			_guildRank = UICreateUtils.createTextField( "家族排名:", null, 100,24,188,52,basefmt );
			_guildRank.selectable = false ;
			addChild(_guildRank); 
			
			var introtxt:TextField = UICreateUtils.createTextField("家族介绍:",null, 100, 24, 13 ,72 , basefmt);
			addChild(introtxt);
			
			_guildIntro = UICreateUtils.createTextField( null,null, 235,56,71,72,basefmt );
			_guildIntro.selectable = false ;
			_guildIntro.multiline = true ;
			_guildIntro.wordWrap = true ;
			addChild(_guildIntro);
			
			//族员列表title
		 	txt = UICreateUtils.createTextField("族员列表",null,72,24,38,134,tablefmt);
			txt.selectable =false ;
			addChild(txt);
			
			txt = UICreateUtils.createTextField("等级",null,48,24,124,134,tablefmt);
			txt.selectable =false ;
			addChild(txt);

			txt = UICreateUtils.createTextField("职务",null,48,24,172,134,tablefmt);
			txt.selectable =false ;
			addChild(txt);

			txt = UICreateUtils.createTextField("竞技场排名",null,84,24,217,134,tablefmt);
			txt.selectable =false ;
			addChild(txt);
			
			var memberbg:Sprite = new Sprite() ;
			memberbg.x = 10 ;
			memberbg.y = 154 ;
			addChild(memberbg);

			//族员列表
			for( var i:int = 0 ; i < PAGE_SIZE ; ++ i )
			{
				var item:ViewGuildMemberItem = new ViewGuildMemberItem();
				item.x = 0 ;
				item.y = 25*i ;
				memberbg.addChild(item);
				item.changebg(i);
				_memberlist.push(item);
			}
//			
			var sbdata:GScrollBarData = new GScrollBarData();
			sbdata.x = 300 ;
			sbdata.y = 154 ;
			sbdata.height = 175 ;
			sbdata.wheelSpeed = 1 ;
			sbdata.movePre =1 ;
			_scrollbar = new GScrollBar(sbdata);
			addChild(_scrollbar);
			_scrollbar.addEventListener(GScrollBarEvent.SCROLL, onScroll);
			memberbg.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			_closebtn = UICreateUtils.createGButton("关闭",80,30,118,332,KTButtonData.SMALL_BUTTON);
			_closebtn.addEventListener(MouseEvent.CLICK, function(evt:Event):void{hide();});
			addChild(_closebtn);
			
			
			_manager.addEventListener(GuildEvent.VIEW_GUILD_BUILD, onGuildComplete);
		}

		private function onGuildComplete(event : GuildEvent) : void {
			if( _vo != null && _vo.isComplete )
			{
				_guildIntro.text = _vo.intro == null ? "" : _vo.intro ;
				for( var i:int = 0 ; i < PAGE_SIZE ; ++ i )
				{
					if( _vo.memberList != null && i < _vo.memberList.length )
					{
						_memberlist[i].vo = _vo.memberList[i];
					}
					else 
					{
						_memberlist[i].vo = null ;
					}
					_memberlist[i].changebg(i);
				}
				_scrollbar.resetValue(PAGE_SIZE, 0, Math.max(_vo.memberList.length - PAGE_SIZE ,0), 0);
			}
		}
		
		public function set vo(value:VoGuild):void
		{
			_vo = value ;
			if( _vo != null )
			{
				_infoblock.title = _vo.name  ;
				_leadername.htmlText = _vo.leader == null ? "" : StringUtils.addEvent(_vo.leader.colorname(), "to") ;
				_membercnt.text = "家族人数:"+_vo.membercnt+"/20" ;
				_guildLevel.text = "家族等级:"+_vo.level.toString() ;
				_guildRank.text = "家族排名:"+_vo.seq.toString();
				_guildIntro.text = _vo.intro == null ? "" : _vo.intro ;
				for( var i:int = 0 ; i < PAGE_SIZE ; ++ i )
				{
					if( _vo.memberList != null && i < _vo.memberList.length )
					{
						_memberlist[i].vo = _vo.memberList[i];
					}
					else 
					{
						_memberlist[i].vo = null ;
					}
					_memberlist[i].changebg(i);
				}
				if( _vo.memberList != null )
					_scrollbar.resetValue(PAGE_SIZE, 0, Math.max( _vo.memberList.length - PAGE_SIZE ,0), 0);
				else 
					_scrollbar.resetValue(PAGE_SIZE, 0, 0, 0);
			}
			else 
				hide() ;
		}

		private function onScroll(event : GScrollBarEvent) : void {
			
			if( _vo == null )
				return ;
			var begin:int = _scrollbar.scrollPosition ;
			for( var i:int = 0 ; i < PAGE_SIZE ; ++ i )
			{
				if( begin + i < _vo.memberList.length ){
					_memberlist[i].vo = _vo.memberList[begin + i];
				}
				else {
					_memberlist[i].vo = null ;
				}
				_memberlist[i].changebg( begin + i );
			}
		}

		private function onMouseWheel(event : MouseEvent) : void {
			
			event.stopPropagation() ;
			_scrollbar.scroll(event.delta);
		}

		private function onClickName(event : TextEvent) : void {
			
			if( _vo == null || _vo.leader == null )
				return ;
			var fm:ManagerFriend = ManagerFriend.getInstance();
			if( fm.isInBackListByPlayerId(_vo.leader.id) )
				PlayerTip.show( _vo.id,_vo.leader.name , GuildUtils.tiplist[GuildUtils.TL_GUILD_VIEW_BLOCK] );
			else if( fm.isInFriendListByPlayerId(_vo.leader.id) )
				PlayerTip.show( _vo.id,_vo.leader.name , GuildUtils.tiplist[GuildUtils.TL_GUILD_VIEW_FRIEND] );
			else 
				PlayerTip.show(_vo.id,_vo.leader.name, GuildUtils.tiplist[GuildUtils.TL_GUILD_VIEW_NORM]);

		}

		private function onMouseOverName(event : MouseEvent) : void {
			if( _vo != null && _vo.leader != null ){
				_leadername.htmlText = StringUtils.addEvent(_vo.leader.linecolorname(),"to");
			}
		}

		private function onMouseOutName(event : MouseEvent) : void {
			if( _vo != null && _vo.leader != null ){
				_leadername.htmlText = StringUtils.addEvent(_vo.leader.colorname(),"to");
			}
		}
	}
}

class Singleton{
}
