package game.module.battle.view
{
	import gameui.controls.GProgressBar;
	import gameui.data.GProgressBarData;

	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class BattleTipBar extends GProgressBar
	{
		public function BattleTipBar(data:GProgressBarData)
		{
			super(data);
			if(_text)
			{
			}
			else
			{
				_text = new TextField();
				this.addChild(_text);
				_text.width = data.width;
				_text.height = 20;
				_text.y = -4;
			
//				var color:Number=0x000000;
//				var angle:Number=ang;
//				var alpha:Number=0.8;
//				var blurX:Number=8;
//				var blurY:Number=8;
//				var distance:Number=dis;
//				var strength:Number=0.65;
//				var inner:Boolean=false;
//				var knockout:Boolean=false;
//				var quality:Number=BitmapFilterQuality.HIGH;
//				return DropShadowFilter(distance,angle,color,alpha,blurX,blurY,strength,quality,inner,knockout);

				//_text.filters = [new DropShadowFilter(0,45,0x000000,0.3,2,2,3,1,false,false)];
				//_text.filters = [new GlowFilter(0x000000, 1, 2, 2, 3, 1)];
			}
		}
		
		public function setFormat(txtf:flash.text.TextFormat):void
		{
			if(txtf)
			{
				_text.setTextFormat(txtf);
			}
		}
		
		public function setBarTextValue(numerator:uint, denominator:uint):void
		{
			_text.text = numerator.toString()+" / "+ denominator.toString();
			
			var fm:TextFormat = new flash.text.TextFormat();
			fm.color = 0xffffff;
			fm.size = 12;
			fm.bold = false;
			fm.align = "center";
			
			_text.setTextFormat(fm);
			//_text.filters = UIManager.getEdgeFilters(0x000000, 3);
			_text.filters = [new GlowFilter(0x000000, 1, 2, 2, 3, 1)];
			
			this.value = (numerator/denominator)*100;
		}
		
		private var _text:TextField; 
	}
}