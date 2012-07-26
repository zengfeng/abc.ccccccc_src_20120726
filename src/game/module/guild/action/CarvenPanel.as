package game.module.guild.action {
	import com.utils.TextFormatUtils;
	import flashx.textLayout.formats.TextAlign;

	import game.module.guild.GuildManager;
	import game.module.guild.GuildUtils;

	import gameui.controls.GButton;
	import gameui.data.GButtonData;

	import com.utils.ColorUtils;
	import com.utils.UIUtil;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;





	/**
	 * @author 1
	 */
	public class CarvenPanel extends GuildActionItem {

		private var _joinBtn:GButton ;
		
		private var _finishLabel:TextField ;
		
		private var _viewBtn:GButton ;

		public function CarvenPanel() {
			super();
		}


		override public function initPanel(line:int) : void
		{
			super.initPanel(line);
			
			var bdata : GButtonData = new GButtonData() ;
			bdata.width = SINGLE_BTN_WIDTH ;
			bdata.x = BUTTON_CENTER - SINGLE_BTN_WIDTH/2 ;
			bdata.y = 22 ;
			bdata.labelData.text = "参加" ;
			_joinBtn = new GButton(bdata);
			_joinBtn.addEventListener(MouseEvent.CLICK, onClickJoin);
			addChild(_joinBtn);
			
			bdata.labelData.text = "查看" ;
			_viewBtn = new GButton(bdata);
			_viewBtn.addEventListener(MouseEvent.CLICK, onClickView);
			addChild(_viewBtn);
			
			_finishLabel = new TextField() ;
			_finishLabel.width = SINGLE_BTN_WIDTH ;
			_finishLabel.x = BUTTON_CENTER - SINGLE_BTN_WIDTH/2 ;
			_finishLabel.y = 25 ;
			var fmt:TextFormat = TextFormatUtils.panelContentCenter ;
//			fmt.size = 12 ;
//			fmt.color = ColorUtils.PANELTEXT0X ;
//			fmt.align = TextAlign.CENTER ;
			_finishLabel.defaultTextFormat = fmt ;
			addChild(_finishLabel);
			_finishLabel.selectable = false ;
		}
		
		override public function refresh():void
		{
			if ( _gadata == null )
				return ;
			if( GuildManager.instance.selfguild == null )
				return ;
			if( _gadata.openlvl > GuildManager.instance.selfguild.level )
			{
				return ;
			}	
			
			var cnt:int = _gadata.personalremain ;
			var info:String = "" ;
			var weekday:int = checkWeekday();
			var showJoin:Boolean = _gadata.state == 2 && cnt > 0 ;
			var showView:Boolean = GuildManager.instance.selfmember.position > 0 && !showJoin ;
			//info 
			
			if( _gadata.state == 2 )
			{
				info = "活动正在进行中" ;
			}
			else if( _gadata.state < 2 )
			{
				info = "本周" + GuildUtils.WEEKDAY[weekday] + " " + _gadata.begintime ;
			}
			else 
			{
				info = "下周" + GuildUtils.WEEKDAY[weekday] + " " + _gadata.begintime ;
			}
			
			_infoLabel.text = info ;
			
			if( showJoin )
			{
				_joinBtn.width = SINGLE_BTN_WIDTH ;
				_joinBtn.x = BUTTON_CENTER - SINGLE_BTN_WIDTH/2 ;
				_joinBtn.visible = true ;
				_viewBtn.visible = false ;
				_finishLabel.visible = false ;
			}
			else if( showView )
			{
				_viewBtn.width = SINGLE_BTN_WIDTH ;
				_viewBtn.x = BUTTON_CENTER - SINGLE_BTN_WIDTH/2 ;
				_viewBtn.visible = true ;	
				_joinBtn.visible = false ;
				_finishLabel.visible = false ;			
			}
			else 
			{
				_viewBtn.visible = false ;
				_joinBtn.visible = false ;
				_finishLabel.visible = true ;
				if( cnt == 0 )
				{
					_finishLabel.text = "活动已结束";
				}
				else if( _gadata.state < 2 )
				{
					_finishLabel.text = "活动未开启" ;
				}
				else
				{
					_finishLabel.text = "活动已结束"; 
				}
			}
			super.refresh();
		}
		
		private function checkWeekday():int{
			if( _gadata.state < 1 )
				return _gadata.config & 7 ;
			else 
				return _gadata.config >> 3 ;
		}
		
//		private function checkActionOn():Boolean{
//			return GuildManager.instance.isactive(_gadata.actId);
//		}
		
		private function onClickJoin( evt:Event ):void{
			sendGuildShortcut();
			closeGuildWindow();
		}
		
		private function onClickView( evt:Event ):void{
//			UIUtil.alignStageCenter(CavernSetTimeWnd.instance);
			CavernSetTimeWnd.instance.show() ;
		}
		override public function levelCheck(lvl:int):void
		{
			super.levelCheck(lvl);
			if( lvl >= _gadata.openlvl )
			{
				_infoLabel.visible = true ;
				_joinBtn.visible = true ;
				_finishLabel.visible = true ;
				_viewBtn.visible = true ;
			}
			else
			{
				_infoLabel.visible = false ;
				_joinBtn.visible = false ;
				_finishLabel.visible = false ;
				_viewBtn.visible = false ;
			}
		}
	}
}
