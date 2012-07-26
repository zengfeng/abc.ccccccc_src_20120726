package game.module.userBuffStatus.ui
{
	import game.module.userBuffStatus.Status;

	import gameui.controls.GImage;
	import gameui.controls.GLabel;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GImageData;
	import gameui.data.GLabelData;
	import gameui.manager.UIManager;

	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipManager;

	import flash.text.TextFormatAlign;



    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-2-1 ����2:15:32
     */
    public class StatusIcon extends GComponent
    {
        public var status : Status;
        private var levelLabel : GLabel;
        private var img : GImage;
        private var _buffList : BuffStatusContainer;
		private var _toolTipString:String = "";

        public function StatusIcon(status : Status)
        {
            _base = new GComponentData();
            _base.width = 25;
            _base.height = 25;
            super(_base);
            this.status = status;
            initViews();
        }

        /** 初始化视图 */
        public function initViews() : void
        {
            var imageData : GImageData = new GImageData();
            imageData.width = 25;
            imageData.height = 25;
            img = new GImage(imageData);
            img.url = status.url;
            addChild(img);

            var data : GLabelData = new GLabelData();
            data.textColor = 0xFFFFFF;
            data.width = 15;
            data.height = 15;
            data.textFormat = UIManager.getTextFormat(12);
            data.textFormat.align = TextFormatAlign.RIGHT;
            data.x = _base.width - data.width - 2;
            data.y = _base.height - data.height - 2;
            levelLabel = new GLabel(data);
            addChild(levelLabel);
        }

        /** TIP */
        public function set tip(value : String) : void
        {
//            toolTip.source = value;
			_toolTipString = value;
			ToolTipManager.instance.refreshToolTip(this);
        }

        /** 等级 */
        public function set level(value : int) : void
        {
            levelLabel.text = value + "";
        }

        private function get buffStatusContainer() : BuffStatusContainer
        {
            if (_buffList == null)
            {
                _buffList = BuffStatusContainer.instance;
            }
            return _buffList;
        }

        override public function show() : void
        {
            if (isClearImg == true)
            {
                img.url = status.url;
                isClearImg = false;
            }
            buffStatusContainer.addIcon(this);
        }

        public var isClearImg : Boolean = false;
        override public function hide() : void
        {
            buffStatusContainer.removeIcon(this);
            img.clearUp();
            isClearImg = true;
        }
		
		
		override protected function onShow():void
		{
			super.onShow();
			ToolTipManager.instance.registerToolTip(this, ToolTip, provideToolTip);
		}
		
		private function provideToolTip():String
		{
			return _toolTipString;
		}
		
		override protected function onHide():void
		{
			ToolTipManager.instance.destroyToolTip(this);
			super.onHide();
		}
    }
}
