package;

import flixel.*;
import flixel.addons.effects.*;
import flixel.effects.particles.*;
import flixel.group.FlxGroup.*;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.*;
import flixel.util.*;
import openfl.*;
import openfl.events.KeyboardEvent;
import tiles.*;

class PlayState extends FlxState {

	var currentLevel:Int;
	var currentStage:Int;
	var runTransitionScreen:Bool;
	
	
	var currentLaserId:Int = 0;

	var waveSprites:FlxTypedGroup<FlxWaveSprite>;
	var board:Array<Array<Tile>>;
	var originalBoard:Array<Array<Tile>>;
	var boardColors:Array<Array<Int>>;
	
	var lasers:FlxTypedGroup<Laser>;
	var laserHeads:FlxTypedGroup<Laser>;
	var particles:FlxTypedGroup<FlxEmitter>;
	
	var availableTiles:FlxTypedGroup<Tile>;
	var availableTilesBackground:FlxSprite;
	var availableColors:Array<Int>;
	
	var pressedTile:Tile;
	var pressed:Bool=false;

	var fireButton:Button;
	var menuButton:Button;	
	var resetButton:Button;	
	
	var transitionScreen:TransitionScreen;
	
	var levelComplete:Bool = false;
	
	var grid:FlxSprite;

	
	
	override public function new(_s:Int, _c:Int, _r:Bool) {

		currentLevel = _c;
		currentStage = _s;
		runTransitionScreen = _r;
		
		super();

		Lib.current.stage.addEventListener (KeyboardEvent.KEY_UP, onKeyUp);
	}

	private function onKeyUp (event:KeyboardEvent) {
		#if android
			if(event.keyCode == 16777234){
				FlxG.debugger.visible = !FlxG.debugger.visible;
			}
			if (event.keyCode == 27) {
				event.stopImmediatePropagation();

				transitionScreen.running = false;
				transitionScreen.start();

				var t = new FlxTimer();
				t.start(.65, function(_) {
					FlxG.switchState(new LevelSelect());	
				});
			}
		#end
	}
	
