package test
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

//	import com.sociodox.theminer.TheMiner;


	[ SWF ( frameRate="60" , backgroundColor=0xFFFFFF,width="1680" , height="1000" ) ]
	/**
	 * @author jian
	 */
	public class TestMouseCost extends Sprite
	{
		public function TestMouseCost()
		{
			stage.frameRate = 60;

			addSprites();

			addMouseFollower();
		}

		private var _follower : Sprite;

		private function addMouseFollower() : void
		{
			_follower = new Sprite();
			_follower.graphics.lineStyle(1);
			_follower.graphics.beginFill(Math.random() * 0xFFFFFF);
			_follower.graphics.drawRect(0, 0, 50, 50);
			
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			addChild(_follower);
		}

		private function addSprites() : void
		{
			var sprite : Sprite;

			for (var i : int = 0; i < 1500; i++)
			{
				sprite = new Sprite();
				sprite.x = Math.random() * 50;
				sprite.y = Math.random() * 50;
				sprite.graphics.lineStyle(1);
				sprite.graphics.beginFill(Math.random() * 0xFFFFFF);
				sprite.graphics.drawRect(0, 0, 50, 50);
				 sprite.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				addChild(sprite);

//				var bitmapData : BitmapData = new BitmapData(sprite.width, sprite.height, false);
//				bitmapData.draw(sprite);
//				var bitmap : Bitmap = new Bitmap(bitmapData);
//				bitmap.x = Math.random() * 500;
//				bitmap.y = Math.random() * 500;
//				 addChild(bitmap);

//				var bitmapWrap:Sprite = new Sprite();
//				bitmapWrap.addChild(bitmap);
//				addChild(bitmapWrap);

			}
		}

		private function onMouseMove(event : MouseEvent) : void
		{
			_follower.x = event.stageX;
			_follower.y = event.stageY;
		}
	}
}
