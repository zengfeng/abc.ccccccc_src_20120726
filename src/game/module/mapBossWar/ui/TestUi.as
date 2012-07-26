package game.module.mapBossWar.ui
{
	import game.module.bossWar.ProxyBossWar;
	import game.module.mapBossWar.BOOSControll;

	import gameui.controls.GButton;
	import gameui.data.GButtonData;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;







    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-2-13 ����6:20:18
     */
    public class TestUi extends Sprite
    {
        public function TestUi()
        {
            initView();
        }

        /** 单例对像 */
        private static var _instance : TestUi;

        /** 获取单例对像 */
        public static function get instance() : TestUi
        {
            if (_instance == null)
            {
                _instance = new TestUi();
            }
            return _instance;
        }

        public function get bwMapController() : BOOSControll
        {
            return BOOSControll.instance;
        }

        private function initView() : void
        {
            var buttonData : GButtonData;
            var button : GButton;
            
            buttonData = new GButtonData();
            buttonData.labelData.text = "参加";
            button = new GButton(buttonData);

            addChild(button);
            button.addEventListener(MouseEvent.CLICK, cs_join);
            
            
            buttonData = new GButtonData();
            buttonData.labelData.text = "离开";
            button = new GButton(buttonData);

            addChild(button);
            button.addEventListener(MouseEvent.CLICK, cs_quit);
            

            buttonData = new GButtonData();
            buttonData.labelData.text = "进入地图";
            button = new GButton(buttonData);

            addChild(button);
            button.addEventListener(MouseEvent.CLICK, enterMap);

            buttonData = new GButtonData();
            buttonData.labelData.text = "加入";
            button = new GButton(buttonData);
            addChild(button);
            button.addEventListener(MouseEvent.CLICK, join);

            buttonData = new GButtonData();
            buttonData.labelData.text = "退出";
            button = new GButton(buttonData);
            addChild(button);
            button.addEventListener(MouseEvent.CLICK, quit);

            buttonData = new GButtonData();
            buttonData.labelData.text = "死亡";
            button = new GButton(buttonData);
            addChild(button);
            button.addEventListener(MouseEvent.CLICK, die);

            buttonData = new GButtonData();
            buttonData.labelData.text = "复活";
            button = new GButton(buttonData);
            addChild(button);
            button.addEventListener(MouseEvent.CLICK, revive);

            for (var i : int = 0; i < numChildren; i++)
            {
                var dis : DisplayObject = getChildAt(i);
                dis.x = i * 100;
            }

            x = 500;
            y = 250;
        }

        private function cs_quit(event : MouseEvent) : void
        {
			ProxyBossWar.instance.quickBossWar();
        }

        private function cs_join(event : MouseEvent) : void
        {
            ProxyBossWar.instance.joyInBossWar();
        }

        private function enterMap(event : MouseEvent) : void
        {
        }

        public function join(event : Event = null) : void
        {
            bwMapController.enter();
        }

        public function quit(event : Event = null) : void
        {
            bwMapController.quit();
        }

        public function die(event : Event = null) : void
        {
            bwMapController.die();
            bwMapController.setReviveTime(30);
        }

        public function revive(event : Event = null) : void
        {
            bwMapController.revive();
        }
    }
}
