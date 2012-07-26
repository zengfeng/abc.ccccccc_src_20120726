package game.module.guild {
	import game.definition.UI;
	import game.module.guild.vo.VoGuildTrend;

	import gameui.containers.GPanel;
	import gameui.controls.GCheckBox;
	import gameui.controls.GScrollBar;
	import gameui.data.GCheckBoxData;
	import gameui.data.GPanelData;
	import gameui.data.GScrollBarData;
	import gameui.events.GScrollBarEvent;

	import com.utils.ColorUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;




	/**
	 * @author 1
	 */
	public class GuildTrendTab extends GPanel
	{
		public static const PAGE_SIZE:int = 14 ;
		private var _hrcheck : GCheckBox ;
		private var _xpcheck : GCheckBox ;
		private var _manager : GuildManager = GuildManager.instance ;
		private var _trendlist : Vector.<GuildTrendItem> = new Vector.<GuildTrendItem>();
		private var _scrollbar : GScrollBar ;
		public function GuildTrendTab() : void
		{
			var data:GPanelData = new GPanelData();
			data.width = 443 ;
			data.height = 385 ;
			super(data);
			addBg();
			addEvent();
		}

		private function addEvent() : void {
			_manager.addEventListener(GuildEvent.GUILD_TREND_CHANGE, function(evt:GuildEvent):void{refreshView();} );
		}

		private function addBg() : void
		{
			var bg : Sprite = UICreateUtils.createSprite( GuildUtils.clanBack , 443, 386 );
			addChild(bg);
			
			bg = UICreateUtils.createSprite( UI.GUILD_LIST_TITLE , 436,26,3,3 );
			addChild(bg);
			
			var cdata : GCheckBoxData = new GCheckBoxData() ;
			cdata.labelData.text = "人事";
			cdata.labelData.textColor = ColorUtils.PANELTEXT0X ;
			cdata.labelData.textFieldFilters = []  ;
			cdata.labelData.width = 32 ;
			cdata.x = 20 ;
			cdata.y = 4 ;
			cdata.selected = true ;
			_hrcheck = new GCheckBox(cdata);
			addChild(_hrcheck);

			cdata.labelData.text = "贡献";
			cdata.labelData.textColor = ColorUtils.PANELTEXT0X ;
			cdata.labelData.textFieldFilters = []  ;
			cdata.showEffect = null ;
			cdata.x = 94 ;
			cdata.y = 4 ;
			cdata.selected = true ;
			_xpcheck = new GCheckBox(cdata);
			addChild(_xpcheck);
			
			var table:Sprite = new Sprite() ;
			table.x = 3 ;
			table.y = 31 ;
			addChild( table );
			
			for( var i:int = 0 ; i < PAGE_SIZE ; ++ i )
			{
				var item:GuildTrendItem = new GuildTrendItem();
				item.changebg(i);
				item.y = i * 25 ;
				table.addChild(item);
				_trendlist.push(item);
			}
			
			var sbdata:GScrollBarData = new GScrollBarData() ;
			sbdata.x = 428;
			sbdata.y = 31;
			sbdata.wheelSpeed = 1;
			sbdata.movePre = 1;
			sbdata.height = PAGE_SIZE * 25;
			_scrollbar = new GScrollBar(sbdata);
			addChild(_scrollbar);
			
			_xpcheck.addEventListener(Event.CHANGE, onChangeFilter);
			_hrcheck.addEventListener(Event.CHANGE, onChangeFilter);
			_scrollbar.addEventListener(GScrollBarEvent.SCROLL, onScroll);
			table.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		private function onMouseWheel(event : MouseEvent) : void {
			event.stopPropagation();
			_scrollbar.scroll(event.delta);
		}

		private function onScroll(event : GScrollBarEvent) : void {
			refreshView() ;
		}
		
		override protected function onShow():void{
			GuildManager.instance.requestTrendList() ;
		}

		public function onChangeFilter(evt : Event) : void
		{
			refreshView();
		}
		
		private function refreshView():void
		{
			var sp:int = _scrollbar.scrollPosition ;
			var res:Vector.<VoGuildTrend> = _manager.getFilteredTrends(_hrcheck.selected, _xpcheck.selected);
			var pos:int = Math.min( sp, res.length - PAGE_SIZE );
			pos = pos >= 0 ? pos : 0 ;
			for( var i:int = pos ; i < pos+PAGE_SIZE ; ++ i )
			{
				if( i < res.length )
				{
					_trendlist[i-pos].vo = res[i];
				}
				else 
				{
					_trendlist[i-pos].vo = null ;
				}
			}
			_scrollbar.resetValue(PAGE_SIZE, 0, Math.max(res.length - PAGE_SIZE , 0), pos);
		}

		public function clearTrends() : void {
			for( var i:int = 0 ; i < PAGE_SIZE ; ++ i ){
				_trendlist[i].vo = null ;
				_trendlist[i].changebg(i);
			}
			_scrollbar.resetValue(PAGE_SIZE, 0, 0, 0);
		}
	}
}
import com.utils.TextFormatUtils;
import game.module.guild.GuildUtils;
import game.module.guild.vo.VoGuildTrend;

import com.utils.ColorUtils;
import com.utils.UICreateUtils;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
class GuildTrendItem extends Sprite{
	private var _lightbg:Sprite ;
	private var _deepbg:Sprite ;
	private var _infotxt:TextField ;
	private var _timetxt:TextField ;
	private var _vo:VoGuildTrend ;
	
	public function GuildTrendItem()
	{
		super() ;
		addbg();
		initVIew() ;
	}

	private function initVIew() : void {
		
		var fmt:TextFormat = TextFormatUtils.panelContent ;
//		fmt.size = 12 ;
//		fmt.color = ColorUtils.PANELTEXT0X ;
//		fmt.align = TextFormatAlign.LEFT ;
		
		_infotxt = UICreateUtils.createTextField(null,null,380,25,2,4,fmt);
		addChild(_infotxt);
		
		_timetxt = UICreateUtils.createTextField(null,null,70,25,width - 80 , 4, fmt);
		addChild(_timetxt);
	}

	private function addbg() : void {
		_deepbg = UICreateUtils.createSprite( GuildUtils.clanDeepBar , 424, 25 );
		_lightbg = UICreateUtils.createSprite( GuildUtils.clanLightBar , 424, 25 );
		addChild(_deepbg);
	}
	
	public function changebg( seq:int ):void{
		removeChildAt(0);
		addChildAt( (seq & 1) == 1 ? _deepbg:_lightbg , 0);
	}
	
	public function set vo( value:VoGuildTrend ):void{
		if( value == null )
		{
			_infotxt.visible = false ;
			_timetxt.visible = false ;
		}
		else 
		{
			_infotxt.visible = true ;
			_infotxt.htmlText = value.trendstr ;
			_timetxt.visible = true ;
			_timetxt.htmlText = value.timestr;
		}
		_vo = value ;
	}
}
