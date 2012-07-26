package com.commUI.tooltip
{
	import utils.DictionaryUtil;
	import game.manager.SignalBusManager;

	import gameui.core.GComponent;
	import gameui.manager.UIManager;

	import log4a.Logger;

	import com.greensock.TweenLite;

	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;

	public class ToolTipManager
	{
		// ===============================================================
		// 单例
		// ===============================================================
		private static var __instance : ToolTipManager;

		public static function get instance() : ToolTipManager
		{
			if (!__instance)
				__instance = new ToolTipManager();
			return __instance;
		}

		public function ToolTipManager() : void
		{
			if (__instance)
				throw (Error("Singleton Error"));
		}

		// ===============================================================
		// 属性
		// ===============================================================
		private var _toolTips : Dictionary = new Dictionary();
		private var _targetRegister : Dictionary = new Dictionary();
		private var _toolTip : ToolTip;
		private var _target : InteractiveObject;
		private var _enabled : Boolean = true;

		// ===============================================================
		// Setter/Getter
		// ===============================================================
		
		// 开启/关闭
		public function set enabled(value : Boolean) : void
		{
			if (_toolTip)
			{
				if (!_enabled && value)
					_toolTip.show();
				else if (!value)
					_toolTip.hide();
			}

			_enabled = value;
		}

		// 当前鼠标悬浮对象
		public function get target() : InteractiveObject
		{
			return _target;
		}

		// ===============================================================
		// 公共方法
		// ===============================================================

		/*
		 * 注册ToolTip鼠标事件
		 * dataPrivider 可以是String/Function/GComponent
		 * String 将String内容传给ToolTip对象（tooltip.source = String）
		 * Function 将Function返回结果传给ToolTip对象 （tooltip.source = function()）
		 * GComponent 将tooltip.source = gcomponent.source
		 */
		public function  registerToolTip(target : InteractiveObject, toolTipClass : Class = null, dataProvider : * = null, sendToChat : Boolean = false) : void
		{
			if (!target)
				return;
			if (!toolTipClass)
				toolTipClass = ToolTip;

			_targetRegister[target] = {toolTipClass:toolTipClass, dataProvider:dataProvider, sendToChat:sendToChat};

			target.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			target.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);

			if (sendToChat)
				target.addEventListener(MouseEvent.CLICK, target_clickHandler);
		}

		// 注销ToolTip鼠标事件
		public function destroyToolTip(target : InteractiveObject) : void
		{
			if (_targetRegister[target])
			{
				if (_target == target)
				{
					hideTip();
				}
				target.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				target.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
				
				if (_targetRegister[target].sendToChat)
					target.removeEventListener(MouseEvent.CLICK, target_clickHandler);
				delete _targetRegister[target];
			}
		}

		// 强制刷新ToolTip
		public function refreshToolTip(target : InteractiveObject) : void
		{
			if (target == _target)
				updateTip();
		}
		
		// 调试
		public function debug (level:int = 0):void
		{
			Logger.debug("// ==============================");
			Logger.debug("显示对象：" + _target);
			Logger.debug("Tips对象：" + _toolTip);
			Logger.debug("注册ToolTip总数：" + DictionaryUtil.getLength(_toolTips));
			Logger.debug("\r\r");
		}
		
		// ------------------------------------------------
		// 对象池操作
		// ------------------------------------------------
		
		// 获得ToolTip
		public function getToolTip(toolTipClass : Class, source : *=null, context : *=null) : ToolTip
		{
			if (!toolTipClass is ToolTip)
				return null;

			var toolTip : ToolTip = _toolTips[toolTipClass];

			if (!toolTip)
			{
				toolTip = newToolTip(toolTipClass, source, context);
				_toolTips[toolTipClass] = toolTip;
			}

			return toolTip;
		}

		// 创建ToolTip
		private function newToolTip(toolTipClass : Class, source : * = null, context : *= null) : ToolTip
		{
			if (!toolTipClass is ToolTip)
				return null;

			var toolTipData : ToolTipData = new ToolTipData();
			var toolTip : ToolTip = new toolTipClass(toolTipData);

			toolTip.source = source;

			cacheToolTip(toolTipClass, toolTip);

			return toolTip;
		}

		// 缓存ToolTip
		private function cacheToolTip(toolTipClass : Class, toolTip : ToolTip) : void
		{
			if (!_toolTips[toolTipClass])
				_toolTips[toolTipClass] = toolTip;
		}


		// ------------------------------------------------
		// 事件响应
		// ------------------------------------------------
		private function rollOverHandler(event : MouseEvent) : void
		{
			if (!_enabled)
				return;
			
			trace("鼠标进入" + event.currentTarget + " " + event.currentTarget.name);
			

			onShowTip(event);
		}
		
		private function rollOutHandler(event : MouseEvent) : void
		{
			setTimeout(onHideTip, 0, event);
		}
		
		private function onShowTip(event : MouseEvent) : void
		{
			if (_toolTip)
				hideTip();

			_target = event.target as InteractiveObject;

			updateTip();
		}

		private function updateTip() : void
		{
			if (!_target) return;

			var toolTipClass : Class = _targetRegister[_target]["toolTipClass"];
			var dataProvider : * = _targetRegister[_target]["dataProvider"];

			var oldToolTip : ToolTip = _toolTip;
			_toolTip = getToolTip(toolTipClass);
			if (oldToolTip && oldToolTip != _toolTip)
				oldToolTip.hide();

			if (UIManager.dragModal)
				_toolTip.visible = false;
			else
				_toolTip.visible = true;

			if (dataProvider != null)
			{
				if (dataProvider is Function)
					_toolTip.source = dataProvider();
				else if (dataProvider is GComponent)
					_toolTip.source = (dataProvider as GComponent).source;
				else if (dataProvider is String)
					_toolTip.source = dataProvider;
				else
					_toolTip.source = dataProvider;
			}
			else if (_target is GComponent)
				_toolTip.source = (_target as GComponent).source;

			_target.addEventListener(MouseEvent.MOUSE_MOVE, toolTip_mouseMoveHandler);
			if (_target.stage)
				layout(_target.stage.mouseX, _target.stage.mouseY);
			UIManager.root.addChild(_toolTip);

			TweenLite.to(_toolTip, 0.3, {alpha:1});
		}

		private function toolTip_mouseMoveHandler(event : MouseEvent) : void
		{
			layout(event.stageX, event.stageY);
		}

		private function onHideTip(event : MouseEvent) : void
		{
			var target : InteractiveObject = event.target as InteractiveObject;
			if (target != _target)
			{
				return;
			}

			hideTip();
		}

		private function hideTip() : void
		{
			if (_target)
			{
				_target.removeEventListener(MouseEvent.MOUSE_MOVE, toolTip_mouseMoveHandler);
				_target = null;
			}

			if (_toolTip)
			{
				_toolTip.hide();
				_toolTip = null;
			}
		}

		private function layout(stageX : Number, stageY : Number) : void
		{
			var offset : Point = new Point(stageX, stageY);
			offset.x += 10;
			offset.y += 10;

			if (_toolTip.data.alginMode == 0)
			{
				if (offset.x + _toolTip.width + 10 > UIManager.stage.stageWidth)
					offset.x = offset.x - (_toolTip.width + 10);
				else
					offset.x += 10;

				if (offset.y + _toolTip.height > UIManager.stage.stageHeight && _toolTip.height < offset.y)
					offset.y -= _toolTip.height;

				if (offset.y + _toolTip.height > UIManager.stage.stageHeight && _toolTip.height > offset.y)
					offset.y = UIManager.root.height / 2 - _toolTip.height / 2;
			}
			else if (_toolTip.data.alginMode == 1)
			{
				if (offset.x + _toolTip.width > UIManager.stage.stageWidth)
					offset.x -= _target.width + _toolTip.width;

				if (offset.y + _toolTip.height > UIManager.stage.stageHeight)
					offset.y -= _toolTip.height + _target.height ;

				offset.y -= _target.height + _toolTip.height;
			}
			_toolTip.moveTo(offset.x, offset.y);
		}

		// ------------------------------------------------
		// Ctrl+左键发送至聊天框
		// ------------------------------------------------
		private function target_clickHandler(event : MouseEvent) : void
		{
			if (!event.ctrlKey)
				return;

			if (event.currentTarget != _target)
			{
				Logger.error("ToolTip对象错误！");
				return;
			}

			var toolTipConfig : Object = _targetRegister[_target];
			var dataProvider : * = toolTipConfig["dataProvider"];
			var source : *;

			if (dataProvider != null)
			{
				if (dataProvider is Function)
					source = dataProvider();
				else if (dataProvider is GComponent)
					source = (dataProvider as GComponent).source;
				else if (dataProvider is String)
					source = dataProvider;
				else
					source = dataProvider;
			}
			else if (_target is GComponent)
				source = (_target as GComponent).source;

			SignalBusManager.sendToChatObject.dispatch(source);
		}



	}
}
