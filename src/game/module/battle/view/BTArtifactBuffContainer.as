package game.module.battle.view
{
	import gameui.core.GComponent;
	import gameui.core.GComponentData;

	import flash.display.DisplayObject;

	public class BTArtifactBuffContainer extends GComponent
	{
		private var typeset:uint;  //排版方式，0为左排版，1为右边排版
		private var gapV:uint = 2;
		private var iconWidth:uint = 25;
		
		//---------------------------------------------------------
		public function BTArtifactBuffContainer(t:uint):void
		{
			_base = new GComponentData();
			_base.width = 138;
			_base.height = 28;
			typeset = t;
			super(_base);
		}
		
		public function setGap(g:uint):void
		{
			gapV = g;
		}
		
		public function setIconWidth(i:uint):void
		{
			iconWidth = i;
		}
		
		public function addArtifact(icon:DisplayObject):void
		{
			if(icon == null || this.contains(icon) == true)
				return ;
			addChild(icon);
			sortIcon();
		}
		
		public function removeArtifact(icon:DisplayObject):void
		{
			if(icon == null || this.contains(icon) == false)
				return ;
			removeChild(icon);
			sortIcon();
		}
		
		private function sortIcon():void
		{
			var i:uint = 0;
			var icon:DisplayObject;
			var row:uint = 0;
			var rand:uint = 0;
			if(typeset == 0)
			{
				for( i = 0; i < numChildren; ++i)
				{
					icon = getChildAt(i);
					icon.x = (iconWidth + gapV)*i;
				}
			}
			else
			{
				for( i = 0; i < numChildren; ++i)
				{
					icon = getChildAt(i);
					icon.x = this.width -(iconWidth)*(i+1)-gapV*i;
				}
			}
		}
	}
}