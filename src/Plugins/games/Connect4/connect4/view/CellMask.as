package Plugins.games.Connect4.connect4.view {
    import Plugins.guames.Connect4.connect4.model.Game;
    
    import flash.display.*;
    
    import mx.core.*;
    
    /** Programmatic graphic drawing a mask with cutout holes for grid cells. */
    public class CellMask extends UIComponent 
    {
        public var maskColor:uint;
        
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            
            for (var i:uint = 0; i <= Game.COLUMNS; i++)
            {
                graphics.beginFill(maskColor);
                graphics.drawRect(i * GameStateView.CELL_GRID,
                                  0,
                                  GameStateView.CELL_GAP,
                                  GameStateView.CELL_GRID * Game.ROWS + GameStateView.CELL_GAP);
                graphics.endFill();
            }
            for (i = 0; i <= Game.ROWS; i++)
            {
                graphics.beginFill(maskColor);
                graphics.drawRect(0,
                                  i * GameStateView.CELL_GRID,
                                  GameStateView.CELL_GRID * Game.COLUMNS + GameStateView.CELL_GAP,
                                  GameStateView.CELL_GAP);
                graphics.endFill();
            }
        }
        
    }
}