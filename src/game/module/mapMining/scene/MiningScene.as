package game.module.mapMining.scene
{
	import worlds.maps.configs.MapLoadFilesConfigData;
	import game.core.avatar.AvatarThumb;
	import game.core.item.Item;
	import game.definition.UI;
	import game.module.mapMining.MiningManager;
	import game.module.mapMining.MiningUtils;

	import gameui.controls.GImage;
	import gameui.data.GImageData;

	import net.AssetData;
	import net.RESManager;

	import worlds.apis.MNpc;
	import worlds.apis.MUI;
	import worlds.roles.cores.Npc;
	import worlds.roles.cores.Role;

	import com.utils.FilterUtils;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;

	/**
	 * @author jian
	 */
	public class MiningScene
	{
		// 场景
		private var _floatingStones : Array;
		// 晶石
		private var _stones : Array;
		// 驴子跳
		private var _isDonkeyJumping : Boolean = false;
		// 光圈特效
		private var _lightCircle : MovieClip;

		// 进入场景
		public function enterScene() : void
		{
			stonesStartFloating();
		}

		// 离开场景
		public function exitScene() : void
		{
			stonesStopFloating();
			stopDonkeyJump();
			hideLightCircle();
			clearStones();
		}

		private function clearStones() : void
		{
			_stones = null;
		}

		private function stopDonkeyJump() : void
		{
			_isDonkeyJumping = false;
		}

		// 获取晶石Animal
		public function getStones() : Array
		{
			if (!_stones)
			{
				var stoneIds : Array = MiningUtils.getStones();
				_stones = [];

				for each (var stoneId:int in stoneIds)
				{
					_stones.push(MNpc.getNpc(stoneId));
				}
			}
			return _stones;
		}

		// 获取晶石Animal
		public function getStoneById(stondId : int) : Npc
		{
			return MNpc.getNpc(stondId);
		}

		// 获取小毛驴Animal
		public function getDonkey() : Role
		{
			return MiningManager.instance.miningSelfPlayer.donkey;
		}

		// 缓存晶石位置
		private function stonesStartFloating() : void
		{
			_floatingStones = [];

			for each (var stone:Role in getStones())
			{
				var floatingStone : FloatingHelper = new FloatingHelper();
				floatingStone.setTarget(stone.avatar, 3 + Math.random() * 5, 1 + Math.random() * 2);
				stone.avatar.hideShodow();
				stone.avatar.player.addEventListener(MouseEvent.ROLL_OVER, stone_rollOverHandler);
				stone.avatar.player.addEventListener(MouseEvent.ROLL_OUT, stone_rollOutHandler);
				_floatingStones.push(floatingStone);
			}
		}

		// 恢复晶石位置
		private function stonesStopFloating() : void
		{
			for each (var floatingStone:FloatingHelper in _floatingStones)
			{
				floatingStone.target.removeEventListener(MouseEvent.ROLL_OVER, stone_rollOverHandler);
				floatingStone.target.removeEventListener(MouseEvent.ROLL_OUT, stone_rollOutHandler);
				floatingStone.restore();
			}
		}

		// 灵石漂浮动画
		public function playStoneAnimation(minerals : Array/* of Item */, stone : Role, donkey : Role) : void
		{
			var offset : Point = MiningUtils.getFlameOffset(stone.id);
			var len : int = minerals.length;

			for (var i : int = 0; i < len; i++)
			{
				var mineral : Item = minerals[i];

				var img : GImage = new GImage(new GImageData());
				img.url = mineral.imgUrl;

				MUI.add(img);
				var flyHelper : FlyHelper = new FlyHelper();
				flyHelper.target = img;
				flyHelper.duration = 1;
				flyHelper.appearPoint = new Point(stone.x + offset.x + 50, stone.y + offset.y);
				flyHelper.hoverPoint = new Point(stone.x - Number(i - (len - 1) / 2) * 40, stone.y - 400);
				flyHelper.endPoint = new Point(donkey.x - 25, donkey.y - 80);
				flyHelper.delay = i * 0.1;
				flyHelper.run(onStoneAnimationComplete);
			}

			setTimeout(donkeyJump, 800);
		}

		private function donkeyJump() : void
		{
			if (_isDonkeyJumping)
				return;

			var jumpHelp : JumpHelper = new JumpHelper();
			var donkey : Role = getDonkey();
			if (donkey)
			{
				_isDonkeyJumping = true;
				donkey.avatar.run(0, 0, 0, 0);
				jumpHelp.target = donkey.avatar.player;
				jumpHelp.duration = 0.8;
				jumpHelp.jumpHeight = 80;
				jumpHelp.jump(onDonkeyJumpComplete);
			}
		}

		// 动画结束，移除对象
		private function onStoneAnimationComplete(target : DisplayObject) : void
		{
			MUI.remove(target);
		}

		private function onDonkeyJumpComplete() : void
		{
			if (!_isDonkeyJumping)
				return;

			var donkey : Role = getDonkey();
			donkey.avatar.stand();
			_isDonkeyJumping = false;
		}

		// 显示光圈特效
		public function showLightCircle(stoneId : int) : void
		{
			if (!_lightCircle)
			{
				_lightCircle = RESManager.getMC(new AssetData(UI.MINING_LIGHT_CIRCLE, "mining"));

				if (!RESManager.getLoader("mining"))
				{
					var res : RESManager = RESManager.instance;
					throw(Error("Loader mining 被意外移除或没有加载过！！！"));
				}
				

				if (!_lightCircle)
				{
//					var res : RESManager = RESManager.instance;
					throw(Error("加载的资源被意外移除！"));
				}
			}

			var stoneAvatar : AvatarThumb = getStoneById(stoneId).avatar;
			var offset : Point = MiningUtils.getFlameOffset(stoneId);
			_lightCircle.x = stoneAvatar.x + offset.x;
			_lightCircle.y = stoneAvatar.y + offset.y;

			stoneAvatar.parent.addChildAt(_lightCircle, stoneAvatar.parent.getChildIndex(stoneAvatar) + 1);
		}

		// 移除光圈特效
		public function hideLightCircle() : void
		{
			if (_lightCircle && _lightCircle.parent)
				_lightCircle.parent.removeChild(_lightCircle);
		}

		// 晶石RollOver
		private static function stone_rollOverHandler(event : MouseEvent) : void
		{
			(event.currentTarget as DisplayObject).filters = [FilterUtils.defaultGlowFilter];
		}

		// 晶石RollOut
		private static function stone_rollOutHandler(event : MouseEvent) : void
		{
			(event.target as DisplayObject).filters = [];
		}
	}
}


