package com.utils
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

    public class FilterUtils
    {
        /** 
         * 默认文字描边 
         * color = 0x000000;
         * alpha = 0.8;
         * blurX = blurY = 2;
         * strength = 17;
         */
//        public static var defaultTextEdgeFilter : GlowFilter = new GlowFilter(0x000000, 0.8, 2, 2, 17, 1, false, false);
        public static var defaultTextEdgeFilter : GlowFilter = new GlowFilter(0x000000, 0.8, 3, 3, 1, 1, false, false);
        public static var iconTextEdgeFilter : GlowFilter = new GlowFilter(0x000000, 1, 3, 3, 4, 1, false, false);
		public static var gradientTextEdgeFilter : GlowFilter = new GlowFilter(0x000000, 1, 4, 4, 4, 1, false, false);
		public static var bossDamageTextFilter : GlowFilter = new GlowFilter(0x000000,1, 2, 2, 5, 1, false, false) ;
        /** 
         * 默认高亮 
         * color = 0xEEff00;
         * alpha = 0.8;
         * blurX = blurY = 6;
         * strength = 2;
         */
        public static var defaultHightLightFilter : GlowFilter = new GlowFilter(0xEEff00, 0.8, 6, 6, 2, 1, false, false);
        /** 
         * 默认发光
         * color = 0xEEff00;
         * alpha = 0.8;
         * blurX = blurY = 6;
         * strength = 2;
         */
        public static var defaultGlowFilter : GlowFilter = new GlowFilter(0xEEff00, 0.8, 6, 6, 2, 1, false, false);
        private static var icoGlowFiterAnimation : GlowFilter = new GlowFilter(0xEEff00, 0.8, 6, 6, 2, 1, false, false);
        /*
         * 选中效果
         */
        public static var selectFilter : GlowFilter = new GlowFilter(0x66ff66, 1, 8, 8, 3);
        private static var _disableFilter : ColorMatrixFilter;
		/*
		 * 文字Over效果
		 */
		public static var textOverFilter: GlowFilter = new GlowFilter(0xFF6600, 1, 2, 2, 2);

        public static function disableFilter() : ColorMatrixFilter
        {
			var color:ColorChange=new ColorChange();
			color.adjustColor(30, -30, -80,0);
            if (_disableFilter == null)
            {
                _disableFilter = new ColorMatrixFilter(color);
            }
            return _disableFilter;
        }

        private static var _dieFilter : ColorMatrixFilter;

        public static function get dieFilter() : ColorMatrixFilter
        {
            if (_dieFilter == null)
            {
                _dieFilter = new ColorMatrixFilter([-1, -1, -1, 0, 0, // R 
                0.3, 1, 0.5, 0.1, 0, // G 
                0.5, 0.8, 1, 0.2, 0, // B 
                0, 0, 0, 1, 0// A
                ]);
            }
            return _dieFilter;
        }

        public static function addFilter(displayObject : DisplayObject, filterObj:*, filterClass:Class) : void
        {
            if (displayObject == null) return;
            var filterList : Array = new Array();
            for (var j : int = 0; j < displayObject.filters.length; j++)
            {
                if (displayObject.filters[j] is filterClass == false)
                {
                    filterList.push(displayObject.filters[j]);
                }
            }
            filterList.push(filterObj);
            displayObject.filters = filterList;
        }

        public static function removeFilter(displayObject : DisplayObject, filterClass:Class) : void
        {
            if (displayObject == null) return;
            var filterList : Array = new Array();
            for (var j : int = 0; j < displayObject.filters.length; j++)
            {
                if (displayObject.filters[j] is filterClass == false)
                {
                    filterList.push(displayObject.filters[j]);
                }
            }
            displayObject.filters = filterList;
        }

        private static var _applyIcoGlowCount : uint = 0;
        private static var _applyIcoGlowDisplayObjects : Array = [];
        private static var _icoGlowSetInterval : uint;

        public static function addIcoGlow(displayObject : DisplayObject) : void
        {
            if (displayObject == null) return;

            if (_applyIcoGlowCount <= 0)
            {
                _icoGlowSetInterval = setInterval(icoGlowPlayingFun, 50);
            }

            if (_applyIcoGlowDisplayObjects.indexOf(displayObject) == -1)
            {
                _applyIcoGlowDisplayObjects.push(displayObject);
                _applyIcoGlowCount++;
            }
        }

        public static function removeIcoGlow(displayObject : DisplayObject) : void
        {
            if (displayObject == null) return;
            if (displayObject.filters.indexOf(icoGlowFiterAnimation) != -1)
            {
                if (displayObject.filters.length > 1)
                {
                    displayObject.filters.splice(displayObject.filters.indexOf(icoGlowFiterAnimation), 1);
                }
                else
                {
                    displayObject.filters = [];
                }
                _applyIcoGlowCount--;
            }

            if (_applyIcoGlowDisplayObjects.indexOf(displayObject) != -1)
            {
                _applyIcoGlowDisplayObjects.splice(_applyIcoGlowDisplayObjects.indexOf(displayObject), 1);
            }

            if (_applyIcoGlowCount <= 0)
            {
                clearInterval(_icoGlowSetInterval);
            }
        }

        private static var _icoGlowBlurGap : Number = 2;

        private static function icoGlowPlayingFun() : void
        {
            if (icoGlowFiterAnimation.blurX <= 0)
            {
                _icoGlowBlurGap = 5;
            }
            else if (icoGlowFiterAnimation.blurX >= 20)
            {
                _icoGlowBlurGap = -5;
            }
            icoGlowFiterAnimation.blurX = icoGlowFiterAnimation.blurY += _icoGlowBlurGap;
            for (var i : int = 0; i < _applyIcoGlowDisplayObjects.length; i++)
            {
                (_applyIcoGlowDisplayObjects[i] as DisplayObject).filters = [icoGlowFiterAnimation];
            }
        }

        public static var defaultGlow : Glow = new Glow();

        public static function addGlow(target : DisplayObject) : void
        {
            defaultGlow.addDisplayObject(target);
        }

        public static function removeGlow(target : DisplayObject) : void
        {
            defaultGlow.removeDisplayObject(target);
        }
		
		// =====================
		// 元神变色滤镜
		// =====================
		private static var _hueFilter:Dictionary = new Dictionary();
		
		public static function getHueFilter (hue:Number):ColorMatrixFilter
		{
			var filter:ColorMatrixFilter = _hueFilter[hue];

			if (filter == null)
			{
				filter = createHueFilter(hue);
				_hueFilter[hue] = filter;
			}
			
			return filter;
		}	
		
		public static function createHueFilter (hue:Number):ColorMatrixFilter
		{
			hue *= Math.PI / 180;
			var cos:Number = Math.cos(hue);
			var sin:Number = Math.sin(hue);
			var r:Number = 0.213;
			var g:Number = 0.715;
			var b:Number = 0.072;
			var trans:Array = [
				(r + (cos * (1 - r))) + (sin * (-r)), 
				(g + (cos * (-g))) + (sin * (-g)),
				(b + (cos * (-b))) + (sin * (1 - b)),
				0,
				0,
				(r + (cos * (-r))) + (sin * 0.143),
				(g + (cos * (1 - g))) + (sin * 0.14),
				(b + (cos * (-b))) + (sin * -0.283),
				0,
				0,
				(r + (cos * (-r))) + (sin * (-(1 - r))),
				(g + (cos * (-g))) + (sin * g),
				(b + (cos * (1 - b))) + (sin * b),
				0,
				0,
				0,
				0,
				0,
				1,
				0,
				0,
				0,
				0,
				0,
				1];
			return new ColorMatrixFilter(trans);		
		}
    }
}