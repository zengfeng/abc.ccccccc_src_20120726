package game.module.dailyQuest {
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class RollTexts extends Sprite {

		private var _texts:Vector.<TextField>=new Vector.<TextField>();
		public var ALLCompleted:String="allCompleted";

		public function RollTexts() {
			super();
		}

		public function addText(str:String):void {
			var textField:TextField=new TextField();
			textField.htmlText=str;
			textField.mouseEnabled=false;
			textField.autoSize=TextFieldAutoSize.CENTER;
			var tf:TextFormat=new TextFormat();
			tf.size=14;
			tf.bold=true;
			var f:GlowFilter=new GlowFilter(0x000000,1,3,3,3);
			textField.filters=[f];
			textField.setTextFormat(tf);
			_texts.push(textField);   
			
		}

		public function startRoll(cp:uint=0):void {
			if(cp>=0 && cp<_texts.length && _texts[cp]!=null){
				addChild(_texts[cp]);
				TweenLite.to(_texts[cp],1.5, {y: -100,onComplete:singleCompleted,onCompleteParams:[cp]});
//				TweenLite.to(_texts[cp],2, {y: -120,alpha:0,onComplete:singleCompleted,onCompleteParams:[cp]});
				TweenLite.delayedCall(0.5,startRoll,[cp+1]);
			}
		}
		
		private function singleCompleted(cp:uint):void{
			removeChild(_texts[cp]);
			if(cp==_texts.length-1){
				_texts=new Vector.<TextField>();
				dispatchEvent(new Event(ALLCompleted));
			}
		}

	} //class end
}
