package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import openfl.Assets;
import flixel.util.FlxTimer;

class PlayState extends FlxState {

	var currentLevel:Int;
	
	var currentLaserId:Int = 0;

	var board:Array<Array<Tile>>;
	var originalBoard:Array<Array<Tile>>;
	var boardColors:Array<Array<Int>>;
	
	var lasers:FlxTypedGroup<Laser>;
	var laserHeads:FlxTypedGroup<Laser>;

	var availableTiles:FlxTypedGroup<Tile>;

	var pressedTile:Tile;
	var pressed:Bool=false;

	var fireButton:FlxSprite;	
	var menuButton:FlxSprite;
	var avaibleTilesBackground:FlxSprite;
	
	override public function new(_c:Int) {
		currentLevel = _c;
		super();
	}
	
	override public function create():Void {
		super.create();
		
		avaibleTilesBackground = new FlxSprite(0, Settings.TILE_HEIGHT * Settings.BOARD_HEIGHT, "assets/images/AvailableTiles.png");
		add(avaibleTilesBackground);
		
		if (Assets.getText("assets/data/level"+Std.string(currentLevel)+".tmx") == null) {
			loadMap(Assets.getText("assets/data/404.tmx"));
		} else {
			loadMap(Assets.getText("assets/data/level" + Std.string(currentLevel) + ".tmx"));	
		}


		lasers = new FlxTypedGroup<Laser>();
		laserHeads = new FlxTypedGroup<Laser>();
		add(lasers);
		
		fireButton = new FlxSprite(FlxG.width / 2, avaibleTilesBackground.y + avaibleTilesBackground.height, "assets/images/FireButton.png");
		fireButton.x -= fireButton.width / 2;
		add(fireButton);
		
		menuButton = new FlxSprite(fireButton.x, fireButton.y + fireButton.height, "assets/images/MenuButton.png");
		add(menuButton);
 	}
	
	function isNumeric(str:String):Bool {
		for (i in 0...str.length) {				
			if (str.charCodeAt(i) >= '0'.charCodeAt(0) && str.charCodeAt(i) <= '9'.charCodeAt(0)) {
				return true;
			}
		}
		return false;
	}
	

 	function loadMap(mapText:String):Void {
 		var xml = Xml.parse(mapText).firstElement();
		
		board = new Array<Array<Tile>>();
		originalBoard = new Array<Array<Tile>>();
		boardColors = new Array<Array<Int>>();
		
		
		for (layer in xml.elementsNamed("layer") ) {
			
	        for(e in layer.elementsNamed("data")){
	        	for(l in 0...e.firstChild().nodeValue.split('\n').length){
	        		var line = e.firstChild().nodeValue.split('\n')[l];

					switch(layer.get("name")) {
								case "Colors":
									boardColors[l-1] = new Array<Int>();

									for(t in 0...line.split(',').length){
										var tile = line.split(',')[t];

										if (isNumeric(tile)) {
											boardColors[l - 1][t] = Std.parseInt(tile) - 41;
										}
									}
							case "Tiles":
								board[l-1] = new Array<Tile>();
								originalBoard[l-1] = new Array<Tile>();

								for(t in 0...line.split(',').length){
									var tile = line.split(',')[t];

									if (isNumeric(tile)) {
										board[l - 1][t] = new Tile(t * Settings.TILE_WIDTH, (l - 1) * Settings.TILE_HEIGHT, Std.parseInt(tile) - 1, false);
										originalBoard[l-1][t] = board[l-1][t];
										add(board[l - 1][t]);
									}
								}
						}
	        	}
	        }
	    }

		availableTiles = new FlxTypedGroup<Tile>();
		add(availableTiles);
		
		for (props in xml.elementsNamed("properties")) {
			for (p in props.elementsNamed("property")) {
				var avail = p.get("value").split(',');
				for (i in 0...avail.length) {
					var a = new Tile(avaibleTilesBackground.x + 11 + i*58, avaibleTilesBackground.y + 10, Std.parseInt(avail[i]), true);
					availableTiles.add(a);
					
				}
			}
		}
 	}


 	function inBounds(_x:Int, _y:Int):Bool {
 		return (_x >= 0 && _x < Settings.BOARD_WIDTH) && (_y >= 0 && _y < Settings.BOARD_HEIGHT);
 	}

