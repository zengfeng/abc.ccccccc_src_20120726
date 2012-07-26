package test
{
	import flash.display.Sprite;

	/**
	 * @author jian
	 */
	public class TestChildIndex extends Sprite
	{
		public function TestChildIndex()
		{
			var sp1:Sprite = new Sprite();
			var sp2:Sprite = new Sprite();
			var sp3:Sprite = new Sprite();
			
			sp1.name = "sp1";
			sp2.name = "sp2";
			sp3.name = "sp3";
			
			addChild(sp1);
			addChild(sp2);
			addChildAt(sp3, numChildren);
			
			reportChildren();
		}
		
		public function reportChildren():void
		{
			for (var i:int = 0; i< numChildren; i++)
			{
				trace(i + " child " + getChildAt(i).name);
			}
		}
	}
}
