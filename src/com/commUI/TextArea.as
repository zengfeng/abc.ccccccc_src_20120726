package com.commUI
{
    import gameui.controls.GScrollBar;
    import gameui.core.GComponent;
    import gameui.core.GComponentData;
    import gameui.data.GScrollBarData;
    import gameui.events.GScrollBarEvent;
    import gameui.manager.UIManager;

    import flash.display.Graphics;
    import flash.events.Event;
    import flash.text.StyleSheet;
    import flash.text.TextField;
    import flash.text.TextFormat;

    /**
     *  @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-4-13
     */
    public class TextArea extends GComponent
    {
        public var COLOR : uint = 0x000000;
        public var TEXT_WIDTH : int = 315;
        public var TEXT_HEIGHT : int = 200;
        public var LINE_HEIGHT : int = 15;
        public var PAGE_SIZE : int = 315;
        public var MAX_LINE_COUNT : int = 100;
        public var SCROLLER_BAR_VISIBLE_AUTO : Boolean = true;
        public var tf : TextField;
        public var scrollBar : GScrollBar;

        public function TextArea(width : int, height : int, color : uint = 0x000000, scrollerBarVisibleAuto : Boolean = true, lineHeight : int = 15, maxLineCount : int = 100)
        {
            COLOR = color;
            _base = new GComponentData();
            _base.width = width;
            _base.height = height;
            TEXT_WIDTH = width - 12;
            TEXT_HEIGHT = height;
            LINE_HEIGHT = lineHeight;
            PAGE_SIZE = Math.floor(TEXT_HEIGHT / lineHeight);
            MAX_LINE_COUNT = maxLineCount;
            SCROLLER_BAR_VISIBLE_AUTO = scrollerBarVisibleAuto;
            super(_base);
            initViews();
            // testWH();
        }

        private function initViews() : void
        {
            var textFormat : TextFormat = new TextFormat();
            textFormat.color = COLOR;
            textFormat.letterSpacing = 0.5;
            textFormat.leading = 2;
            textFormat.font = UIManager.defaultFont;

            var style : StyleSheet = new StyleSheet();
            style.setStyle("a:link", {textDecoration:"none"});
            style.setStyle("a:hover", {textDecoration:"underline"});
            tf = new TextField();
            tf.wordWrap = true;
            tf.defaultTextFormat = textFormat;
            tf.styleSheet = style;
            tf.width = TEXT_WIDTH;
            tf.height = TEXT_HEIGHT;
            addChild(tf);

            // 滚动条
            var scrollBarData : GScrollBarData;
            scrollBarData = new GScrollBarData();
            scrollBarData.height = TEXT_HEIGHT;
            scrollBarData.x = _base.width - scrollBarData.width ;
            scrollBarData.y = 0;
            scrollBarData.wheelSpeed = 1;
            scrollBarData.movePre = 1;
            scrollBar = new GScrollBar(scrollBarData);
            scrollBar.resetValue(PAGE_SIZE, 1, 1, 1);
            if (SCROLLER_BAR_VISIBLE_AUTO == true) scrollBar.visible = false;
            addChild(scrollBar);

            scrollBar.addEventListener(GScrollBarEvent.SCROLL, scrollBartfOnScroll);
            tf.addEventListener(Event.SCROLL, tfOnScroll);
        }

        /** 文件滚动事件 */
        private function tfOnScroll(event : Event = null) : void
        {
            scrollBar.removeEventListener(GScrollBarEvent.SCROLL, scrollBartfOnScroll);
            tf.removeEventListener(Event.SCROLL, tfOnScroll);

            var min : Number = 1;
            var max : Number = textScrollMax - PAGE_SIZE;
            max = max <= 1 ? 1 : max;
            var value : Number = tf.scrollV;
            scrollBar.resetValue(PAGE_SIZE, min, max, value);
            tf.addEventListener(Event.SCROLL, tfOnScroll);
            scrollBar.addEventListener(GScrollBarEvent.SCROLL, scrollBartfOnScroll);
            scrollInfo();
        }

        /** 滚动条滚动事件 */
        private function scrollBartfOnScroll(event : GScrollBarEvent) : void
        {
            var value : int = event.position;
            if (value <= 1)
            {
                value = 1;
            }

            tf.scrollV = value;
            scrollInfo();
        }

        public function scrollToMax() : void
        {
            tf.scrollV = textScrollMax;
        }

        public function get textScrollMax() : int
        {
            return tf.numLines;
        }

        public function isSetScrollToMax() : Boolean
        {
            return tf.numLines - tf.scrollV <= PAGE_SIZE;
        }

        protected const LINE_SEP : String = "\n";
        protected var msgList : Vector.<String> = new Vector.<String>();
        protected var lineCount : int = 0;
        protected var htmlText : String = "";

        /** 添加消息 */
        public function removeLastLine(lineNum : int = 1) : void
        {
            for (var i : int = 0; i < lineNum; i++)
            {
                var firstLineEndIndex : int = htmlText.lastIndexOf(LINE_SEP);
                htmlText = htmlText.substring(0, firstLineEndIndex);
                lineCount--;
            }

            if (SCROLLER_BAR_VISIBLE_AUTO == true)
            {
                if (textScrollMax >= PAGE_SIZE)
                {
                    scrollBar.visible = true;
                }
                else
                {
                    scrollBar.visible = false;
                }
            }

            if (isSetScrollToMax == true)
            {
                scrollToMax();
            }
        }

        /** 添加消息 */
        public function appendMsg(str : String) : void
        {
            var arr:Array = str.split(LINE_SEP);
            var isSetScrollToMax : Boolean = this.isSetScrollToMax();
            htmlText += LINE_SEP + str;
            tf.htmlText = htmlText;
            lineCount+= arr.length;
            if (lineCount > MAX_LINE_COUNT)
            {
                var firstLineEndIndex : int = htmlText.indexOf(LINE_SEP);
                firstLineEndIndex += LINE_SEP.length;
                htmlText = htmlText.substring(firstLineEndIndex, htmlText.length);
                lineCount--;
            }

            if (SCROLLER_BAR_VISIBLE_AUTO == true)
            {
                if (textScrollMax >= PAGE_SIZE)
                {
                    scrollBar.visible = true;
                }
                else
                {
                    scrollBar.visible = false;
                }
            }

            if (isSetScrollToMax == true)
            {
                scrollToMax();
            }
        }

        /** 清空消息 */
        public function clearMsgs() : void
        {
            htmlText = "";
            tf.htmlText = htmlText;
            lineCount = 0;
            if (SCROLLER_BAR_VISIBLE_AUTO == true)
            {
                scrollBar.visible = false;
            }
            tf.scrollV = 1;
            tfOnScroll();
        }

        public function testWH() : void
        {
            var g : Graphics = this.graphics;
            g.beginFill(0xFF0000, 0.1);
            g.drawRect(0, 0, _base.width, _base.height);
            g.endFill();
        }

        private function scrollInfo() : void
        {
        }
    }
}
