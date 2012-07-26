package worlds.auxiliarys
{
	import flash.utils.getTimer;
	import worlds.roles.cores.Player;

	import flash.utils.Dictionary;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-20
	// ============================
	public class PlayerGrid
	{
		private var _width : Number;
		private var _height : Number;
		private var _gridSize : Number;
		private var _numCells : int;
		private var _numCols : int;
		private var _numRows : int;
		private var _maxShow : int;
		private var _countShow : int;
		private var _grid : Dictionary = new Dictionary();
		private var _gridShowed : Dictionary = new Dictionary();
		private var _showedPlayerList:Vector.<Player> = new Vector.<Player>();
		private var _self : Player;
		private var _selfGridX : int = 0;
		private var _selfGridY : int = 0;

		function PlayerGrid() : void
		{
		}

		public function clearup() : void
		{
			var cell : Vector.<Player>;
			var keyArr_1 : Array = [];
			var keyArr_2 : Array;

			var rowDic : Dictionary;
			var rowDicShowed : Dictionary;
			var key1 : *;
			var key2 : *;
			for (key1 in _grid)
			{
				keyArr_1.push(key1);
				rowDic = _grid[key1];
				rowDicShowed = _grid[key1];
				keyArr_2 = [];
				for (key2 in rowDic)
				{
					keyArr_1.push(key2);
					cell = rowDic[key2];
					while (cell.length > 0)
					{
						cell.shift();
					}

					cell = rowDicShowed[key2];
					while (cell.length > 0)
					{
						cell.shift();
					}
				}

				while (keyArr_2.length > 0)
				{
					delete rowDic[keyArr_2.shift()];
					delete rowDicShowed[keyArr_2.shift()];
				}
			}

			while (keyArr_1.length > 0)
			{
				delete _grid[keyArr_1.shift()];
				delete _gridShowed[keyArr_1.shift()];
			}
			
			while(_showedPlayerList.length > 0)
			{
				_showedPlayerList.shift();
			}
		}

		public function reset(width : int, height : int, gridSize : int, maxShow : int = 100) : void
		{
			clearup();
			_width = width;
			_height = height;
			_gridSize = gridSize;
			_numCols = Math.ceil(_width / _gridSize);
			_numRows = Math.ceil(_height / _gridSize);
			_numCells = _numCols * _numRows;
			_maxShow = maxShow;
			_countShow = 0;
			makeGrid();
		}

		private function makeGrid() : void
		{
			var cell : Vector.<Player>;
			var gridX : int ;
			var gridY : int;
			var gridRow : Dictionary;
			var gridRowShowed : Dictionary;
			for (gridY = 0; gridY < _numRows; gridY++)
			{
				gridRow = _grid[gridY] = new Dictionary();
				gridRowShowed = _gridShowed[gridY] = new Dictionary();
				for (gridX = 0; gridX < _numCols; gridX++)
				{
					cell = new Vector.<Player>();
					gridRow[gridX] = cell;
					cell = new Vector.<Player>();
					gridRowShowed[gridX] = cell;
				}
			}
		}

		// ==============
		// self
		// ==============
		public function setSelf(player : Player) : void
		{
			selfMoveNum = 20;
			_self = player;
			playerSetGridXY(_self);
			_selfGridX = _self.gridX;
			_selfGridY = _self.gridY;
			_self.preGridX = _selfGridX;
			_self.preGridY = _selfGridY;
			_self.sWalkStart.add(selfMoveStart);
			_self.sWalkEnd.add(selfMoveEnd);
			_self.sPosition.add(selfMove);
//			_self.sTransportTo.add(selfTransportTo);
			updatePlayerCellText(_self);
		}

		private function selfMoveStart() : void
		{
		}

		private function selfMoveEnd() : void
		{
		}

		private function selfTransportTo() : void
		{
			if (oneCell(_self.preGridX, _self.preGridY, _self.gridX, _self.gridY)) return;
			var i:int = 0;
			var length:int = _showedPlayerList.length;
			var index:int = 0;
			var player:Player;
			while(i < length)
			{
				player = _showedPlayerList[index];
				if(!inKen(player))
				{
					playerHide(player);
				}
				else
				{
					index ++;
				}
				i++;
			}
		}
		
		private var selfMoveNum:int = 20;
		private function selfMove(x : int, y : int) : void
		{
			selfMoveNum++;
			if(selfMoveNum < 20)
			{
				return;
			}
			var time:Number = getTimer();
			selfMoveNum = 0;
			var preGridX : int = _self.gridX;
			var preGridY : int = _self.gridY;
			playerSetGridXY(_self);
			updatePlayerCellText(_self);
			_selfGridX = _self.gridX;
			_selfGridY = _self.gridY;
			var gridX : int = _selfGridX;
			var gridY : int = _selfGridY;
			var cell : Vector.<Player>;
			if (!oneCell(preGridX, preGridY, gridX, gridY))
			{
				_self.preGridX = preGridX;
				_self.preGridY = preGridY;
				if(Math.abs(preGridX -gridX) > 2 || Math.abs(preGridY -gridY) > 2) selfTransportTo();
				// 如果向左走 -----------------------------------
				if (_selfGridX - preGridX < 0)
				{
					// 隐藏右边
					gridX = _selfGridX + 2;
					if (gridX < _numCols)
					{
						gridY = _selfGridY;
						cell = getCellShowed(gridX, gridY);
						cellShowedHideAll(cell);

						// 右上
						gridY = _selfGridY - 1;
						if (gridY >= 0)
						{
							cell = getCellShowed(gridX, gridY);
							cellShowedHideAll(cell);
						}
						// 右下
						gridY = _selfGridY + 1;
						if (gridY < _numRows)
						{
							cell = getCellShowed(gridX, gridY);
							cellShowedHideAll(cell);
						}
					}

					// 显示左边
					if (!isFull)
					{
						gridX = _selfGridX - 1;
						if (gridX >= 0)
						{
							gridY = _selfGridY;
							cell = getCell(gridX, gridY);
							cellShow(cell);

							// 左上
							if (!isFull)
							{
								gridY = _selfGridY - 1;
								if (gridY >= 0)
								{
									cell = getCell(gridX, gridY);
									cellShow(cell);
								}
							}
							// 左下
							if (!isFull)
							{
								gridY = _selfGridY + 1;
								if (gridY < _numRows)
								{
									cell = getCell(gridX, gridY);
									cellShow(cell);
								}
							}
						}
					}
					// 显示左边 End
				}
				// 如果向右走 -----------------------------------
				if (_selfGridX - preGridX > 0)
				{
					// 隐藏左边
					gridX = _selfGridX - 2;
					if (gridX >= 0)
					{
						gridY = _selfGridY;
						cell = getCellShowed(gridX, gridY);
						cellShowedHideAll(cell);

						// 左上
						gridY = _selfGridY - 1;
						if (gridY >= 0)
						{
							cell = getCellShowed(gridX, gridY);
							cellShowedHideAll(cell);
						}
						// 左下
						gridY = _selfGridY + 1;
						if (gridY < _numRows)
						{
							cell = getCellShowed(gridX, gridY);
							cellShowedHideAll(cell);
						}
					}

					// 显示右边
					if (!isFull)
					{
						gridX = _selfGridX + 1;
						if (gridX < _numCols)
						{
							gridY = _selfGridY;
							cell = getCell(gridX, gridY);
							cellShow(cell);

							// 右上
							if (!isFull)
							{
								gridY = _selfGridY - 1;
								if (gridY >= 0)
								{
									cell = getCell(gridX, gridY);
									cellShow(cell);
								}
							}
							// 右下
							if (!isFull)
							{
								gridY = _selfGridY + 1;
								if (gridY < _numRows)
								{
									cell = getCell(gridX, gridY);
									cellShow(cell);
								}
							}
						}
					}
					// 显示右边 end
				}
				// 如果向上走 -----------------------------------
				if (_selfGridY - preGridY < 0)
				{
					// 隐藏下边
					gridY = _selfGridY + 2;
					if (gridY < _numRows)
					{
						gridX = _selfGridX;
						cell = getCellShowed(gridX, gridY);
						cellShowedHideAll(cell);

						// 左下
						gridX = _selfGridX - 1;
						if (gridX >= 0)
						{
							cell = getCellShowed(gridX, gridY);
							cellShowedHideAll(cell);
						}
						// 右下
						gridX = _selfGridX + 1;
						if (gridX < _numCols)
						{
							cell = getCellShowed(gridX, gridY);
							cellShowedHideAll(cell);
						}
					}

					// 显示上边
					if (!isFull)
					{
						gridY = _selfGridY - 1;
						if (gridY >= 0)
						{
							gridX = _selfGridX;
							cell = getCell(gridX, gridY);
							cellShow(cell);

							// 左上
							if (!isFull)
							{
								gridX = _selfGridX - 1;
								if (gridX >= 0)
								{
									cell = getCell(gridX, gridY);
									cellShow(cell);
								}
							}
							// 右上
							if (!isFull)
							{
								gridX = _selfGridX + 1;
								if (gridX < _numCols)
								{
									cell = getCell(gridX, gridY);
									cellShow(cell);
								}
							}
						}
					}
					// 显示上面 End
				}
				// 如果向下走 -----------------------------------
				if (_selfGridY - preGridY > 0)
				{
					// 隐藏上边
					gridY = _selfGridY - 2;
					if (gridY >= 0)
					{
						gridX = _selfGridX;
						cell = getCellShowed(gridX, gridY);
						cellShowedHideAll(cell);

						// 左上
						gridX = _selfGridX - 1;
						if (gridX >= 0)
						{
							cell = getCellShowed(gridX, gridY);
							cellShowedHideAll(cell);
						}
						// 右上
						gridX = _selfGridX + 1;
						if (gridX < _numCols)
						{
							cell = getCellShowed(gridX, gridY);
							cellShowedHideAll(cell);
						}
					}

					// 显示下边
					if (!isFull)
					{
						gridY = _selfGridY + 1;
						if (gridY < _numRows)
						{
							gridX = _selfGridX;
							cell = getCell(gridX, gridY);
							cellShow(cell);

							// 左下
							if (!isFull)
							{
								gridX = _selfGridX - 1;
								if (gridX >= 0)
								{
									cell = getCell(gridX, gridY);
									cellShow(cell);
								}
							}
							// 右下
							if (!isFull)
							{
								gridX = _selfGridX + 1;
								if (gridX < _numCols)
								{
									cell = getCell(gridX, gridY);
									cellShow(cell);
								}
							}
						}
					}
					// 显示上面 End
				}
			}
			trace("playerGrid::selfMove", getTimer() - time);
		}

		// =======================
		// Other Player
		// =======================
		public function addPlayer(player : Player) : void
		{
			if (player.gridX == -1)
			{
				playerSetGridXY(player);
				player.preGridX = player.gridX;
				player.preGridY = player.gridY;
				var cell : Vector.<Player> = getCell(player.gridX, player.gridY);
				cellAddPlayer(cell, player);
				player.sMove.add(playerMove);
				updatePlayerCellText(player);

				if (!inKen(player))
				{
					playerHide(player, true);
					trace("playerHide", player.isShow);
					_countShow++;
				}
				else
				{
					if (isFull)
					{
						playerHide(player, true);
						_countShow++;
						trace("playerHide", player.isShow);
					}
					else
					{
						playerShow(player, true);
						trace("playerShow", player.isShow);
						// _countShow++;
					}
				}
			}
		}

		public function removePlayer(player : Player) : void
		{
			if (player.gridX != -1)
			{
				player.sMove.remove(playerMove);
				if (player.isShow)
				{
					playerHide(player);
				}
				var cell : Vector.<Player> = getCell(player.gridX, player.gridY);
				cellRemovePlayer(cell, player);
			}
			player.gridX = -1;
			player.gridY = -1;
			player.preGridX = -1;
			player.preGridY = -1;
		}

		public function modelIn(player : Player) : void
		{
			if (player.gridX != -1)
			{
				var cell : Vector.<Player>;
				player.sMove.remove(playerMove);
				if (!player.isShow)
				{
					player.limitShow();
					player.isShow = true;
				}
				else
				{
					cell = getCellShowed(player.preGridX, player.preGridY);
					cellShowedRemovePlayer(cell, player);
					showedPlayerListRemove(player);
					_countShow--;
				}
				cell = getCell(player.gridX, player.gridY);
				cellRemovePlayer(cell, player);
			}
			player.gridX = -1;
			player.gridY = -1;
			player.preGridX = -1;
			player.preGridY = -1;
		}

		public function modelOut(player : Player) : void
		{
			addPlayer(player);
		}

		private function playerMove(player : Player) : void
		{
			playerChangeIndex(player);
		}

		private function playerChangeIndex(player : Player) : void
		{
			var preGridX : int = player.gridX;
			var preGridY : int = player.gridY;
			playerSetGridXY(player);
			if (!oneCell(preGridX, preGridY, player.gridX, player.gridY))
			{
				updatePlayerCellText(player);
				player.preGridX = preGridX;
				player.preGridY = preGridY;
				var cell : Vector.<Player> = getCell(preGridX, preGridY);
				cellRemovePlayer(cell, player);
				cell = getCell(player.gridX, player.gridY);
				cellAddPlayer(cell, player);
				if (!inKen(player))
				{
					if (player.isShow)
					{
						playerHide(player);
					}
				}
				else
				{
					if (!isFull)
					{
						if (!player.isShow)
						{
							playerShow(player);
						}
						else
						{
							cell = getCellShowed(preGridX, preGridY);
							cellShowedRemovePlayer(cell, player);
							cell = getCellShowed(player.gridX, player.gridY);
							cellShowedAddPlayer(cell, player);
						}
					}
					else if (player.isShow)
					{
						cell = getCellShowed(preGridX, preGridY);
						cellShowedRemovePlayer(cell, player);
						cell = getCellShowed(player.gridX, player.gridY);
						cellShowedAddPlayer(cell, player);
					}
				}

				player.preGridX = player.gridX;
				player.preGridY = player.gridY;
			}
		}

		// ==================
		// util
		// ==================
		/** 是否人数已满 */
		private function get isFull() : Boolean
		{
			return _countShow >= _maxShow;
		}

		/** 是否在显示范围内 */
		private function inKen(palyer : Player) : Boolean
		{
			return Math.abs(palyer.gridX - _selfGridX) <= 1 && Math.abs(palyer.gridY - _selfGridY) <= 1;
		}

		/** 是否是同一个格子 */
		private function oneCell(preGridX : int, preGridY : int, gridX : int, gridY : int) : Boolean
		{
			return preGridX == gridX && preGridY == gridY;
		}

		/** 设置格子 */
		private function playerSetGridXY(player : Player) : void
		{
			player.gridX = int(player.x / _gridSize);
			player.gridY = int(player.y / _gridSize);
			if(player.gridX < 0) player.gridX = 0;
			if(player.gridY < 0) player.gridY = 0;
			if(player.gridX >= _numCols) player.gridX = _numCols - 1;
			if(player.gridY >= _numRows) player.gridY = _numRows - 1;
		}

		/** 获取格子 */
		private function getCell(gridX : int, gridY : int) : Vector.<Player>
		{
			return _grid[gridY][gridX];
		}

		/** 获取格子(显示的玩家) */
		private function getCellShowed(gridX : int, gridY : int) : Vector.<Player>
		{
			return _gridShowed[gridY][gridX];
		}

		/** 显示玩家 */
		private function playerShow(player : Player, isFrist : Boolean = false) : void
		{
			if (isFrist == false && player.isShow == true) return;
			player.limitShow();
			var cell : Vector.<Player> = getCellShowed(player.gridX, player.gridY);
			cellShowedAddPlayer(cell, player);
			showedPlayerListAdd(player);
			player.isShow = true;
			_countShow++;
		}

		/** 隐藏玩家 */
		private function playerHide(player : Player, isFrist : Boolean = false) : void
		{
			if (isFrist == false && player.isShow == false)
			{
				return;
			}
			player.limitHide();
			var cell : Vector.<Player> = getCellShowed(player.preGridX, player.preGridY);
			cellShowedRemovePlayer(cell, player);
			showedPlayerListRemove(player);
			player.isShow = false;
			_countShow--;
		}

		/** 移除玩家从格子 */
		private function cellRemovePlayer(cell : Vector.<Player>, player : Player) : void
		{
			var index : int = cell.indexOf(player);
			cell.splice(index, 1);
		}

		/** 添加玩家玩家到格子 */
		private function cellAddPlayer(cell : Vector.<Player>, player : Player) : void
		{
			cell.push(player);
		}

		/** 移除玩家从格子(显示) */
		private function cellShowedRemovePlayer(cell : Vector.<Player>, player : Player) : void
		{
			var index : int = cell.indexOf(player);
			if (index != -1)
			{
				cell.splice(index, 1);
			}
			else
			{
				trace();
			}
		}

		/** 添加玩家玩家到格子(显示) */
		private function cellShowedAddPlayer(cell : Vector.<Player>, player : Player) : void
		{
			var index : int = cell.indexOf(player);
			if (index == -1)
			{
				cell.push(player);
				if (player.isShow == false)
				{
					trace(player.isShow);
				}
			}
		}
		
		/** 添加玩家到显示列表 */
		private function showedPlayerListAdd(player:Player):void
		{
			var index:int = _showedPlayerList.indexOf(player);
			if(index == -1)
			{
				_showedPlayerList.push(player);
			}
		}
		
		/** 移除玩家从显示列表 */
		private function showedPlayerListRemove(player:Player):void
		{
			var index:int = _showedPlayerList.indexOf(player);
			if(index != -1)
			{
				_showedPlayerList.splice(index, 1);
			}
		}

		/** 隐藏显示格子里所有玩家 */
		private function cellShowedHideAll(cell : Vector.<Player>) : void
		{
			var player : Player;
			var index:int;
			while (cell.length > 0)
			{
				player = cell[0];
				trace(player.isShow);
				playerHide(player);
				trace(player.isShow);
				index = cell.indexOf(player);
				if (index != -1)
				{
					cell.splice(index, 1);
				}
			}
		}

		/** 显示格子里的玩家 */
		private function cellShow(cell : Vector.<Player>) : void
		{
			var player:Player;
			var length:int = cell.length;
			for (var i : int = 0; i < length; i++)
			{
				if (!isFull)
				{
					player = cell[i];
					if(player.gridX != -1)
					{
						playerShow(player);
					}
					else
					{
						cellRemovePlayer(cell, player);
						addPlayer(player);
						i --;
						length--;
					}
					if(i > 30) break;
				}
				else
				{
					break;
				}
			}
		}

		// ==================
		// updatePlayer
		// ==================
		public function updatePlayerCellText(player : Player) : void
		{
			var row : int = player.gridY;
			var col : int = player.gridX;
			// player.updateCell(row, col);
		}

		// ==================
		// GETTER
		// ==================
		public function get grid() : Dictionary
		{
			return _grid;
		}

		public function get numRows() : Number
		{
			return _numRows;
		}

		public function get numCols() : Number
		{
			return _numCols;
		}

		public function get gridSize() : Number
		{
			return _gridSize;
		}
	}
}
