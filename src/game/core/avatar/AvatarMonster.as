package game.core.avatar {
	import game.manager.MouseManager;

	import gameui.controls.BDPlayer;
	import gameui.core.GComponentData;

	import net.AssetData;
	import net.RESManager;

	import com.greensock.TweenLite;
	import com.utils.FilterUtils;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;





    /**
     * @author yangyiqiang
     */
    public class AvatarMonster extends AvatarThumb 
    {
        override public function run(goX : int, goY : int, targetX : int, targetY : int) : void
        {
            var x_distance : Number = goX - targetX;
            var y_distance : Number = goY - targetY;

            var angle : Number = Math.atan2(y_distance, x_distance) * 180 / Math.PI;
            if (angle < 0)
            {
                angle += 360;
            }
            if (angle >= 360 || angle < 90)
            {
                _direction = 10;
                player.flipH = false;
            }
            else if (angle >= 90 && angle < 180)
            {
                _direction = 10;
                player.flipH = true;
            }
            else if (angle >= 180 && angle < 270)
            {
                _direction = 11;
                player.flipH = false;
            }
            else if (angle >= 270 && angle < 360)
            {
                _direction = 11;
                player.flipH = true;
            }
            setAction(_direction + 2);
        }

        private var _diePlay : BDPlayer;
        private var _isDie : Boolean = false;
        private static var _arrow : MovieClip;

        override public function die() : void
        {
            var arr : AvatarUnit = AvatarManager.instance.getAvatarFrame(_uuid, AvatarManager.DIE);
            _isDie = true;
            if (!arr || !arr.avatars) return;
            setAction(AvatarManager.DIE, 1, -1, [arr.avatars[arr.avatars.length - 1]]);
            hideName();
            showArrow();
            // if (_arrow)
            // {
            // addChild(_arrow);
            // return;
            // }
            // _arrow = RESManager.getMC(new AssetData("actionArrow"));
            // _arrow.y -= 100;
            // addChild(_arrow);
            AvatarManager.instance.getDie();
            player.stop();
        }

        public function showArrow() : void
        {
            FilterUtils.addGlow(player);
            if (_arrow == null)
            {
                _arrow = RESManager.getMC(new AssetData("ArrowMC"));
            }
            _arrow.x = _avatarBd.topX + 50;
            _arrow.y = -70;
            addChild(_arrow);
        }

        public function hideArrow() : void
        {
            if (_arrow && _arrow.parent) _arrow.parent.removeChild(_arrow);
            FilterUtils.removeGlow(player);
            player.filters = [];
        }

        override protected function initComplete(event : Event) : void
        {
            super.initComplete(event);
            if (_isDie)
                die();
        }

        public function onRollOut(event : MouseEvent) : void
        {
            MouseManager.cursor = MouseManager.ARROW;
        }

        public function onRollOver(event : MouseEvent) : void
        {
            if (_isDie)
                MouseManager.cursor = MouseManager.PICK_UP;
            else
            {
                MouseManager.cursor = MouseManager.BATTLE;
            }
        }

        override protected function onMouseClick(event : MouseEvent) : void
        {
            super.onMouseClick(event);
        }

        public function quit() : void
        {
            _diePlay = new BDPlayer(new GComponentData());
            _diePlay.setBDData(AvatarManager.instance.getDie());
            addChild(_diePlay);
            _diePlay.play(40);
            _diePlay.addEventListener(Event.COMPLETE, dieComplete);
            TweenLite.to(player, 0.6, {alpha:0, overwrite:0});
            if (_arrow && this.contains(_arrow))
            {
                _arrow.stop();
                this.removeChild(_arrow);
            }
            if (!_isDie) return;
            FilterUtils.removeGlow(player);
            FilterUtils.removeGlow(this);
            this.filters = [];
            player.filters = [];
        }

        private function dieComplete(event : Event) : void
        {
            _diePlay.stop();
            _diePlay.removeEventListener(Event.COMPLETE, dieComplete);
            hide();
        }

        /** 站立 */
        override public function stand() : void
        {
            setAction(_direction == 10 ? AvatarManager.BT_STAND : _direction);
        }

        /** 正面准备战斗(战斗站立) */
        override public function fontReadyBattle() : void
        {
			changeType(AvatarType.MONSTER_TYPE);
            setAction(AvatarManager.BT_STAND);
        }

        /** 正面物理攻击 */
        override public function fontAttack(loop : int = 0) : void
        {
            changeType(AvatarType.MONSTER_TYPE);
            setAction(AvatarManager.ATTACK, loop);
        }

        /** 背面物理攻击 */
        override public function backAttack(loop : int = 0) : void
        {
        }

        /** 正面技能攻击 */
        override public function fontSkillAttack(loop : int = 0) : void
        {
            changeType(AvatarType.MONSTER_TYPE);
            setAction(AvatarManager.MAGIC_ATTACK, loop);
        }

        /** 背面技能攻击 */
        override public function backSkillAttack(loop : int = 0) : void
        {
        }

        /** 正面被攻击 */
        override public function fontHit(loop : int = 0) : void
        {
           changeType(AvatarType.MONSTER_TYPE);
            setAction(AvatarManager.HURT, loop);
        }

        /** 背面被攻击 */
        override public function backHit(loop : int = 0) : void
        {
        }

        override protected function onHide() : void
        {
            super.onHide();
            this.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
            this.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
            FilterUtils.removeGlow(this);
            if (_arrow && this.contains(_arrow))
            {
                this.removeChild(_arrow);
            }
        }

        override protected function onShow() : void
        {
            super.onShow();
            this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
            this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
        }

        override internal function reset() : void
        {
            super.reset();
            _isDie = false;
            alpha = 1;
        }
		
		/** 回收 */
		override internal function callback() : void {
			reset();
			dispose();
		}

        public function AvatarMonster()
        {
            super();
        }
    }
}
