package com.commUI.transanim {
	import flash.events.Event;
	import flash.display.DisplayObject;
	import gameui.core.GComponent;
	import gameui.core.GComponentData;

	/**
	 * @author zhangzheng
	 */
	public class KeyFrameAnimation extends GComponent {
		
		private var _play:Boolean = false  ;
		
		private var _binds:Vector.<AnimBindInfo> = new Vector.<AnimBindInfo>();
		
		private var _reverse:Boolean = false ;
		
		public function KeyFrameAnimation(base : GComponentData) {
			super(base);
		}
		
		public function bindAnimation( object:DisplayObject, id:int ):Boolean
		{
			if( !_play && contains(object))
			{
				var info:AnimBindInfo = findBind(object);
				if( info == null )
				{
					info = new AnimBindInfo() ;
					info.id = id ;
					info.object = object ;
					_binds.push(info);
				}
				else 
				{
					info.id = id ;
					info.keyframe = 0;
					info.frame = 0 ;
				}
				return true ;
			}
			return false ;
		}
		
		public function unbindAnimation( object:DisplayObject ):Boolean
		{
			var i:int = -1 ;
			if( !_play )
			{
				i = findBindIndex(object) ;
				if( i != -1 )
					_binds.splice(i, 1);
				return true ;
			}
			return false ;
		}
		
		public function unbindAnimationAll():void
		{
			_binds = new Vector.<AnimBindInfo>() ;
			_play = false ;
			
		}
		
		public function playAnimation( begin:int = -1 , loop:Boolean = false , reverse:Boolean = false ):void
		{
			for each( var bind:AnimBindInfo in _binds )
			{
				bind.play = true ;
				bind.loop = loop ;
				if( begin != -1 )
				{
					bind.frame = begin ;
					bind.keyframe = getKeyFrameIndex( bind.id , begin );
				}
			}
			_reverse = reverse ;
			addEventListener(Event.ENTER_FRAME, onAnimFrame);
		}
		
		public function stopAnimation():void
		{
			for each( var bind:AnimBindInfo in _binds )
			{
				bind.play = false ;
			}
		}
		
		public function applyAnimationFrame( frame:int ):void
		{
			for each( var bind:AnimBindInfo in _binds )
			{
				var frameList:Vector.<TransKeyFrame> = KeyFrameAnimManager.instance.getAnimation(bind.id);
				if( frameList == null || frameList.length == 0 )
					continue ;
				var current:TransKeyFrame ;
				var next:TransKeyFrame ;
				if( frame == -1 || frame > frameList[frameList.length - 1].keyframe)
				{
					bind.frame = frameList[frameList.length - 1].keyframe;
					bind.keyframe = frameList.length - 1;
					current = frameList[bind.keyframe];
					next = null ;
				}
				else 
				{
					bind.frame = frame ;
					bind.keyframe = getKeyFrameIndex(bind.id, frame) ;
					current = frameList[bind.keyframe];
					next = (bind.keyframe + 1 == frameList.length) ? null : frameList[bind.keyframe + 1 ];
				}
				applyFrame(current,next,bind);
			}
		}
		
		protected function findBind( object:DisplayObject ):AnimBindInfo
		{
			for each ( var info:AnimBindInfo in _binds )
			{
				if( info.object == object )
				{
					return info ;
				}
			}
			return null ;
		}
		
		protected function findBindIndex( object:DisplayObject ):int
		{
			for( var i:int = 0 ; i < _binds.length ; ++ i )
			{
				if( _binds[i].object == object )
					return i ;
			}
			return -1 ;
		}
		
		protected function onAnimFrame( evt:Event ):void
		{
			var stop:Boolean = true ;
			for each( var bind:AnimBindInfo in _binds )
			{
				if( !bind.play )
					continue ;
				var frameList:Vector.<TransKeyFrame> = KeyFrameAnimManager.instance.getAnimation(bind.id);
				if( frameList != null )
				{
					var curframe:TransKeyFrame = frameList[bind.keyframe] ;
					var nextframe:TransKeyFrame = null;
					if( bind.frame == curframe.keyframe )
					{
						nextframe = ( bind.keyframe + 1 < frameList.length ) ? frameList[ bind.keyframe + 1 ] : null ;
					}
					else
					{
						nextframe = frameList[bind.keyframe + 1] ;
					}
					
					applyFrame(curframe, nextframe, bind);
					
					if( !_reverse )
					{
						if( nextframe == null )
						{
							bind.frame = 0 ;
							bind.keyframe = 0 ;
							if( !bind.loop )
								bind.play = false ;
						}
						else 
						{
							++ bind.frame ;
							stop = false ;
							if( bind.frame == nextframe.keyframe )
								++ bind.keyframe ;
						}						
					}
					else
					{
						if( bind.frame == 0 )
						{
							if( !bind.loop )
							{
								bind.frame = frameList[frameList.length - 1].keyframe ;
								bind.keyframe = frameList.length - 1 ;
							}
							else 
							{
								bind.frame = 0 ;
								bind.keyframe = 0 ;
								bind.play = false ;
							}
						}
						else
						{
							-- bind.frame ;
							stop = false ;
							if( bind.frame < curframe.keyframe )
								-- bind.keyframe ;
						}
					}
					
				}
			}
			if( stop )
			{
				var stopevt:Event = new Event( KeyFrameAnimEvent.Animation_Finish );
				dispatchEvent(stopevt);
				removeEventListener(Event.ENTER_FRAME, onAnimFrame);
			}
		}
		
		protected function applyFrame( current:TransKeyFrame , next:TransKeyFrame , bind:AnimBindInfo ):void
		{
			if( bind.frame == current.keyframe || next == null )
			{
				bind.object.x = current.x ;
				bind.object.y = current.y ;
				bind.object.scaleX = current.scaleX ;
				bind.object.scaleY = current.scaleY ;
				bind.object.alpha = current.alpha ;
				bind.object.visible = current.visible ;
			}
			else
			{
				var dFrame:int = bind.frame - current.keyframe ;
				if( current.dX != 0 ) bind.object.x = current.x + current.dX * dFrame ;
				if( current.dY != 0 ) bind.object.y = current.y + current.dY * dFrame ;
				if( current.dScaleX != 0 ) bind.object.scaleX = current.scaleX + current.dScaleX * dFrame ;
				if( current.dScaleY != 0 ) bind.object.scaleY = current.scaleY + current.dScaleY * dFrame ;
				if( current.dAlpha != 0 ) bind.object.alpha = current.alpha + current.dAlpha * dFrame ;
				bind.object.visible = current.visible ;
			}
		}
		
		
		protected function getKeyFrameIndex( id:int , frame:int ):int
		{
			var frameList:Vector.<TransKeyFrame> = KeyFrameAnimManager.instance.getAnimation(id);
			if( frameList != null )
			{
				for( var i:int = 0 ; i < frameList.length ; ++ i )
				{
					if( frameList[i].keyframe > frame )
						return i == 0 ? 0 : i - 1 ;
					else if( frameList[i].keyframe == frame && i == frameList.length - 1 )
						return i ;
				}
			}
			return 0 ;
		}
	}
}

import flash.display.DisplayObject;
class AnimBindInfo{
	internal var object:DisplayObject ;
	internal var id:int ;
	internal var frame:int ;
	internal var keyframe:int ;
	internal var loop:Boolean ;
	internal var play:Boolean ;
}
