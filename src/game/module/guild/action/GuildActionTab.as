package game.module.guild.action {
	import com.utils.TextFormatUtils;
	import log4a.Level;
	import game.module.guild.vo.VoGuild;
	import game.module.quest.guide.VoGuide;
	import com.utils.UICreateUtils;
	import gameui.manager.UIManager;
	import game.module.guild.GuildEvent;
	import game.module.guild.GuildManager;
	import game.module.guild.GuildUtils;
	import game.module.guild.vo.VoGuildAction;

	import gameui.containers.GPanel;
	import gameui.data.GPanelData;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	import com.utils.ColorUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;



	/**
	 * @author 1
	 */
	public class GuildActionTab extends GPanel
	{
		private var _explabel:TextField ;
		private var _actPanel:GPanel ;
		private var _actList:Vector.<GuildActionItem> = new Vector.<GuildActionItem>() ;
		private var _manager:GuildManager = GuildManager.instance;
		
		private const PAGE_SIZE:uint = 5 ;
		
		public function GuildActionTab()
		{
			var data:GPanelData = new GPanelData() ;
			data.width = 443 ;
			data.height = 385 ;
			
			super(data);
			addBg();
			addText() ;
			addList() ;
//			refreshExp();
			addEvent() ;
		}

		private function addEvent() : void {
			_manager.addEventListener(GuildEvent.GUILD_ACTION_CHANGE, onActionChange);
			_manager.addEventListener(GuildEvent.GUILD_ENTER, onActionChange);
			_manager.addEventListener(GuildEvent.GUILD_BASE_CHANGE, onActionChange);
			
		}

//		private function onGuildEnter(event : GuildEvent) : void {
////			refreshExp();
//			refreshAction();
//		}
//
//		private function onBaseChange(event : GuildEvent) : void {
////			refreshExp();
//			refreshAction();
//		}
//		
		private function onActionChange(evt:GuildEvent):void
		{
			refreshAction() ;
		}
		
		private function refreshAction():void{
			levelCheck() ;
			for each( var act:GuildActionItem in _actList )
			{
				act.refresh() ;
			}			
		}
//		private function refreshExp():void{
//			var vo:VoGuild = GuildManager.instance.selfguild ;
//			if( vo != null )
////				_explabel.text = "家族级别升至下一级还差: " + (vo.levelexp == 0 ? "已满级" : vo.levelexp - vo.exp).toString();
//				_explabel.text = vo.levelexp == 0 ? "家族等级已满" : "家族级别升至下一级还差:" + ( vo.levelexp - vo.exp ).toString() ;
//		}
		
		private function addBg() : void
		{
			var bg : Sprite = UICreateUtils.createSprite(GuildUtils.clanBack,443,386);
			addChild(bg);
			
		}
		
		
		
		private function addText() : void
		{
//			var format : TextFormat = TextFormatUtils.panelSubTitle;
//			var textField : TextField = UICreateUtils.createTextField( "家族级别升至下一级还差:",null,190,20,13,6,format );
//			format.size = 14 ;
//			format.align = TextFormatAlign.LEFT ;
//			format.bold = true ;
//			format.color = ColorUtils.PANELTEXT0X ;
//			textField.width = 175;
//			textField.text = "家族级别升至下一级还差:";
//			textField.defaultTextFormat = format;
//			textField.x = 13;
//			textField.y = 6;
//			textField.height = 20 ;
//			textField.width = 175 ;
//			textField.selectable = false ;
//			addChild(textField);
			
//			_explabel = UICreateUtils.createTextField( null,null,280,20,13,6,format );
//			_explabel.x = textField.width + textField.x ;
//			_explabel.y = 6 ;
//			_explabel.defaultTextFormat = format ;
//			_explabel.width = 100 ;
//			_explabel.height = 20 ;
//			_explabel.selectable = false ;
			var it:Sprite = UICreateUtils.createSprite(GuildUtils.iconHint,17,13,18,12);
			addChild(it);
			
			var txt:TextField = UICreateUtils.createTextField("活动奖励随家族等级提升而增多",null,200,20,36,10,TextFormatUtils.panelContent);
			addChild(txt);
		}
		
		private function addList() : void 
		{
			var row:uint = Math.max( GuildManager.instance.actiondata.length, PAGE_SIZE ) ;
			var pdata:GPanelData = new GPanelData() ;
			pdata.x = 5 ;
			pdata.y = 40 ;
			pdata.bgAsset = new AssetData(SkinStyle.emptySkin);
			pdata.width = 423 ;
			pdata.height = 350 ;
			_actPanel = new GPanel(pdata);
			addChild(_actPanel);
			
			var celly:int = 0 ;
			for( var i:uint = 0 ; i < row ; ++ i )
			{
				var cell:GuildActionItem ;
				if( i < GuildManager.instance.actiondata.length )
				{
					var vo:VoGuildAction = GuildManager.instance.actiondata[i] ;
					cell = GuildActionItem.createItem(vo.paneltype);
					cell.initPanel(i);
					cell.data = vo ;
					cell.addEventListener(GuildEvent.CLOSE_VIEW, onCloseView);
				}
				else
				{
//					cell = new GuildActionItem() ;
//					cell.initPanel(i);
					break ;
				}
				
				cell.x = 0 ; 
				cell.y = celly ;
				celly += 68 ;
				_actPanel.addChild(cell);
				_actList.push(cell);
			}
		}

		private function onCloseView(event : Event) : void {
			dispatchEvent(event);
		}
		
		public function levelCheck() : void
		{
			if( _manager.selfguild == null )
				return ;
			for each( var item: GuildActionItem in _actList )
			{
				item.levelCheck(_manager.selfguild.level);
			}
		}
	}
}
