package game.module.tasteTea
{
	import game.module.guild.GuildEvent;
	import game.core.menu.MenuManager;
	import game.core.menu.MenuType;
	import game.module.guild.GuildManager;

	/**
	 * @author Lv
	 */
	public class TasteTeaControl {
		
		private static var _instance :TasteTeaControl;
		private var _level:uint ;
		
		public function TasteTeaControl(control:Control):void{
			control;
		}
		public static function get instance():TasteTeaControl{
			if(_instance == null){
				_instance = new TasteTeaControl(new Control());
			}
			return _instance;
		}
		
		private var teaUI:TastePanel;
		public function setupUI():void{
			//判断家族等级不够
			if(!teaUI){
				teaUI = MenuManager.getInstance().changMenu(MenuType.TASTTEA).target as TastePanel ;
//				MenuManager.getInstance().getMenuButton(MenuType.TASTTEA).target=teaUI;
			}
			if( GuildManager.instance.selfguild != null )
				teaUI.bonous = GuildManager.instance.selfguild.teabonous ;
			MenuManager.getInstance().changMenu(MenuType.TASTTEA);
			var num:int = GuildManager.instance.actiondata[1].personalremain;
			enableTastTeaBtn(num != 0);
			
			
			GuildManager.instance.addEventListener(GuildEvent.GUILD_BASE_CHANGE, onChangeBase);
		}

		private function onChangeBase(event : GuildEvent) : void {
			if( teaUI && GuildManager.instance.selfguild != null && _level != GuildManager.instance.selfguild.level ){
				teaUI.bonous = GuildManager.instance.selfguild.teabonous ;
				_level = GuildManager.instance.selfguild.level ;
			}
		}
		
		public function tasteTeaReward( sel:uint , reward:uint ) : void{
			if( teaUI != null ){
				teaUI.reward( sel,reward );
			}
		}
		
		public function closeUI():void{
			if( teaUI )
			{
				MenuManager.getInstance().closeMenuView(MenuType.TASTTEA);
				GuildManager.instance.removeEventListener(GuildEvent.GUILD_BASE_CHANGE, onChangeBase);
			}
		}
		
		//品茶按钮不可以用
		public function enableTastTeaBtn(b:Boolean):void{
			teaUI.EnableTastTea(b);
		}
	}
}
class Control{}
