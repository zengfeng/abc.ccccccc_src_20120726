package game.module.formation.centralPanel {
	import flash.display.Sprite;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.module.formation.FMControler;
	import game.module.formation.drageAvatear.FMDrageAvatar;
	import game.module.formation.drageAvatear.FMReceiveAvatar;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.drag.DragData;
	import gameui.drag.DragManage;
	import gameui.drag.IDragItem;
	import gameui.drag.IDragTarget;
	import gameui.manager.UIManager;
	import net.AssetData;

	/**
	 * @author Lv
	 */
	public class DrageItem extends GComponent implements IDragTarget {
		public function DrageItem() {
			var bg : Sprite = UIManager.getUI(new AssetData("formationBG0", "FMSwf"));
			addChild(bg);
			bg.alpha = 0;
			
			_base = new GComponentData();
			super(_base);
		}

		public function dragEnter(dragData : DragData) : Boolean {
//			return false;
			var Dis:Boolean;
			if(!(dragData.dragSource is FMDrageAvatar)||(dragData.s_place == 1)||(dragData.s_gird == UserData.instance.myHero.id))
				Dis= false;
			else 
				Dis = true;
			if(Dis == true){
				FMControler.instance.deleteInFmHero(dragData.s_gird);
			}
			if((Dis == false)&&(dragData.s_gird == UserData.instance.myHero.id)){
				FMControler.instance.clearnStartStep();
				StateManager.instance.checkMsg(279);
			}
			return Dis;
		}
		public static function onDragRelease(dragTarget : IDragTarget, dragData : DragData) : void {

			if (!(dragTarget is DrageItem)) {
				if (dragData.s_gird == UserData.instance.myHero.id) {
					FMControler.instance.clearnStartStep();
					StateManager.instance.checkMsg(279);
					DragManage.getInstance().finishDrag(false);
				} else {
					FMControler.instance.deleteInFmHero(dragData.s_gird);
					DragManage.getInstance().finishDrag(false);
//					FMControler.instance.deleteInFmHero(dragData.s_gird);
//					DragManage.getInstance().finishDrag(true);
				}
				return;
			}
			DragManage.getInstance().finishDrag(true);
		}

		public function canSwap(source : IDragItem, target : IDragItem) : Boolean {
			return false;
		}
	}
}
