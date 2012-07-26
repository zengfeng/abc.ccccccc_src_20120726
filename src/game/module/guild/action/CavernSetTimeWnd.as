package game.module.guild.action {
	import gameui.manager.GToolTipManager;
	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipManager;
	import game.core.menu.MenuType;
	import game.core.menu.MenuManager;
	import game.module.guild.GuildView;
	import game.core.user.StateManager;
	import game.manager.DailyInfoManager;
	import game.manager.VersionManager;
	import game.module.guild.GuildEvent;
	import game.module.guild.GuildManager;
	import game.module.guild.GuildUtils;
	import game.module.guild.vo.VoGuildAction;
	import game.net.core.Common;
	import game.net.data.CtoS.CSGDSetTime;

	import gameui.controls.GButton;
	import gameui.controls.GImage;
	import gameui.controls.GRadioButton;
	import gameui.data.GButtonData;
	import gameui.data.GImageData;
	import gameui.data.GRadioButtonData;
	import gameui.data.GTitleWindowData;
	import gameui.group.GToggleGroup;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.GCommonSmallWindow;
	import com.utils.ColorUtils;
	import com.utils.TextFormatUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;





	/**
	 * @author 1
	 */
	public class CavernSetTimeWnd extends GCommonSmallWindow {
		
		public static function get instance():CavernSetTimeWnd
		{
			if( _instance == null )
			{
				_instance = new CavernSetTimeWnd();
				
			}
			return _instance ;
		}
		
		private static var _instance:CavernSetTimeWnd = null ;
		private var _radioSel : GRadioButton ;
		private var _radioArr : Vector.<GRadioButton> = new Vector.<GRadioButton>() ;
		private var _grp : GToggleGroup ;
		private var _intro:TextField ;
		private const _introText:String = "寻宝将于<font color='#FF0000'>__TIME__</font>开启\n活动开启前，随时可以更改开启日期";
		private var _thisweek : Boolean ;
		private var _confirm:GButton ;
		private var _manager:GuildManager = GuildManager.instance ;
		public function CavernSetTimeWnd() {
			var data:GTitleWindowData = new GTitleWindowData();
			data.width = 323 ;
			data.height = 276 ;
			data.parent = MenuManager.getInstance().getMenuTarget(MenuType.CLANLIST);
			data.modal =  true ;
			data.allowDrag = true ;
			data.x = ( data.parent.width - data.width ) / 2 ;
			data.y = ( data.parent.height - data.height ) / 2 ;
			super(data);
			initView() ;
		}
		protected function initView():void{
			
			title = "家族寻宝";
			
			var bg:Sprite = UIManager.getUI( new AssetData(GuildUtils.clanBack) );
			bg.width = 308;
			bg.height = 265 ;
			bg.x = 8 ;
			bg.y = 2 ;
			_contentPanel.addChild(bg);
			
			var bossbg:Sprite = UIManager.getUI(new AssetData(GuildUtils.brightBack));
			bossbg.x = 11 ;
			bossbg.y = 5 ;
			bossbg.width = 301 ;
			bossbg.height = 127 ;
			_contentPanel.addChild(bossbg);
			
			var bossiconbg:Sprite = UIManager.getUI(new AssetData(GuildUtils.cavernbossbg));
			bossiconbg.x = 111 + bossiconbg.width/2  ;
			bossiconbg.y = 32 + bossiconbg.height/2 ;
			_contentPanel.addChild(bossiconbg);
			
			var imgdata:GImageData = new GImageData() ;
			var bossimg:GImage = new GImage(imgdata) ;
			bossimg.url = VersionManager.instance.getUrl("assets/ico/BossHeadIcon/5009.png");
			bossimg.x = 144  ;
			bossimg.y = -61 ;
			_contentPanel.addChild(bossimg);
			
			_grp = new GToggleGroup();
			var svrwd:uint = getCurrentDate().day ;
			svrwd = svrwd == 0 ? 7 : svrwd ;
			for( var weekd:uint = 1 ; weekd < 8 ; ++ weekd )
			{
				var rdata:GRadioButtonData = new GRadioButtonData();
				rdata.x = 22 + ((weekd-1)%4)*77 ;
				rdata.y = 136 + Math.floor((weekd-1)/4)*23 ;
				rdata.labelData.text = "周"+ GuildUtils.WEEKDAY[weekd%7];
				rdata.labelData.width = 47 ;
				rdata.labelData.textColor = ColorUtils.PANELTEXT0X;
				rdata.labelData.textFieldFilters = null ;
				var rad:GRadioButton = new GRadioButton(rdata);
				rad.group = _grp;
				rad.name = (weekd%7).toString() ;
				rad.addEventListener(MouseEvent.MOUSE_UP , onSelectRadio );
				_contentPanel.addChild(rad);
				_radioArr.push( rad );
			}
			
			_intro = new TextField() ;
			_intro.x = 22 ;
			_intro.y = 187 ;
			_intro.width = 275 ;
			_intro.height = 40 ;
			_intro.multiline = true ;
			
			var fmt:TextFormat = TextFormatUtils.panelContentCenter ;
//			fmt.align = TextFormatAlign.CENTER ;
//			fmt.size = 12 ;
//			fmt.color = ColorUtils.PANELTEXT0X;
			_intro.defaultTextFormat = fmt ;
			_intro.selectable = false ;
			_contentPanel.addChild(_intro);
//			var ldata:GLabelData = new GLabelData() ;
//			ldata.x = 38 ;
//			ldata.y = 228 ;
//			ldata.width = 250 ;
//			ldata.textFieldFilters = null ;
//			ldata.textColor = 0x000000
//			ldata.text = "寻宝默认为周六" + StringUtils.addColor("19:15", "#FF0000" ) + "开启,请在此之前修改"+StringUtils.NEWLINE_TOKENS[0] + "活动尚未开启前，族长保有随时修改的权利";
//			var label:GLabel = new GLabel(ldata);
//			_contentPanel.addChild(label);
			
			var bdata:GButtonData = new GButtonData() ;
			bdata.x = 122 ; 
			bdata.y = 229 ;
			bdata.labelData.text = "确定" ;
			_confirm = new GButton(bdata);
			_contentPanel.addChild(_confirm);
			_confirm.addEventListener(MouseEvent.CLICK, onClickButton);
			_confirm.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
			_confirm.toolTip = ToolTipManager.instance.getToolTip(ToolTip);
			updateView() ;
			
			_manager.addEventListener(GuildEvent.GUILD_ACTION_CHANGE, onActionChange);
		}

		private function onMouseRollOver(event : MouseEvent) : void {
			_confirm.toolTip.source = "家族寻宝正在进行中，无法修改时间";
		}
		
		public function updateView():void
		{
			var vo:VoGuildAction = _manager.actiondata[2];
			var sel:int ;
			var wd:int = getCurrentDate().day ;
			var rwd:int = 0;
			if( vo.state < 1 )
			{
				sel = vo.config & 7 ;
				for each( var r1:GRadioButton in _radioArr )
				{
					rwd = int(r1.name) ;
					if( wd == rwd )
					{
						if( isTimeOver() )
						{
							r1.enabled = false ;
						}
						else
							r1.enabled = true ; 
					}
					else if( wd != 0 && rwd > wd || rwd == 0 )
						r1.enabled = true ;
					else 
						r1.enabled = false ;
						
					if( rwd == sel )
					{
						r1.selected = true ;
						_radioSel = r1 ;
					}
				}
				_thisweek = true ;
			}
			else 
			{
				sel = vo.config >> 3 ;
				for each( var r2:GRadioButton in _radioArr )
				{
					r2.enabled = true ;	
					rwd = int(r2.name) ;			
					if( rwd == sel )
					{
						r2.selected = true ;
						_radioSel = r2 ;
					}
				}
				_thisweek = false ;
			}
			updateConfirmBtn( vo != null && vo.state != 2 && vo.state != 1 );
			updateIntroText() ;
		}
		
		private function updateConfirmBtn(b:Boolean):void{
			if( _confirm.enabled ){
				if( !b ){
					_confirm.enabled = false ;
					_confirm.mouseEnabled = true ;
					_confirm.mouseChildren =true ;
					_confirm.removeEventListener(MouseEvent.CLICK, onClickButton);
					GToolTipManager.registerToolTip(_confirm);
				}
			}
			else {
				if( b ){
					_confirm.enabled = true ;
					GToolTipManager.destroyToolTip(_confirm);
					_confirm.addEventListener(MouseEvent.CLICK, onClickButton);
				}
			}
		}
		
		public function onSelectRadio( evt:Event ):void
		{
			_radioSel = _grp.selection as GRadioButton ;
		}
		
		public function onClickButton( evt:Event ):void
		{
			var vo:VoGuildAction = _manager.actiondata[2];
			if( vo.guildremain != 0 && getCurrentDate().day == int(_radioSel.name) && isTimeOver() )
			{
				StateManager.instance.checkMsg(175);
			}
			else 
			{
				var msg:CSGDSetTime = new CSGDSetTime() ;
				msg.weekday = uint( _radioSel.name )|(vo.state >= 1 ? 8:0);
				Common.game_server.sendMessage(0xFC,msg);
				this.hide();
			}
		}
		public function updateIntroText():void
		{
			if( _radioSel != null )
			{
				var str:String = " 周"+GuildUtils.WEEKDAY[(int)(_radioSel.name)] ;
				str += " 18: 30 " ;
				_intro.htmlText = (_thisweek ? "本周":"下周") + _introText.replace("__TIME__", str);
			}
		}
		
		public function getCurrentDate():Date
		{
			var date:Date = new Date() ;
			date.time = date.time + DailyInfoManager.instance.stampoff ;
			return date ;
		}
		
		public function isTimeOver():Boolean
		{
			var vo:VoGuildAction = GuildManager.instance.actiondata[2];
			var date:Date = getCurrentDate();
			var day1:Number = date.date ;
			date.time -= vo.beginstamp ;
			var day2:Number = date.date ;
			return day1 == day2 ;
			
		}
		
		public function onActionChange(evt:Event):void
		{
			updateView();
		}
	}
}
