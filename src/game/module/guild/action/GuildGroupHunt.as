package game.module.guild.action {
	import game.module.guild.GuildManager;

	import gameui.controls.GButton;
	import gameui.data.GButtonData;

	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author zhangzheng
	 */
	public class GuildGroupHunt extends GuildActionItem {
		public function GuildGroupHunt() {
			super();
		}
		
		private var _openBtn:GButton ;
		
		override public function initPanel(line:int) : void
		{
			super.initPanel(line);
			
			var bdata : GButtonData = new GButtonData() ;
			bdata.width = SINGLE_BTN_WIDTH ;
			bdata.x = BUTTON_CENTER - SINGLE_BTN_WIDTH/2 ;
			bdata.y = 22 ;
			bdata.labelData.text = "打开" ;
			_openBtn = new GButton(bdata);
			_openBtn.addEventListener(MouseEvent.CLICK, onClickOpen);
			addChild(_openBtn);
			
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
			_infoLabel.text = "剩余奖励次数:" + cnt ;
			super.refresh();
		}
		
		public function onClickOpen(evt : Event) : void
		{
//			closeGuildWindow() ;
//			sendGuildShortcut() ;
			//TODO:implement
		}
		
		override public function levelCheck(lvl:int):void
		{
			super.levelCheck(lvl);
			if( lvl >= _gadata.openlvl )
			{
				_infoLabel.visible = true ;
				_openBtn.visible = true ;
			}
			else
			{
				_infoLabel.visible = false ;
				_openBtn.visible = false ;
			}
		}
	}
}
