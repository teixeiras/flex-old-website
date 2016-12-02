package Plugins.games.tetris.lib {

public class PlayerControls {



    public function tryMoveLeft(block : Block, board : Board) : void {

        if(block.xPos ==  0){
          return;
        }

        var blockArray  : Array  = block.cellsForCurrentRotation;
        var canMoveLeft : Boolean = true;

        for(var y : int = 0; y < block.height; y++ ) {
            for(var x: int = 0; x < block.width; x++ ){
                if(blockArray[y][x] > 0x000000){
                    if(board.cells[block.yPos + y][block.xPos + x -1] > 0x000000){
                        canMoveLeft = false;
                    }
                }

            }
        }

        if(canMoveLeft){
            block.xPos--;
        }

    }


    public function tryMoveRight(block : Block, board : Board) : void {

        if(block.xPos == board.width - block.width){
          return;
        }

        var blockArray  : Array  = block.cellsForCurrentRotation;
        var canMoveRight : Boolean = true;

        for(var y : int = 0; y < block.height; y++ ) {
            for(var x: int = 0; x < block.width; x++ ){
                if(blockArray[y][x] > 0x000000){
                    if(board.cells[block.yPos + y][block.xPos + x + 1] > 0x000000){
                        canMoveRight = false;
                    }
                }

            }
        }

        if(canMoveRight){
            block.xPos++;
        }

    }


    public function tryRotate(rotationsAndDirection : int, block : Block, board : Board) : void {
        var nextRotation : int = block.rotation;
        nextRotation += rotationsAndDirection;
        if(nextRotation < 0){
            nextRotation += block.rotations;
        }
        nextRotation %= block.rotations;

        if(!collision(nextRotation, block, board)){
            block.rotation = nextRotation;
        }



    }


    public function collision(nextRotation : int, block : Block, board : Board) : Boolean {
        var nextCells : Array = block.cellsForRotation(nextRotation);


        //Alert.show("here 1");
        var nextCellsHeight : int = nextCells.length;
        var nextCellsWidth  : int = nextCells[0].length;

        //check if block will be rotated outside right edge of game board (left is impossible)
        if( (block.xPos + nextCellsWidth) > board.width) return true;


        for(var y : int = 0; y < nextCellsHeight; y++ ) {
            for(var x: int = 0; x < nextCellsWidth; x++ ){
                if(nextCells[y][x] > 0x000000){
                    if(board.cells[block.yPos + y][block.xPos + x] > 0x000000){
                        return true;
                    }
                }

            }
        }

        return false;


    }



}

}
