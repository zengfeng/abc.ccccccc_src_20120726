package test
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageQuality;
    import flash.display.StageScaleMode;
    import flash.geom.Point;
    import flash.system.Security;
    import flash.utils.setInterval;
    import flash.utils.setTimeout;
    import framerate.SecondsTimer;
    import game.core.avatar.AvatarPlayer;
    import game.core.avatar.AvatarThumb;


    /**
     * @author ZengFeng (Email:zengfeng75[AT]163.com) 2012-3-12   ����6:10:22 
     */
    [ SWF ( frameRate="60" , backgroundColor=0x000000,width="1680" , height="1000" ) ]
    public class TestAvatar2 extends Sprite
    {
        public function TestAvatar2()
        {
            super();
            initializeStage();
//            setInterval(run, 4000);
            for(var i:int = 0; i < 500; i++)
            {
                var avatar : AvatarThumb = new AvatarPlayer();
                avatar.initUUID(1);
                avatar.setAction(1);
                avatar.setName("aaaaaaaaa");
                avatar.x = Math.random() * stage.stageWidth;
                avatar.y = Math.random() * stage.stageHeight;
//                addChild(avatar);
//                avatar.visible = false;
//                setTimeout(avatar.stop, 5000);
            }
            
//            for(i = 0; i < 100; i++)
//            {
//                var id:int = Math.floor(Math.random() * numChildren);
//                while(dieList.indexOf(id) != -1)
//                {
//                    id = Math.floor(Math.random() * numChildren);
//                }
//                
//                avatar = getChildAt(id) as AvatarThumb;
//                setTimeout(avatar.stop, 1000);
//                dieList.push(avatar);
//            }
//            SecondsTimer.addFunction(run);
        }

        private function initializeStage() : void
        {
            flash.system.Security.allowDomain("*");
            stage.quality = StageQuality.HIGH;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            transform.perspectiveProjection.projectionCenter = new Point(stage.stageWidth / 2, stage.stageHeight / 2);
        }
        
        private var dieList:Vector.<AvatarPlayer> = new Vector.<AvatarPlayer>();
        public function run() : void
        {
            var avatar : AvatarThumb;
            for(var i:int = 0; i < 200; i++)
            {
//                var id:int = Math.floor(Math.random() * numChildren);
//                while(dieList.indexOf(id) != -1)
//                {
//                    id = Math.floor(Math.random() * numChildren);
//                }
                
                avatar = getChildAt(i) as AvatarThumb;
                dieList.push(avatar);
            }
            
//            while(dieList.length > 30)
//            {
//                avatar = dieList.shift();
//                avatar.setAction(1);
//            }
        }
    }
}
