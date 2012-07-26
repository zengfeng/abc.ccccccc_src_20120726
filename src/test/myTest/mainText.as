package test.myTest
{
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.display.Loader;
    /**
     * @author Lv
     */
        public final class mainText
 
        {
 
                private static var fileMaps:Object={};//存储载入文件的LOADER
 
                private static var libCallFunc:Function;//同步传输的回调方法
 
                //载入外部SWF资源，存储在fileMaps对象内
 
                public static function load(fileName:String,onLoadedFunc:Function=null):void{
 
                        mainText.libCallFunc=onLoadedFunc;
 
                        var libFile:Loader=mainText.fileMaps[fileName] as Loader;
 
                        if(libFile==null){
 
                                mainText.fileMaps[fileName]=new Loader();
 
                                libFile=mainText.fileMaps[fileName] as Loader;
 
                        }else if (libFile.contentLoaderInfo.bytesLoaded==libFile.contentLoaderInfo.bytesTotal){
 
                                return;//如果已经文件已经载入完成，跳出此方法
 
                        }
 
                        libFile.load(new URLRequest(fileName));
 
                        libFile.contentLoaderInfo.addEventListener(Event.COMPLETE,mainText.callFunc);
 
                }
 
                //获取外部SWF资源的链接类
 
                public static function getObj(fileName:String,objName:String):DisplayObject{
 
                        var libFile:Loader=mainText.fileMaps[fileName] as Loader;
 
                        if (libFile==null){
 
                                //trace("文件【"+fileName+"】不存在,请检查文件名");
 
                                return null;
 
                        }
 
                        if (!libFile.contentLoaderInfo.applicationDomain.hasDefinition(objName)){
 
                                //trace("文件【"+fileName+"】内没有名字为【"+objName+"】的链接类，请检查链接类的名字");
 
                                return null;
 
                        }
 
                        var objClass:Class=libFile.contentLoaderInfo.applicationDomain.getDefinition(objName) as Class;
 
                        return new objClass() as DisplayObject;
 
                }
 
                
                //执行回调方法
 
                private static function callFunc(evt:Event):void{
 
                        if (mainText.libCallFunc==null){
 
                                return;
 
                        }
 
                        mainText.libCallFunc.apply(null);
 
                        mainText.libCallFunc=null;
 
                }
 
        }
}
