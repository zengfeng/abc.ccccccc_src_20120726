package game.module.guild.action {
	import worlds.apis.MTo;
	import game.definition.UI;
	import game.manager.VersionManager;
	import game.module.guild.GuildEvent;
	import game.module.guild.GuildManager;
	import game.module.guild.vo.VoGuildAction;

	import gameui.containers.GPanel;
	import gameui.controls.GImage;
	import gameui.data.GPanelData;
	import gameui.manager.GToolTipManager;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.commUI.tooltip.ToolTipManager;
	import com.commUI.tooltip.WordWrapToolTip;
	import com.utils.ColorUtils;
	import com.utils.FilterUtils;
	import com.utils.TextFormatUtils;
	import com.utils.UICreateUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;





	/**
	 * @author 1
	 */
	public class GuildActionItem extends GPanel
	{
		protected static const SINGLE_BTN_WIDTH:int = 70 ;
		protected static const TWO_BTN_WIDTH:int = 50 ;
		protected static const TWO_BTN_SPACE:int = 10 ;
		protected static const BUTTON_CENTER:int = 360 ;
		
		private static const ACTION_SPINMONEY:int = 0 ;
		private static const ACTION_CARVEN:int = 2 ;
		private static const ACTION_DRINKTEA:int = 1 ;
		private static const ACTION_ESCOR:int = 3 ;
		private static const ACTION_GROUPHUNT:int = 4 ;
		
		protected var _icon : GImage ;
		protected var _iconbg : Sprite ;
		protected var _nameLabel : TextField ;
		protected var _infoLabel : TextField ;
//		private var _joinBtn : GButton ;
		protected var _gadata : VoGuildAction ;
//		private var _opened : Boolean = true ;
//		private var _cftbtn : GButton ;
//		private var _finalLabel : TextField ;

		public function GuildActionItem()
		{
			var data:GPanelData = new GPanelData() ;
			data.width = 423 ;
			data.height = 66 ;
			super(data);
		}
		
		public static function createItem( typ:int ):GuildActionItem
		{
			var result : GuildActionItem ;
			switch( typ )
			{
				case ACTION_SPINMONEY : 
					result = new SpinMoneyPanel();
					break ;
				case ACTION_CARVEN : 
					result = new CarvenPanel() ;
					break ;
				case ACTION_DRINKTEA :
					result = new DrinkTeaPanel() ;
					break ;
				case ACTION_ESCOR :
					result = new EscorPanel() ;
					break ;
				case ACTION_GROUPHUNT :
				// TO DO
//					result = new GuildGroupHunt() ;
					break ;
				default :
					result = null ;
			}
			return result ;
		}

		public function initPanel(line:int) : void
		{
			var bg : Sprite = UIManager.getUI(new AssetData(UI.GUILD_ACTION_ITEM_BACK));
			bg.width = width ;
			bg.height = height ;
			addChild(bg);
			
			_iconbg = UICreateUtils.createSprite( UI.GUILD_ACTION_ICON_BACK, 60, 60, 13, 3 );
			addChild(_iconbg);
			
			_icon = UICreateUtils.createGImage(null,48,48,19,9);
			addChild(_icon);
			
			
			
//			var data:ItemIconData = new ItemIconData();
//			data.x = 13 ;
//			data.y = 3 ;
//			data.width = 60 ;
//			data.height = 60 ;
//			_icon = new CommonIcon(data);
//			_icon.background = UIManager.getUI(new AssetData(UI.GUILD_ACTION_ICON_BACK));
//			addChild(_icon);

			var fmt : TextFormat = TextFormatUtils.panelSubTitle ;
//			fmt.size = 14 ;
//			fmt.bold = true ;
//			fmt.align = TextFormatAlign.LEFT ;
//			fmt.color = ColorUtils.PANELTEXT0X ;
			_nameLabel = UICreateUtils.createTextField(null,null,65,20,87,24,fmt);
//			_nameLabel.width = 65 ;
//			_nameLabel.height = 20 ;
//			_nameLabel.x = 67 ;
//			_nameLabel.y = 22 ;
//			_nameLabel.defaultTextFormat = fmt;
			addChild(_nameLabel);
			
			fmt = TextFormatUtils.panelContentCenter ;
//			fmt.size = 12 ;
//			fmt.align = TextFormatAlign.CENTER ;
//			fmt.color = ColorUtils.PANELTEXT0X ;
			_infoLabel = UICreateUtils.createTextField(null,null,110,18,160,25,fmt);
//			_infoLabel.defaultTextFormat = fmt ;
//			_infoLabel.x = 160 ;
//			_infoLabel.y = 22 ;
//			_infoLabel.height = 18 ;
//			_infoLabel.width = 110 ;
			addChild(_infoLabel);
			
			_icon.visible = false ;
//			_nameLabel.selectable = false ;
//			_infoLabel.selectable = false ;
			toolTip = ToolTipManager.instance.getToolTip(WordWrapToolTip);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}
		
//		override protected function onShow():void
//		{
//			if( _toolTip != null )
//			{
//				ToolTipManager.instance.registerToolTip(this,ToolTip);
//				toolTip.source = tipText ;
//			}
//		}
//		
//		override protected function onHide():void
//		{
//			if( _toolTip != null )
//			{
//				ToolTipManager.instance.destroyToolTip(this);
//			}
//		}

		public function get tipText():String
		{
			var result : String = "" ;
			if( _gadata != null )
			{
				//title 
				result = "<font color='#FFFFFF' size='14'><b>" + _gadata.title + "</b></font>\r" ;
				result += "<font color='#FFFF00' size='12'>" + _gadata.reward + "</font>\r" ;
				result += "<font color='#FFFFFF' size='12'>" + _gadata.intro + "</font>\r" ;
				if( GuildManager.instance.selfguild.level >= _gadata.openlvl )
					result += "<font color='#999999' size='12'>需要家族等级" + _gadata.openlvl + "</font>" ;
				else 
					result += "<font color='#BD0000' size='12'>需要家族等级" + _gadata.openlvl + "</font>" ;
			}
			return result ;
		}

		public function set data(adv : VoGuildAction) : void
		{
			_gadata = adv ;
			if( _gadata != null )
			{
				_icon.visible = true ;
				_iconbg.visible = true ;
				_icon.url = iconUrl ;
				_nameLabel.text = _gadata.title ;
				GToolTipManager.registerToolTip(this);
			}
			if( GuildManager.instance.selfguild )
				levelCheck( GuildManager.instance.selfguild.level );
			refresh() ;
		}
		
		protected function onMouseOver(evt:Event):void
		{
			if( _toolTip != null )
			{
				_toolTip.source = tipText ;
			}
		}
		
//		private function onClickCfg(evt:Event):void
//		{
//			CavernSetTimeWnd.instance.show() ;
//		}
		
//		private function onMouseClick( evt:Event ):void
//		{
//			var csgas:CSGuildActShortcut = new CSGuildActShortcut();
//			csgas.act = _gadata.actId ;
//			Common.game_server.sendMessage(0x2DF,csgas);
//			
//			ClanManager.myClanView.hide();
//			if( _gadata.actId == 2 )
//				if( MapUtil.isClanMainMap() )
//					openTeaPanel();
//				else
//					setTimeout(openTeaPanel, 3000);
//		}
		
//		private function openTeaPanel():void{
//			TasteTeaControl.instance.setupUI();
//		}
		
		public function get actId() : uint
		{
			return _gadata == null ? 0xFFFF : _gadata.actId ;
		}

		public function get iconUrl() : String
		{
			return VersionManager.instance.getUrl("assets/ico/guildaction/" + actId + ".png");
		}

		public function refresh() : void
		{
//			if ( _gadata == null )
//				return ;
//			if( ClanManager.myFamily == null )
//				return ;
//			if ( ClanManager.guildLevel(ClanManager.myFamily.exp) < _gadata.openlvl )
//			{
//				if ( _opened )
//				{
//					_joinBtn.enabled = false ;
//					_opened = false ;
//					FilterUtils.addFilter(_icon, FilterUtils.disableFilter(), ColorMatrixFilter);
//				}
//				return ;
//			}
//
//			if ( !_opened )
//			{
//				_joinBtn.enabled = true ;
//				_opened = true ;
//				FilterUtils.removeFilter(_icon, ColorMatrixFilter);
//			}
//
//			if ( _gadata.actType == ActionDataVo.ACT_DAILY )
//			{
//				_infoLabel.text = "今日剩余次数:" + ClanManager.actionTimes(actId) ;
//				if( _gadata.remain > 0 )
//				{
//					if( contains(_finalLabel) )
//						removeChild(_finalLabel);
//					if( !contains(_joinBtn) )
//						addChild( _joinBtn );
//				}
//				else 
//				{
//					if( contains(_joinBtn) )
//						removeChild(_joinBtn);
//					if( !contains(_finalLabel) )
//						addChild( _finalLabel );
//				}
//			}
//			else if( _gadata.actId == 1 )	//家族护送
//			{
//				var str : String = "本周" + ClanManager.WEEKDAY[_gadata.param&7] + " " + ClanManager.timeDict[ClanManager.ackey(_gadata.actId, _gadata.param&7)];
//				_infoLabel.text = str ;
//				_joinBtn.enabled = _gadata.remain > 0 && ClanManager.isactive(_gadata.actId) ;
//				
//				if( ClanManager.myFamily.leader == UserData.instance.playerId || ClanManager.myFamily.vice == UserData.instance.playerId ) 
//				{
//					_joinBtn.width = TWO_BTN_WIDTH ;
//					_joinBtn.x = centx - _joinBtn.width - TWO_BTN_SPACE / 2 ;
//					_cftbtn.width = TWO_BTN_WIDTH ;
//					_cftbtn.x = centx + TWO_BTN_SPACE / 2 ;
//					if( !contains(_cftbtn) )
//						addChild(_cftbtn);
//				}
//				else
//				{
//					_joinBtn.width = SINGLE_BTN_WIDTH ;
//					_joinBtn.x = centx - _joinBtn.width/2 ;
//					if( contains(_cftbtn) )
//						removeChild(_cftbtn);
//				}
//			}
//			else if( _gadata.actId == 3 )	//家族运镖，每周末
//			{
//				var str1:String = "本周" + ClanManager.WEEKDAY[0] + " " + ClanManager.timeDict[ClanManager.ackey(3, 0)];
//				_infoLabel.text = str1 ;
//				_joinBtn.enabled = _gadata.remain > 0 && ClanManager.isactive(_gadata.actId);
//			}
		}
		
		protected function sendGuildShortcut(fun:Function = null,arg:Array = null):void
		{
			if( _gadata != null )
			{
				MTo.transportTo( 1, _gadata.shortcutx,_gadata.shortcuty,_gadata.shortcutmap , fun, arg );
			}
		}
		
		protected function closeGuildWindow():void
		{
			var evt:GuildEvent = new GuildEvent(GuildEvent.CLOSE_VIEW);
			dispatchEvent(evt);
		}
		
		public function levelCheck(lvl:int):void
		{
			if( _gadata == null )
				return ;
				
			_gadata.update(lvl);
			
			if( lvl >= _gadata.openlvl )
			{
				_icon.filters = [];
				_iconbg.filters = [];
				_nameLabel.textColor = ColorUtils.PANELTEXT0X ;
				return ;
			}
			else
			{
				_icon.filters = [FilterUtils.disableFilter()];
				_icon.filters = [FilterUtils.disableFilter()];
				_nameLabel.textColor = ColorUtils.GRAY0X ;
				return  ;
			}
		}
//		public function OnClickBtn(evt : Event) : void
//		{
//			var gas : CSGuildActShortcut = new CSGuildActShortcut() ;
//			gas.act = _gadata.actId ;
//			Common.game_server.sendMessage(0x2DF, gas);
//		}
	}
}
