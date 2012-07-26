package game.module.mapGroupBattle.uis
{
    import framerate.SecondsTimer;

    import gameui.core.GComponent;
    import gameui.core.GComponentData;
    import gameui.manager.UIManager;


    import com.utils.TimeUtil;

    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;

    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-1-30 ����10:38:47
     */
    public class UiOverTimer extends GComponent
    {
        /** 文本 */
        private var tf : TextField;
        private var _time : int = 0;
        private var running : Boolean = false;

        public function UiOverTimer()
        {
            _base = new GComponentData();
            _base.width = 40;
            _base.height = 20;
            super(_base);
            initViews();
        }

        /** 初始化视图 */
        protected function initViews() : void
        {
//            bg = UIManager.getUI(new AssetData("GroupBattle_OverTimeBg"));
//            bg.width = _base.width;
//            bg.height = _base.height;
//            addChild(bg);

            var textFormat : TextFormat = new TextFormat();
            textFormat.size = 14;
            textFormat.color = 0x2F1F00;
            textFormat.align = TextFormatAlign.CENTER;
            textFormat.font = UIManager.defaultFont;
            var tempTF : TextField = new TextField();
            tempTF.selectable = false;
            tempTF.defaultTextFormat = textFormat;
            tempTF.width = _base.width;
            tempTF.height = _base.height;
            tempTF.x = 0;
            tempTF.y = 0;
            tempTF.text = "30:05";
            addChild(tempTF);
            tf = tempTF;
        }

        public function get time() : int
        {
            return _time;
        }

        public function set time(time : int) : void
        {
            _time = time;
            tf.text = TimeUtil.toMMSS(time);
            if (_time > 1 && running == false)
            {
                running = true;
                SecondsTimer.addFunction(secondsTimer);
            }
            else if (_time <= 1)
            {
                onComplete();
            }
        }

        private function secondsTimer() : void
        {
            time -= 1;
        }

        public function stop() : void
        {
            running = false;
            SecondsTimer.removeFunction(secondsTimer);
        }

        private function onComplete() : void
        {
            stop();
            tf.text = "00:00";
        }
    }
}
