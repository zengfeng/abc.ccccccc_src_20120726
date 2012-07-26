package test.myTest {
	import gameui.controls.GTextInput;
	import gameui.data.GTextInputData;

	import project.Game;

	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author jian
	 */
	public class TextGTextInput extends Game {
		public function TextGTextInput() {
			super();
			var data : GTextInputData = new GTextInputData();
			data.restrict = "0-9";
			data.text = "输入";
			data.selectAll = true;

			var input : GTextInput = new GTextInput(data);
			input.textField.addEventListener(MouseEvent.CLICK, selectAllOnce);
			addChild(input);

			var tf : TextField = new TextField();
			tf.text = "输入";
			tf.y = 40;
			tf.addEventListener(MouseEvent.CLICK, selectAllOnce);
			addChild(tf);
		}

		function selectAllOnce(e : MouseEvent) {
			e.target.removeEventListener(MouseEvent.CLICK, selectAllOnce);
			e.target.addEventListener(FocusEvent.FOCUS_OUT, addSelectListener);
			selectAll(e);
		}

		function addSelectListener(e : FocusEvent) {
			e.target.addEventListener(MouseEvent.CLICK, selectAllOnce);
			e.target.removeEventListener(FocusEvent.FOCUS_OUT, addSelectListener);
		}

		function selectAll(e : Event) {
			e.target.setSelection(0, e.target.getLineLength(0));
		}

		private function focusInHandler(event : FocusEvent) : void {
			var tf : TextField = event.target as TextField;
			tf.setSelection(0, tf.text.length);
		}
	}
}
