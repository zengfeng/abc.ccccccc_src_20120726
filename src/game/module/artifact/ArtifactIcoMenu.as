package game.module.artifact {
	import game.core.menu.MenuOpenAction;

	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.manager.UIManager;

	import net.AssetData;
	import net.RESManager;

	import com.greensock.TweenLite;
	import com.greensock.easing.Circ;

	import flash.display.MovieClip;
	import flash.geom.Point;

	/**
	 * @author yangyiqiang
	 */
	public class ArtifactIcoMenu extends GComponent {
		public function ArtifactIcoMenu() {
			_base = new GComponentData();
			_base.width = 900;
			_base.height = 50;
			super(base);
			initButton();
		}

		override protected function create() : void {
		}

		private var _list : Vector.<ArtifactButton>=new Vector.<ArtifactButton>();
		private var _showList : Vector.<ArtifactButton> = new Vector.<ArtifactButton>();

		public function initCurrnVo(id : int) : void {
			for each (var button:ArtifactButton in _list) {
				if ((button.vo && button.vo.id > id) || _showList.indexOf(button) >= 0) continue;
				if (button.vo.id != id) {
					button.vo.level = 10;
					button.vo.state = 0;
				}
				button.refresh();
				_showList.push(button);
			}
			_showList.sort(sortFun);
			addButtons();
			refresh();
		}

		public function refresh() : void {
			for each (var button:ArtifactButton in _showList) {
				button.refresh();
			}
		}

		private var _playId : int;
		private var _callBack : Function;
		private var _arr : Array;

		public function play(id : int, fun : Function, arr : Array) : void {
			_playId = id;
			var point : Point = this.localToGlobal(new Point((_showList.length - 1) * 50, 0));
			var action : MovieClip = RESManager.getMC(new AssetData("artifactAction", "artifact"));
			action.x = UIManager.stage.stageWidth / 2 - 200;
			action.y = UIManager.stage.stageHeight / 2 - 200;
			addChild(action);
			_callBack = fun;
			_arr = arr;
			TweenLite.to(action, 1.5, {x:point.x - 200, y:point.y - 50, ease:Circ.easeIn, overwrite:0, onComplete:MenuOpenAction.instance.playComplete, onCompleteParams:[action, complete, new Point((_showList.length - 1) * 50 - 70, -50), this]});
		}

		private function complete() : void {
			if (_callBack != null) _callBack.apply(null, _arr);
			initCurrnVo(_playId);
		}

		private function addButtons() : void {
			for (var i : int ;i < _showList.length;i++) {
				_showList[i].x = 70 * i;
				_showList[i].y = 0;
				addChild(_showList[i]);
			}
		}

		private function sortFun(a : ArtifactButton, b : ArtifactButton) : int {
			if (!a.vo || !b.vo) return -1;
			return a.vo.id - b.vo.id;
		}

		private function initButton() : void {
			for each (var vo:VoArtifact in ArtifactManage.instance().getVos()) {
				if (!vo) continue;
				_list.push(new ArtifactButton(vo));
			}
		}
	}
}
import game.module.artifact.ArtifactEvent;
import game.module.artifact.VoArtifact;

import gameui.controls.BDPlayer;
import gameui.core.GComponent;
import gameui.core.GComponentData;

import net.AssetData;
import net.RESManager;

import com.commUI.tooltip.SmallTip;
import com.commUI.tooltip.ToolTipManager;
import com.utils.ColorChange;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;

class ArtifactButton extends GComponent {
	private var _vo : VoArtifact;

	public function  ArtifactButton(vo : VoArtifact) {
		_base = new GComponentData();
		super(_base);
		_vo = vo;
		if (_vo) {
			var obj : DisplayObject = RESManager.getObj(new AssetData("artifact" + _vo.id, "artifact"));
			if (!obj) obj = RESManager.getObj(new AssetData("artifact" + 1, "artifact"));
			addChild(obj);
		}
	}

	private var _player : BDPlayer;

	override protected function create() : void {
		_player = new BDPlayer(new GComponentData());
		_player.x=32;
		_player.y=32;
		addChild(_player);
	}

	public function get vo() : VoArtifact {
		return _vo;
	}

	public function refresh() : void {
		if (!_vo) return;

		switch(_vo.type) {
			case 0:
			case 4:
				var arr : ColorChange = new ColorChange();
				arr.adjustSaturation(-100);
				this.alpha=0.6;
//				this.filters = [new ColorMatrixFilter(arr.toArray())];
				break;
			case 6:
				_player.visible = true;
				_player.setBDData(RESManager.getBDData(new AssetData("1", "184549378")));
				_player.play(80, null, 0);
				break;
			default :
				_player.visible = false;
				_player.stop();
				this.filters = [];
				this.alpha=1;
				break;
		}
	}

	private function onClick(event : Event) : void {
		this.dispatchEvent(new ArtifactEvent(ArtifactEvent.ARTIFACT_CLICK, _vo));
	}

	override protected function onShow() : void {
		super.onShow();
		if (!vo) return;
		ToolTipManager.instance.registerToolTip(this, SmallTip, _vo.getTips);
		this.addEventListener(MouseEvent.CLICK, onClick);
	}

	override protected function onHide() : void {
		super.onHide();
		ToolTipManager.instance.destroyToolTip(this);
		this.addEventListener(MouseEvent.CLICK, onClick);
	}
}
