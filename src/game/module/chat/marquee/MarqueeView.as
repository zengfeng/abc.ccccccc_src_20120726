package game.module.chat.marquee
{
	import game.definition.UI;
	import game.manager.ViewManager;

	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;

	import net.AssetData;

	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.utils.UICreateUtils;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;

	/**
	 * @author 1
	 */
	public class MarqueeView extends GComponent
	{
		private var _textContainer : Sprite;
		private var _marqueeTextF : TextField;
		private var _textBitmapData : BitmapData;
		private var _bg : Sprite;
		private var _textBitmap:Bitmap;
		private var _model:MarqueeModel;
		private var _isPlaying:Boolean=false;

        private static const marqueeSpeed:uint=80; 
		private static const marqueeWidth:uint=552;
		
		public function MarqueeView(data : GComponentData,model:MarqueeModel)
		{
			data.width = 626;
			data.height = 36;
		    data.parent = ViewManager.instance.getContainer(ViewManager.IOC_CONTAINER);
			data.align = new GAlign(-1, -1, 129, -1, 1, -1);
			mouseEnabled = false;
			mouseChildren = false;
			super(data);
			
			_model=model;
			
		}

		override protected function create() : void
		{
			super.create();
			addBg();
			addTextBg();
			addTextField();
		}

		private function addBg() : void
		{
			_bg = UIManager.getUI(new AssetData(UI.MARQUEEBG));
			addChild(_bg);
			
		}

		private function addTextBg() : void
		{
			var rect : Rectangle = new Rectangle(0, 0, 552, 30);
			_textContainer = new Sprite();
			_textContainer.scrollRect = rect;
			_textContainer.x = 32;
			_textContainer.y = 1;
			addChild(_textContainer);
		}

		private function addTextField() : void
		{
		   _marqueeTextF = UICreateUtils.createTextField(null, "", 100, 30, 0, 0, UIManager.getTextFormat(14, 0xffffff));
		}
		
		public function playMarquee(str:String):void
		{
			if(_isPlaying==false)
			{
			setMarqueeContent(str);
			_isPlaying=true;
			}
		}

		private function setMarqueeContent(str : String) : void
		{
			
			_marqueeTextF.htmlText=str;
			_marqueeTextF.autoSize = TextFieldAutoSize.LEFT;
			_marqueeTextF.wordWrap=false;
			drawBitmap();		
			moveMarquee();
		}

		private function drawBitmap() : void
		{
			_textBitmapData = new BitmapData(_marqueeTextF.textWidth, _marqueeTextF.textHeight+2, true, 0);

			var _matrix : Matrix = new Matrix();
			_matrix.tx = -2;
			_matrix.ty = 0;
			_textBitmapData.draw(_marqueeTextF, _matrix, null, null, null, true);

			_textBitmap = new Bitmap(_textBitmapData, PixelSnapping.ALWAYS);
			if(_textContainer.contains(_textBitmap))
			_textContainer.removeChild(_textBitmap);
			_textContainer.addChild(_textBitmap);
	//		_textBitmap.smoothing=true;

			// _textBg.addChild(new GButton(new GButtonData()));
		}
		private var _timer:Timer;
		
		
		private function moveMarquee():void
		{
			_textBitmap.x=(_bg.x+_bg.width);
//			_textBitmap.y=2;
			_textContainer.y = (_bg.height - _textBitmap.height) * 0.5-1;
			
			var moveTime:int=((marqueeWidth+_textBitmap.width)/marqueeSpeed);
			
			TweenLite.to(_textBitmap, moveTime, {x:_bg.x-_textBitmap.width, ease:Linear.easeNone, onUpdate:onUpdate,onComplete:completeHandler});					
		}
		
		private function completeHandler():void
		{
		   _model.marqueeMsg.shift();
		   if(_model.marqueeMsg.length>0)
		   {			
			  setMarqueeContent((_model.marqueeMsg[0]) as String);
		   }
		   else
		   {
			  _isPlaying=false;
			  this.hide();
		   }
		}	
		
		private function onUpdate():void
		{
			_textBitmap.x = Math.round(_textBitmap.x);
		}

		override protected function onShow() : void
		{
			layout();
		}

		override protected function layout() : void
		{
			GLayout.layout(this);
			

			// this.x=int((UIManager.root.stage.stageWidth - this.width)*0.5);
			// this.y=int((UIManager.root.stage.stageHeight - this.height)*0.5);
		}
		
		public function setModel(value:MarqueeModel):void
		{
			_model=value;
		}
		
	}
}