	override public function create():Void {
		super.create();
		
		
		grid = new FlxSprite(0, 0, Settings.GRID);
		add(grid);
		
		waveSprites = new FlxTypedGroup<FlxWaveSprite>();

		availableTilesBackground = new FlxSprite(0, grid.y + grid.width, Settings.AVAILABLE_TILES);
		add(availableTilesBackground);
		if (Assets.getText(Settings.LEVEL + Std.string(currentStage)+ '/' + Std.string(currentLevel)+".tmx") == null) {
			loadMap(Assets.getText(Settings.LEVEL_404));
		} else {
			loadMap(Assets.getText(Settings.LEVEL + Std.string(currentStage)+ '/' + Std.string(currentLevel) + ".tmx"));	
		}

		add(waveSprites);

		lasers = new FlxTypedGroup<Laser>();
		laserHeads = new FlxTypedGroup<Laser>();
		add(lasers);
	
		fireButton = new Button(0, availableTilesBackground.y + availableTilesBackground.height, "Fire lasers", FlxG.width, 96);
		resetButton = new Button(0, fireButton.y + fireButton.background.height + 24, "Reset Board", FlxG.width, 96); 
		menuButton = new Button(0, resetButton.y + resetButton.background.height + 25, "Menu", FlxG.width, 96);
		add(fireButton);
		add(menuButton);
		add(resetButton);

		add(particles);

		transitionScreen = new TransitionScreen();
		if (runTransitionScreen) {
			transitionScreen.startHalf();	
		}
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
										boardColors[l - 1][t] = Std.parseInt(tile) - 81;
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
											board[l-1][t] = new Blank(t * (Settings.TILE_WIDTH + Settings.GRID_WIDTH) +  Settings.BOARD_OFFSET_X, (l - 1) * (Settings.TILE_HEIGHT + Settings.GRID_WIDTH) + Settings.BOARD_OFFSET_Y, Std.parseInt(tile) - 1, Settings.TILE_DIRECTIONS[Std.parseInt(tile) -1], false, boardColors[l-1][t], t, l-1);
										} else if(_tile >= Tile.MIRROR && _tile < Tile.BACK_MIRROR){
											board[l-1][t] = new Mirror(t * (Settings.TILE_WIDTH + Settings.GRID_WIDTH) +  Settings.BOARD_OFFSET_X, (l - 1) * (Settings.TILE_HEIGHT + Settings.GRID_WIDTH) + Settings.BOARD_OFFSET_Y, Std.parseInt(tile) - 1, Settings.TILE_DIRECTIONS[Std.parseInt(tile) -1], false, boardColors[l-1][t], t, l-1);
										} else if(_tile >= Tile.BACK_MIRROR && _tile < 3){
											board[l-1][t] = new BackMirror(t * (Settings.TILE_WIDTH + Settings.GRID_WIDTH) +  Settings.BOARD_OFFSET_X, (l - 1) * (Settings.TILE_HEIGHT + Settings.GRID_WIDTH) + Settings.BOARD_OFFSET_Y, Std.parseInt(tile) - 1, Settings.TILE_DIRECTIONS[Std.parseInt(tile) -1], false, boardColors[l-1][t], t, l-1);
										} else if (_tile == 3) {
											trace("That is not a valid tile!");
										} else if(_tile >= Tile.SOURCE && _tile < Tile.TARGET){
											board[l-1][t] = new Source(t * (Settings.TILE_WIDTH + Settings.GRID_WIDTH) +  Settings.BOARD_OFFSET_X, (l - 1) * (Settings.TILE_HEIGHT + Settings.GRID_WIDTH) + Settings.BOARD_OFFSET_Y, Std.parseInt(tile) - 1, Settings.TILE_DIRECTIONS[Std.parseInt(tile) -1], false, boardColors[l-1][t], t, l-1);
										} else if(_tile >= Tile.TARGET && _tile < Tile.MERGE){
											board[l - 1][t] = new Target(t * (Settings.TILE_WIDTH + Settings.GRID_WIDTH) +  Settings.BOARD_OFFSET_X, (l - 1) * (Settings.TILE_HEIGHT + Settings.GRID_WIDTH) + Settings.BOARD_OFFSET_Y, Std.parseInt(tile) - 1, Settings.TILE_DIRECTIONS[Std.parseInt(tile) -1], false, boardColors[l - 1][t], t, l - 1);
											particles.add(board[l - 1][t].particles);
										} else if(_tile >= Tile.MERGE && _tile < Tile.BLOCK){
											board[l - 1][t] = new Merge(t * (Settings.TILE_WIDTH + Settings.GRID_WIDTH) +  Settings.BOARD_OFFSET_X, (l - 1) * (Settings.TILE_HEIGHT + Settings.GRID_WIDTH) + Settings.BOARD_OFFSET_Y, Std.parseInt(tile) - 1, Settings.TILE_DIRECTIONS[Std.parseInt(tile) -1], false, boardColors[l - 1][t], t, l - 1);
										} else if(_tile >= Tile.BLOCK && _tile < Tile.PORTAL_IN){
											board[l - 1][t] = new Block(t * (Settings.TILE_WIDTH + Settings.GRID_WIDTH) +  Settings.BOARD_OFFSET_X, (l - 1) * (Settings.TILE_HEIGHT + Settings.GRID_WIDTH) + Settings.BOARD_OFFSET_Y, Std.parseInt(tile) - 1, Settings.TILE_DIRECTIONS[Std.parseInt(tile) -1], false, boardColors[l - 1][t], t, l - 1);
										} else if (_tile >= Tile.PORTAL_IN && _tile < Tile.PORTAL_OUT) {
											board[l - 1][t] = new PortalIn(t * (Settings.TILE_WIDTH + Settings.GRID_WIDTH) +  Settings.BOARD_OFFSET_X, (l - 1) * (Settings.TILE_HEIGHT + Settings.GRID_WIDTH) + Settings.BOARD_OFFSET_Y, Std.parseInt(tile) - 1, Settings.TILE_DIRECTIONS[Std.parseInt(tile) -1], false, boardColors[l - 1][t], t, l - 1);
										} else if (_tile >= Tile.PORTAL_OUT && _tile < Tile.COLLECT_POINT) {
											board[l - 1][t] = new PortalOut(t * (Settings.TILE_WIDTH + Settings.GRID_WIDTH) +  Settings.BOARD_OFFSET_X, (l - 1) * (Settings.TILE_HEIGHT + Settings.GRID_WIDTH) + Settings.BOARD_OFFSET_Y, Std.parseInt(tile) - 1, Settings.TILE_DIRECTIONS[Std.parseInt(tile) -1], false, boardColors[l - 1][t], t, l - 1);
										} else if (_tile == Tile.COLLECT_POINT) {
											var c = new CollectPoint(t * (Settings.TILE_WIDTH + Settings.GRID_WIDTH) +  Settings.BOARD_OFFSET_X, (l - 1) * (Settings.TILE_HEIGHT + Settings.GRID_WIDTH) + Settings.BOARD_OFFSET_Y, Std.parseInt(tile) - 1, Settings.TILE_DIRECTIONS[Std.parseInt(tile) -1], false, boardColors[l - 1][t], t, l - 1);
											board[l - 1][t] = c;
											add(c.innerCircle);
										} else {
											trace("Unidetified block on the grid!!!");
										}

