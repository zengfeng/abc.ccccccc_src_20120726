package game.module.monsterPot
{
	import gameui.core.GComponent;
	import gameui.core.GComponentData;

	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipManager;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class CountryButton extends GComponent
	{
		private var _text : TextField = new TextField();
		private var _btn : MovieClip = null;
		public var countryId : uint;
		public var openLevel : uint;
		public var monsterIds : Vector.<uint>=new Vector.<uint>();
		/**存储的是未-1的实际位置
		 * 等待处理的怪物
		 * */
		public var nextMonsterId : uint = 1;
		/**
		 * 正在处理的怪物，在一次登录中记录使用
		 * */
		public var selectMonsterId : uint = 0;
		/**
		 * 当前已经处理到的怪物起始位置
		 * */
		public var currentProgressPos : uint = 0;
		public var corpseId : uint = 0;
		public var opendPos : uint = 0;
		public var explain : String = "";
		public var stuffItems : Vector.<uint>=null;
		private var _selected : Boolean = false;
		/**剩余重置次数*/
		public var resetCount : uint = 0;
		public var maxResetCount : uint = 0;
		public var clickFun : Function = null;
		public var clickFunParam : Array = [];

		// ===============================================================
		// Setter/Getter
		// ===============================================================
		public function set vo(value : MonsterCountryVO) : void
		{
			_source = value;
		}

		public function get vo() : MonsterCountryVO
		{
			return _source;
		}

		public function get selected() : Boolean
		{
			return _selected;
		}

		public function set selected(value : Boolean) : void
		{
			_selected = value;
			if (_selected == false)
			{
				_btn.gotoAndStop(1);
			}
			else
			{
				_btn.gotoAndStop(4);
			}
		}

		public function get btn() : MovieClip
		{
			return _btn;
		}

		public function set btn(value : MovieClip) : void
		{
			if (_btn)
				removeChild(_btn);

			_btn = value;
			this.addChildAt(_btn, 0);
			_btn.mouseChildren = false;
			layout();
		}

		public function set text(value : String) : void
		{
			_text.htmlText = value;

			layout();
		}

		// ===============================================================
		// 方法
		// ===============================================================
		public function CountryButton()
		{
			var data : GComponentData = new GComponentData();
			data.width = 60;
			super(data);
		}

		override protected function create() : void
		{
			super.create();

			_text = new TextField();
			_text.autoSize = TextFieldAutoSize.CENTER;
			_text.selectable = false;
			_text.mouseEnabled = false;

			var tf : TextFormat = new TextFormat();
			tf.size = 14;
			tf.bold = true;
			tf.color = 0xffff99;
			_text.defaultTextFormat = tf;
			var gf : GlowFilter = new GlowFilter(0x000000, 0.8);
			_text.filters = [gf];

			addChild(_text);
		}

		// ------------------------------------------------
		// 更新
		// ------------------------------------------------
		override protected function layout() : void
		{
			if (_btn != null)
			{
				_text.x = (_btn.width - _text.width) / 2;
				_text.y = (_btn.height - _text.height);
				_btn.mouseChildren = false;
			}
		}

		// ------------------------------------------------
		// 交互
		// ------------------------------------------------
		override protected function onShow() : void
		{
			addEventListener(MouseEvent.CLICK, mouseResponse);
			addEventListener(MouseEvent.MOUSE_OVER, mouseResponse);
			addEventListener(MouseEvent.MOUSE_OUT, mouseResponse);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseResponse);
			addEventListener(MouseEvent.MOUSE_UP, mouseResponse);
			ToolTipManager.instance.registerToolTip(this, ToolTip, getToolTipString);
		}

		override protected function onHide() : void
		{
			ToolTipManager.instance.destroyToolTip(this);
			removeEventListener(MouseEvent.CLICK, mouseResponse);
			removeEventListener(MouseEvent.MOUSE_OVER, mouseResponse);
			removeEventListener(MouseEvent.MOUSE_OUT, mouseResponse);
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseResponse);
			removeEventListener(MouseEvent.MOUSE_UP, mouseResponse);
		}

		private function mouseResponse(e : Event) : void
		{
			switch (e.type)
			{
				case MouseEvent.CLICK:
					clickFun.apply(null, clickFunParam);
					break;
				case MouseEvent.MOUSE_OVER:
					_btn.gotoAndPlay(2);
					break;
				case MouseEvent.MOUSE_OUT:
					_btn.gotoAndPlay(1);
					if (_selected == true)
					{
						_btn.gotoAndPlay(4);
					}
					break;
				case MouseEvent.MOUSE_DOWN:
					_btn.gotoAndPlay(3);
					break;
				case MouseEvent.MOUSE_UP:
					_btn.gotoAndPlay(2);
					break;
			}
		}
		
		// ------------------------------------------------
		// 其它
		// ------------------------------------------------
		private function getToolTipString():String
		{
			return vo.description;
		}
	}
}
