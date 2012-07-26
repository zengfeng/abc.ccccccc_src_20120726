package game.module.guild.action {
	import com.utils.TextFormatUtils;
	import flashx.textLayout.formats.TextAlign;

	import game.module.guild.GuildManager;

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
	public class SpinMoneyPanel extends GuildActionItem {
		
		private var _joinBtn:GButton ;
		
		private var _finishLabel:TextField ;
		
		public function SpinMoneyPanel() {
			super();
		}
		
		override public function initPanel(line:int) : void
		{
			super.initPanel(line);
			
			var bdata : GButtonData = new GButtonData() ;
			bdata.width = SINGLE_BTN_WIDTH ;
			bdata.x = BUTTON_CENTER - SINGLE_BTN_WIDTH/2 ;
			bdata.y = 22 ;
			bdata.labelData.text = "传送" ;
			_joinBtn = new GButton(bdata);
			_joinBtn.addEventListener(MouseEvent.CLICK, onClickJoin);
			addChild(_joinBtn);
			
			_finishLabel = new TextField() ;
			_finishLabel.width = SINGLE_BTN_WIDTH ;
			_finishLabel.x = BUTTON_CENTER - SINGLE_BTN_WIDTH/2 ;
			_finishLabel.y = 25 ;
			var fmt:TextFormat = TextFormatUtils.panelContentCenter ;
//			fmt.size = 12 ;
//			fmt.color = ColorUtils.PANELTEXT0X ;
//			fmt.align = TextAlign.CENTER ;
			_finishLabel.defaultTextFormat = fmt ;
			_finishLabel.text = "本日已结束";
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
			var cnt:int = _gadata.personalremain;
			_infoLabel.text = "今日剩余次数:" + cnt ;
			if( cnt > 0 )
			{
				_joinBtn.visible = true ;
				_finishLabel.visible = false ;
			}
			else 
			{
				_joinBtn.visible = false ;
				_finishLabel.visible = true ;
			}
			super.refresh();
		}
		
		public function onClickJoin(evt : Event) : void
		{
			closeGuildWindow() ;
			sendGuildShortcut() ;
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
