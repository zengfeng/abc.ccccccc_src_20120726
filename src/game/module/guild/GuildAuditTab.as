package game.module.guild {
	import game.definition.UI;

	import gameui.containers.GPanel;
	import gameui.controls.GScrollBar;
	import gameui.data.GPanelData;
	import gameui.data.GScrollBarData;
	import gameui.events.GScrollBarEvent;
	import gameui.manager.UIManager;

	import com.utils.FilterUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;




	/**
	 * @author zhangzheng
	 */
	public class GuildAuditTab extends GPanel {
		
		private static const PAGE_SIZE:int = 14 ;
		
		private var _applylist:Vector.<GuildAuditItem> = new Vector.<GuildAuditItem>();
		private var _scrollbar:GScrollBar ;
		private var _manager:GuildManager = GuildManager.instance;
		
		public function GuildAuditTab() {
			var data:GPanelData = new GPanelData();
			data.width = 443 ;
			data.height = 385 ;
			super(data);
			initView() ;
			
		}
		
		public function initView() : void {
			var bg:Sprite = UICreateUtils.createSprite(GuildUtils.clanBack,443,385,0,0);
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
			
			var txt:TextField = UICreateUtils.createTextField("申请人",null,75,24,37,7,fmt);
			txt.selectable = false ;
			addChild(txt);
			
			txt = UICreateUtils.createTextField("等级",null,55,24,129,7,fmt);
			txt.selectable = false ;
			addChild(txt);
			txt = UICreateUtils.createTextField("竞技场排名",null,90,24,195,7,fmt);
			txt.selectable = false ;
			addChild(txt);
			txt = UICreateUtils.createTextField("操作",null,56,24,340,7,fmt);
			txt.selectable = false ;
			addChild(txt);
			
			var itembg:Sprite = new Sprite() ;
			itembg.x = 3 ;
			itembg.y = 31 ;
			addChild(itembg);
			
			for( var i:int = 0 ; i < PAGE_SIZE ; ++ i )
			{
				var item:GuildAuditItem = new GuildAuditItem();
				item.updatebg(i);
				item.x = 0 ;
				item.y = i * 25 ;
				itembg.addChild(item);
				_applylist.push(item) ;
				
				if( _manager.applyList != null)
				{
					if( i < _manager.applyList.length  )
						item.vo = _manager.applyList[i];
					else 
						item.vo = null ;
				}
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
			_manager.addEventListener( GuildEvent.GUILD_APPLY_CHANGE , onApplyChange);
		}

		private function onApplyChange(event : GuildEvent) : void {
			var pos:int = _scrollbar.scrollPosition ;
			pos = Math.max( Math.min( pos , _manager.applyList.length - PAGE_SIZE ) , 0 ); 
			for( var i:int = 0 ; i < PAGE_SIZE ; ++ i )
			{
				if( pos + i < _manager.applyList.length )
				{
					_applylist[i].vo = _manager.applyList[ pos + i];
				}
				else 
				{
					_applylist[i].vo = null ;
				}
				_applylist[i].updatebg( pos + i ) ;
			}
			_scrollbar.resetValue(PAGE_SIZE, 0, Math.max( _manager.applyList.length - PAGE_SIZE , 0), pos);
		}

		private function onScroll(event : GScrollBarEvent) : void {
			_manager.requestApplyList();
		}

		private function onMouseWheel(event : MouseEvent) : void {
			event.stopPropagation() ;
			_scrollbar.scroll(event.delta);
		}
		
		override protected function onShow():void{
			_manager.requestApplyList();
			super.show() ;
		}
	}
}