										originalBoard[l-1][t] = board[l-1][t];
										add(board[l - 1][t]);
										
										if (Settings.FUN) {
											board[l - 1][t].visible = false;
											var t = new FlxWaveSprite(board[l - 1][t]);
											t.strength = 35;
											t.speed = 15;
											waveSprites.add(t);
										}
									}
								}
						}
	        	}
	        }
	    }

		availableTiles = new FlxTypedGroup<Tile>();
		availableColors = new Array<Int>();
		add(availableTiles);
		
		for (i in 0...6) {
			availableColors.push(0);
		}
		
		for (props in xml.elementsNamed("properties")) {
			for (p in props.elementsNamed("property")) {
				var avail = p.get("value").split(',');
				
				
				for (i in 0...avail.length) {
					if (p.get("name") == "AvailableColors") {						
						availableColors[i] = Std.parseInt(avail[i]);
					} else {
						var _tile = Std.parseInt(avail[i]);
						
						var a:Dynamic;
						
						if(_tile >= Tile.BLANK && _tile < Tile.MIRROR){
							a = new Blank(availableTilesBackground.x + 22 + i*58*2, availableTilesBackground.y + 22, _tile, Settings.TILE_DIRECTIONS[_tile], true, availableColors[i], -1, -1);
						} else if(_tile >= Tile.MIRROR && _tile < Tile.BACK_MIRROR){
							a = new Mirror(availableTilesBackground.x + 22 + i*58*2, availableTilesBackground.y + 22, _tile, Settings.TILE_DIRECTIONS[_tile], true, availableColors[i], -1, -1);
						} else if(_tile >= Tile.BACK_MIRROR && _tile < Tile.SOURCE){
							a = new BackMirror(availableTilesBackground.x + 22 + i*58*2, availableTilesBackground.y + 22, _tile, Settings.TILE_DIRECTIONS[_tile], true, availableColors[i], -1, -1);
						}else if(_tile >= Tile.BLOCK && _tile < Tile.PORTAL_IN){
							a = new Block(availableTilesBackground.x + 22 + i*58*2, availableTilesBackground.y + 22, _tile, Settings.TILE_DIRECTIONS[_tile], true, availableColors[i], -1, -1);
						} else if(_tile >= Tile.SOURCE && _tile < Tile.TARGET){
							a = new Source(availableTilesBackground.x + 22 + i*58*2, availableTilesBackground.y + 22, _tile, Settings.TILE_DIRECTIONS[_tile], true, availableColors[i], -1, -1);
						} else if(_tile >= Tile.TARGET && _tile < Tile.MERGE){
							a = new Target(availableTilesBackground.x + 22 + i * 58*2, availableTilesBackground.y + 22, _tile, Settings.TILE_DIRECTIONS[_tile], true, availableColors[i], -1, -1);
							particles.add(a.particles);
						} else if(_tile >= Tile.MERGE && _tile < Tile.BLOCK){
							a = new Merge(availableTilesBackground.x + 22 + i*58*2, availableTilesBackground.y + 22, _tile, Settings.TILE_DIRECTIONS[_tile], true, availableColors[i], -1, -1);					
						} else if (_tile >= Tile.PORTAL_IN && _tile < Tile.PORTAL_OUT) {
							a = new PortalIn(availableTilesBackground.x + 22 + i*58*2, availableTilesBackground.y + 22, _tile, Settings.TILE_DIRECTIONS[_tile], true, availableColors[i], -1, -1);					
						} else {
							a = new PortalOut(availableTilesBackground.x + 22 + i*58*2, availableTilesBackground.y + 22, _tile, Settings.TILE_DIRECTIONS[_tile], true, availableColors[i], -1, -1);						
						}

						if (Settings.FUN) {
							var t = new FlxWaveSprite(a);
							t.strength = 35;
							t.speed = 15;
							waveSprites.add(t);
							a.visible = false;
						}
						availableTiles.add(a);
					}
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
		for (l in laserHeads) {
			remove(l);
			l.destroy();
			l = null;
		}
		for (l in lasers) {
			remove(l);
			l.destroy();
			l = null;
		}
		laserHeads.clear();
		lasers.clear();

		for (j in 0...board.length) {
			for (i in 0...board[j].length) {
				board[j][i].resetState();
			}
		}
	}
		
	function startNextLevel() {
		transitionScreen.running = false;
		transitionScreen.start();
				
		Settings.SAVES.data.completedLevels[currentLevel + currentStage * Settings.LEVELS_IN_STAGE] = true;
		Settings.SAVES.flush();
		
		var t = new FlxTimer();
			t.start(.65, function(_) {

			if (currentLevel < 7) {
				FlxG.switchState(new PlayState(currentStage, currentLevel+1, true));		
			} else {
				FlxG.switchState(new LevelSelect());
			}
		});
	}
	
	
 	function handleMouse() {
		if (FlxG.mouse.justPressed) {
		
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
					startNextLevel();
				} else {
					generateLasers();	
				}
			}
			if (FlxG.mouse.overlaps(menuButton)) {
	
				transitionScreen.running = false;
				transitionScreen.start();
	
				var t = new FlxTimer();
				t.start(.65, function(_) {
					FlxG.switchState(new LevelSelect());	
				});
			}
			if (FlxG.mouse.overlaps(resetButton)) {
				
				FlxG.switchState(new PlayState(currentStage, currentLevel, false));
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
		lasers.add(l);
		currentLaserId++;	
		

		l.becomeHead.start(Settings.LASER_SPEED, function(_){
			laserHeads.add(l);
		});

		if (hoverTile.type == Tile.COLLECT_POINT) {
			hoverTile.connectedColors.push(l.colorId);
			hoverTile.update(0);
			checkLevelComplete();
		}
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
				var target = board[j][i];

				if (board[j][i].type == Tile.TARGET) {
					
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
				} else if (board[j][i].type == Tile.COLLECT_POINT) {
					if (!target.completed) {
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
					

		if(Settings.FUN){
			for(w in waveSprites){
				w.x = w.target.x - w.width/4 - 3;
				w.y = w.target.y;
				w.angle = w.target.angle;
				w.flipX = w.target.flipX;
				w.flipY = w.target.flipY;
			}
		}

		if (FlxG.keys.justPressed.ESCAPE) {
				transitionScreen.running = false;
				transitionScreen.start();

			var t = new FlxTimer();
			t.start(.65, function(_) {
				FlxG.switchState(new LevelSelect());	
			});
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

					if(spawnLaserHoverTile.type == Tile.COLLECT_POINT){
						spawnLaserHoverTile.connectedColors.push(l.colorId);
						spawnLaserHoverTile.update(0);
						checkLevelComplete();
					}
				}
			}
			
			
			var hoverTile = getTile(board, l.x + _moveX * (Settings.TILE_WIDTH + Settings.GRID_WIDTH), l.y + _moveY * (Settings.TILE_HEIGHT + Settings.GRID_WIDTH));
			
			if (tmp == Tile.TELEPORT) {
				for (y in 0...board.length) {
					for (x in 0...board[y].length) {
						if (board[y][x].type == Tile.PORTAL_OUT && board[y][x].colorId == currentTile.colorId) {
							hoverTile = board[y][x]; 
						}
					}
				}
			}
			
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
				
				if (uniqueLaser && !(hoverTile.type == Tile.SOURCE && hoverTile.direction == nextDirection)) {
					var laser = new Laser(hoverTile.x, hoverTile.y, nextDirection, l.ID, l.colorId, hoverTile, l.laserNumber + 1);		
					lasers.add(laser);								
					laser.becomeHead.start(Settings.LASER_SPEED, function(_){
						laserHeads.add(laser);
					});
					
					if (hoverTile.type == Tile.TARGET) {
						checkLevelComplete();	
					}
				}
				
				if (hoverTile.type == Tile.COLLECT_POINT) {

					hoverTile.connectedColors.push(l.colorId);
					hoverTile.update(elapsed);
					checkLevelComplete();
				}
			}
			laserHeads.remove(l);
		}
	}
}