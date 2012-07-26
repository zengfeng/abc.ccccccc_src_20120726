package test
{
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.ui.Keyboard;
    import game.core.avatar.AvatarTurtle;
    import gameui.manager.UIManager;
    import project.Game;




    /**
     * @author yangyiqiang
     */
    public class TestAvatar3 extends Game
    {
        private var _avatar : AvatarTurtle;

        private function initAvatar() : void
        {
            UIManager.setRoot(this);
            this.graphics.beginFill(0xffee00);
            this.graphics.drawRect(0, 0, 300, 200);
            this.graphics.endFill();
            _avatar = new AvatarTurtle();
            _avatar.x = 300;
            _avatar.y = 200;
            _avatar.initUUID(67113876);
            _avatar.setName("asffff");
            addChild(_avatar);
        }

        private var _num : int = 0;

        private function onFrame() : void
        {
            _num++;
            _avatar.setAction(_num % 2 == 0 ? 20 : 1);
        }

        private var d : int = 1;

        private function onClick(event : MouseEvent) : void
        {
            d++;
            if (d >= 6) d = 1;
            // _avatar.setAction(d);
            _avatar.run(mouseX, mouseY, 0, 0);
        }

        override protected function initGame() : void
        {
            initAvatar();
        }

        public function TestAvatar3()
        {
            super();

            this.stage.addEventListener(MouseEvent.CLICK, onClick);
            this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        }

        private function onKeyDown(event : KeyboardEvent) : void
        {
            if (event.keyCode > Keyboard.NUMBER_0 && event.keyCode <= Keyboard.NUMBER_9)
            {
                var q : int = parseInt(String.fromCharCode(event.keyCode));
                _avatar.setQuality(q);
            }
        }
    }
}
