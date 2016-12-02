package Plugins.games.Breakout.lib {                                    
    import flash.display.*;
    import flash.events.*;
    import flash.ui.Mouse;
    import flash.utils.*;
    
    import mx.core.UIComponent;

    public class MyGameCanvas extends UIComponent 
    {
        // Gameplay constants
        private var TIMER_SPEED:int=15;
        private var NUM_BLOCK_ROWS:int = 5;
        private var NUM_BLOCK_COLS:int = 10;
        private var BLOCK_GUTTER_X:int = 4;
        private var BLOCK_GUTTER_Y:int = 4;
        private var BLOCK_FIELD_Y:int = 30;
        private var BALL_RADIUS:Number = 10.0;
        private var PADDLE_DIST_FROM_BOTTOM:int = 40;
        private var PADDLE_WIDTH:int = 40;
        private var PADDLE_HEIGHT:int = 8;
        private var INITIAL_BALL_SPEED:Number = .2 * TIMER_SPEED;

    
        // Sprites
        private var blocks:Array = new Array(0);
        private var ball:Sprite = new Sprite();
        private var paddle:Sprite = new Sprite();

        private var ball_dx:Number;
        private var ball_dy:Number;
        private var ball_speed:Number;
        private var lives:int = 3;

        private var ticker:Timer;

        // Embed our images
        [Embed(source="gold_block.jpg")]
        private var GoldBlock:Class;

        [Embed(source="red_block.jpg")]
        private var RedBlock:Class;

        [Embed(source="blue_block.jpg")]
        private var BlueBlock:Class;

        // Put these image classes into one array for easy access
        private var allBlocks:Array = new Array(GoldBlock, RedBlock, BlueBlock);
		private function mouseMoveHandler(event:MouseEvent):void {
			paddle.x = this.mouseX;
            paddle.y = height - PADDLE_DIST_FROM_BOTTOM;
		}

  
        public function init():void 
        {
        	this.parent.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
            // set up ball
            ball.graphics.beginFill(0xee00ee);
            ball.graphics.drawCircle(0, 0, BALL_RADIUS);
            ball.graphics.endFill();
            addChild(ball);
            resetBall();            // places the ball in a starting location

            // set up paddle sprite
            paddle.graphics.beginFill(0x000000);
            paddle.graphics.drawRect(-PADDLE_WIDTH/2, -PADDLE_HEIGHT/2, PADDLE_WIDTH, PADDLE_HEIGHT);
            paddle.graphics.endFill();

            paddle.y = height - PADDLE_DIST_FROM_BOTTOM;
            addChild(paddle);

            // Figure out some metrics for placing the blocks
            var reference_block:DisplayObject = new GoldBlock();

            var block_field_width:int = NUM_BLOCK_COLS * reference_block.width
                + (NUM_BLOCK_COLS-1)*BLOCK_GUTTER_X;
            var block_field_x:int = (width - block_field_width) / 2;

            var current_block_index:int = 0;

            // Create and position the blocks
            for (var x:int = 0; x < NUM_BLOCK_COLS; x++)
            {
                for (var y:int = 0; y < NUM_BLOCK_ROWS; y++)
                {
                    // Create a new Block object
                    var current_image:Class = allBlocks[current_block_index];
                    var sprite:DisplayObject = new current_image();

                    // Create sprite, position it, and add it to the display list.
                    sprite.x = block_field_x + x * (reference_block.width + BLOCK_GUTTER_X);
                    sprite.y = BLOCK_FIELD_Y + y * (reference_block.height + BLOCK_GUTTER_Y);

                    addChild(sprite);

                    // Add the Block to our list
                    blocks.push(sprite);

                    // This piece of code causes us to cycle through the available block images.
                    current_block_index++;
                    if (current_block_index >= allBlocks.length)
                        current_block_index = 0;
                }
            }


            // Create a Timer object, tell it to call our onTick method, and start it
            ticker = new Timer(10); 
            ticker.addEventListener(TimerEvent.TIMER, onTick);
            ticker.start();
        }
		

        
        public function onTick(evt:TimerEvent):void 
        {
            // Place the paddle (based on mouse location)
          
          


            // Check paddle collision with ball
            if (ball.hitTestObject(paddle))
            {
                // Adjust X momentum of ball based on where on the paddle we hit
                var new_ball_dx:Number = (ball.x - paddle.x) / (PADDLE_WIDTH/2.0)
                    * INITIAL_BALL_SPEED;

                // Blend this new momentum with the old
                ball_dx = (ball_dx + new_ball_dx) / 2;
                ball_dy = -ball_dy;
            }
    
            // Check collision with every block
            for (var i:int = 0; i < blocks.length; i++)
            {
                var block:DisplayObject = blocks[i];
                if (block == null) continue;

                // Check collision
                if (ball.hitTestObject(block))
                {
                    // We collided, remove this sprite
                    removeChild(block);
                    blocks[i] = null;

                    // Figure out which way the ball should bounce
                    var ball_distance_norm_x:int = (ball.x - block.x) / block.width;
                    var ball_distance_norm_y:int = (ball.y - block.y) / block.height;

                    // Don't bounce in a direction that the ball is already going
                    if (ball_distance_norm_x * ball_dx > 0)
                        ball_dy = -ball_dy;
                    else if (ball_distance_norm_y * ball_dy > 0)
                        ball_dx = -ball_dx;
                   
                    // If we get here then either bounce is valid, pick one based on ball loc
                    else if (ball_distance_norm_x > ball_distance_norm_y)
                        ball_dx = -ball_dx;
                    else
                        ball_dy = -ball_dy;
    
                    // Increase ball speed by 2.5% to make things interesting!
                    ball_dx *= 1.025;
                    ball_dy *= 1.025;
                }
            }

            // Check collision with sides of screen
            if (ball.x - BALL_RADIUS < 0) ball_dx = Math.abs(ball_dx);
            if (ball.x + BALL_RADIUS > width) ball_dx = -Math.abs(ball_dx);
            if (ball.y - BALL_RADIUS < 0) ball_dy = Math.abs(ball_dy);

            // Check if ball was lost
            if (ball.y - BALL_RADIUS > height)
            {
                if (lives > 0) lives -= 1;
                resetBall();
                // todo: check for game over
            }

            // Move ball
            ball.x += ball_dx;
            ball.y += ball_dy;

        }

        public function resetBall():void
        {
            ball.x = .25 * width;
            ball.y = .5 * height;
            ball_dx = INITIAL_BALL_SPEED * .70;
            ball_dy = INITIAL_BALL_SPEED * .70;
        }

    }
}

