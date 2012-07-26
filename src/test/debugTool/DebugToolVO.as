package test.debugTool
{
	import flash.display.DisplayObject;
	import gameui.manager.UIManager;
	import flash.display.DisplayObjectContainer;
	/**
	 * @author 1
	 */
	public class DebugToolVO
	{
	    public var objectName:String;                    
		public var objectClass:String;
		public var objectContainer:DisplayObjectContainer;
		public var displayObject:DisplayObject;
		public var depth:int=1;
		public var isContainer:Boolean;
	}
}
