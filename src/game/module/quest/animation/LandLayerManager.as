package game.module.quest.animation {
	import game.core.avatar.AvatarManager;
	import game.core.avatar.PerformerAvatar;

	import worlds.apis.MLand;
	import worlds.apis.MStory;

	import com.greensock.TweenLite;

	import flash.display.DisplayObject;
	import flash.utils.setTimeout;

	/**
	 * @author yangyiqiang
	 */
	public class LandLayerManager {
		/** 单例对像 */
		private static var _instance : LandLayerManager;

		/** 获取单例对像 */
		static public function get instance() : LandLayerManager {
			if (_instance == null) {
				_instance = new LandLayerManager();
			}
			return _instance;
		}

		public function LandLayerManager() {
		}

		private var _mapX : Number;
		private var _mapY : Number;

		public function enterIntoAnimation(mapX : Number, mapY : Number,fun:Function) : void {
			_mapX = mapX;
			_mapY = mapY;
			MStory.enter();
			MLand.setPosition(_mapX, _mapY);
			var x : Number = MLand.mapContainer.x - _mapX * 0.1;
			var y : Number = MLand.mapContainer.y - _mapY * 0.1;
			TweenLite.to(MLand.mapContainer, 1.5, {scaleX:1.1, scaleY:1.1, onComplete:zoomUpEnd,onCompleteParams:[fun], overwrite:0});
			TweenLite.to(MLand.mapContainer, 1.5, {x:x, y:y, overwrite:0});
		}

		public function setPosition() : void {
			MLand.setPosition(_mapX * 1.1, _mapY * 1.1);
		}

		public function exitAnimation() : void {
			zoomRestore();
		}

		private function zoomRestore() : void {
			// TweenLite.to(MLand.mapContainer, 1, {scaleX:1, scaleY:1, onComplete:end, overwrite:0});
			// zoom();
			// setTimeout(end, 2);
			end();
		}

		private function end() : void {
			MLand.mapContainer.scaleX = 1;
			MLand.mapContainer.scaleY = 1;
			removeAllPerformer();
			MStory.exit();
		}

		private function zoomUpEnd(fun:Function) : void {
			MLand.mapContainer.scaleX = 1.1;
			MLand.mapContainer.scaleY = 1.1;
			if(fun!=null)fun();
		}
		
		public function shake() : void
		{
			var displayObject : DisplayObject = MLand.mapContainer;
			var x : int = displayObject.x;
			var y : int = displayObject.y;

			var offset : Number = 6;

			var fun : Function = function(offsetX : Number, offsetY : Number) : void
			{
				displayObject.x = x + offsetX;
				displayObject.y = y + offsetY;
			};

			var offsetX : Number = 0;
			var offsetY : Number = 0;
			for (var i : int = 0; i < 10; i++)
			{
				offsetX = Math.random() * offset;
				offsetY = Math.random() * offset;
				setTimeout(fun, 100 * i, offsetX, offsetY);
				setTimeout(fun, 100 * i + 50, 0, 0);
			}
		}


		public function goto(avatarId : int, x : Number, y : Number, timer : Number = 1) : void {
			var goAvatar : PerformerAvatar;
			for each (var avatar:PerformerAvatar in _avatarList) {
				if (avatar.npcId == avatarId) {
					goAvatar = avatar;
					break;
				}
			}
			goAvatar.run(x, y, goAvatar.x, goAvatar.y);
			TweenLite.to(goAvatar, timer, {x:x, y:y, onComplete:onRunEnd, onCompleteParams:[goAvatar, x, y, goAvatar.x, goAvatar.y], overwrite:0});
		}

		private function onRunEnd(avatar : PerformerAvatar, x : Number, y : Number, myX : Number, myY : Number) : void {
			avatar.standDirection(x, y, myX, myY);
		}

		private var _avatarList : Vector.<PerformerAvatar>=new Vector.<PerformerAvatar>();

		/** 添加avatar */
		public function addPerformer(avatar : PerformerAvatar, x : int = -1, y : int = -1) : PerformerAvatar {
			_avatarList.push(avatar);
			if (x != -1)
				avatar.x = x;
			if (y != -1)
				avatar.y = y;
			avatar.setAction(1);
			MLand.mapContainer.addChild(avatar);
			return avatar;
		}

		public function getPerformer(npcId : int) : PerformerAvatar {
			for each (var avatar:PerformerAvatar in _avatarList) {
				if (avatar.npcId == npcId)
					return avatar;
			}
			return null;
		}

		public function removePerformer(npcId : int) : void {
			var max : int = _avatarList.length;
			for (var i : int = 0;i < max;i++) {
				if (_avatarList[i].npcId == npcId) {
					_avatarList[i].hide();
					AvatarManager.instance.removeAvatar(_avatarList[i]);
					_avatarList.splice(i, 1);
					return;
				}
			}
		}

		public function removeAllPerformer() : void {
			for each (var avatar:PerformerAvatar in _avatarList) {
				avatar.hide();
				AvatarManager.instance.removeAvatar(avatar);
			}
			_avatarList = new Vector.<PerformerAvatar>();
		}
	}
}
