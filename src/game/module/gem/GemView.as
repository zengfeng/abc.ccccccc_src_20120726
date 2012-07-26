package game.module.gem
{
	import com.commUI.GCommonWindow;
	import game.manager.ViewManager;
	import game.module.gem.attach.GemAttachPanel;
	import game.module.gem.identify.GemIdentifyPanel;
	import game.module.gem.merge.GemMergePanel;
	import gameui.containers.GTabbedPanel;
	import gameui.core.GAlign;
	import gameui.data.GTabData;
	import gameui.data.GTabbedPanelData;
	import gameui.data.GTitleWindowData;



	/**
	 * @author jian
	 */
	public class GemView extends GCommonWindow
	{
		private var _tabbedPanel : GTabbedPanel;

		public function GemView()
		{
			var data : GTitleWindowData = new GTitleWindowData();
			data.width = 626;
			data.height = 384;
			data.allowDrag = true;
			data.parent = ViewManager.instance.uiContainer;

			super(data);
		}

		override protected function create() : void
		{
			super.create();

			title = "灵珠";

			var data : GTabbedPanelData = new GTabbedPanelData();
			data.tabData.padding = 10;
			data.tabData.gap = 1;
			data.tabData.x = 0;
			data.x = 5;

			_tabbedPanel = new GTabbedPanel(data);
			_tabbedPanel.addTab("灵珠镶嵌", new GemAttachPanel());
			_tabbedPanel.addTab("灵珠鉴定", new GemIdentifyPanel());
			_tabbedPanel.addTab("灵珠合成", new GemMergePanel());

			_tabbedPanel.group.selectionModel.index = 0;
			_contentPanel.add(_tabbedPanel);
		}
	}
}