 	function handleMouse() {
			
		
		if(FlxG.mouse.justPressed){
			var pressedX:Int = Std.int(FlxG.mouse.x/Settings.TILE_WIDTH);
			var pressedY:Int = Std.int(FlxG.mouse.y/Settings.TILE_HEIGHT);


			for(t in availableTiles){
				if(FlxG.mouse.overlaps(t)){
					pressed = true;
					pressedTile = t;

					FlxTween.tween(pressedTile.scale, {x:1.2, y:1.2}, .1, {ease:FlxEase.quadInOut});


					if(inBounds(pressedX, pressedY)){
						board[pressedY][pressedX] = originalBoard[pressedY][pressedX];
					}
				}
			}
			
			if (FlxG.mouse.overlaps(fireButton)) {
				generateLasers();
			}
			
			if (FlxG.mouse.overlaps(menuButton)) {
				FlxG.switchState(new MenuState());
			}
		}

		if(pressed){
			pressedTile.x = FlxG.mouse.x - pressedTile.width/2;
			pressedTile.y = FlxG.mouse.y - pressedTile.height/2;
		}

		if(FlxG.mouse.justReleased && pressed){
			pressed = false;

			var possibleX:Int = Std.int(FlxG.mouse.x/Settings.TILE_WIDTH);
			var possibleY:Int = Std.int(FlxG.mouse.y/Settings.TILE_HEIGHT);

				FlxTween.tween(pressedTile.scale, {x:1, y:1}, .1, {ease:FlxEase.quadIn});

			if(inBounds(possibleX, possibleY) && !board[possibleY][possibleX].movable){
				board[Std.int(FlxG.mouse.y/Settings.TILE_HEIGHT)][Std.int(FlxG.mouse.x/Settings.TILE_WIDTH)] = pressedTile;
				pressedTile.x = Std.int(FlxG.mouse.x/Settings.TILE_WIDTH)*Settings.TILE_WIDTH;
				pressedTile.y = Std.int(FlxG.mouse.y/Settings.TILE_HEIGHT)*Settings.TILE_HEIGHT;
			} else {

				FlxTween.tween(pressedTile, {x:pressedTile.originalPosition.x, y:pressedTile.originalPosition.y}, .5, {ease:FlxEase.quadIn});
			}
		}
 	}

 	function fireLaser(t:Tile){

		var possibleX:Int = Std.int(t.x/Settings.TILE_WIDTH);
		var possibleY:Int = Std.int(t.y/Settings.TILE_HEIGHT);

		
		var l = new Laser(t.x, t.y, t.direction, currentLaserId, Settings.AVAILABLE_COLORS[boardColors[possibleY][possibleX]], board[possibleY][possibleX]);
		lasers.add(l);
		currentLaserId++;	
		
		l.becomeHead.start(Settings.LASER_SPEED, function(_){
			laserHeads.add(l);
		});
 	}

 	function generateLasers(){

		for (l in lasers) {
			if (l.becomeHead.active) {
				l.becomeHead.cancel();
			}
		}
		
		laserHeads.clear();
		lasers.clear();
		
 		for(j in 0...board.length){
 			for(i in 0...board[j].length){
 				var t = board[j][i];
				if(t.type == Tile.SOURCE_UP || t.type == Tile.SOURCE_LEFT || t.type == Tile.SOURCE_DOWN || t.type == Tile.SOURCE_RIGHT){
					fireLaser(t);
				}
 			}
 		}
 	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		handleMouse();
		
		if (FlxG.keys.justPressed.ESCAPE) {
			FlxG.switchState(new MenuState());
		}

		
		for (l in laserHeads) {
			
				var _moveX:Int = 0;
				var _moveY:Int = 0;

				var currentTile = board[Std.int(l.y/Settings.TILE_HEIGHT)][Std.int(l.x/Settings.TILE_WIDTH)];
				//currentTile.color = l.color;
				
				var nextDirection:Int = l.direction;

				switch (currentTile.type) {
					case Tile.SOURCE_UP:
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
					case Tile.SOURCE_RIGHT:
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
					case Tile.SOURCE_DOWN:				
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
					case Tile.SOURCE_LEFT:
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

				var possibleX:Int = Std.int(l.x / Settings.TILE_WIDTH) + _moveX;
				var possibleY:Int = Std.int(l.y / Settings.TILE_HEIGHT) + _moveY;

				if (inBounds(possibleX, possibleY)){
					var uniqueLaser:Bool = true;
					for(laser in lasers){
						if(laser.x == possibleX*Settings.TILE_WIDTH && laser.y == possibleY*Settings.TILE_HEIGHT && laser.direction == nextDirection && l.ID == laser.ID){
							uniqueLaser = false;
						}
					}

					if(board[possibleY][possibleX].type == Tile.BLOCK || board[possibleY][possibleX].type == Tile.SOURCE_UP || board[possibleY][possibleX].type == Tile.SOURCE_RIGHT || board[possibleY][possibleX].type == Tile.SOURCE_DOWN || board[possibleY][possibleX].type == Tile.SOURCE_LEFT){
						uniqueLaser = false;
					}

					if(uniqueLaser){
						var laser = new Laser(l.x + _moveX*Settings.TILE_WIDTH, l.y + _moveY*Settings.TILE_HEIGHT, nextDirection, l.ID, l.color, board[possibleY][possibleX]);
						lasers.add(laser);	
						
						laser.becomeHead.start(Settings.LASER_SPEED, function(_){
							laserHeads.add(laser);
						});
					}
				}
				
				laserHeads.remove(l);
				
			}
		}
}