package game.module.chatwhisper.view {
	import gameui.layout.GLayout;
	import gameui.core.GAlign;
	import flash.display.DisplayObjectContainer;
	import game.manager.ViewManager;

	import gameui.controls.GIcon;
	import gameui.data.GIconData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.utils.FilterUtils;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * @author ZengFeng Email:zengfeng75[AT]163.com)  2011  2011-11-21 ����8:50:55
	 */
	public class WhisperIcoButton extends GIcon {
		private var _countCount : uint = 0;
		public var countLabel : TextField;
		private var countLabelBg : Sprite;

		public function WhisperIcoButton() {
			_data = new GIconData();
			_data.asset = new AssetData("ChatWhisperIconButton_Up");
			_data.width = 40;
			_data.height = 40;
			_data.parent = ViewManager.instance.getContainer(ViewManager.IOC_CONTAINER);
			_data.align = new GAlign(-1, 13, -1, 80);
			super(_data);
		}

		/** 默认位置 */
		// public function get defaultPostion() : Point
		// {
		//			//  _bottom = 400;
		//			//  _left = 450;
		// _bottom = 70;
		// _right = 3;
		// return super.defaultPostion;
		// }
		/** 初始化视图 */
		override protected function create() : void {
			super.create();
			countLabelBg = UIManager.getUI(new AssetData("numberMount"));
			countLabelBg.x = 17;
			countLabelBg.y = -3;
			addChild(countLabelBg);

			var textFormat : TextFormat = new TextFormat();
			textFormat.font = UIManager.defaultFont;
			textFormat.size = 12;
			textFormat.color = 0xFFFFFF;
			textFormat.align = TextFormatAlign.CENTER;
			countLabel = new TextField();
			countLabel.width = countLabelBg.width;
			countLabel.height = countLabelBg.height;
			countLabel.x = 17 + 1.2;
			countLabel.y = -3 + 1.5;
			countLabel.defaultTextFormat = textFormat;
			countLabel.filters = [FilterUtils.defaultTextEdgeFilter];
			addChild(countLabel);
		}

		override public function show() : void {
			if (countCount > 0) {
				countLabelBg.visible = true;
				countLabel.visible = true;
				FilterUtils.addGlow(this);
			} else {
				if (countLabelBg)
					countLabelBg.visible = false;
				countLabel.visible = false;
				FilterUtils.removeGlow(this);
				filters = [];
			}
			super.show();
			GLayout.update(UIManager.root, this);
		}

		override public function hide() : void {
			FilterUtils.removeGlow(this);
			filters = [];
			super.hide();
			countCount = 0;
		}
		
		public function setParent(parent:DisplayObjectContainer):void
		{
			_data.parent = parent;
		}

		public function get countCount() : uint {
			return _countCount;
		}

		public function set countCount(countCount : uint) : void {
			_countCount = countCount;
			if (countLabel)
				countLabel.text = _countCount.toString();
			if (_countCount > 0) {
				this.show();
			}
		}
	}
}
