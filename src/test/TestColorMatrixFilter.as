package test
{
	import bd.BDData;
	import bd.BDUnit;
	import com.utils.UICreateUtils;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import game.config.StaticConfig;
	import gameui.controls.BDPlayer;
	import gameui.controls.GButton;
	import gameui.controls.GImage;
	import gameui.controls.GTextInput;
	import gameui.core.GComponentData;
	import gameui.data.GButtonData;
	import gameui.data.GTextInputData;
	import project.Game;





	
	/**
	 * @author jian
	 */
	public class TestColorMatrixFilter extends Game
	{
		private const IDLE:uint = 0;
		private const LOAD:uint = 1;
		private const READY:uint = 2;
		private const PLAY:uint = 3;
		
		private var bdPlayers:Vector.<BDPlayer>;
		private var movieClips:Vector.<GImage>;
		private var bdData:BDData;
		private var bdUnitVector:Vector.<BDUnit> = new Vector.<BDUnit>();
		private var count:uint = 0;
		private var bdPlayerButton:GButton;
		private var movieClipButton:GButton;
		private var bdPlayerState:uint = IDLE;
		private var movieClipState:uint = READY;
		
		private var xNumInput:GTextInput;
		private var yNumInput:GTextInput;
		
		override protected function initGame():void
		{
			addTextInputs();
			addButtons();
		}
		
		private function addTextInputs():void
		{
			var data:GTextInputData = new GTextInputData();
			data.x = 20;
			data.y = 10;
			data.width = 80;
			
			xNumInput = new GTextInput(data);
			xNumInput.text = "10";
			addChild(xNumInput);
			
			var data2:GTextInputData = new GTextInputData();
			data2.x = 120;
			data2.y = 10;
			data2.width = 80;
			
			yNumInput = new GTextInput(data2);
			yNumInput.text = "10";
			addChild(yNumInput);
		}
		
		private function addButtons():void
		{
			var data:GButtonData = new GButtonData();
			data.x = 220;
			data.y = 10;
			data.labelData.text = "BDPlayer";
			bdPlayerButton = new GButton(data);
			addChild(bdPlayerButton);
			bdPlayerButton.addEventListener(MouseEvent.CLICK, onClickBDPlayerButton);
			
			var data2:GButtonData = new GButtonData();
			data2.x = 320;
			data2.y = 10;
			data2.labelData.text = "MovieClip";
			movieClipButton = new GButton(data2);
			addChild(movieClipButton);
			movieClipButton.addEventListener(MouseEvent.CLICK, onClickMovieClipButton);
		}
		
		private function onClickBDPlayerButton(event:MouseEvent):void
		{
			switch (bdPlayerState)
			{
				case IDLE: 
					startLoadBDData();
					break;
				case LOAD: 
					break;
				case READY: 
					drawBDPlayers();
					break;
				case PLAY: 
					removeBDPlayers();
					break;
			}
		}
		
		private function startLoadBDData():void
		{
			bdPlayerState = LOAD;
			for (var i:uint = 1; i < 53; i++)
			{
				count++;
				
				var loader:Loader = new Loader();
//				var key:String = printf("%04s", i);
//				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadBDPlayerComplete);
//				loader.load(new URLRequest(StaticConfig.cdnRoot + "assets/test/soul_png/蓝色元神" + key + ".png"));
			}
		}
		
		private function onLoadBDPlayerComplete(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, onLoadBDPlayerComplete);
			
			var bitmap:Bitmap = loaderInfo.content as Bitmap;
			var bdUnit:BDUnit = new BDUnit(new Point(0, 0), bitmap.bitmapData);
			
			bdUnitVector.push(bdUnit);
			
			count--;
			
			if (count == 0)
			{
				bdPlayerState = READY;
				bdData = changeBDDataHue(new BDData(bdUnitVector), 40);
				drawBDPlayers();
			}
		}
		
		private static function changeBitmapDataHue(sourceBitmapData:BitmapData, hue:Number):BitmapData
		{
			hue *= Math.PI / 180;
			var cos:Number = Math.cos(hue);
			var sin:Number = Math.sin(hue);
			var redLuminance:Number = 0.213;
			var greenLuminance:Number = 0.715;
			var blueLuminance:Number = 0.072;
			var change:Array = new Array((redLuminance + (cos * (1 - redLuminance))) + (sin * (-redLuminance)), (greenLuminance + (cos * (-greenLuminance))) + (sin * (-greenLuminance)), (blueLuminance + (cos * (-blueLuminance))) + (sin * (1 - blueLuminance)), 0, 0, (redLuminance + (cos * (-redLuminance))) + (sin * 0.143), (greenLuminance + (cos * (1 - greenLuminance))) + (sin * 0.14), (blueLuminance + (cos * (-blueLuminance))) + (sin * -0.283), 0, 0, (redLuminance + (cos * (-redLuminance))) + (sin * (-(1 - redLuminance))), (greenLuminance + (cos * (-greenLuminance))) + (sin * greenLuminance), (blueLuminance + (cos * (1 - blueLuminance))) + (sin * blueLuminance), 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1);
			var filter:ColorMatrixFilter = new ColorMatrixFilter(change);
			var targetBitmapData:BitmapData = new BitmapData(sourceBitmapData.rect.width, sourceBitmapData.rect.height);
			targetBitmapData.applyFilter(sourceBitmapData, sourceBitmapData.rect, new Point(0,0), filter);
			return targetBitmapData;
		}
		
		private static function changeBDDataHue(sourceBDData:BDData, hue:Number):BDData
		{
			
			var bdUnitVector:Vector.<BDUnit> = new Vector.<BDUnit>;
			for each (var sourceBDUnit:BDUnit in sourceBDData.list())
			{
				var targetBitmapData:BitmapData = changeBitmapDataHue(sourceBDUnit.bds, hue);
				var targetBDUnit:BDUnit = new BDUnit(sourceBDUnit.offset, targetBitmapData);
				bdUnitVector.push(targetBDUnit);
			}
			
			var targetBDData:BDData = new BDData(bdUnitVector);
			return targetBDData;
		}
		
		private function drawBDPlayers():void
		{
			bdPlayers = new Vector.<BDPlayer>;
			var xNum:uint = uint(xNumInput.text);
			var yNum:uint = uint(yNumInput.text);
			
			for (var i:uint = 0; i < xNum; i++)
			{
				for (var j:uint = 0; j < yNum; j++)
				{
					var data:GComponentData = new GComponentData();
					var bdPlayer:BDPlayer = new BDPlayer(data);
					bdPlayer.setBDData(bdData);
					bdPlayer.x = (i * 50) % 800;
					bdPlayer.y = 40 + (j * 50) % 560;
					
					addChild(bdPlayer);
					bdPlayers.push(bdPlayer);
					bdPlayer.play(133, null, 0);
				}
			}
			bdPlayerState = PLAY;
		}
		
		private function removeBDPlayers():void
		{
			for each (var bdPlayer:BDPlayer in bdPlayers)
			{
				bdPlayer.dispose();
				removeChild(bdPlayer);
			}
			bdPlayerState = READY;
		}
		
		private function onClickMovieClipButton(event:MouseEvent):void
		{
			switch (movieClipState)
			{
				case READY: 
					drawMoiveClips();
					break;
				case PLAY: 
					removeMovieClips();
					break;
			}
		
		}
		
		private function drawMoiveClips():void
		{
			movieClips = new Vector.<GImage>;
			var xNum:uint = uint(xNumInput.text);
			var yNum:uint = uint(yNumInput.text);
			
			for (var i:uint = 0; i < xNum; i++)
			{
				for (var j:uint = 0; j < yNum; j++)
				{
					var movieClip:GImage = UICreateUtils.createGImage(StaticConfig.cdnRoot + "assets/goods/蓝色swf测试.swf");
					movieClip.x = (i * 50) % 800;
					movieClip.y = 40 + (j * 50) % 560;
					movieClips.push(movieClip);
					addChild(movieClip);
				}
			}
			movieClipState = PLAY;
		}
		
		private function removeMovieClips():void
		{
			for each (var movieClip:GImage in movieClips)
			{
				removeChild(movieClip);
			}
			movieClipState = READY;
		}
		
		public function TestColorMatrixFilter()
		{
			super();
		}
	}
}
