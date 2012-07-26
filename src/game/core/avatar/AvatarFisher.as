package game.core.avatar
{
	import bd.BDData;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	import com.utils.UICreateUtils;
	import flash.events.Event;
	import flash.utils.setTimeout;
	import game.definition.UI;
	import game.module.mapFishing.FisherAction;
	import game.module.mapFishing.FishingPosition;
	import gameui.controls.BDPlayer;
	import gameui.controls.GImage;
	import gameui.core.GComponentData;
	import net.AssetData;
	import utils.BDUtil;







	/**
	 * @author jian
	 */
	public class AvatarFisher extends AvatarThumb
	{
		private var _facing : uint;
		private var _postion : uint;
		private var _awardImage : GImage;
		private var _onPullComplete : Function;

		public function getPosition() : uint
		{
			return _postion;
		}

		public function AvatarFisher(position : uint)
		{
			super();

			mouseEnabled = false;
			mouseChildren = false;

			_postion = position;

			initFacing();
			addWaterWave();
		}
		
		public function resetPosition(position : uint):void
		{
			_postion = position;

			initFacing();
			addWaterWave();
			sit();
		}

		private function initFacing() : void
		{
			if (_postion == FishingPosition.TOP_LEFT)
			{
				_facing = 0;
				_player.flipH = false;
			}
			else if (_postion == FishingPosition.TOP_RIGHT)
			{
				_facing = 0;
				_player.flipH = true;
			}
			else if (_postion == FishingPosition.BOTTOM_LEFT)
			{
				_facing = 1;
				_player.flipH = false;
			}
			else
			{
				_facing = 1;
				_player.flipH = true;
			}
		}

		public function addWaterWave() : void
		{
			var bdData : BDData = BDUtil.getBDData(new AssetData(UI.FISHING_WATER_WAVE, "fishing"));
			var wave : BDPlayer = new BDPlayer(new GComponentData());
			wave.setBDData(bdData);
			wave.play(30, null, 0);

			if (_postion == FishingPosition.TOP_LEFT)
			{
				wave.x = 122;
				wave.y = 93;
			}
			else if (_postion == FishingPosition.TOP_RIGHT)
			{
				wave.x = -127;
				wave.y = 93;
			}
			else if (_postion == FishingPosition.BOTTOM_LEFT)
			{
				wave.x = 98;
				wave.y = -40;
			}
			else
			{
				wave.x = -98;
				wave.y = -40;
			}

			addChildAt(wave, 0);
		}

		private function addAwardImage() : void
		{
			_awardImage = UICreateUtils.createGImage(null);
			_awardImage.visible = false;
			addChild(_awardImage);
		}

		public function sit() : void
		{
			setAction(FisherAction.SIT + _facing * 3 + 1);
		}

		public function hold() : void
		{
			setAction(FisherAction.HOLD + _facing * 3 + 1);
		}

		public function pull(awardUrl : String, onComplete : Function) : void
		{
			_onPullComplete = onComplete;

			setAction(FisherAction.PULL + _facing * 3 + 1, 1, 0);
			_player.addEventListener(Event.COMPLETE, onPullComplete);

			// var helper:AwardAnimationHelper = new AwardAnimationHelper(_awardImage);
			// helper.play(60);
			setTimeout(tweenAward, 200, awardUrl);
		}

		private function tweenAward(awardUrl:String) : void
		{
			if (!_awardImage)
				addAwardImage();

			var fromX : Number;
			var fromY : Number;
			var thruX : Number;
			var thruY : Number;
			var toX : Number;
			var toY : Number;

			if (_postion == FishingPosition.TOP_LEFT)
			{
				fromX = 110;
				fromY = 90;
				thruX = fromX - 43;
				thruY = fromY - 334;
				toX = fromX - 200;
				toY = fromY - 225;
			}
			else if (_postion == FishingPosition.TOP_RIGHT)
			{
				fromX = -125;
				fromY = 90;
				thruX = fromX + 43;
				thruY = fromY - 334;
				toX = fromX + 175;
				toY = fromY - 225;
			}
			else if (_postion == FishingPosition.BOTTOM_LEFT)
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
			TweenMax.to(_awardImage, 1.35, {ease:Circ.easeInOut, bezierThrough:[{x:thruX, y:thruY}, {x:toX, y:toY}]});
		}

		private function onPullComplete(event : Event) : void
		{
			_player.removeEventListener(Event.COMPLETE, onPullComplete);
			sit();
			TweenLite.to(_awardImage, 1, {alpha:0, onComplete:function() : void
			{
				_awardImage.visible = false;
				_awardImage.alpha = 1;
			}});
			_onPullComplete();
		}
	}
}
