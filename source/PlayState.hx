package;

import flixel.*;
import flixel.addons.effects.*;
import flixel.effects.particles.*;
import flixel.group.FlxGroup.*;
import flixel.tweens.*;
import flixel.util.*;
import openfl.*;
import tiles.*;
import flixel.group.FlxGroup.FlxTypedGroup;

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
	var availableTilesBackground:FlxSprite;

	var pressedTile:Tile;
	var pressed:Bool=false;

	var fireButton:Button;	
	
	var transitionScreen:TransitionScreen;
	
	var levelComplete:Bool = false;
	
	var grid:FlxSprite;
	override public function new(_c:Int) {
		currentLevel = _c;
		super();
	}
	
	override public function create():Void {
		super.create();
		//FlxG.camera.bgColor = 0xFF326f2c;
		
		grid = new FlxSprite(0, 0, "assets/images/Grid.png");
		add(grid);
		
		availableTilesBackground = new FlxSprite(0, grid.y + grid.width, "assets/images/AvailableTiles.png");
		add(availableTilesBackground);
		
		
		
		if (Assets.getText("assets/data/level"+Std.string(currentLevel)+".tmx") == null) {
			loadMap(Assets.getText("assets/data/404.tmx"));
		} else {
			loadMap(Assets.getText("assets/data/level" + Std.string(currentLevel) + ".tmx"));	
		}

		lasers = new FlxTypedGroup<Laser>();
		laserHeads = new FlxTypedGroup<Laser>();
		add(lasers);
		
		fireButton = new Button(0, availableTilesBackground.y + availableTilesBackground.height, "Fire lasers", FlxG.width, 32);
		add(fireButton);
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
		particles = new FlxTypedGroup<FlxEmitter>();
		
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
										var type = "tiles.";
										var _tile = Std.parseInt(tile) - 1;

										if(_tile >= Tile.BLANK && _tile < Tile.MIRROR){
											board[l-1][t] = new Blank(t * (Settings.TILE_WIDTH + Settings.GRID_WIDTH) +  Settings.BOARD_OFFSET.x, (l - 1) * (Settings.TILE_HEIGHT + Settings.GRID_WIDTH) + Settings.BOARD_OFFSET.y, Std.parseInt(tile) - 1, Settings.TILE_DIRECTIONS[Std.parseInt(tile) -1], false, boardColors[l-1][t], t, l-1);
										} else if(_tile >= Tile.MIRROR && _tile < Tile.BACK_MIRROR){
											board[l-1][t] = new Mirror(t * (Settings.TILE_WIDTH + Settings.GRID_WIDTH) +  Settings.BOARD_OFFSET.x, (l - 1) * (Settings.TILE_HEIGHT + Settings.GRID_WIDTH) + Settings.BOARD_OFFSET.y, Std.parseInt(tile) - 1, Settings.TILE_DIRECTIONS[Std.parseInt(tile) -1], false, boardColors[l-1][t], t, l-1);
										} else if(_tile >= Tile.BACK_MIRROR && _tile < Tile.BLOCK){
											board[l-1][t] = new BackMirror(t * (Settings.TILE_WIDTH + Settings.GRID_WIDTH) +  Settings.BOARD_OFFSET.x, (l - 1) * (Settings.TILE_HEIGHT + Settings.GRID_WIDTH) + Settings.BOARD_OFFSET.y, Std.parseInt(tile) - 1, Settings.TILE_DIRECTIONS[Std.parseInt(tile) -1], false, boardColors[l-1][t], t, l-1);
										}else if(_tile >= Tile.BLOCK && _tile < Tile.SOURCE){
											board[l-1][t] = new Block(t * (Settings.TILE_WIDTH + Settings.GRID_WIDTH) +  Settings.BOARD_OFFSET.x, (l - 1) * (Settings.TILE_HEIGHT + Settings.GRID_WIDTH) + Settings.BOARD_OFFSET.y, Std.parseInt(tile) - 1, Settings.TILE_DIRECTIONS[Std.parseInt(tile) -1], false, boardColors[l-1][t], t, l-1);
										} else if(_tile >= Tile.SOURCE && _tile < Tile.TARGET){
											board[l-1][t] = new Source(t * (Settings.TILE_WIDTH + Settings.GRID_WIDTH) +  Settings.BOARD_OFFSET.x, (l - 1) * (Settings.TILE_HEIGHT + Settings.GRID_WIDTH) + Settings.BOARD_OFFSET.y, Std.parseInt(tile) - 1, Settings.TILE_DIRECTIONS[Std.parseInt(tile) -1], false, boardColors[l-1][t], t, l-1);
										} else if(_tile >= Tile.TARGET && _tile < Tile.MERGE){
											board[l - 1][t] = new Target(t * (Settings.TILE_WIDTH + Settings.GRID_WIDTH) +  Settings.BOARD_OFFSET.x, (l - 1) * (Settings.TILE_HEIGHT + Settings.GRID_WIDTH) + Settings.BOARD_OFFSET.y, Std.parseInt(tile) - 1, Settings.TILE_DIRECTIONS[Std.parseInt(tile) -1], false, boardColors[l - 1][t], t, l - 1);
											particles.add(board[l - 1][t].particles);
										} else if(_tile >= Tile.MERGE){
											board[l - 1][t] = new Merge(t * (Settings.TILE_WIDTH + Settings.GRID_WIDTH) +  Settings.BOARD_OFFSET.x, (l - 1) * (Settings.TILE_HEIGHT + Settings.GRID_WIDTH) + Settings.BOARD_OFFSET.y, Std.parseInt(tile) - 1, Settings.TILE_DIRECTIONS[Std.parseInt(tile) -1], false, boardColors[l - 1][t], t, l - 1);
										} else {
											trace("Unidetified block on the grid!!!");
										}

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
					var _tile = Std.parseInt(avail[i]);
					
					var a:Dynamic;
					
					if(_tile >= Tile.BLANK && _tile < Tile.MIRROR){
						a = new Blank(availableTilesBackground.x + 11 + i*58, availableTilesBackground.y + 11, _tile, Settings.TILE_DIRECTIONS[_tile], true, 0, -1, -1);
					} else if(_tile >= Tile.MIRROR && _tile < Tile.BACK_MIRROR){
						a = new Mirror(availableTilesBackground.x + 11 + i*58, availableTilesBackground.y + 11, _tile, Settings.TILE_DIRECTIONS[_tile], true, 0, -1, -1);
					} else if(_tile >= Tile.BACK_MIRROR && _tile < Tile.BLOCK){
						a = new BackMirror(availableTilesBackground.x + 11 + i*58, availableTilesBackground.y + 11, _tile, Settings.TILE_DIRECTIONS[_tile], true, 0, -1, -1);
					}else if(_tile >= Tile.BLOCK && _tile < Tile.SOURCE){
						a = new Block(availableTilesBackground.x + 11 + i*58, availableTilesBackground.y + 11, _tile, Settings.TILE_DIRECTIONS[_tile], true, 0, -1, -1);
					} else if(_tile >= Tile.SOURCE && _tile < Tile.TARGET){
						a = new Source(availableTilesBackground.x + 11 + i*58, availableTilesBackground.y + 11, _tile, Settings.TILE_DIRECTIONS[_tile], true, 0, -1, -1);
					} else if(_tile >= Tile.TARGET && _tile < Tile.MERGE){
						a = new Target(availableTilesBackground.x + 11 + i * 58, availableTilesBackground.y + 11, _tile, Settings.TILE_DIRECTIONS[_tile], true, 0, -1, -1);
						particles.add(a.particles);
					} else {
						a = new Merge(availableTilesBackground.x + 11 + i*58, availableTilesBackground.y + 11, _tile, Settings.TILE_DIRECTIONS[_tile], true, 0, -1, -1);					
					}
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
	
	function resetBoard() {
		laserHeads.clear();
		lasers.clear();
		
		for (j in 0...board.length) {
			for (i in 0...board[j].length) {
				if (board[j][i].type == Tile.TARGET) {
					while (board[j][i].connectedColors.length > 0) {
					board[j][i].connectedColors.pop();	
					board[j][i].particlesLaunched = false;	
					}
				}
			}
		}
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
					resetBoard();
					
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

		var possibleX:Int = Std.int(t.x / (Settings.TILE_WIDTH + Settings.GRID_WIDTH));
		var possibleY:Int = Std.int(t.y / (Settings.TILE_HEIGHT + Settings.GRID_WIDTH));

		var hoverTile = getTile(board, Std.int(t.x), Std.int(t.y));
		
		var l = new Laser(t.x, t.y, t.direction, currentLaserId, boardColors[possibleY][possibleX], hoverTile, 0);
		
		var tmp = hoverTile.properAnimation(t.direction);
		
		if (tmp[0] != 0) {
			l.angle = tmp[0];
		}
		if (tmp[1] != 0) {
			if (l.angle % 180 == 0) {
				l.flipX = true;	
			} else {
				l.flipY = true;	
			}
		} 
		if (tmp[2] != null){
			l.animation.play(tmp[2]);
		}
		
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
		
		resetBoard();
		
 		for(j in 0...board.length){
 			for(i in 0...board[j].length){
 				var t = board[j][i];
				if(t.type == Tile.SOURCE){
					fireLaser(t);
				}
 			}
 		}
 	}
	function checkLevelComplete() {		
		var c : Bool = true;
		
		for(j in 0...board.length){
 			for (i in 0...board[j].length) {
				if (board[j][i].type == Tile.TARGET) {
					var target = board[j][i];
					
					switch(target.connectedColors.length) {
						case 0:
							c = false;
						case 1:
							if (target.colorId != target.connectedColors[0]) {
								c = false;
							} else {
								target.complete();
							}
						case 2:
							if (target.colorId != Settings.MIXED_COLORS[target.connectedColors[0]][target.connectedColors[1]]) {
								c = false;	
							} else {
								target.complete();
							}
						default:
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
		fireButton.text.text = "Next level";
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		handleMouse();
				
		if (FlxG.keys.justPressed.ESCAPE) {
			FlxG.switchState(new MenuState());
		}	
		
		for (l in laserHeads) {
				var currentTile = getTile(board, l.x, l.y);
				var tmp = currentTile.nextMove(l.direction);
				
				var _moveX:Int = tmp[0];
				var _moveY:Int = tmp[1];
				var nextDirection:Int  = tmp[2];		

				
				if (tmp[3] == 1) {
					var spawnLaserDirection:Int = FlxObject.UP;
					switch(nextDirection) {
						case FlxObject.UP:	
							spawnLaserDirection = FlxObject.DOWN;
						case FlxObject.RIGHT:
							spawnLaserDirection = FlxObject.LEFT;
						case FlxObject.DOWN:
							spawnLaserDirection = FlxObject.UP;
						case FlxObject.LEFT:
							spawnLaserDirection = FlxObject.RIGHT;
					}
					
					var spawnLaserHoverTile = getTile(board, currentTile.x - _moveX * (Settings.TILE_WIDTH + Settings.GRID_WIDTH), currentTile.y - _moveY * (Settings.TILE_HEIGHT + Settings.GRID_WIDTH));
					if (spawnLaserHoverTile != null && spawnLaserHoverTile.passable) {
						var laser = new Laser(spawnLaserHoverTile.x, spawnLaserHoverTile.y, spawnLaserDirection, l.ID, l.colorId, spawnLaserHoverTile, l.laserNumber);
							laser.becomeHead.start(Settings.LASER_SPEED, function(_){
							laserHeads.add(laser);
						});
						lasers.add(laser);
					}
					
				}
				
				
				var hoverTile = getTile(board, l.x + _moveX * (Settings.TILE_WIDTH + Settings.GRID_WIDTH), l.y + _moveY * (Settings.TILE_HEIGHT + Settings.GRID_WIDTH));
				
				if (hoverTile != null && hoverTile != currentTile) {
					
					var uniqueLaser:Bool = true;
			
					for (laser in lasers) {
						if (laser.x == l.x && laser.y == l.y && laser.direction == l.direction && laser != l) {
							if (l.ID == laser.ID) {
								uniqueLaser = false;	
							}
						}
						  
					}
					if (hoverTile.type == Tile.BLOCK || (!currentTile.passable && l.laserNumber != 0)) {
						uniqueLaser = false;
					}
					
					if (uniqueLaser) {
						var laser = new Laser(hoverTile.x, hoverTile.y, nextDirection, l.ID, l.colorId, hoverTile, l.laserNumber + 1);	
						
						var tmp = hoverTile.properAnimation(nextDirection);
						
						if (tmp[0] != 0) {
							laser.angle = tmp[0];
						}
						if (tmp[1] != 0) {
							if (laser.angle % 180 == 0) {
								laser.flipX = true;	
							} else {
								laser.flipY = true;	
							}
						}
						if (tmp[2] != null){
							laser.animation.play(tmp[2]);
						}
						
						lasers.add(laser);								
						laser.becomeHead.start(Settings.LASER_SPEED, function(_){
							laserHeads.add(laser);
						});
						
						if (hoverTile.type == Tile.TARGET) {
							checkLevelComplete();	
						}
					} 
				}
				
				laserHeads.remove(l);
				 
			}
		}
}