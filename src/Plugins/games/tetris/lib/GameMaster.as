package Plugins.games.tetris.lib {

import flash.display.Graphics;
import mx.controls.Alert;

public class GameMaster {

    public var delay       : int = 25;
    public var blockSize   : int = 10;
    public var gameModel   : GameModel;
    public var gamePainter : GamePainter;
    public var gameOver    : Boolean = false;



    public function doGameMasterActions(frameNo : int) : void {
        if(frameNo % delay == 0){
            if(moveDownCollision()){
               putBlock();
               checkForFullRows();
               gamePainter.drawBoard(gameModel.board);
               gameModel.block = null;
               gameModel.block = Block.newBlock();
               gameModel.block.yPos = 0;
               gameModel.block.xPos = 6;
               //block.xPos %= board.width;
                if(putCollision()){
                  gameOver = true;
                  return;
                }
            } else {
               gameModel.block.yPos ++;
            }

            drawBlock();

        }
    }


    public function putCollision() : Boolean {
        var currentCells : Array = gameModel.block.cellsForCurrentRotation;

        for(var y : int = 0; y < gameModel.block.height; y++) {
            for(var x: int = 0; x < gameModel.block.width; x++){
                if(currentCells[y][x] > 0x000000){
                    if(gameModel.board.cells[gameModel.block.yPos + y][gameModel.block.xPos + x] > 0x000000){
                        this.gameOver = true;
                        return true;
                    }
                }

            }
        }
        //Alert.show("Not Game Over");
        return false;

    }


    public function moveDownCollision() : Boolean{
        var blockHeight : int    = gameModel.block.cellsForCurrentRotation.length;
        var blockWidth  : int    = gameModel.block.cellsForCurrentRotation[0].length;
        var blockArray  : Array  = gameModel.block.cellsForCurrentRotation;


        if((gameModel.block.yPos + blockHeight) == gameModel.board.height){
            return true;
        }

        for(var y : int = 0; y < blockHeight; y++) {
            for(var x: int = 0; x < blockWidth; x++ ){
                if(blockArray[y][x] > 0x000000){
                    if(gameModel.board.cells[gameModel.block.yPos + y + 1][gameModel.block.xPos + x] > 0x000000){
                        return true;      
                    }
                }

            }
        }

        return false;
    }

    protected function putBlock() : Boolean {
        var blockHeight : int    = gameModel.block.cellsForCurrentRotation.length;
        var blockWidth  : int    = gameModel.block.cellsForCurrentRotation[0].length;
        var blockArray  : Array  = gameModel.block.cellsForCurrentRotation;

        for(var y : int = 0; y < blockHeight; y++) {
            for(var x: int = 0; x < blockWidth; x++ ){
                if(blockArray[y][x] > 0){ //if block has a cell at these coords...
                    if(gameModel.board.cells[gameModel.block.yPos + y][gameModel.block.xPos + x] > 0) {
                        gameOver = true;
                        return false;
                    }

                  gameModel.board.cells[gameModel.block.yPos + y][gameModel.block.xPos + x] = blockArray[y][x];
                }
            }
        }

        return true;
    }

    public function drawBlock() : void {
       gamePainter.drawBlock(gameModel.block);
    }


    public function checkForFullRows() : void{
        var fullRows : int = 0;
        for(var y : int = 0; y < gameModel.board.cells.length; y++){
            var rowIsFull : Boolean = true;
            for(var x: int=  0; x < gameModel.board.cells[y].length; x++){
                //Alert.show("Cell " + y + "," + x + " is " + new String(board.cells[y][x]));
                if(gameModel.board.cells[y][x] == 0x000000){
                    //Alert.show("Row " + y + " is not full");
                    rowIsFull = false;
                    break;
                }
            }
            if(rowIsFull){
                fullRows++;
                for(var yy : int = y; yy > 0; yy--){
                    for(var xx: int = 0; xx < gameModel.board.cells[yy].length; xx++){
                       gameModel.board.cells[yy][xx] = gameModel.board.cells[yy-1][xx];
                    }
                }
                for(var xxx: int = 0; xxx < gameModel.board.cells[0]; xxx++){
                    gameModel.board.cells[0][xxx] = 0;
                }
            }
        }

        var tempScore : int = 0;
        for(var i:int = 0; i<fullRows; i++){
          tempScore +=i + 1;
        }

        gameModel.score += tempScore;
        gamePainter.drawScore(gameModel.score);
    }

}

}