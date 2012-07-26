package game.module.riding
{
	/**
	 * @author zhengyuhang
	 */
	public class MoveBarModel
	{
		private static const SUFFLE_STEPS : int = 7;
		// private static const FIRSTX_POSITION=30;
		// private static const RIDING_CELL_PADDING=60;
		private var _listModel : Array;
		private var _viewBegin : int = 0;
		private var _viewEnd : int = 0;
		private var _size : int = 0;

		public function MoveBarModel() : void
		{
		}

		public function set source(value : *) : void
		{
			if (value)
			{
				_listModel = value;
				_size = _listModel.length;
			}
		}

		public function moveRight() : void
		{
			if (_viewEnd + SUFFLE_STEPS >= _size)
			{
				moveMostRight();
			}

			updateView();
		}

		public function moveLeft() : void
		{
			if (_viewBegin - SUFFLE_STEPS <= 0)
			{
				moveMostLeft();
			}

			updateView();
		}

		private function moveMostRight() : void
		{
			_viewBegin = _size - SUFFLE_STEPS;
			_viewEnd = _size;
			updateView();
		}

		private function moveMostLeft() : void
		{
			_viewBegin = 0;
			_viewEnd = _viewBegin + SUFFLE_STEPS;
			updateView();
		}

		private function updateView() : void
		{
			var ridingItem : RidingItemCell;

			for (var i : int = 0;i < _listModel.length;i++)
			{
			}
		}
	}
}
