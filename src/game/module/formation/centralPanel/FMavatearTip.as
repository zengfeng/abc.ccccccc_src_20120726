package game.module.formation.centralPanel {
	import com.commUI.tooltip.ToolTip;
	import com.commUI.tooltip.ToolTipData;
	import com.utils.StringUtils;
	import game.core.item.prop.ItemProp;
	import game.core.item.prop.ItemPropManager;
	import game.core.prop.Prop;
	import game.core.prop.PropManager;
	import game.module.formation.FMControlPoxy;
	import game.module.formation.formationManage.FMManager;
	import game.module.formation.formationManage.VoFM;


	/**
	 * @author Lv
	 */
	public class FMavatearTip extends ToolTip {
		public function FMavatearTip(data : ToolTipData) {
			super(data);
		}

		override protected function getToolTipText() : String {
			var text : String = "";
			// 阵形位置
			var step : int = _source as Number;
			if (step == 10000)
				step = 0;
			var fmID : int = FMControlPoxy.startFmK;
			var leve : int = (FMManager.formationKindsDic[fmID] as VoFM).fm_level;
			var stepArr : Array = FMManager.formationStepTipDic[fmID];

			var numStr : String;

//			if (step == 0) {
//				if (stepArr[1] > 10) {
//					numStr = String(stepArr[1]);
//				} else {
//					numStr = "0" + stepArr[1];
//				}
//			} else if (step == 1) {
//				if (stepArr[0] > 10) {
//					numStr = String(stepArr[0]);
//				} else {
//					numStr = "0" + stepArr[0];
//				}
//			} else {
//				if (stepArr[step] > 10) {
//					numStr = String(stepArr[step]);
//				} else {
//					numStr = "0" + stepArr[step];
//				}
//			}

			if (stepArr[step] > 10) {
				numStr = String(stepArr[step]);
			} else {
				numStr = "0" + stepArr[step];
			}

			var stepID : String ;
			if (leve != 10)
				stepID = String(fmID) + "0" + String(leve) + numStr;
			else
				stepID = String(fmID) + "10" + numStr;
			var isFmEye : Boolean = false;
			var fmArr : Array = (FMManager.formationKindsDic[fmID] as VoFM).fm_frameArr;

			if (leve == 1)
				isFmEye = false;
			else {
				if (fmArr[step] == 3)
					isFmEye = true;
				else
					isFmEye = false;
			}

			if (isFmEye)
				text += "阵眼加成\r";
			else
				text += "阵位加成\r";

			var prop : ItemProp = ItemPropManager.instance.getProp(int(stepID));

			for each (var key:String in prop.allKeys) {
				if (prop[key] > 0) {
					var value : String = " +" + prop[key];
					var name : String;
					if ((PropManager.instance.getPropByKey(key) as Prop).per == 1)
						value += "%";
					name = (PropManager.instance.getPropByKey(key) as Prop).name;
					text += name + StringUtils.addColor(String(value), "#279F15") + "\r";
				}
			}
			var eye : String = (FMManager.formationKindsDic[fmID] as VoFM).fm_eyeEffEct;
			if (isFmEye)
				text += StringUtils.addColor(eye, "#FFF000") + "\r";

			return text;
		}
	}
}
