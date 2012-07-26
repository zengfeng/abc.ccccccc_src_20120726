package com.commUI.pager
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import gameui.cell.LabelSource;

	/**
	 * @author jian
	 */
	public class PagerModel extends EventDispatcher
	{
		// =====================
		// @属性
		// =====================
		// 总的显示格子数
		private var _size : int;
		// 从1到当前的格子数（不包含当前格子）
		private var _left : int;
		// 从当前格子到最大值的格子数（不包含当前格子）
		private var _right : int;
		// 最大页数
		private var _total : int;
		// 当前页数
		private var _pos : int;
		// 格子数组
		private var _labels : Array /* of LabelSource */;
		// 是否抛出事件
		private var _throwEvent:Boolean = false;
		// 总是显示最左边一个
		private var _showHead : Boolean = false;
		// 总是显示最右边一个
		private var _showTail : Boolean = true;

		// =====================
		// @方法
		// =====================
		public function PagerModel(size : int)
		{
			_size = size;
		}

		public function get size() : int
		{
			return _size;
		}
		
		public function set throwEvent(value:Boolean):void
		{
			_throwEvent = value;
		}

		public function set page(value : int) : void
		{
			_pos = value;
			if (_throwEvent)
			{
				var event:Event = new Event(Event.CHANGE);
				dispatchEvent(event);
			}
		}
		
		public function get page():int
		{
			return _pos;
		}

		public function set total(value : int) : void
		{
			_total = value;
		}

		public function get labels() : Array /* of LabelSource */
		{
			updateLabels();
			return _labels;
		}
		
		public function get first():int
		{
			return 1;
		}

		public function get previous() : int
		{
			return (_pos > 1) ? (_pos - 1) : 1;
		}

		public function get next() : int
		{
			return (_pos < _total) ? (_pos + 1) : _total;
		}

		public function get hitLeft() : Boolean
		{
			return _pos == 1;
		}

		public function get hitRight() : Boolean
		{
			return _pos == _total;
		}
		
		public function get moreLeft() : Boolean
		{
			return (_pos - 1) > _left;
		}

		public function get moreRight() : Boolean
		{
			return (_total - _pos) > _right;
		}

		// =====================
		// @属性
		// =====================
		public function updateModel() : void
		{


			var size:int = (_total<_size)?_total:_size;
			var halfRight : int = size / 2;
			var halfLeft : int = size - halfRight;			
			
			
			if (_pos < halfLeft)
			{
				_left = _pos-1;
				_right = size - 1 - _left;
			}
			else if (_pos > _total - halfRight)
			{
				_right = (_total - _pos);
				_left = size - 1 - _right;
			}
			else
			{
				_left = halfLeft-1;
				_right = size - 1 - _left;
			}
			
			if (_left <0) _left = 0;
		}

		private function updateLabels() : void
		{
			var nPage : int;
			_labels = [];

			if (_left > 0)
			{
				// 第一页
				if (_showHead)
					addLabel((moreLeft ? "..." : "") + 1, 1);

				// 左边剩余页
				var head:int = _pos - _left + (_showHead?1:0);
				for (nPage = head;nPage < _pos;nPage++)
				{
					addLabel(nPage.toString(), nPage);
				}
			}

			// 当前页
			addLabel(_pos.toString(), _pos);

			if (_right > 0)
			{
				// 右边剩余页
				var tail:int = _pos + _right + (_showTail?0:1);
				for (nPage = _pos + 1;nPage < tail;nPage++)
				{
					addLabel(nPage.toString(), nPage);
				}

				// 最后一页
				if (_showTail)
					addLabel((moreRight ? "..." : "") + _total, _total);
			}
			
			if (_labels.length > _size)
			{
				throw (Error("页数越界！" + _labels.length + " > " + _size));
			}
		}



		private function addLabel(text : String, page : int) : void
		{
			_labels.push(new LabelSource(text, page));
		}
	}
}
