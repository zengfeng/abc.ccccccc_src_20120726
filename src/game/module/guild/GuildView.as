package game.module.guild {
	import game.core.IModuleInferfaces;
	import game.core.menu.MenuType;
	import game.core.menu.MenuManager;
	import game.core.menu.VoMenuButton;
	import game.manager.ViewManager;

	import gameui.core.GComponent;
	import gameui.data.GTitleWindowData;

	import com.commUI.GCommonWindow;

	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author zhangzheng
	 */
	public class GuildView extends GCommonWindow implements IModuleInferfaces {
		
		public static const GVSTATE_LIST:int = 0 ;
		public static const GVSTATE_SELF:int = 1 ;
		
		private var _selfguildpanel:SelfGuildPanel ;
		private var _guildlistpanel:GuildListPanel ;
		private var _currentpanel:GComponent ;
		private var _currentstatus:int = -1;
		private var _manager:GuildManager = GuildManager.instance ;
		
		public function GuildView() {
			var data:GTitleWindowData = new GTitleWindowData() ;
			data.width = 735 ;
			data.height = 417 ;
			data.allowDrag = true ;
			data.parent = ViewManager.instance.uiContainer;
			super(data);
		}
		
		override protected function create():void
		{
			super.create() ;
//			super.create();
			title = "家族";
		}

		private function onChangeState(event : GuildEvent) : void {
			changeState(event.param);
		}

		private function onGuildEnter(event : GuildEvent) : void {
			_selfguildpanel.vo = _manager.selfguild ;
			changeState(1);
		}
		
		private function onGuildLeave(event : GuildEvent) : void {
			changeState(0) ;
			_selfguildpanel.vo = null ;
		}

		private function onCloseView(event : Event) : void {
			MenuManager.getInstance().closeMenuView(MenuType.CLANLIST);
		}
		
		override protected function onClickClose(evt:MouseEvent):void{
			if( _currentstatus == 0 && _manager.selfguild != null )
			{
				changeState(1);
				_closeButton.enabled = true ;
			}
			else
			{
				super.onClickClose(evt);
			}
		}
		
		override public function show():void{
			changeState(_manager.selfguild == null ? 0 : 1);
			super.show();
		}
		
		override public function changeState( value:uint ):void
		{
			if( _currentstatus == value )
				return ;
			if( _currentstatus == -1 )
			{
				_currentpanel = value == 0 ? _guildlistpanel : _selfguildpanel ;
				_contentPanel.addChild( _currentpanel );
				width = _currentpanel.width ;
				height = _currentpanel.height ;
			}
			else if( _currentstatus == 0 )
			{
				_contentPanel.removeChild(_guildlistpanel);
				_contentPanel.addChild(_selfguildpanel);
				_currentpanel = _selfguildpanel ;
				width = _currentpanel.width ;
				height = _currentpanel.height ;
			}
			else if( value == 0 )
			{
				_contentPanel.removeChild(_selfguildpanel);
				_contentPanel.addChild(_guildlistpanel);
				_currentpanel = _guildlistpanel ;
				width = _currentpanel.width ;
				height = _currentpanel.height ;
			}
			_currentstatus = value ; 
			layout();
		}

		public function initModule() : void {
			_selfguildpanel = new SelfGuildPanel() ;
			_guildlistpanel = new GuildListPanel() ;
			
			_selfguildpanel.vo = _manager.selfguild; 
			
			//add event 
			_selfguildpanel.addEventListener(GuildEvent.CLOSE_VIEW, onCloseView);
			_selfguildpanel.addEventListener(GuildEvent.CHANGE_STATE, onChangeState );
			
			_manager.addEventListener(GuildEvent.GUILD_ENTER, onGuildEnter);
			_manager.addEventListener(GuildEvent.GUILD_LEAVE, onGuildLeave);
		}
	}
}
