package game.module.quest
{
	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.manager.UIManager;

	import com.greensock.TweenLite;

	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author yangyiqiang
	 * 任务
	 */
	public class QuestMessagePanel extends GComponent
	{
		public function QuestMessagePanel()
		{
			_base = new GComponentData();
			_base.width = 80;
			_base.height = 600;
			_base.parent = UIManager.root;
			_base.align = new GAlign(-1, -1, -1, 100, 0);
			super(base);
		}

		private var _text : TextField;

		override protected function create() : void
		{
			_text = new TextField();
			_text.width = this.width;
			_text.embedFonts=!UIManager.hasEmbedFonts;
			_text.selectable=false;
			_text.autoSize = TextFieldAutoSize.CENTER;
			_text.filters=[new GlowFilter(0xff00ff, 1, 20, 20, 4)];
			var textFormat : TextFormat = new TextFormat();
			textFormat.color=0xffffff;
			textFormat.font = "STXinwei";
			textFormat.size=30;
			_text.defaultTextFormat=textFormat;
			addChild(_text);
		}

		override public function set source(value : *) : void
		{
			if (value is String && value != "")
			{
				this.alpha = 0;
				_text.htmlText = value;
				this.x=(UIManager.stage.stageWidth-this.width)/2;
				this.y=UIManager.stage.stageHeight-200;
				show();
			}
		}
		
		override public function show() : void
		{
			TweenLite.to(this, 1, {alpha:1, onComplete:super.show(),overwrite:0});
			TweenLite.to(this, 1, {delay:3, onComplete:hide,overwrite:0});
		}

		override public function hide() : void
		{
			TweenLite.to(this, 1, {alpha:0, onComplete:super.hide()});
		}
	}
}
