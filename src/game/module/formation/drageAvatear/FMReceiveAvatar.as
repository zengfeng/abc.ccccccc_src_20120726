package game.module.formation.drageAvatear {
	import com.commUI.tooltip.ToolTipManager;
	import com.utils.HeroUtils;
	import flash.display.Sprite;
	import game.core.hero.VoHero;
	import game.core.user.StateManager;
	import game.core.user.UserData;
	import game.module.formation.FMControlPoxy;
	import game.module.formation.FMControler;
	import game.module.formation.centralPanel.DrageItem;
	import game.module.formation.centralPanel.FMavatearTip;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.drag.DragData;
	import gameui.drag.DragManage;
	import gameui.drag.IDragItem;
	import gameui.drag.IDragTarget;





	/**
	 * @author Lv
	 */
	public class FMReceiveAvatar extends GComponent implements IDragTarget {
		private var _ellipseSP : Sprite;
		// true:有将领存在  false：无将领存在
		private static var _isDrag : Boolean = false;
		private var _heroID : int;

		public function FMReceiveAvatar():void {
			_ellipseSP = new Sprite();
			_ellipseSP.graphics.beginFill(0x222222, 0);
			_ellipseSP.graphics.drawEllipse(0, 0, 62, 39);
			_ellipseSP.graphics.endFill();
			addChild(_ellipseSP);
			
			ToolTipManager.instance.registerToolTip(this, FMavatearTip);
			_base = new GComponentData();
			_base.width = 62;
			_base.height = 39;
			super(_base);
		}
		private var _heroTip : VoHero;
		private var _Fmstep:Number;

	 	override public function get source() : * {
			if(fmstep == 0)
				fmstep = 10000;
			return fmstep;
		}

		public function dragEnter(dragData : DragData) : Boolean {
			var Dis : Boolean;
			if (!(dragData.dragSource is FMDrageAvatar))
				Dis = false;
			else
				Dis = true;
			if ((dragData.s_place == 1) && (!isDrag) && (dragData.s_gird != UserData.instance.myHero.id) && (dragData.t_place == 2)) {
				FMControler.instance.heroGoWaring(dragData.s_gird);
			}
			if ((dragData.s_place == 1) && isDrag && (dragData.s_gird != UserData.instance.myHero.id) && (dragData.t_place == 2) && (heroID != UserData.instance.myHero.id)) {
				FMControler.instance.changeWaringState(dragData.s_gird);
			}
			if ((Dis == false) && (dragData.s_gird == UserData.instance.myHero.id)) {
			}
			return Dis;
		}

		public static function onDragRelease(dragTarget : IDragTarget, dragData : DragData) : void {
			if (!(dragData.dragSource is FMDrageAvatar)) {
				DragManage.getInstance().finishDrag(false);
				return;
			}

			if (!(dragTarget is FMReceiveAvatar)&&!(dragTarget is DrageItem)&&!(dragTarget is FMDrageAvatar)) {
				if ((dragData.s_gird == UserData.instance.myHero.id)&&(dragData.s_place == 2)) {
					FMControler.instance.clearnStartStep();
					StateManager.instance.checkMsg(279);
					DragManage.getInstance().finishDrag(false);
				}else if((dragData.s_place == 1) && (dragData.t_place == 1)){
					FMControler.instance.clearnStartStep();
					DragManage.getInstance().finishDrag(false);
				} else {
					FMControler.instance.deleteInFmHero(dragData.s_gird);
					DragManage.getInstance().finishDrag(true);
				}
				return;
			}
			if(dragTarget is DrageItem){
				FMControler.instance.clearnStartStep();
				DragManage.getInstance().finishDrag(false);
				return;
			}

			if ((dragData.s_place == 1) && (dragData.t_place == 2)) {
				FMControler.instance.changeWaringState(dragData.s_gird);
			}
			DragManage.getInstance().finishDrag(true);
		}

		public function canSwap(source : IDragItem, target : IDragItem) : Boolean {
			return false;
		}

		public static function get isDrag() : Boolean {
			return _isDrag;
		}

		public function set isDrag(isDrag : Boolean) : void {
			_isDrag = isDrag;
		}
		private static var _heroid:int;
		public static function get heroid():int{
			return _heroid;
		}
		public function get heroID() : int {
			return _heroID;
		}

		public function set heroID(heroID : int) : void {
			_heroID = heroID;
			_heroid = heroID;
		}

		public function get fmstep() : int {
			return _Fmstep;
		}

		public function set fmstep(fmstep : int) : void {
			
			_Fmstep = fmstep;
		}
	}
}
