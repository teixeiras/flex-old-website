package Plugins.games.tetris.lib {

import flash.display.Graphics;
public class Board {
    public var width  : int = 16;
    public var height : int = 16;
    public var cells  : Array = null;
    public var blockSize : int = 10;

    public function Board(width:int, height: int){
        this.width  = width;
        this.height = height;

        this.cells = new Array(height);
        for(var y : int =0; y<height; y++){
            this.cells[y] = new Array(width);
            for(var x: int = 0; x < width; x++){
                this.cells[y][x] = 0;
            }
        }
    }


    public function clear() : void {
        for(var y : int =0; y<height; y++){
             for(var x: int = 0; x < width; x++){
                 this.cells[y][x] = 0;
             }
         }
     }
    
}
}
