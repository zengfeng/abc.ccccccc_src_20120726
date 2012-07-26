package game.module.mapFishing.element {
	import game.core.avatar.AvatarManager;
	import net.RESManager;
	import bd.BDData;

	import game.core.avatar.AvatarThumb;
	import game.module.mapFishing.FisherAction;
	import game.module.mapFishing.FishingPosition;
	import game.module.mapFishing.pool.FishingChairVO;
	import game.module.mapFishing.pool.FishingPool;
	import gameui.controls.BDPlayer;
	import gameui.controls.GImage;
	import gameui.core.GComponentData;
	import log4a.Logger;
	import net.AssetData;
	import net.RESManager;
	import worlds.roles.cores.Player;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	import com.utils.UICreateUtils;
	import flash.utils.setTimeout;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-3-15 ����3:21:06
	 */
	public class FishingPlayer
	{
		public var playerId : int;
		public var modelId : int;
		public var player : Player;
		private var _wavePlayer : BDPlayer;
		private var _facing : uint;
		private var _position : uint = 0;
		private var _awardImage : GImage;
		private var _onPullComplete : Function;
		private var _chair : FishingChairVO;
		private var _isEnter : Boolean = false;

		public function get avatar() : AvatarThumb
		{
			return player.avatar;
		}

		public function getPosition() : uint
		{
			return _position;
		}

		/** 进入钓鱼模式 */
		public function enter() : void
		{
			Logger.info("玩家"+ playerId + "进入鱼塘");
			_isEnter = true;
			player.changeModel(modelId);
			_chair = FishingPool.instance.takeChair(playerId, onStand, onSit, player.x, player.y);
			_position = _chair.position;

			if (_chair.usage == "sit")
			{
				onSit();
			}
			else if (_chair.usage == "stand")
			{
				onStand();
			}
		}

		/** 退出钓鱼模式 */
		public function exit() : void
		{
			Logger.info("玩家"+ playerId + "离开鱼塘");
			_isEnter = false;
			if (_awardImage)
			{
				TweenLite.killTweensOf(_awardImage);
				if (_awardImage.parent)
					_awardImage.hide();
				_awardImage = null;
			}

			FishingPool.instance.returnChair(_chair, playerId);

			if (_wavePlayer)
			{
				_wavePlayer.hide();
				_wavePlayer = null;
			}
			if (player)
			{
				player.changeModel(0);
				if (player.avatar)
					player.avatar.visible = true;
				player = null;
			}
		}

		protected function onStand() : Boolean
		{
			Logger.info("玩家" +playerId + "站起");

			if (player.avatar)
			{
				player.avatar.visible = false;
			}
			return true;
		}

		protected function onSit() : Boolean
		{
			Logger.info("玩家" + playerId + "坐下");
			initFacing();
			addWaterWave();
			sit();
			return true;
		}

		private function initFacing() : void
		{
			if (!avatar || !avatar.player)
				return;
				
			if (_position == FishingPosition.TOP_LEFT)
			{
				_facing = 0;
				avatar.player.flipH = false;
			}
			else if (_position == FishingPosition.TOP_RIGHT)
			{
				_facing = 0;
				avatar.player.flipH = true;
			}
			else if (_position == FishingPosition.BOTTOM_LEFT)
			{
				_facing = 1;
				avatar.player.flipH = false;
			}
			else
			{
				_facing = 1;
				avatar.player.flipH = true;
			}
		}

		private function addWaterWave() : void
		{
			_wavePlayer = AvatarManager.instance.getCommBDPlayer(AvatarManager.WATER_WAVE, new GComponentData());
			_wavePlayer.play(120, null, 0);

			if (_position == FishingPosition.TOP_LEFT)
			{
				_wavePlayer.x = 125;
				_wavePlayer.y = 83;
			}
			else if (_position == FishingPosition.TOP_RIGHT)
			{
				_wavePlayer.x = -124;
				_wavePlayer.y = 83;
			}
			else if (_position == FishingPosition.BOTTOM_LEFT)
			{
				_wavePlayer.x = 101;
				_wavePlayer.y = -50;
			}
			else
			{
				_wavePlayer.x = -101;
				_wavePlayer.y = -50;
			}

			avatar.addChildAt(_wavePlayer, 0);
		}

		private function addAwardImage() : void
		{
			_awardImage = UICreateUtils.createGImage(null);
			_awardImage.visible = false;
			avatar.addChild(_awardImage);
		}

		public function sit() : void
		{
			avatar.setAction(FisherAction.SIT + _facing * 3 + 1);
		}

		public function hold() : void
		{
			avatar.setAction(FisherAction.HOLD + _facing * 3 + 1);
		}

		public function pull(awardUrl : String, onComplete : Function) : void
		{
			_onPullComplete = onComplete;

			avatar.setAction(FisherAction.PULL + _facing * 3 + 1, 1, 0);

			// var helper:AwardAnimationHelper = new AwardAnimationHelper(_awardImage);
			// helper.play(60);
			setTimeout(tweenAward, 200, awardUrl);
		}

		private function tweenAward(awardUrl : String) : void
		{
			if (!_awardImage)
				addAwardImage();

			var fromX : Number;
			var fromY : Number;
			var thruX : Number;
			var thruY : Number;
			var toX : Number;
			var toY : Number;

			if (_position == FishingPosition.TOP_LEFT)
			{
				fromX = 110;
				fromY = 90;
				thruX = fromX - 43;
				thruY = fromY - 334;
				toX = fromX - 200;
				toY = fromY - 225;
			}
			else if (_position == FishingPosition.TOP_RIGHT)
			{
				fromX = -125;
				fromY = 90;
				thruX = fromX + 43;
				thruY = fromY - 334;
				toX = fromX + 175;
				toY = fromY - 225;
			}
			else if (_position == FishingPosition.BOTTOM_LEFT)
			{
				fromX = 90;
				fromY = -65;
				thruX = fromX - 24;
				thruY = fromY - 181;
				toX = fromX - 186;
				toY = fromY - 90;
			}
			else
			{
				fromX = -120;
				fromY = -65;
				thruX = fromX + 24;
				thruY = fromY - 181;
				toX = fromX + 170;
				toY = fromY - 90;
			}

			_awardImage.url = awardUrl;
			_awardImage.visible = true;
			_awardImage.x = fromX;
			_awardImage.y = fromY;
			TweenMax.to(_awardImage, 1.35, {ease:Circ.easeInOut, onComplete:onPullComplete, bezierThrough:[{x:thruX, y:thruY}, {x:toX, y:toY}]});
		}

		private function onPullComplete() : void
		{
			if (_isEnter)
			{
				TweenLite.to(_awardImage, 1, {alpha:0, onComplete:function() : void
				{
					_awardImage.visible = false;
					_awardImage.alpha = 1;
				}});
				sit();
				_onPullComplete();
			}
		}
	}
}
		
