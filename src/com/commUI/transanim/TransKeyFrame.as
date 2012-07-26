package com.commUI.transanim {
	/**
	 * @author zhangzheng
	 */
	public class TransKeyFrame {
		
		public var keyframe:int = 0 ;
		public var visible:Boolean = true ;
		
		public var x:Number = 0 ;
		public var y:Number = 0 ;
		public var scaleX:Number = 1 ;
		public var scaleY:Number = 1 ;
		public var alpha:Number = 1 ;
		
		public var dX:Number = 0 ;
		public var dY:Number = 0 ;
		public var dScaleX:Number = 0 ;
		public var dScaleY:Number = 0 ;
		public var dAlpha:Number = 0 ;
		
		public function parse( xml:XML ):void
		{
			keyframe = xml.@seq ;
			visible = xml.@visible ;
			x = xml.@x ;
			y = xml.@y ;
			scaleX = xml.@scaleX == undefined ? 1 : xml.@scaleX ;
			scaleY = xml.@scaleY == undefined ? 1 : xml.@scaleY ;
			alpha = xml.@alpha == undefined ? 1 : xml.@alpha ;
		}
	}
}
