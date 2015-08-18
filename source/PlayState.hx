package;

import flixel.addons.transition.FlxTransitionSprite;
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
import openfl.display.BlendMode;
import flixel.effects.particles.FlxEmitter;
import flixel.addons.effects.FlxWaveSprite;
import flixel.addons.display.FlxBackdrop;

class PlayState extends FlxState {

	var currentLevel:Int;
	
	var currentLaserId:Int = 0;

	var board:Array<Array<Tile>>;
	var originalBoard:Array<Array<Tile>>;
	var boardColors:Array<Array<Int>>;
	
	var lasers:FlxTypedGroup<Laser>;
	var laserHeads:FlxTypedGroup<Laser>;
	var particles:FlxTypedGroup<FlxEmitter>;
	var availableTiles:FlxTypedGroup<Tile>;

	var pressedTile:Tile;
	var pressed:Bool=false;

	var fireButton:FlxSprite;	
	var menuButton:FlxSprite;
	var avaibleTilesBackground:FlxSprite;
	
	var transitionScreen:TransitionScreen;
	
	var levelComplete:Bool = false;
	
	var grid:FlxSprite;
	
	override public function new(_c:Int) {
		currentLevel = _c;
		super();
	}
	
	override public function create():Void {
		super.create();
		FlxG.camera.bgColor = 0xFF326f2c;
		
		grid = new FlxSprite(0, 0, "assets/images/Grid.png");
		add(grid);
		
		avaibleTilesBackground = new FlxSprite(0, grid.y+grid.width, "assets/images/AvailableTiles.png");
		add(avaibleTilesBackground);
		
		
		
		if (Assets.getText("assets/data/level"+Std.string(currentLevel)+".tmx") == null) {
			loadMap(Assets.getText("assets/data/404.tmx"));
		} else {
			loadMap(Assets.getText("assets/data/level" + Std.string(currentLevel) + ".tmx"));	
		}

		
		
		lasers = new FlxTypedGroup<Laser>();
		particles = new FlxTypedGroup<FlxEmitter>();
		laserHeads = new FlxTypedGroup<Laser>();
		add(lasers);
		
		fireButton = new FlxSprite(FlxG.width / 2, avaibleTilesBackground.y + avaibleTilesBackground.height, "assets/images/FireButton.png");
		fireButton.x -= fireButton.width / 2;
		add(fireButton);
		
		menuButton = new FlxSprite(fireButton.x, fireButton.y + fireButton.height, "assets/images/MenuButton.png");
		add(menuButton);
		
		add(particles);
	
		
		transitionScreen = new TransitionScreen();
		transitionScreen.setupHalf();
		transitionScreen.startHalf();
		add(transitionScreen);
		
		
	
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
										board[l - 1][t] = new Tile(t * (Settings.TILE_WIDTH + Settings.GRID_WIDTH) +  Settings.BOARD_OFFSET.x, (l - 1) * (Settings.TILE_HEIGHT + Settings.GRID_WIDTH) + Settings.BOARD_OFFSET.y, Std.parseInt(tile) - 1, false, boardColors[l-1][t], t, l-1);
										originalBoard[l-1][t] = board[l-1][t];
										add(board[l - 1][t]);
										
										if (Settings.FUN) {
											var t = new FlxWaveSprite(board[l - 1][t]);
											t.strength = 35;
											t.speed = 15;
											add(t);
										}
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
					var a = new Tile(avaibleTilesBackground.x + 11 + i*58, avaibleTilesBackground.y + 10, Std.parseInt(avail[i]), true, 0, -1, -1);
					availableTiles.add(a);
				}
			}
		}
 	}


 	function getTile(_b : Array<Array<Tile>>, _x:Float, _y:Float):Tile {
		for (j in 0..._b.length) {
			for (i in 0..._b[j].length) {
				var currentTile = _b[j][i];
				if (currentTile.x-3 <= _x && currentTile.y - 3 <= _y && currentTile.x + currentTile.width +1 >= _x && currentTile.y + currentTile.height + 1 >= _y) {
					return _b[j][i];	
				}
			}
		}
		
		return null;
 	}

	function sortAvailableTiles(order:Int, t1:Tile, t2:Tile) {
		if (pressedTile == t2) {
			return order;	
		}
		return -order;
	}
	
 	function handleMouse() {
			
		
		if(FlxG.mouse.justPressed){
			var pressedX:Int = Std.int(FlxG.mouse.x/Settings.TILE_WIDTH);
			var pressedY:Int = Std.int(FlxG.mouse.y/Settings.TILE_HEIGHT);
			

			for(t in availableTiles){
				if (FlxG.mouse.overlaps(t)) {

					for(l in lasers){
						l.becomeHead.cancel();
					}

					laserHeads.clear();
					lasers.clear();
					particles.clear();					

					
					pressed = true;
					pressedTile = t;

					FlxTween.tween(pressedTile.scale, {x:1.1, y:1.1}, .1, {ease:FlxEase.quadInOut});
					
					var hoverTile = getTile(board, FlxG.mouse.x, FlxG.mouse.y);
					
					if (hoverTile != null) {
						board[hoverTile.boardY][hoverTile.boardX] = getTile(originalBoard, hoverTile.x, hoverTile.y);
					}
				}
				
				availableTiles.sort(sortAvailableTiles);
			}
			
			if (FlxG.mouse.overlaps(fireButton)) {
				if (levelComplete) {
					transitionScreen.setup();
					transitionScreen.start();
					
					var t = new FlxTimer();
					t.start(1.22, function(_) {
						FlxG.switchState(new PlayState(currentLevel+1));	
					});
					
					
				} else {
					generateLasers();	
				}
				
			}
			
			if (FlxG.mouse.overlaps(menuButton)) {
				FlxG.switchState(new MenuState());
			}
		}

		if(pressed){
			pressedTile.x = FlxG.mouse.x - pressedTile.width/2;
			pressedTile.y = FlxG.mouse.y - pressedTile.height / 2;
			
			
			var hoverTile = getTile(board, FlxG.mouse.x, FlxG.mouse.y);
			if (hoverTile != null) {
				if (hoverTile.type == Tile.BLANK) {
					hoverTile.color = 0xFF00FF00;	
				} else {
					hoverTile.color = 0xFFFF0000;	
				}
				
			}
		}

		if(FlxG.mouse.justReleased && pressed){
			pressed = false;

			FlxTween.tween(pressedTile.scale, {x:1, y:1}, .1, {ease:FlxEase.quadIn});

			var hoverTile = getTile(board, FlxG.mouse.x, FlxG.mouse.y);
			
			if (hoverTile != null && !hoverTile.movable && hoverTile.type == Tile.BLANK) {

				board[hoverTile.boardY][hoverTile.boardX] = pressedTile;
				
				pressedTile.x = hoverTile.x;
				pressedTile.y = hoverTile.y;
				pressedTile.boardX = hoverTile.boardX;
				pressedTile.boardY = hoverTile.boardY;
				
			} else {
				FlxTween.tween(pressedTile, {x:pressedTile.originalPosition.x, y:pressedTile.originalPosition.y}, .5, {ease:FlxEase.quadIn});
			}
		}
 	}

 	function fireLaser(t:Tile){

		var possibleX:Int = Std.int(t.x/(Settings.TILE_WIDTH + Settings.GRID_WIDTH));
		var possibleY:Int = Std.int(t.y/(Settings.TILE_HEIGHT + Settings.GRID_WIDTH));

		var hoverTile = getTile(board, Std.int(t.x), Std.int(t.y));
		
		var l = new Laser(t.x, t.y, t.direction, currentLaserId, Settings.AVAILABLE_COLORS[boardColors[possibleY][possibleX]], hoverTile, 0);
		lasers.add(l);
		currentLaserId++;	
		
		l.becomeHead.start(Settings.LASER_SPEED, function(_){
			laserHeads.add(l);
		});
 	}

 	function generateLasers(){

		for (l in lasers) {
			l.becomeHead.cancel();
		}
		
		laserHeads.clear();
		lasers.clear();
		particles.clear();
		
 		for(j in 0...board.length){
 			for(i in 0...board[j].length){
 				var t = board[j][i];
				t.targetReached = false;
				if(t.type == Tile.SOURCE_UP || t.type == Tile.SOURCE_LEFT || t.type == Tile.SOURCE_DOWN || t.type == Tile.SOURCE_RIGHT){
					fireLaser(t);
				}
 			}
 		}
 	}

	function checkLevelComplete() {		
		var c : Bool = true;
		
		for(j in 0...board.length){
 			for (i in 0...board[j].length) {
				if (board[j][i].type >= Tile.TARGET_UP && board[j][i].type <= Tile.TARGET_LEFT) {
					if (!board[j][i].targetReached) {
						c = false;
					}
				}
			}
		}
		
			
		if (c) {
			completeLevel();
		}
	}
	
	function completeLevel() {
		levelComplete = true;
		
		fireButton.loadGraphic("assets/images/NextLevel.png");
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		handleMouse();
				
		if (FlxG.keys.justPressed.ESCAPE) {
			FlxG.switchState(new MenuState());
		}
		
		for (l1 in lasers) {
			for (l2 in lasers) {
				if (l1 != l2 && l1.x == l2.x && l1.y == l2.y && (l1.becomeHead.active || l2.becomeHead.active)) {
					
					var directionSum:Int = l1.direction + l2.direction;
					
					var hoverTile = getTile(board, l1.x, l1.y);
					
					if (hoverTile.type<= Tile.BACK_MIRROR && (directionSum == Settings.OPPOSITE_DIRECTIONS[hoverTile.type][0] || directionSum == Settings.OPPOSITE_DIRECTIONS[hoverTile.type][1])) {
						l1.becomeHead.cancel();
						l2.becomeHead.cancel();
								
						l1.animation.play(l1.animation.name + "Half", true, false, l1.animation.frameIndex);
						l2.animation.play(l2.animation.name + "Half", true, false, l2.animation.frameIndex);		
						
						laserHeads.remove(l1);
						laserHeads.remove(l2);
					}				
				}	
			}
		}	
		
		for (l in laserHeads) {
				var _moveX:Int = 0;
				var _moveY:Int = 0;
				
				var currentTile = getTile(board, l.x, l.y);
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

				var hoverTile = getTile(board, l.x + _moveX * (Settings.TILE_WIDTH + Settings.GRID_WIDTH), l.y + _moveY * (Settings.TILE_HEIGHT + Settings.GRID_WIDTH));
				
				if (hoverTile != null) {
					var uniqueLaser:Bool = true;
					
					for(laser in lasers){
						if(laser.x == l.x && laser.y == l.y && laser.direction == nextDirection && l.ID == laser.ID && laser != l){
							uniqueLaser = false;
						}
					}
					if(hoverTile.type == Tile.BLOCK || hoverTile.type == Tile.SOURCE_UP || hoverTile.type == Tile.SOURCE_RIGHT || hoverTile.type == Tile.SOURCE_DOWN || hoverTile.type == Tile.SOURCE_LEFT){
						uniqueLaser = false;
					}
					
					if (uniqueLaser) {
						var laser = new Laser(hoverTile.x, hoverTile.y, nextDirection, l.ID, l.color, hoverTile, l.laserNumber+1);
						lasers.add(laser);	

						#if !mobile
							particles.add(laser.particleEmitter);
						#end
							
						laser.becomeHead.start(Settings.LASER_SPEED, function(_){
							laserHeads.add(laser);
						});
						
						if (hoverTile.type >= Tile.TARGET_UP && hoverTile.type <= Tile.TARGET_LEFT) {
							checkLevelComplete();	
						}
					}
				}
				
				laserHeads.remove(l);
				 
			}
		}
}