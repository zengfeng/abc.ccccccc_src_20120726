package com.utils
{
    import com.greensock.TweenLite;
    import com.greensock.easing.Linear;

    import flash.display.DisplayObject;
    import flash.filters.GlowFilter;

    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2011 2011-12-23 ����2:08:00
     */
    public class Glow
    {
        // public var glowFilter:GlowFilter = new GlowFilter(color, 1, maxBlur, maxBlur, maxStrength, 1, false, false);
        public var glowFilter : GlowFilter ;
        public var glowFilterDisplayList : Vector.<DisplayObject> = new Vector.<DisplayObject>();
        private var glowTween : TweenLite;
        private var color : uint = 0xEEff00;
        private var minBlur : int = 0;
        private var maxBlur : int = 10;
        private var minStrength : int = 0;
        private var maxStrength : int = 10;

        function Glow(color : uint = 0xEEff00, minBlur : Number = 2, maxBlur : Number = 14, minStrength : Number = 2, maxStrength : Number = 4) : void
        {
            this.color = color;
            this.minBlur = minBlur;
            this.maxBlur = maxBlur;
            this.minStrength = minStrength;
            this.maxStrength = maxStrength;
            glowFilter = new GlowFilter(color, 0.8, maxBlur, maxBlur, maxStrength, 2, false, false);
        }

        public function addDisplayObject(displayObject : DisplayObject) : void
        {
            var index : int = glowFilterDisplayList.indexOf(displayObject);
            if (index == -1) glowFilterDisplayList.push(displayObject);
            if (glowFilterDisplayList.length > 0)
            {
                play();
            }
        }

        public function removeDisplayObject(displayObject : DisplayObject) : void
        {
            var index : int = glowFilterDisplayList.indexOf(displayObject);
            if (index != -1)
            {
                glowFilterDisplayList.splice(index, 1);
                displayObjectRemoveThisFilter(displayObject);
            }
            if (glowFilterDisplayList.length <= 0)
            {
                pause();
            }
        }

        private function displayObjectRemoveThisFilter(displayObject : DisplayObject) : void
        {
            if (displayObject == null) return;
            var filterList : Array = [];
            for (var i : int = 0; i < displayObject.filters.length; i++)
            {
                if ((displayObject.filters[i] is GlowFilter) == false)
                {
                    filterList.push(displayObject.filters[i]);
                }
            }
            displayObject.filters = filterList;
        }

        private  function initGlowTween() : void
        {
            if (glowTween) return;
            glowTween = TweenLite.to(glowFilter, 0.5, {blurX:minBlur, blurY:minBlur, strength:minStrength, onUpdate:glowTween_onUpdate, onComplete:glowTween_onComplete, onReverseComplete:glowTween_onReverseComplete, ease:Linear.easeOut});
        }

        private  function glowTween_onUpdate() : void
        {
            var displayObject : DisplayObject;
            for (var i : int = 0; i < glowFilterDisplayList.length; i++)
            {
                displayObject = glowFilterDisplayList[i];
                var filterList : Array = new Array();
                for (var j : int = 0; j < displayObject.filters.length; j++)
                {
                    if (displayObject.filters[j] is GlowFilter == false)
                    {
                        filterList.push(displayObject.filters[j]);
                    }
                }
                filterList.push(glowFilter);
                displayObject.filters = filterList;
            }
        }

        private  function glowTween_onComplete() : void
        {
            glowTween.reverse();
        }

        private  function glowTween_onReverseComplete() : void
        {
            glowTween.restart();
        }

        public  function play() : void
        {
            initGlowTween();
            if (glowTween.paused) glowTween.play();
        }

        public function pause() : void
        {
            if (glowTween && glowTween.paused == false) glowTween.pause();
        }
    }
}
