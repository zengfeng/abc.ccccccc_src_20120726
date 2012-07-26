package game.module.guild {
	import game.definition.UI;
	import com.utils.TextFormatUtils;
	import com.utils.FilterUtils;
	import com.utils.UICreateUtils;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import gameui.containers.GPanel;
	import gameui.controls.GScrollBar;
	import gameui.data.GPanelData;
	import gameui.data.GScrollBarData;
	import gameui.events.GScrollBarEvent;
	import gameui.manager.UIManager;
	import net.AssetData;





	/**
	 * @author zhangzheng
	 */
	public class GuildMemberTab extends GPanel {

		private static const PAGE_SIZE:int = 14 ;
		
		private var _memberlist:Vector.<GuildMemberItem> = new Vector.<GuildMemberItem>();
		private var _scrollbar:GScrollBar ;
		private var _manager:GuildManager = GuildManager.instance;

		public function GuildMemberTab() {
			var data:GPanelData = new GPanelData() ;
			data.width = 443 ;
			data.height = 385 ;
			super(data);
			initView() ;
		}
		
		public function initView() : void {
			var bg:Sprite = UICreateUtils.createSprite(GuildUtils.clanBack,443,385) ;
			addChild(bg);
			
			bg = UICreateUtils.createSprite(UI.GUILD_LIST_TITLE,437,26,3,3);
			addChild(bg);

			var fmt : TextFormat = new TextFormat();
			fmt.font = UIManager.defaultFont;
			fmt.color = 0x2F1F00;
			fmt.size = 12;
			fmt.leading = 3;
			fmt.align = TextFormatAlign.CENTER ;
			fmt.bold = true ;

			var txt:TextField = UICreateUtils.createTextField("族员列表",null,75,25,22,7,fmt);
			txt.selectable = false ;
			addChild(txt);
			
			txt = UICreateUtils.createTextField("等级",null,51,25,119,7,fmt);
			txt.selectable = false ;
			addChild(txt);

			txt = UICreateUtils.createTextField("职务",null,50,25,167,7,fmt);
			txt.selectable = false ;
			addChild(txt);

			txt = UICreateUtils.createTextField("竞技场排名",null,95,25,204,7,fmt);
			txt.selectable = false ;
			addChild(txt);
			
			txt = UICreateUtils.createTextField("总贡献",null,65,24,287,7,fmt);
			txt.selectable = false ;
			addChild(txt);
			
			txt = UICreateUtils.createTextField("状态",null,50,24,369,7,fmt);
			txt.selectable = false ;
			addChild(txt);			
			
			var itembg:Sprite = new Sprite() ;
			itembg.x = 3 ;
			itembg.y = 31 ;
			addChild(itembg);
			
			for( var i:int = 0 ; i < PAGE_SIZE ; ++ i )
			{
				var item:GuildMemberItem = new GuildMemberItem();
				item.updatebg(i);
				item.x = 0 ;
				item.y = i * 25 ;
				itembg.addChild(item);
				_memberlist.push(item) ;
			}
			
			var sbdata:GScrollBarData = new GScrollBarData() ;
			sbdata.x = 428;
			sbdata.y = 31;
			sbdata.wheelSpeed = 1;
			sbdata.movePre = 1;
			sbdata.height = PAGE_SIZE * 25;
			_scrollbar = new GScrollBar(sbdata);
			addChild(_scrollbar);
			
			itembg.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			_scrollbar.addEventListener(GScrollBarEvent.SCROLL, onScroll);
			_manager.addEventListener(GuildEvent.GUILD_MEMBER_LIST_CHANGE, onMemberListChange);
//			_manager.addEventListener(GuildEvent.GUILD_MEMBER_INFO_CHANGE, onMemberListChange);
//			_manager.addEventListener( GuildEvent.MEMBER_INFO_CHANGE , onMemberChange);
		}

		private function onMemberInfoChange(event : GuildEvent) : void {
			for each( var mem:GuildMemberItem in _memberlist )
			{
				if( mem.vo != null && mem.vo.id == event.param )
					mem.refresh() ;
			}
		}

		public function initMembers():void
		{
			refreshMemberList(0);
			_scrollbar.resetValue(PAGE_SIZE, 0, Math.max(_manager.selfguild.memberList.length - PAGE_SIZE, 0 ), 0 ) ;
		}

		private function onMemberListChange(event : GuildEvent) : void {
			
			if( _manager.selfguild == null )
				return ;
			
			var pos:int = Math.min( _manager.selfguild.memberList.length - PAGE_SIZE , _scrollbar.scrollPosition ) ;
			pos = pos < 0 ? 0 : pos ;
			var len:int = _manager.selfguild.memberList.length ;
			refreshMemberList(pos);
			_scrollbar.resetValue(PAGE_SIZE, 0, len > PAGE_SIZE ? len - PAGE_SIZE : 0 , pos ) ;
		}
		
		private function onScroll(event : GScrollBarEvent) : void {
			var pos:int = Math.min( _manager.selfguild.memberList.length - PAGE_SIZE , _scrollbar.scrollPosition ) ;
			pos = pos < 0 ? 0 : pos ;
			refreshMemberList(pos);
		}

		private function onMouseWheel(event : MouseEvent) : void {
			event.stopPropagation();
			_scrollbar.scroll(event.delta);
		}
		
		private function refreshMemberList( pos:int ):void{
			
			for( var i:int = 0 ; i < PAGE_SIZE ; ++ i )
			{
				if( pos + i < _manager.selfguild.memberList.length )
				{
					_memberlist[i].vo = _manager.selfguild.memberList[pos + i];
				}
				else 
				{
					_memberlist[i].vo = null ;
				}
				_memberlist[i].updatebg(pos + i);
			}

		}
	}
}
