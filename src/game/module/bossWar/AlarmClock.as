package game.module.bossWar
{
    import gameui.controls.GButton;
    import gameui.skin.SkinStyle;
    import net.AssetData;
    import gameui.containers.GPanel;
    import gameui.data.GPanelData;

    /**
     * @author Lv
     */
    public class AlarmClock extends GPanel
    {
        //复活按钮
        private var reviveBtn:GButton;
        //寻路按钮
        private var WayfindingBtn:GButton;
        
        public function AlarmClock()
        {
           _data = new GPanelData();
			initData();
			super(_data);
			initView();
			initEvent();
        }

        private function initData() : void
        {
            _data.width = 275;
			_data.height = 25;
			_data.bgAsset=new AssetData(SkinStyle.emptySkin);   //取消背景
        }

        private function initEvent() : void
        {
        }

        private function initView() : void
        {
        }
    }
}
