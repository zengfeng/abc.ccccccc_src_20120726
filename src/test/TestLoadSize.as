package test
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import game.manager.VersionManager;
	import net.LibData;
	import net.RESLoader;
	import net.SWFLoader;

	/**
	 * @author jian
	 */
	public class TestLoadSize extends Sprite
	{
		private var _urlLoader:RESLoader;
		private var _swfLoader:SWFLoader;
		private var _list1:Vector.<item>=new Vector.<item>();
		private var _list2:Vector.<item>=new Vector.<item>();
		public function TestLoadSize()
		{
			_urlLoader=new RESLoader(new LibData(VersionManager.instance.getUrl("assets/swf/ui.swf"), "ui"));
			_swfLoader=new SWFLoader(new LibData(VersionManager.instance.getUrl("assets/swf/ui.swf"), "ui"));
//			_urlLoader.load();
//			_swfLoader.load();
			var vo:item=new item();
			vo.id=10;
			vo.name="asfdasdfasf";
			_list1.push(vo);
			_list2.push(vo);
			this.stage.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(event:MouseEvent) : void
		{
			_list1[0].id++;
			//trace("list1[0]===>"+_list1[0].name,"list2[0]===>"+_list2[0].id);
		}
		
	}
}
class item{
	public var name:String="";
	public var id:int=0;
}
