package game.module.formation.drageAvatear {
	import com.commUI.tooltip.ToolTipManager;
	import com.utils.HeroUtils;
	import flash.display.DisplayObject;
	import game.core.avatar.AvatarThumb;
	import game.core.hero.VoHero;
	import game.core.item.IndexListModel;
	import game.manager.ViewManager;
	import game.module.formation.centralPanel.DrageItem;
	import game.module.formation.centralPanel.FMavatearTip;
	import gameui.drag.DragData;
	import gameui.drag.DragManage;
	import gameui.drag.IDragItem;
	import gameui.drag.IDragSource;
	import gameui.drag.IDragTarget;



	/**
	 * @author Lv
	 */
	public class FMDrageAvatar extends AvatarThumb implements IDragSource, IDragTarget {
		public function FMDrageAvatar() {
			super();
		}

		public function dragEnter(dragData : DragData) : Boolean {
			var Dis : Boolean;
			if (!dragData || !(dragData.dragSource is FMDrageAvatar))
				Dis = false;
			else
				Dis = true;
			if((this.identifyPath == 2)&&(dragData.s_place == 2))
				Dis = false;
			return Dis;
		}

		public function canSwap(source : IDragItem, target : IDragItem) : Boolean {
			return false;
		}

		private var _hero : FMDrageAvatar;

		public function get dragImage() : DisplayObject {
			if (!_hero) {
				_hero = new FMDrageAvatar();
				_hero.initAvatar(_id,_type,_cloth);
				_hero.scaleX = _hero.scaleY = 0.6;
				_hero.mouseEnabled = false;
				_hero.mouseChildren = false;
			}

			return _hero;
		}
		private var _step:int;

		// 1:左边   2：右边
		private var _identifyPath : int;
		// 1:出战   2：不出战
		private var _isWaring : int;

		/**
		 * data.s_gird: 当前将领ID
		 * data.s_place: 1:左边   2：右边
		 * data.t_place: 1:出战   2：不出战
		 */
		public function stateDrag() : void {
			var data : DragData = new DragData();
			data.dragSource = this;
			data.s_gird = this._uuid & 0xffff;
			data.s_place = identifyPath;
			data.t_place = isWaring;
			data.stageX = -5;
			data.stageY = -5;
			data.isAuto = false;
			data.callBack = FMReceiveAvatar.onDragRelease;
			DragManage.getInstance().darg(this, data, ViewManager.instance.uiContainer, false);
		}
		public function get identifyPath() : int {
			return _identifyPath;
		}

		public function set identifyPath(identifyPath : int) : void {
			_identifyPath = identifyPath;
		}

		public function get isWaring() : int {
			return _isWaring;
		}

		public function set isWaring(isWaring : int) : void {
			_isWaring = isWaring;
		}

		public function get heroID() : int {
			return this._uuid & 0xffff;
		}

		public function set step(step : int) : void {
			_step = step;
			if(_step == 0)
				_step = 10000;
			ToolTipManager.instance.registerToolTip(this, FMavatearTip,_step);
		}
	}
}
