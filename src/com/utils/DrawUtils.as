package com.utils
{
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.display.MovieClip;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.geom.Matrix;

	/** 绘图工具 */
	public class DrawUtils
	{
		/** 圆角矩形 */
		public static function roundRect(target:DisplayObject = null, width:Number = 100, height:Number = 100,borderWidth:Number = 1, round:Number = 10, beginColor:Number = 0xFFCC33, lineColor:Number = 0xFF6600, beginAlpha:Number = 0.5, lineAlpha:Number = 1):DisplayObject
		{
			var g:Graphics;
			if(target == null)
			{
				var sprite:Sprite = new Sprite();
				g = sprite.graphics;
				g.clear();
				g.beginFill(beginColor, beginAlpha);
				g.lineStyle(borderWidth, lineColor, lineAlpha);
				g.drawRoundRect(0 ,0, width, height, round, round);
				g.endFill();
				return sprite;
			}
			
			if(target is Shape)
			{
				g = (target as Shape).graphics;
			}
			else if(target is Sprite)
			{
				g = (target as Sprite).graphics;
			}
			else if(target is MovieClip)
			{
				g = (target as MovieClip).graphics;
			}
			else
			{
				return target;
			}
			
			if(g == null) return target;
			g.clear();
			g.beginFill(beginColor, beginAlpha);
			g.lineStyle(borderWidth, lineColor, lineAlpha);
			g.drawRoundRect(0 ,0, width, height, round, round);
			g.endFill();
			return target;
		}
		
		/** 平铺填充 */
		public static function tiledBitmapFill(target:DisplayObject, fillImg:BitmapData, radius:Number = 0, width:Number = -1, height:Number = -1, x:Number = 0, y:Number = 0):DisplayObject
		{
			if(target == null || fillImg == null) return target;
			
			var g:Graphics;
			if(target is Shape)
			{
				g = (target as Shape).graphics;
			}
			else if(target is Sprite)
			{
				g = (target as Sprite).graphics;
			}
			else if(target is MovieClip)
			{
				g = (target as MovieClip).graphics;
			}
			else
			{
				return target;
			}
			with (g) {
				clear();
				beginBitmapFill(fillImg); 
				width = width < 0 ? target.width : width;
				height = height < 0 ? target.height : height;
				drawRoundRect(x, y, width, height, radius, radius);
				endFill();
			}
			return target;
		}
        
        /** 转位图BitmapData */
        public static function drawBitmapData(displayObject:DisplayObject, width:Number = -1, height:Number = -1):BitmapData
        {
            if(displayObject == null) return null;
            if(width == -1) width = displayObject.width;
            if(height == -1) height = displayObject.height;
            var matrix:Matrix = new Matrix();
            matrix.a = width / displayObject.width;
            matrix.d = height / displayObject.height;
            
            var bitmapData:BitmapData = new BitmapData(width, height, true, 0x00000000);
            bitmapData.draw(displayObject, matrix);
            return bitmapData;
        }
	}
	
	
}