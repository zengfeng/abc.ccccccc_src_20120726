package worlds.roles.animations.depths
{
	import flash.display.Graphics;
	import flash.text.TextFormatAlign;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.display.Sprite;

	/**
	 * @author ZengFeng (zengfeng75[AT]163.com) 2012-7-5
	 */
	public class TestNodeDisplay extends Sprite
	{
		private var positionTF : TextField;
		private var indexTF : TextField;
		private var bg : Sprite = new Sprite();

		public function TestNodeDisplay()
		{
			draw();
			addChild(bg);
			var textFormat : TextFormat = new TextFormat();
			textFormat.align = TextFormatAlign.CENTER;
			positionTF = new TextField();
			positionTF.defaultTextFormat = textFormat;
			positionTF.width = width;
			positionTF.height = 20;
			positionTF.x = -25;
			positionTF.y = -100;
			addChild(positionTF);

			indexTF = new TextField();
			indexTF.defaultTextFormat = textFormat;
			indexTF.width = width;
			indexTF.height = 20;
			indexTF.x = -25;
			indexTF.y = -85;
			addChild(indexTF);
		}

		override public function set y(value : Number) : void
		{
			super.y = value;
			if(positionTF == null) return;
			positionTF.text = value + "";
			if (parent)
			{
				indexTF.text = parent.getChildIndex(this) + "";
			}
		}

		public function updateInfo() : void
		{
			if(positionTF == null) return;
			positionTF.text = y + "";
			if (parent)
			{
				indexTF.text = parent.getChildIndex(this) + "";
			}
		}
		
		public function draw(color : Number = 0xFF0000) : void
		{
			var graphics : Graphics = bg.graphics;
			graphics.beginFill(color, 1);
			graphics.lineStyle(3, 0x000000);
			graphics.drawRect(-25, -100, 50, 100);
			graphics.endFill();
			updateInfo();
		}
		
		

		public function setAction(value : int, loop : int = 0, index : int = -1, arr : Array = null) : void
		{
		}

		public function run(goX : int, goY : int, targetX : int, targetY : int) : void
		{
		}

		public function stand() : void
		{
		}
	}
}
