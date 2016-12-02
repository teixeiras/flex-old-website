package Plugins.games.tetris.lib {

import flash.display.Graphics;
import mx.controls.Alert;
import mx.controls.Label;


public class GamePainter {

    public var boardGraphics : Graphics = null;
    public var blockGraphics : Graphics = null;
    public var scoreLabel    : Label    = null;
    public var debugMode     : Boolean  = false;


    public var blockSize : int  = 10;

    public function drawBlock(block: Block) : void{
        blockGraphics.clear();

        var blockArray : Array = block.cellsForCurrentRotation;

        for(var y: int = 0; y < blockArray.length ; y++){
            for(var x : int = 0; x < blockArray[0].length; x++) {
                if(blockArray[y][x] > 0x000000){
                    blockGraphics.beginFill(blockArray[y][x]);
                    blockGraphics.drawRect((block.xPos + x) * blockSize, (block.yPos + y) * blockSize, blockSize, blockSize);
                }
            }

        }

        if(debugMode){
            blockGraphics.lineStyle(1, 0xaa0000, 1.0);
            for(y = 0; y < block.height; y++){
                blockGraphics.moveTo( block.xPos * blockSize, (block.yPos + y) * blockSize);
                blockGraphics.lineTo((block.xPos * blockSize) + (block.width * blockSize), (block.yPos + y) * blockSize);
                blockGraphics.moveTo((block.xPos * blockSize), (block.yPos + y) * blockSize + blockSize -1 );
                blockGraphics.lineTo((block.xPos * blockSize) + (block.width * blockSize), (block.yPos + y) * blockSize + blockSize -1);
            }

            for(x = 0; x < block.width; x++){
                blockGraphics.moveTo( (block.xPos + x) * blockSize , (block.yPos) * blockSize);
                blockGraphics.lineTo(((block.xPos + x) * blockSize), (block.yPos + block.height) * blockSize);
                blockGraphics.moveTo(((block.xPos + x) * blockSize) + blockSize -1, (block.yPos) * blockSize);
                blockGraphics.lineTo(((block.xPos + x) * blockSize) + blockSize -1, (block.yPos + block.height) * blockSize);
            }
        }

    }

    public function drawBoard(board: Board) : void{
        boardGraphics.clear();

        //draw black board background
        boardGraphics.beginFill(0x000000);
        boardGraphics.drawRect(0,0, board.width * blockSize, board.height * blockSize);

        //draw cells
        boardGraphics.beginFill(0x00ff00);
        for(var y: int = 0; y<board.height;  y++){
            for(var x: int = 0; x<board.width; x++){
                if(board.cells[y][x] > 0){
                    boardGraphics.beginFill(board.cells[y][x]);
                    boardGraphics.drawRect(x * blockSize, y * blockSize, blockSize, blockSize);
                }
            }
        }

        if(debugMode){
            boardGraphics.lineStyle(1, 0xaaaaaa, 1.0);
            for(x =0; x<board.width; x++){
                boardGraphics.moveTo(x * blockSize, 0);
                boardGraphics.lineTo(x * blockSize, board.height * blockSize);
                boardGraphics.moveTo(x * blockSize + blockSize -1, 0);
                boardGraphics.lineTo(x * blockSize + blockSize -1, board.height * blockSize);
            }

            for(y = 0; y<board.height; y++){
                boardGraphics.moveTo(0, y * blockSize);
                boardGraphics.lineTo(board.width * blockSize, y * blockSize);
                boardGraphics.moveTo(0, y * blockSize + blockSize-1);
                boardGraphics.lineTo(board.width * blockSize, y * blockSize + blockSize-1);
            }
        }

    }

    public function drawScore(score : int) : void {
        this.scoreLabel.text = "Score: " + score;
    }

}

}