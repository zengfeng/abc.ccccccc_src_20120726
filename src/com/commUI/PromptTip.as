package com.commUI
{
	import gameui.core.GComponent;
	import gameui.core.GComponentData;
	import gameui.manager.UIManager;

	import net.AssetData;

	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	
	/**
	 * @author ZengFeng[zengfeng75(At)163.com]  2011 2011-11-16  ����3:38:27 
	 * 冒泡提示Tip
	 */
	public class PromptTip extends GComponent
	{
		/** 背景 */
		protected var _bg:Sprite = UIManager.getUI(new AssetData("Bg_PromptTip"));
		protected var _textField:TextField = new TextField();
		protected var _postion:Point;
		public function PromptTip(postion:Point = null, content:String = "大家好", width:uint = 200, height:uint = 40)
		{
			_base = new GComponentData();
			_base.width = width;
			_base.height = height;
			_base.parent = UIManager.root;
			super(_base);
			_bg.width = width;
			_bg.height = height;
			addChild(_bg);
			_textField.x = 5;
			_textField.y = 3;
			_textField.width = width - _textField.x * 2;
			_textField.height = height - _textField.y * 2;
			_textField.text = content;
			_textField.textColor = 0xFFFFFF;
			addChild(_textField);
			if(postion == null) postion = new Point(200, 200);
			if(postion)
			{
				this.x = postion.x - 10;
				this.y = postion.y + height;
			}
			show();
		}
		
		public function showTip(postion:Point = null, content:String = "大家好", width:uint = 200, height:uint = 30):void
		{
			if(postion)
			{
				this.x = postion.x - 10;
				this.y = postion.y + height;
			}
			_textField.text = content;
			_textField.x = 5;
			_textField.y = 3;
			_textField.width = width - _textField.x * 2;
			_textField.height = height - _textField.y * 2;
			this.show();
			
			
		}
		
		public static function showTip(postion:Point = null, content:String = "大家好", width:uint = 200, height:uint = 40):PromptTip
		{
			var tip : PromptTip = new PromptTip(postion,content, width, height);
			return tip;
		}
			
		
	}
}