package Plugins.games.Connect4.connect4.model {
   
    
    [Event(name="stateChanged",type="flash.events.Event")]
    [Event(name="tokenPlaced",type="flash.events.Event")] 
    
	public class Game {
		// Fundamental dimensions of game
		public static const COLUMNS:uint = 		7;
		public static const ROWS:uint = 		6;
		public static const CELLS:uint =        COLUMNS * ROWS;
		public static const WINNING_RUN:uint = 	4;
		
		// Directional constants used throughout game logic, representing cardinal directions
		// from some cell to neighboring cells.
		public static const NORTHEAST:uint = 	0;
		public static const EAST:uint = 		1;
		public static const SOUTHEAST:uint = 	2;
		public static const SOUTH:uint = 		3;
		public static const SOUTHWEST:uint = 	4;
		public static const WEST:uint = 		5;
		public static const NORTHWEST:uint = 	6;
		public static const NORTH:uint = 		7;
		public static const MAX_DIRECTION:uint = 7;
		
		// The DELTA arrays may be indexed by a direction to obtain the X and Y
		// offsets to the corresponding neighbor cell.
		public static const DELTA_X:Array = [1, 1,  1,  0, -1, -1, -1, 0];
		public static const DELTA_Y:Array = [1, 0, -1, -1, -1, 0, 1, 1];
		
		// OPPOSITES[dir] returns the opposite direction
		public static const OPPOSITES:Array = [4, 5, 6, 7, 0, 1, 2, 3];
		
		// Player constants
		[Bindable]
		public static var YELLOW:uint = 	0;
		[Bindable]
		public static var RED:uint = 		1;
		public static var PLAYER_NAMES:Array = ["Yellow", "Red"];
		[Bindable]
		public static var PLAYER_COLORS:Array = [0xFFFF00, 0xFF0000];

        // Direction names for debugging purposes.
		public static const DIRECTION_NAMES:Array = [
			"NE", "E", "SE", "S", "SW", "W", "NW", "N"
		];

        // Event names
		public static const STATE_CHANGED:String = "stateChanged";
		public static const TOKEN_PLACED:String = "tokenPlaced";
		
		// Number of moves (not turns) of lookahead used in analysis.
		[Bindable]
		public var lookahead:uint = 4;

        // The current GameState
        private var _state:GameState;

        /** Create a new Game object. */
        public function Game()
        {
            initializeGame();
        }
        
        /**
         * Return the current state of the game.
         */
        [Bindable("stateChanged")]
        public function get state():GameState
        {
        	return _state;
        }
        
        public function set state(gs:GameState):void
        {
        	_state = gs;
        	updateState();
        }
        
        /**
         * Indicate that an update to the state has occurred.
         * As something of a hack, this is used to fire display
         * updates for other purposes even when the state
         * doesn't change.
         */
        public function updateState():void
        {
        	dispatchEvent(new Event(STATE_CHANGED));
        }

        /**
         * Make a move in the given column.
         */
        public function playColumn(col:int):void
        {
    		state = state.playColumn(col);
        }
        
        /**
         * Take back the most recent move, and if it was an
         * autoMove, take back the one before that too.
         */         
        public function retractMove():void
        {
            var lastState:GameState = state.parent;
            if (lastState.autoMove)
                lastState = lastState.parent;
            state = lastState;
        }

        /**
         * Make the current player's best possible move according
         * to the scoring system.
         */
     	public function playBestMove():void
    	{
    		GameState.instanceCount = 0;
    		state = state.playBestMove();
    		trace(GameState.instanceCount + " states created");
    	}			

    	/**
    	 * Initialize this game.
    	 */
      	public function initializeGame():void
    	{
            state = GameState.initialState(this);
    	}
    	
	}
}
