package game.module.guild.city {
	import worlds.apis.MTo;
	import flash.display.Stage;
	import game.manager.ViewManager;

	import gameui.controls.GButton;
	import gameui.data.GButtonData;
	import gameui.manager.UIManager;

	import worlds.apis.MWorld;
	import worlds.apis.MapUtil;

	import com.commUI.button.KTButtonData;

	import flash.events.MouseEvent;
	/**
	 * @author zhangzheng
	 */
	public class UIGuildCity {
		
		private var _exitbtn:GButton ;
		private var _setup:Boolean = false ;
		private static var _instance:UIGuildCity ;
		public static function get instance():UIGuildCity{
			if( _instance == null )
				_instance = new UIGuildCity( new Singleton() ) ;
			return _instance ;
		}
		
		public function UIGuildCity( s:Singleton ){
			s ;
			registMapEvent();
		}

		private function registMapEvent() : void {
			MWorld.sInstallComplete.add(onMapInstall);
		}

		private function onMapInstall() : void {
			if( MapUtil.isClanHkeeMap() ){
				if( !_setup ){
					addExitBtn();
					_setup = true ;
				}
			}
			else{
				if( _setup ){
					removeExitBtn();
					_setup = false ;
				}
			}
		}

		private function addExitBtn() : void {
			if( _exitbtn == null ){
				var ebtndata:GButtonData = new KTButtonData(KTButtonData.EXIT_BUTTON);
				ebtndata.parent = ViewManager.instance.getContainer(ViewManager.AUTO_CONTAINER) ;
				_exitbtn = new GButton(ebtndata);
				_exitbtn.x = UIManager.stage.stageWidth - 90;
				_exitbtn.y = 20;
				_exitbtn.addEventListener(MouseEvent.CLICK, onClickLeave);
			}
			_exitbtn.show() ;
			ViewManager.addStageResizeCallFun(onStageResize);
		}

		private function onStageResize(s:Stage,w:int,h:int) : void {
			_exitbtn.x = UIManager.stage.stageWidth - 70;
			_exitbtn.y = 10;
		}

		private function onClickLeave(event : MouseEvent) : void {
			MWorld.csBackMap();
		}

		private function removeExitBtn() : void {
			if( _exitbtn != null ){
				ViewManager.removeStageResizeCallFun(onStageResize);
				_exitbtn.hide() ;
			}
		}
				
	}
}
class Singleton{
}