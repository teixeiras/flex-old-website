
package Plugins.games.tetris.lib{
import flash.display.Graphics;
import mx.controls.Alert;

public class Block {

    public var xPos        : int = 0;
    public var yPos        : int = 0;
    public var rotation    : int = 0;
    public var rotations   : int = 1;
    private var cells       : Array = null;


    public function get width() : int {
        return cells[rotation][0].length;
    }

    public function get height() : int {
        return cells[rotation].length;
    }

    public function get cellsForCurrentRotation() : Array {
        return cells[rotation];
    }

    public function cellsForRotation(specificRotation : int) : Array{
        return this.cells[specificRotation];
    }




    public static function newBlock() : Block{
        var blockNumber : Number = Math.round((Math.random() * 7));

        if(blockNumber == 0) return newSquareBlock();
        if(blockNumber == 1) return newColumnBlock();
        if(blockNumber == 2) return newLLeftBlock();
        if(blockNumber == 3) return newLRightBlock();
        if(blockNumber == 4) return newSBlock();
        if(blockNumber == 5) return newZBlock();
        if(blockNumber == 6) return newTBlock();

        return newSquareBlock();
    }

    public static function newLLeftBlock() : Block {
        var block : Block = new Block();
        block.rotations = 4;

        block.cells = new Array();

        var color : int = 0xffff00;

        var rotation0 : Array = new Array();
        rotation0.push([0x000000, color]);
        rotation0.push([0x000000, color]);
        rotation0.push([color   , color]);
        block.cells.push(rotation0);

        var rotation1 : Array = new Array();
        rotation1.push([color , 0x000000, 0x000000]);
        rotation1.push([color , color   , color]);
        block.cells.push(rotation1);

        var rotation2 : Array = new Array();
        rotation2.push([color, color]);
        rotation2.push([color, 0x000000]);
        rotation2.push([color, 0x000000]);
        block.cells.push(rotation2);

        var rotation3 : Array = new Array();
        rotation3.push([color    , color     , color]);
        rotation3.push([0x000000 , 0x000000  , color]);
        block.cells.push(rotation3);

        return block;

    }

    public static function newLRightBlock() : Block {
        var block : Block = new Block();
        block.rotations = 4;

        block.cells = new Array();

        var color : int = 0x00ffff;

        var rotation0 : Array = new Array();
        rotation0.push([color, 0x000000]);
        rotation0.push([color, 0x000000]);
        rotation0.push([color, color   ]);
        block.cells.push(rotation0);

        var rotation1 : Array = new Array();
        rotation1.push([0x000000, 0x000000, color ]);
        rotation1.push([color , color     , color]);
        block.cells.push(rotation1);

        var rotation2 : Array = new Array();
        rotation2.push([color   , color]);
        rotation2.push([0x000000, color]);
        rotation2.push([0x000000, color]);
        block.cells.push(rotation2);

        var rotation3 : Array = new Array();
        rotation3.push([color , color    , color   ]);
        rotation3.push([color , 0x000000 , 0x000000]);
        block.cells.push(rotation3);

        return block;

    }


    public static function newColumnBlock() : Block {
        var block : Block = new Block();
        block.rotations = 2;
        block.cells = new Array();

        var color : int = 0xff0000;

        var rotation0 : Array = new Array();
        rotation0.push([color]);
        rotation0.push([color]);
        rotation0.push([color]);
        rotation0.push([color]);
        block.cells.push(rotation0);

        var rotation1 : Array = new Array();
        rotation1.push([color, color, color, color]);
        block.cells.push(rotation1);

        return block;
    }

    public static function newSquareBlock() : Block {
        var block : Block = new Block();
        block.rotations = 1;
        block.cells = new Array();

        var color : int = 0x00ff00;

        var rotation0 : Array = new Array();
        rotation0.push([color, color]);
        rotation0.push([color, color]);
        block.cells.push(rotation0);

        return block;
    }


    public static function newSBlock() : Block {
        var block : Block = new Block();
        block.rotations = 2;
        block.cells = new Array();

        var color : int = 0x0000ff;

        var rotation0 : Array = new Array();
        rotation0.push([0x000000, color, color]);
        rotation0.push([color, color, 0x000000]);
        block.cells.push(rotation0);

        var rotation1 : Array = new Array();
        rotation1.push([color  , 0x000000]);
        rotation1.push([color  , color   ]);
        rotation1.push([0x00000, color   ]);
        block.cells.push(rotation1);

        return block;
    }

    public static function newZBlock() : Block {
        var block : Block = new Block();
        block.rotations = 2;
        block.cells = new Array();

        var color : int = 0xff00ff;

        var rotation0 : Array = new Array();
        rotation0.push([color   , color, 0x000000]);
        rotation0.push([0x000000, color, color]);
        block.cells.push(rotation0);

        var rotation1 : Array = new Array();
        rotation1.push([0x000000, color    ]);
        rotation1.push([color   , color    ]);
        rotation1.push([color   , 0x000000 ]);
        block.cells.push(rotation1);

        return block;
    }

    public static function newTBlock() : Block {
        var block : Block = new Block();
        block.rotations = 4;

        block.cells = new Array();

        var color : int = 0x88ffff;

        var rotation0 : Array = new Array();
        rotation0.push([0x000000, color, 0x000000]);
        rotation0.push([color   , color, color]);
        block.cells.push(rotation0);

        var rotation1 : Array = new Array();
        rotation1.push([0x000000 , color]);
        rotation1.push([color    , color]);
        rotation1.push([0x000000 , color]);
        block.cells.push(rotation1);

        var rotation2 : Array = new Array();
        rotation2.push([color   , color, color   ]);
        rotation2.push([0x000000, color, 0x000000]);
        block.cells.push(rotation2);

        var rotation3 : Array = new Array();
        rotation3.push([color, 0x000000]);
        rotation3.push([color, color   ]);
        rotation3.push([color, 0x000000]);
        block.cells.push(rotation3);

        return block;

    }



}

}
