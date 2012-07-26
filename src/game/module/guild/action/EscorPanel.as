package game.module.guild.action {
	import com.utils.TextFormatUtils;
	import flashx.textLayout.formats.TextAlign;

	import game.module.guild.GuildManager;
	import game.module.guild.GuildUtils;

	import gameui.controls.GButton;
	import gameui.data.GButtonData;

	import com.utils.ColorUtils;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;




	/**
	 * @author 1
	 */
	public class EscorPanel extends GuildActionItem {

		private var _joinBtn:GButton ;
		
		private var _finishLabel:TextField ;
		
		public function EscorPanel() {
			super();
		}


		override public function initPanel(line:int) : void
		{
			super.initPanel(line);
			
			var bdata : GButtonData = new GButtonData() ;
			bdata.width = SINGLE_BTN_WIDTH ;
			bdata.x = BUTTON_CENTER - SINGLE_BTN_WIDTH/2 ;
			bdata.y = 25 ;
			bdata.labelData.text = "参加" ;
			_joinBtn = new GButton(bdata);
			_joinBtn.addEventListener(MouseEvent.CLICK, onClickJoin);
			addChild(_joinBtn);
			
			_finishLabel = new TextField() ;
			_finishLabel.width = SINGLE_BTN_WIDTH ;
			_finishLabel.x = BUTTON_CENTER - SINGLE_BTN_WIDTH/2 ;
			_finishLabel.y = 22 ;
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
				return ;
			
			var cnt:int = _gadata.personalremain ;
			var info:String = "" ;
			var showJoin:Boolean = checkActionOn() && cnt > 0 ;
			//info 			
			if( showJoin )
			{
				_joinBtn.width = SINGLE_BTN_WIDTH ;
				_joinBtn.x = BUTTON_CENTER - SINGLE_BTN_WIDTH/2 ;
				_joinBtn.visible = true ;
				_infoLabel.text = "活动正在进行中" ;
				_finishLabel.visible = false ;
			}
			else 
			{
				if( _gadata.state < 2 )
				{
					info = "本周" ;
				}
				else 
				{
					info = "下周" ;
				}
				
				info += GuildUtils.WEEKDAY[0] + " " + _gadata.begintime ;
				_infoLabel.text = info ;

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
		
		private function checkActionOn():Boolean{
			return _gadata.state == 2;
		}
		
		private function onClickJoin( evt:Event ):void{
			closeGuildWindow();
			sendGuildShortcut();
		}
		
		override public function levelCheck(lvl:int):void
		{
			super.levelCheck(lvl);
			if( lvl >= _gadata.openlvl )
			{
				_infoLabel.visible = true ;
				_joinBtn.visible = true ;
				_finishLabel.visible = true ;
			}
			else
			{
				_infoLabel.visible = false ;
				_joinBtn.visible = false ;
				_finishLabel.visible = false ;
			}
		}
	}
}
