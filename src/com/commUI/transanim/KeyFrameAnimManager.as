package com.commUI.transanim {
	import flash.utils.Dictionary;
	/**
	 * @author zhangzheng
	 */
	public class KeyFrameAnimManager {
		
		private static var _instance:KeyFrameAnimManager ;
		
		private var _animDic:Dictionary = new Dictionary();
		
		public function KeyFrameAnimManager( single:Singleton )
		{
			single ;
		}
		
		public static function get instance():KeyFrameAnimManager
		{
			if( _instance == null )
			{
				_instance = new KeyFrameAnimManager( new Singleton() );
			}
			return _instance ;
		}
		
		public function addAnimation( id:int , anim:Vector.<TransKeyFrame> ):void
		{
			pretreat( anim );
			if( !_animDic.hasOwnProperty(id) )
			{
				_animDic[id] = anim ;
			}
		}

		private function pretreat(anim : Vector.<TransKeyFrame>) : void {
			
			if( anim.length > 1 )
			{
				for( var i:int = 0 ; i < anim.length - 1 ; ++ i )
				{
					var dFrame:Number = anim[i+1].keyframe - anim[i].keyframe ;
					if( anim[i+1].x != anim[i].x )
					{
						anim[i].dX = ( anim[i+1].x - anim[i].x )/dFrame;
					}
					if( anim[i+1].y != anim[i].y )
					{
						anim[i].dY = ( anim[i+1].y - anim[i].y )/dFrame ;
					}
					if( anim[i+1].scaleX != anim[i].scaleX )
					{
						anim[i].dScaleX = ( anim[i+1].scaleX - anim[i].scaleX )/dFrame ;
					}
					if( anim[i+1].scaleY != anim[i].scaleY )
					{
						anim[i].dScaleY = ( anim[i+1].scaleY - anim[i].scaleY )/dFrame ;
					}
					if( anim[i+1].alpha != anim[i].alpha )
					{
						anim[i].dAlpha = ( anim[i+1].alpha - anim[i].alpha )/dFrame ;
					}
				}
			}
		}
		
		public function removeAnimation( id:int ):void
		{
			if( _animDic.hasOwnProperty(id) )
				delete _animDic[id];
		}
		
		public function getAnimation( id:int ):Vector.<TransKeyFrame>
		{
			if( _animDic.hasOwnProperty(id) )
				return _animDic[id] as Vector.<TransKeyFrame> ;
			return null ;
		}
	}
}

class Singleton{
	
}