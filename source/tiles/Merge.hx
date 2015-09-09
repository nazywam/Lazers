package tiles;

import flixel.FlxObject;

class Merge extends Tile {

		override public function nextMove(_d:Int){
		switch (_d) {
			case FlxObject.UP:
				switch (direction) {
					case FlxObject.UP:
						return Tile.STOP;
					case FlxObject.RIGHT:
						return Tile.TURN_RIGHT;
					case FlxObject.DOWN:
						return Tile.TURN_RIGHT.concat([1]);
					case FlxObject.LEFT:
						return Tile.TURN_LEFT;
				}
			case FlxObject.RIGHT:
				switch (direction) {
					case FlxObject.UP:
						return Tile.TURN_UP;
					case FlxObject.RIGHT:
						return Tile.STOP;
					case FlxObject.DOWN:
						return Tile.TURN_DOWN;
					case FlxObject.LEFT:
						return Tile.TURN_UP.concat([1]);
				}
			case FlxObject.DOWN:
				switch (direction) {
					case FlxObject.UP:
						return Tile.TURN_RIGHT.concat([1]);
					case FlxObject.RIGHT:
						return Tile.TURN_RIGHT;
					case FlxObject.DOWN:
						return Tile.STOP;
					case FlxObject.LEFT:
						return Tile.TURN_LEFT;
				}
			case FlxObject.LEFT:
				switch (direction) {
					case FlxObject.UP:
						return Tile.TURN_UP;
					case FlxObject.RIGHT:
						return Tile.TURN_UP.concat([1]);
					case FlxObject.DOWN:
						return Tile.TURN_DOWN;
					case FlxObject.LEFT:
						return Tile.STOP;
				}
		}
		return Tile.STOP;
	}
	
	
	
	override public function properAnimation(_d:Int):Array<Dynamic> {
		switch (_d) {
			case FlxObject.UP:
				switch (direction) {
					case FlxObject.UP:
						return [0, 0];
					case FlxObject.RIGHT:
						return [270, 1];
					case FlxObject.DOWN:
						return [270, 1];
					case FlxObject.LEFT:
						return [270, 0];
				}
			case FlxObject.RIGHT:
				switch (direction) {
					case FlxObject.UP:
						return [0, 0];
					case FlxObject.RIGHT:
						return [0, 0];
					case FlxObject.DOWN:
						return [180, 1];
					case FlxObject.LEFT:
						return [180, 1];
				}
			case FlxObject.DOWN:
				switch (direction) {
					case FlxObject.UP:
						return [90, 0];
					case FlxObject.RIGHT:
						return [90, 0];
					case FlxObject.DOWN:
						return [0, 0];
					case FlxObject.LEFT:
						return [90, 1];
				}
			case FlxObject.LEFT:
				switch (direction) {
					case FlxObject.UP:
						return [0, 1];
					case FlxObject.RIGHT:
						return [0, 1];
					case FlxObject.DOWN:
						return [180, 0];
					case FlxObject.LEFT:
						return [0, 0];
				}
		}
		return super.properAnimation(_d);
	}
}