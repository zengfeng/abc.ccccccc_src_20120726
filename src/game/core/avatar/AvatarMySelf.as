package game.core.avatar {
	import gameui.controls.BDPlayer;
	import gameui.controls.GLabel;
	import gameui.core.GAlign;
	import gameui.core.GComponentData;
	import gameui.data.GLabelData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;

	import net.AssetData;
	import net.RESManager;

	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Quint;
	import com.utils.StringUtils;

	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author yangyiqiang
	 */
	public class AvatarMySelf extends AvatarPlayer {
		/** 单例对像 */
		private static var _instance : AvatarMySelf;

		/** 获取单例对像 */
		static public function get instance() : AvatarMySelf {
			if (_instance == null) {
				_instance = new AvatarMySelf(new Singleton());
			}
			return _instance;
		}
		
		public function get cloth():int
		{
			return _cloth;
		}
		
		override public function setAction(value : int, loop : int = 0, index : int = -1, arr : Array = null,onComplete:Function=null,onCompleteParams:Array=null) : void {
			super.setAction(value, loop, index, arr,onComplete,onCompleteParams);
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		function AvatarMySelf(singleton : Singleton)  {
			singleton;
			super();
			mouseChildren = false;
			mouseEnabled = false;
		}

		private var _questComplete : MovieClip;
		private var _questAccept : MovieClip;

		public function levelUp() : void {
		}

		public function questComplete() : void {
			if (_questComplete && this.contains(_questComplete)) {
				this.removeChild(_questComplete);
			}
			_questComplete = RESManager.getMC(new AssetData("quest_complete", "commonAction"));
			_questComplete.gotoAndPlay(0);
			_questComplete.x = -50;
			_questComplete.y = this.avatarBd ? this.avatarBd.topY - 60 : 0;
			addChild(_questComplete);
		}

		public function questAccept() : void {
			if (_questAccept && this.contains(_questAccept)) {
				this.removeChild(_questAccept);
			}
			_questAccept = RESManager.getMC(new AssetData("quest_accept", "commonAction"));
			_questAccept.gotoAndPlay(0);
			_questAccept.x = -15;
			_questAccept.y = this.avatarBd ? this.avatarBd.topY - 60 : 0;
			addChild(_questAccept);
		}

		protected var _showPlayer : BDPlayer;

		override public function playShowAction() : void {
			if (_avatarBd) {
				if (!_showPlayer)
					_showPlayer = new BDPlayer(new GComponentData());
				_showPlayer.setBDData(AvatarManager.instance.getAvatarBD(AvatarType.AVATAR_SHOW).bds);
				_showPlayer.addEventListener(Event.COMPLETE, showEnd);
				addChild(_showPlayer);
				_showPlayer.play();
			}
		}

		/** 回收，放入ObjectPool */
		override internal function callback() : void {
			
		}

		protected function showEnd(event : Event) : void {
			if (!_showPlayer) return;
			_showPlayer.removeEventListener(Event.COMPLETE, showEnd);
			_showPlayer.hide();
		}

		private var _textData : GLabelData = new GLabelData();

		public function sorollMsg(str : String) : void {
			_textData.width = 500;
			_textData.align = new GAlign(-1, -1, -1, -1, 0);
			_textData.textColor = 0xffffff;
			_textData.textFormat = UIManager.getTextFormat(14);
			_textData.y = -50;
			var text : GLabel = new GLabel(_textData);
			addChild(text);
			text.htmlText = StringUtils.addBold(str);
			GLayout.layout(text);
			var topY : Number = this.avatarBd.topY - 25;
			TweenLite.to(text, 1.5, {y:topY, onComplete:sorollEnd, onCompleteParams:[text], overwrite:0, ease:Cubic.easeOut});
		}

		private function sorollEnd(text : GLabel) : void {
			TweenLite.to(text, 0.3, {alpha:0, onComplete:sorollEnd2, onCompleteParams:[text], overwrite:0, ease:Quint.easeOut});
		}

		private function sorollEnd2(text : GLabel) : void {
			this.removeChild(text);
		}
	}
}
class Singleton
{
}
