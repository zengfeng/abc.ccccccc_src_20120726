package com.utils
{
    import flash.text.TextField;
    /**
     * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-2  ����4:48:57 
     * Label组件工具类，用来创建通用默认的Label组件
     */
    public class LabelUtils
    {
        /** 
         * 标题1
         */ 
        public static function createH1():TextField
        {
            var label:TextField = new TextField();
            label.defaultTextFormat = TextFormatUtils.h1;
            label.filters = [FilterUtils.defaultTextEdgeFilter];
            return label;
        }
        
        /** 
         * 标题2
         */ 
        public static function createH2():TextField
        {
            var label:TextField = new TextField();
			label.height = 20;
            label.defaultTextFormat = TextFormatUtils.h2;
            label.filters = [FilterUtils.defaultTextEdgeFilter];
            return label;
        }
        
        /** 
         * 标题3
         */ 
        public static function createH3():TextField
        {
            var label:TextField = new TextField();
            label.defaultTextFormat = TextFormatUtils.h3;
            label.filters = [FilterUtils.defaultTextEdgeFilter];
            return label;
        }
        
        /** 
         * 正文1
         */ 
        public static function createContent1():TextField
        {
             var label:TextField = new TextField();
            label.defaultTextFormat = TextFormatUtils.content;
            return label;
        }
        
        /** 
         * 正文2
         */ 
        public static function createContent2():TextField
        {
             var label:TextField = new TextField();
            label.defaultTextFormat = TextFormatUtils.content;
            label.filters = [FilterUtils.defaultTextEdgeFilter];
            return label;
        }
		
        /** 
         * 正文加粗
         */ 
        public static function createContentBold():TextField
        {
             var label:TextField = new TextField();
            label.defaultTextFormat = TextFormatUtils.contentBold;
            return label;
        }
        
        /** 
         * 提示1
         */ 
        public static function createPrompt1():TextField
        {
             var label:TextField = new TextField();
			label.height = 20;
            label.defaultTextFormat = TextFormatUtils.prompt1;
            label.filters = [FilterUtils.defaultTextEdgeFilter];
            return label;
        }
        
        /** 
         * 提示2
         */ 
        public static function createPrompt2():TextField
        {
             var label:TextField = new TextField();
            label.defaultTextFormat = TextFormatUtils.prompt2;
            return label;
        }
        
    }
}
