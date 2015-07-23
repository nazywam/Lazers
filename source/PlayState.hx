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
	
	var board:Array<Array<Tile>>;
	var lasers:FlxTypedGroup<Laser>;

	override public function create():Void {
		super.create();

		board = new Array<Array<Tile>>();
		for(i in 0...14){
			board[i] = new Array<Tile>();
			for(j in 0...14){
				var possibleId = 0;
				if(Std.random(4) == 0){
					possibleId = Std.random(3);
				}

				board[i][j] = new Tile(j*32, i*32, possibleId);
				add(board[i][j]);
			}
		}

		lasers = new FlxTypedGroup<Laser>();
		add(lasers);
 	}

 	function inBounds(_x:Int, _y:Int):Bool {
 		return (_x >= 0 && _x < 14) && (_y >= 0 && _y < 14);
 	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		for(l in lasers){
			if(l.head){
				l.head = false;

				var _moveX:Int;
				var _moveY:Int;
				_moveX = _moveY = 0;


				var currentTile = board[Std.int(l.y/32)][Std.int(l.x/32)];
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



				if (inBounds(Std.int(l.x/32) + _moveX, Std.int(l.y/32) + _moveY)){
					var laser = new Laser(l.x + _moveX*32, l.y + _moveY*32, nextDirection);
					lasers.add(laser);
				}
			}
		}


		if(FlxG.mouse.justPressed){
			var l = new Laser(Std.int(FlxG.mouse.x / 32)* 32, Std.int(FlxG.mouse.y / 32)* 32, FlxObject.UP);
			lasers.add(l);
		}



	}	
}