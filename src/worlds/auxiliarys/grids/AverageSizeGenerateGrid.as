// // // /////////////////////////////////////////////////////
// AverageSizeBuilderGrid.as
// Macromedia ActionScript Implementation of the Class AverageSizeBuilderGrid
// Generated by Enterprise Architect
// Created on:      11-五月-2012 15:20:01
// Original author: ZengFeng
// // // /////////////////////////////////////////////////////
package worlds.auxiliarys.grids
{
    import flash.utils.Dictionary;
    /**
     * 平均单元格大小生成网格策略
     * @author ZengFeng
     * @version 1.0
     * @updated 11-五月-2012 15:22:38
     */
    public class AverageSizeGenerateGrid extends AbstractGenerateGridStrategy
    {
        function AverageSizeGenerateGrid()
        {
        }

        /**
         * 生成网格
         * 
         * @param width    网格总宽度
         * @param height    网格总高度
         * @param itemPresetWidth    单元格预设宽度
         * @param itemPresetHeight    单元格预设高度
         */
        override public function generateGrid(width : int, height : int, itemPresetWidth : int, itemPresetHeight : int, pushList : Vector.<GridItem> = null, itemDic : Dictionary = null) : Vector.<GridItem>
        {
            return null;
        }
    }
    // end AverageSizeBuilderGrid
}