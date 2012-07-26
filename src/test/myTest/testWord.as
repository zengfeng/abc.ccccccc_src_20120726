package test.myTest
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import game.config.StaticConfig;
	import game.module.battle.view.BattleNumber;
	import gameui.controls.GButton;
	import gameui.data.GButtonData;
	import net.AssetData;
	import net.LibData;
	import net.RESManager;





    /**
     * @author Lv
     */
    public class testWord extends Sprite
    {
        public var bossBloodVec:Vector.<Bitmap> = new Vector.<Bitmap>();
        public function testWord()
        {
             RESManager.instance.load(new LibData(StaticConfig.cdnRoot + "assets/ui/numberTest.swf", "bossNum"), initDieFrame);
             
        }

        private function initDieFrame() : void
        {
            for(var  i:int = 0; i < 12; i++ )
			{
				if(i == 0)
					bossBloodVec[i] = new Bitmap(RESManager.getBitmapData(new AssetData("Number_Hurt_a", "bossNum")));
				else if(i == 1)
					bossBloodVec[i] = new Bitmap(RESManager.getBitmapData(new AssetData("Number_Hurt_b", "bossNum")));
				else 
					bossBloodVec[i] = new Bitmap(RESManager.getBitmapData(new AssetData("Number_Hurt_" + (i-2).toString(), "bossNum")));
			}
            
            loaderIMG();
        }

        private function loaderIMG() : void
        {
            var data:GButtonData = new GButtonData();
            data.labelData.text = "tiaoxue";
            data.x = 100;
            data.y = 50;
            var gbtn:GButton = new GButton(data);
            addChild(gbtn);
            gbtn.addEventListener(MouseEvent.MOUSE_DOWN, ondown);
            
        }
		private var harm2:int = 100;
        private function ondown(event : MouseEvent) : void
        {
            getBlood(harm2);
            harm2+=15;
        }
        private function getBlood(harm:int): void{
            var bx:int = 0;
			var by:int = 0;
            var numBitmap:BattleNumber = new BattleNumber();
            numBitmap.initNumbers(bossBloodVec, Math.abs(harm), 0,4);
			numBitmap.toNumber();
			numBitmap.visible = true;
			numBitmap.scaleX = 0.5;
			numBitmap.scaleY = 0.5;
			numBitmap.alpha = 0.3;
            addChild(numBitmap);
            numBitmap.x = 250;
            numBitmap.y = 100;
            
            bx = numBitmap.x;
			by = numBitmap.y;
			TweenLite.to(numBitmap,1,{delay:0, scaleX:1, scaleY:1,y:by-38, alpha:1, overwrite:0});
			TweenLite.to(numBitmap,0.5,{delay:0.5,scaleX:1.1, scaleY:1.1, alpha:0,y:by-45, onComplete:ShowHarmComplete_func, onCompleteParams:[numBitmap], overwrite:0});
        }
        private function ShowHarmComplete_func(tf : BattleNumber) : void
		{
			removeChild(tf);
		}

    }
}
