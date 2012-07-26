package game.module.userBuffStatus.ui
{
	import game.module.userBuffStatus.Buff;

	import gameui.controls.GImage;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.data.GImageData;

	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipManager;
	import com.utils.FilterUtils;



	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-2-1 ����2:15:32
	 */
	public class BuffIcon extends GComponent
	{
		public var buff : Buff;
		private var img : GImage;
		private var _buffStatusContainer : BuffStatusContainer;
		private var _toolTipString : String;

		public function BuffIcon(buff : Buff)
		{
			_base = new GComponentData();
			_base.width = 25;
			_base.height = 25;
			super(_base);
			this.buff = buff;
			initViews();
		}

		/** 初始化视图 */
		public function initViews() : void
		{
			var imageData : GImageData = new GImageData();
			imageData.width = 25;
			imageData.height = 25;
			img = new GImage(imageData);
			img.url = buff.url;
			addChild(img);
		}

		/** TIP */
		public function set tip(value : String) : void
		{
//			toolTip.source = value;
			_toolTipString = value;
			ToolTipManager.instance.refreshToolTip(this);
		}

		/** 时间 */
		public function set time(value : int) : void
		{
			if (value <= 3 && value > 0)
			{
				FilterUtils.addGlow(this);
			}
			else
			{
				FilterUtils.removeGlow(this);
			}
		}

		private function get buffStatusContainer() : BuffStatusContainer
		{
			if (_buffStatusContainer == null)
			{
				_buffStatusContainer = BuffStatusContainer.instance;
			}
			return _buffStatusContainer;
		}

		override public function show() : void
		{
			if (isClearImg == true)
			{
				img.url = buff.url;
				isClearImg = false;
				addChild(img);
				buffStatusContainer.addIcon(this);
			}
		}

		public var isClearImg : Boolean = true;

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
