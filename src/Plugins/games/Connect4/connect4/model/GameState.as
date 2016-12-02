package Plugins.games.Connect4.connect4.model {

    import mx.utils.ObjectUtil;
    import mx.utils.ArrayUtil;
    import mx.effects.*;
    import flash.utils.*;
    import Plugins.Games.Connect4.connect4.model.*;

    /**
     * GameState is an immutable object representing a single state of the game.
     */
    public class GameState
    {
        public static const WINNING_SCORE:int = 999;
        public static const LOSING_SCORE:int = -WINNING_SCORE;
        
        private static const RUN_LENGTH_BITS:uint = 3;
        private static const RUN_LENGTH_MASK:uint = (1 << RUN_LENGTH_BITS) - 1;

        private static const RUN_CHUNK_BITS:uint = 24;
        private static const RUN_CHUNK_FACTOR:uint = (1 << RUN_CHUNK_BITS);
        private static const RUN_CHUNK_MASK:uint = (1 << RUN_CHUNK_BITS) - 1;
        
        private static const PLAYER_CHUNK_BITS:uint = 12;
        private static const PLAYER_CHUNK_MASK:uint = (1 << PLAYER_CHUNK_BITS) - 1;
        
        private static const PLAYER_CHUNK_INCREMENT:uint = 1 | (1<<3) | (1<<6) | (1<<9);
        private static const PLAYER_CHUNK_WIN:uint = PLAYER_CHUNK_INCREMENT << 2;
        
        private static const GENERATIONAL_DISCOUNT:Number = 0.95;

        // Game of which this is a state        
        private var _game:Game;

        // The _cells[] array is the heart of the GameState
        // representation.  There are three ranges in it, each of
        // which stores a different kind of value:
        //
        //   cells[c*ROWS + r] stores encoded run length fields (+)
        //                     or token players (-) for the cell [c,r]
        //   cells[CELLS + c] stores the max row played in column c
        //   cells[CELLS + COLUMNS + c] stores the key string for column c
        //
        // RUN LENGTH FIELDS: each of these values is a Number with a
        // 48-bit integer value consisting of two 24-bit fields, the
        // right 24 bits counting the run lengths in directions 0..3
        // and the left 24 bits counting run lengths in directions
        // 4..7 (note that dir 7 is North where no neighbors can
        // actually exist).
        //
        // Each of those 24-bit fields is further subdivided into two
        // 12-bit player chunks, the leftmost for player 0 and the
        // rightmost for player 1.  Each of those chunks has four
        // 3-bit run length fields, corresponding to the run length
        // directions from right to left extending from the current
        // cell.
        //
        // Note that the bits for dirs 0..3 can be directly added to
        // the bits for dirs 4..7 to give combined run lengths for the
        // four axes 0/4, 1/5, 2/6, 3(/7), for scoring purposes and to
        // set up new run lengths in neighbor cells.  Adding octal
        // 1111 to a player chunk or to the above sum gives the new
        // axis run lengths after playing a piece in this space.
        //
        // One can also mask a combined run length sum (for some
        // player's fields only) with octal 44444444 to see if a play
        // has resulted in a win.
        //
        // TOKEN PLAYER VALUES: this is -(player+1) if there's a token
        // for that player in the cell.
        //
        // KEY VALUES: a string for some column consisting of "|"
        // followed by an "r" or "y" for each cell with a token in it,
        // starting from the bottom.
        //
        private var _cells:Array;

        // player who made move recorded in this state
        private var _player:uint;

        // The current minmax score for this prospective state, from
        // the vantage point of the player who could achieve it.
        private var _score:Number;

        // The lookahead depth used to calculate the score.
        private var _scoreDepth:int = -1;

        // The pure positional score of this state, not accounting for
        // any future moves.
        private var _positionalScore:Number;

        // The predecessor state of this state.
        private var _parent:GameState;

        // The row and column that were played to achieve this state.
        private var _row:int = -1;
        private var _column:int = -1;

        // If a win state, the axis direction 0..3 along which the win occurred.
        private var _winningAxis:uint;
        
        // Flag indicating that this state's move was made with autoMove enabled.
        public var autoMove:Boolean = false;
                
        // Overall instance count used for reporting
        public static var instanceCount:uint = 0;

        // Cache of GameStates by state key
        public static var entries:Object = {};

        // Cache hit rate.
        public static var cacheHits:uint = 0;
                
        /**
         * Create a new GameState belonging to some Game.
         */
        public function GameState(game:Game)
        {
            instanceCount++;
            _game = game;
        }

        /**
         * Create an initial state for a game with no tokens.
         */
        public static function initialState(game:Game):GameState
        {
            var gs:GameState = new GameState(game);
            gs._cells = new Array(Game.CELLS + (2*Game.COLUMNS));
            for (var i:uint = 0; i < Game.CELLS + Game.COLUMNS; i++)
            {
                gs._cells[i] = 0;
            }
            for (i = Game.CELLS + Game.COLUMNS; i < Game.CELLS + (2*Game.COLUMNS); i++)
            {
                gs._cells[i] = "|";
            }
            gs._positionalScore = 0;
            return gs;   
        }

        /**
         * Get the overall key for this state, for caching purposes.
         */
        public function get key():String
        {
            var k:String = "";
            for (var c:uint = 0; c < Game.COLUMNS; c++)
            {
                k += _cells[Game.CELLS + Game.COLUMNS + c];
            }
            return k;
        }
        
        /**
         * Get the key for a state that would be reached by playing in
         * a particular column from this state.
         */
        private function getKeyForColumn(column:int):String
        {
            var k:String = "";
            for (var c:uint = 0; c < Game.COLUMNS; c++)
            {
                k += _cells[Game.CELLS + Game.COLUMNS + c];
                if (c == column)
                {
                    k += (player == 0) ? 'r' : 'y';
                }
            }
            return k;
        }
        
        /**
         * Obtain a tabula-rasa successor state to this state, to be
         * filled in by calling applyMove().
         */
        private function successor():GameState
        {
            var gs:GameState = new GameState(_game);
            gs._parent = this;
            gs._cells = _cells.slice();
            gs._player = 1 - _player;
            gs._positionalScore = -_positionalScore;
            return gs;
        }

        /**
         * Return the state that will be reached by a play in some
         * column, throwing an error if that column can't be played.
         */
        public function playColumn(column:int):GameState
        {
            var nextRow:int = _cells[Game.CELLS + column];
            if (nextRow >= Game.ROWS)
            {
                throw new Error("attempt to play in out-of-play cell " + row + "," + column);
            }
            var gs:GameState = getNextState(column);
            return gs;
        }
        
        /**
         * Make the best possible move that can be made from this state.
         */
        public function playBestMove():GameState
        {
            if (parent == null)
            {
                // Optimization for the first move of the game!
                return getNextState((Game.COLUMNS - 1) / 2);
            }

            // Look over all the possible successor states, and pick
            // the best one.
            //
            var bestScore:Number = LOSING_SCORE;
            var bestState:GameState = this;
            for (var c:uint = 0; c < Game.COLUMNS; c++)
            {
                var gs:GameState = getNextState(c);
                if (gs)
                {
                    var sc:Number = gs.score;
                    if (bestScore < sc)
                    {
                        bestScore = sc;
                        bestState = gs;
                    }
                }
            }
            
            // TODO: should dither between tied states
            // also better handle case where no moves left.
            return bestState;
        }

        /**
         * Return the state that will be reached by a play in some
         * column.
         */
        public function getNextState(column:int):GameState
        {
            var row:int = _cells[Game.CELLS + column];
            if (row >= Game.ROWS)
            {
                // If no more room in this column, no move!
                return null;
            }
            
            // Try to get a cached state, if we possibly can.
            var k:String = getKeyForColumn(column);
            var cachedState:GameState = entries[k] as GameState;
            if (cachedState)
            {
                cacheHits++;
                cachedState._parent = this;
                cachedState._row = row;
                cachedState._column = column;
                return cachedState;
            }

            // No cached state: create a new one and apply the move,
            // then cache it.
            var gs:GameState = this.successor();
            gs.applyMove(row, column);
            entries[k] = gs;
            return gs;
        }
        
        // Array of weights for positional scoring of run lengths.
        // Note that the weight some run length is greater than the
        // total score of any runs of smaller lengths... in other
        // words, a bunch of 2-token runs is not as important as a
        // single 3-token run.
        private static const RUN_LENGTH_WEIGHTS:Array = [0, 1, 8, 32, 100, 100, 100, 100, 100, 100, 100];

        /**
         * Get the positional score based on a run lengths bit array,
         * encoded as axes 0..3 for player 0, then player 1.
         */
        private function cellScore(axisRuns:uint):Number
        {
            var s:Number = 0;

            s += RUN_LENGTH_WEIGHTS[axisRuns & RUN_LENGTH_MASK];
            axisRuns >>= 3;
            s += RUN_LENGTH_WEIGHTS[axisRuns & RUN_LENGTH_MASK];
            axisRuns >>= 3;
            s += RUN_LENGTH_WEIGHTS[axisRuns & RUN_LENGTH_MASK];
            axisRuns >>= 3;
            s += RUN_LENGTH_WEIGHTS[axisRuns & RUN_LENGTH_MASK];
            axisRuns >>= 3;

            s -= RUN_LENGTH_WEIGHTS[axisRuns & RUN_LENGTH_MASK];
            axisRuns >>= 3;
            s -= RUN_LENGTH_WEIGHTS[axisRuns & RUN_LENGTH_MASK];
            axisRuns >>= 3;
            s -= RUN_LENGTH_WEIGHTS[axisRuns & RUN_LENGTH_MASK];
            axisRuns >>= 3;
            s -= RUN_LENGTH_WEIGHTS[axisRuns & RUN_LENGTH_MASK];

            return (player == 0) ? s : -s;
        }
        
        /**
         * The most important method in this class: apply a move to a state.
         */
        private function applyMove(row:int, column:int):void
        {
            // take note of the move made here
            _row = row;
            _column = column;

            // advance next row for this column
            _cells[Game.CELLS + column]++;

            // update key for this column
            _cells[Game.CELLS + Game.COLUMNS + column] += (player == 0) ? 'y' : 'r';
            
            // remove the cell we just played, but first note what that was there
            var value:Number = _cells[(row * Game.COLUMNS) + column];
            _cells[(row * Game.COLUMNS) + column] = -1 - player;

            // extract the 0..3 and 4..7 directional run chunks and add
            // them to get the axis run lengths
            var chunk03Runs:uint = value & RUN_CHUNK_MASK;
            var chunk47Runs:uint = value / RUN_CHUNK_FACTOR;
            var axisRuns:uint = chunk03Runs + chunk47Runs;
            
            // subtract the score contribution of the deleted cell
            _positionalScore -= cellScore(axisRuns);

            // adjust the axis runs for the played token
            // if we're interested in player 1, then shift all chunks to the right.
            if (player == 1)
            {
                chunk03Runs >>= PLAYER_CHUNK_BITS;
                chunk47Runs >>= PLAYER_CHUNK_BITS;
                axisRuns >>= PLAYER_CHUNK_BITS;
            }
            
            var adjustedAxisRuns:uint = axisRuns + PLAYER_CHUNK_INCREMENT;
            if ((adjustedAxisRuns & PLAYER_CHUNK_WIN) != 0)
            {
                // if we got a run of 4 on any axis, scoring is done
                // and no point in adjusting nearby cells for the play
                _positionalScore = WINNING_SCORE;
                
                for (dir = 0; dir < 4; dir++)
                {
                    if (adjustedAxisRuns & 4)
                    {
                        _winningAxis = dir;
                        break;
                    }
                    adjustedAxisRuns >>= RUN_LENGTH_BITS;
                }
                return;
            }
            
            // update neighboring cells with new run lengths            
            for (var dir:uint = 0; dir < 4; dir++)
            {
                var run03Length:uint = (chunk03Runs & RUN_LENGTH_MASK) + 1;
                var run47Length:uint = (chunk47Runs & RUN_LENGTH_MASK) + 1;
                var dx:int = Game.DELTA_X[dir];
                var dy:int = Game.DELTA_Y[dir];

                // If there is a run of N cells in some direction, then
                // the Nth cell away in that direction gets an increment
                // pointing back towards this cell.
                //
                addToRun(row+(dy*run03Length), column+(dx*run03Length), dir+4, run47Length);
                addToRun(row-(dy*run47Length), column-(dx*run47Length), dir, run03Length);
                chunk03Runs >>= RUN_LENGTH_BITS;
                chunk47Runs >>= RUN_LENGTH_BITS;
            }
        }

        /**
         * Adjust the positionalScore incrementally for a new run length in some
         * direction from the specified cell.
         */
        private function addToRun(row:int, column:int, dir:uint, runLength:uint):void
        {
            if (row >= _cells[Game.CELLS + column] && row < Game.ROWS
                && column >= 0 && column < Game.COLUMNS)
            {
                // There is no token in this cell.  Get its run-length fields.
                var value:Number = _cells[(row * Game.COLUMNS) + column];

                var chunk03Runs:uint = value & RUN_CHUNK_MASK;
                var chunk47Runs:uint = value / RUN_CHUNK_FACTOR;
                var axisRuns:uint = chunk03Runs + chunk47Runs;

                var chunk:uint = (dir < 4) ? chunk03Runs : chunk47Runs;
                value = (dir < 4) ? (value - chunk) : (value & RUN_CHUNK_MASK);

                var shift:uint = ((player*4) + (dir % 4)) * RUN_LENGTH_BITS;
                var mask:uint = RUN_LENGTH_MASK << shift;
                var oldRunLength:uint = (axisRuns & mask) >> shift;
                
                _positionalScore -= RUN_LENGTH_WEIGHTS[oldRunLength];
                _positionalScore += RUN_LENGTH_WEIGHTS[oldRunLength + runLength];

                chunk += runLength << shift;
                value += ((dir < 4) ? chunk : (chunk * RUN_CHUNK_FACTOR));

                _cells[(row * Game.COLUMNS) + column] = value
                // TODO: discounting of cells farther from play
            }
        }

        /**
         * Return the minmax score for this game state.
         */
        public function get score():Number
        {
            return getScoreWithDepth(_game.lookahead);
        }
        
        /**
         * Get the minimax score for this state using the given lookahead depth.
         */
        public function getScoreWithDepth(depth:uint):Number
        {
            if (depth == _scoreDepth)
            {
                // return cached score, if we know it.
                return _score;
            }
            
            if (win || depth == 0)
            {
                // If there are no successor states to care about,
                // the positional score IS the minmax score.
                _score = _positionalScore;
            }
            else
            {                    
                // We're going to look at successors.  First make a
                // quick shallow pass looking for opponent wins, then
                // broaden if we don't find any.
                //
                for (var c:uint = 0; c < Game.COLUMNS; c++)
                {
                    var nextState:GameState = getNextState(c);
                    if (nextState != null && nextState.win)
                    {
                        // We found an opponent win in one move.  So
                        // consider the move score a slightly
                        // discounted lose and stop recursing.
                        //
                        _score = GENERATIONAL_DISCOUNT * LOSING_SCORE;
                        _scoreDepth = depth;
                        return _score;
                    }
                }

                // No immediate losses.  Recurse and get the minimum
                // of the negated score of any successor state.
                // (We're negating because successor states are scored
                // from the opponent's vantage point).
                _score = WINNING_SCORE;
                for (c = 0; _score > LOSING_SCORE && c < Game.COLUMNS; c++)
                {
                    nextState = getNextState(c);
                    if (nextState != null)
                    {
                        _score = Math.min(_score, -nextState.getScoreWithDepth(depth - 1));
                    }
                }

                // This results in geometric unweighting of more
                // distant lookaheads, so that more distant wins are
                // not scored at a par with quicker wins.
                //
                _score *= GENERATIONAL_DISCOUNT;
            }
            _scoreDepth = depth;
            return _score;
        }
        
        /** Determine whether a cell is playable. */
        public function isCellInPlay(row:int, column:int):Boolean
        {
            return (row < Game.ROWS) && (row == _cells[Game.CELLS + column]);
        }

        /** Determine whether a cell was "responsible" for the win in a win state. */
        public function isWinningCell(row:int, column:int):Boolean
        {
            if (!win)
            {
                return false;
            }
            
            if (row == this.row && column == this.column)
            {
                return true;
            }
                    
            // Look for up to 3 cells in either direction along the
            // winning axis in both directions.  This is kind of
            // annoying, but the whole run-length thing is optimized
            // for scoring and determining that a win occurred, rather
            // than determining exactly which cells caused it.
            //
            for (var i:int = 1; i <= 3; i++)
            {
                var r:int = this.row + i*Game.DELTA_Y[_winningAxis];
                var c:int = this.column + i*Game.DELTA_X[_winningAxis];
                if (getCellPlayer(r, c) != player)
                {
                    break;
                }
                if (row == r && column == c) 
                {
                    return true;
                }
            }
            
            for (i= 1; i <= 3; i++)
            {
                r = this.row - i*Game.DELTA_Y[_winningAxis];
                c = this.column - i*Game.DELTA_X[_winningAxis];
                if (getCellPlayer(r, c) != player)
                {
                    break;
                }
                if (row == r && column == c) 
                {
                    return true;
                }
            }

            return false;
        }
            
        /**
         * Return the token player for some cell, or -1 if there isn't any.
         */
        public function getCellPlayer(row:int, column:int):int
        {
            var value:Number = _cells[(row * Game.COLUMNS) + column];
            if (value < 0)
            {
                return -value - 1;
            }
            return -1;
        }
                
        // run length is negative if for player 1
        public function getRun(row:int, column:int, dir:uint):int
        {
            var value:Number = _cells[(row * Game.COLUMNS) + column];
            var chunk:uint = (dir < 4) ? (value & RUN_CHUNK_MASK) : (value / RUN_CHUNK_FACTOR);
            var shift:uint = (dir % 4) * RUN_LENGTH_BITS;
            var mask:uint = RUN_LENGTH_MASK << shift;
            var runLength:int = (chunk & mask) >> shift;
            chunk >>= PLAYER_CHUNK_BITS;
            runLength -= (chunk & mask) >> shift;
            return runLength;
        }

        public function get player():uint
        {
            return _player;
        }

        public function get win():Boolean
        {
            return _positionalScore >= WINNING_SCORE;
        }
                
        public function get parent():GameState
        {
            return _parent;
        }
        
        public function get row():int
        {
            return _row;
        }
        
        public function get column():int
        {
            return _column;
        }
    }
}
