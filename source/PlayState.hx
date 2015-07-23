package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxObject;
import flixel.util.FlxColor;

class PlayState extends FlxState {
	
	var map:Array<Array<Int>> = 
[[2,1,1,1,1,1,1,3],
[1,2,1,1,1,1,3,1],
[1,1,2,1,1,3,1,1],
[1,1,1,2,3,1,1,1],
[1,1,1,1,1,1,1,1],
[1,1,1,3,1,2,1,1],
[1,1,3,1,1,1,2,1],
[5,3,1,1,1,1,1,2]];

	var currentLaserId:Int = 0;

	var board:Array<Array<Tile>>;
	var originalBoard:Array<Array<Tile>>;

	var lasers:FlxTypedGroup<Laser>;

	var availableTiles:FlxTypedGroup<Tile>;

	var pressedTile:Tile;
	var pressed:Bool=false;

	override public function create():Void {
		super.create();

		loadMap(map);

		availableTiles = new FlxTypedGroup<Tile>();
		add(availableTiles);

		lasers = new FlxTypedGroup<Laser>();
		add(lasers);

		for (i in 0...8) {
			var t = new Tile(Settings.TILE_WIDTH * Settings.BOARD_WIDTH + 20, i*40, Std.random(4), true, FlxObject.UP);
			availableTiles.add(t);
		}
		
 	}

 	function loadMap(map:Array<Array<Int>>){
 		board = new Array<Array<Tile>>();
		originalBoard = new Array<Array<Tile>>();


		for(i in 0...map.length){
			board[i] = new Array<Tile>();
			originalBoard[i] = new Array<Tile>();
			for(j in 0...map[i].length){
				board[i][j] = new Tile(j*Settings.TILE_WIDTH, i*Settings.TILE_HEIGHT, map[i][j]-1, false, FlxObject.UP);
				originalBoard[i][j] = board[i][j];
				add(board[i][j]);
			}
		}
 	}


 	function inBounds(_x:Int, _y:Int):Bool {
 		return (_x >= 0 && _x < Settings.BOARD_WIDTH) && (_y >= 0 && _y < Settings.BOARD_HEIGHT);
 	}

 	function handleMouse(){
		if(FlxG.mouse.justPressed){
			var pressedX:Int = Std.int(FlxG.mouse.x/Settings.TILE_WIDTH);
			var pressedY:Int = Std.int(FlxG.mouse.y/Settings.TILE_HEIGHT);


			for(t in availableTiles){
				if(FlxG.mouse.overlaps(t)){
					pressed = true;
					pressedTile = t;

					if(inBounds(pressedX, pressedY)){
						board[pressedY][pressedX] = originalBoard[pressedY][pressedX];
					}
				}
			}

			if(inBounds(pressedX, pressedY) && !pressed){
				var l = new Laser(Std.int(FlxG.mouse.x / Settings.TILE_WIDTH)* Settings.TILE_HEIGHT, Std.int(FlxG.mouse.y / Settings.TILE_HEIGHT)* Settings.TILE_HEIGHT, FlxObject.UP, currentLaserId, Std.random(0xFFFFFF) + 0xFF000000);
				lasers.add(l);
				currentLaserId++;
			}			
		}

		if(pressed){
			pressedTile.x = FlxG.mouse.x - pressedTile.width/2;
			pressedTile.y = FlxG.mouse.y - pressedTile.height/2;
		}

		if(FlxG.mouse.justReleased && pressed){
			pressed = false;

			if(inBounds(Std.int(FlxG.mouse.x/Settings.TILE_WIDTH), Std.int(FlxG.mouse.y/Settings.TILE_HEIGHT))){
				board[Std.int(FlxG.mouse.y/Settings.TILE_HEIGHT)][Std.int(FlxG.mouse.x/Settings.TILE_WIDTH)] = pressedTile;
				pressedTile.x = Std.int(FlxG.mouse.x/Settings.TILE_WIDTH)*Settings.TILE_WIDTH;
				pressedTile.y = Std.int(FlxG.mouse.y/Settings.TILE_HEIGHT)*Settings.TILE_HEIGHT;
			} else {
				pressedTile.x = pressedTile.originalPosition.x;
				pressedTile.y = pressedTile.originalPosition.y;
			}
		}
 	}

