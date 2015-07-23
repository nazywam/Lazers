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
	
	var currentLaserId:Int = 0;

	var board:Array<Array<Tile>>;
	var lasers:FlxTypedGroup<Laser>;

	var availableTiles:FlxTypedGroup<Tile>;

	var pressedTile:Tile;
	var pressed:Bool=false;

	override public function create():Void {
		super.create();

		board = new Array<Array<Tile>>();
		for(i in 0...Settings.BOARD_HEIGHT){
			board[i] = new Array<Tile>();
			for(j in 0...Settings.BOARD_WIDTH){
				var possibleId = 0;
				if(Std.random(4) == 0){
					possibleId = Std.random(3);
				}

				board[i][j] = new Tile(j*Settings.TILE_WIDTH, i*Settings.TILE_HEIGHT, possibleId);
				add(board[i][j]);
			}
		}

		availableTiles = new FlxTypedGroup<Tile>();
		add(availableTiles);

		lasers = new FlxTypedGroup<Laser>();
		add(lasers);

		for (i in 0...8) {
			var t = new Tile(Settings.TILE_WIDTH * Settings.BOARD_WIDTH + 20, i*40, Std.random(3));
			availableTiles.add(t);
		}
		
 	}

 	function inBounds(_x:Int, _y:Int):Bool {
 		return (_x >= 0 && _x < Settings.BOARD_WIDTH) && (_y >= 0 && _y < Settings.BOARD_HEIGHT);
 	}

 	function handleMouse(){
		if(FlxG.mouse.justPressed){
			if(inBounds(Std.int(FlxG.mouse.x/Settings.TILE_WIDTH), Std.int(FlxG.mouse.y/Settings.TILE_HEIGHT))){
				var l = new Laser(Std.int(FlxG.mouse.x / Settings.TILE_WIDTH)* Settings.TILE_HEIGHT, Std.int(FlxG.mouse.y / Settings.TILE_HEIGHT)* Settings.TILE_HEIGHT, FlxObject.UP, currentLaserId, Std.random(0xFFFFFF) + 0xFF000000);
				lasers.add(l);
				currentLaserId++;
			} else {
				for(t in availableTiles){
					if(FlxG.mouse.overlaps(t)){
						pressed = true;
						pressedTile = t;
					}
				}
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

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		handleMouse();
		

		for(l in lasers){
			if(l.head){
				l.head = false;

				var _moveX:Int;
				var _moveY:Int;
				_moveX = _moveY = 0;


				var currentTile = board[Std.int(l.y/Settings.TILE_HEIGHT)][Std.int(l.x/Settings.TILE_WIDTH)];
				currentTile.color = FlxColor.RED;
				
				var nextDirection:Int = l.direction;

				switch (l.direction) {
					case FlxObject.UP:
						switch (currentTile.type) {
							case 0:
								nextDirection = l.direction;
								_moveX = 0;
								_moveY = -1;
							case 1:
								nextDirection = FlxObject.RIGHT;
								_moveX = 1;
								_moveY = 0;
							case 2:
								nextDirection = FlxObject.LEFT;
								_moveX = -1;
								_moveY = 0;
						}
					case FlxObject.RIGHT:
						switch(currentTile.type){
							case 0:
								nextDirection = l.direction;
								_moveX = 1;
								_moveY = 0;
							case 1:
								nextDirection = FlxObject.UP;
								_moveX = 0;
								_moveY = -1;
							case 2:
								nextDirection = FlxObject.DOWN;
								_moveX = 0;
								_moveY = 1;
						}
						
					case FlxObject.DOWN:
						switch (currentTile.type) {
							case 0:
								nextDirection = l.direction;
								_moveX = 0;
								_moveY = 1;
							case 1:
								nextDirection = FlxObject.LEFT;
								_moveX = -1;
								_moveY = 0;
							case 2:
								nextDirection = FlxObject.RIGHT;
								_moveX = 1;
								_moveY = 0;
						}
					case FlxObject.LEFT:
						switch (currentTile.type) {
							case 0:
								nextDirection = l.direction;
								_moveX = -1;
								_moveY = 0;
							case 1:
								nextDirection = FlxObject.DOWN;
								_moveX = 0;
								_moveY = 1;
							case 2:
								nextDirection = FlxObject.UP;
								_moveX = 0;
								_moveY = -1;
						}
				}



				if (inBounds(Std.int(l.x/Settings.TILE_WIDTH) + _moveX, Std.int(l.y/Settings.TILE_HEIGHT) + _moveY)){

					var uniqueLaser:Bool = true;
					for(laser in lasers){
						if(laser.x == l.x + _moveX*Settings.TILE_WIDTH && laser.y == l.y + _moveY*Settings.TILE_HEIGHT && laser.direction == nextDirection && l.ID == laser.ID){
							uniqueLaser = false;
						}
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