 	function generateLasers(){
 		for(j in 0...board.length){
 			for(i in 0...board[j].length){
 				var t = board[j][i];
	 			if(t.type == Tile.SOURCE){
	 				var moveX:Int = 0;
	 				var moveY:Int = 0;


	 				switch (t.direction) {
	 					case FlxObject.UP:
	 						moveX = 0;
	 						moveY = -1;
	 					case FlxObject.RIGHT:
							moveX = 1;
	 						moveY = 0;
	 					case FlxObject.DOWN:
							moveX = 0;
	 						moveY = 1;
	 					case FlxObject.LEFT:
							moveX = -1;
	 						moveY = 0;
	 				}
	 				var possibleX:Int = Std.int(t.x/Settings.TILE_WIDTH) + moveX;
	 				var possibleY:Int = Std.int(t.y/Settings.TILE_HEIGHT) + moveY;

	 				if(inBounds(possibleX, possibleY) && board[possibleY][possibleX].type != Tile.BLOCK && board[possibleY][possibleX].type != Tile.SOURCE){
	 					var l = new Laser(t.x + moveX * Settings.TILE_WIDTH, t.y + moveY * Settings.TILE_HEIGHT, t.direction, currentLaserId, Std.random(0xFFFFFF) + 0xFF000000);
		 				lasers.add(l);

		 				currentLaserId++;	
	 				}
 				}		
 			}
 		}
 	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		handleMouse();

		if(FlxG.keys.justPressed.L){
			lasers.clear();
			generateLasers();
		}


		for(l in lasers){
			if(l.head){
				l.head = false;

				var _moveX:Int;
				var _moveY:Int;
				_moveX = _moveY = 0;

				var currentTile = board[Std.int(l.y/Settings.TILE_HEIGHT)][Std.int(l.x/Settings.TILE_WIDTH)];
				//currentTile.color = l.color;
				
				var nextDirection:Int = l.direction;

				switch (currentTile.type){
					case Tile.BLANK:
						switch (l.direction) {
							case FlxObject.UP:
								nextDirection = l.direction;
								_moveX = 0;
								_moveY = -1;
							case FlxObject.RIGHT:
								nextDirection = l.direction;
								_moveX = 1;
								_moveY = 0;
							case FlxObject.DOWN:
								nextDirection = l.direction;
								_moveX = 0;
								_moveY = 1;
							case FlxObject.LEFT:
								nextDirection = l.direction;
								_moveX = -1;
								_moveY = 0;
						}
					case Tile.MIRROR:
						switch (l.direction) {
							case FlxObject.UP:
								nextDirection = FlxObject.RIGHT;
								_moveX = 1;
								_moveY = 0;
							case FlxObject.RIGHT:
								nextDirection = FlxObject.UP;
								_moveX = 0;
								_moveY = -1;
							case FlxObject.DOWN:
								nextDirection = FlxObject.LEFT;
								_moveX = -1;
								_moveY = 0;
							case FlxObject.LEFT:
								nextDirection = FlxObject.DOWN;
								_moveX = 0;
								_moveY = 1;
						}
					case Tile.BACK_MIRROR:
						switch (l.direction) {
							case FlxObject.UP:
								nextDirection = FlxObject.LEFT;
								_moveX = -1;
								_moveY = 0;
							case FlxObject.RIGHT:
								nextDirection = FlxObject.DOWN;
								_moveX = 0;
								_moveY = 1;
							case FlxObject.DOWN:
								nextDirection = FlxObject.RIGHT;
								_moveX = 1;
								_moveY = 0;
							case FlxObject.LEFT:
								nextDirection = FlxObject.UP;
								_moveX = 0;
								_moveY = -1;
						}
				}

				if (inBounds(Std.int(l.x / Settings.TILE_WIDTH) + _moveX, Std.int(l.y / Settings.TILE_HEIGHT) + _moveY)){
					var uniqueLaser:Bool = true;
					for(laser in lasers){
						if(laser.x == l.x + _moveX*Settings.TILE_WIDTH && laser.y == l.y + _moveY*Settings.TILE_HEIGHT && laser.direction == nextDirection && l.ID == laser.ID){
							uniqueLaser = false;
						}
					}

					if(board[Std.int(l.y/Settings.TILE_HEIGHT) + _moveY][Std.int(l.x/Settings.TILE_WIDTH) + _moveX].type == Tile.BLOCK || board[Std.int(l.y/Settings.TILE_HEIGHT) + _moveY][Std.int(l.x/Settings.TILE_WIDTH) + _moveX].type == Tile.SOURCE){
						uniqueLaser = false;
					}

					if(uniqueLaser){
						var laser = new Laser(l.x + _moveX*Settings.TILE_WIDTH, l.y + _moveY*Settings.TILE_HEIGHT, nextDirection, l.ID, l.color);
						lasers.add(laser);	
					}
				}
			}
		}
	}	
}