package tiles;
import flixel.FlxObject;


class Source extends Tile {
	override public function nextMove(_d:Int){
		switch (_d) {
			case FlxObject.UP:
				return Tile.TURN_UP;
			case FlxObject.RIGHT:
				return Tile.TURN_RIGHT;
			case FlxObject.DOWN:
				return Tile.TURN_DOWN;
			case FlxObject.LEFT:
				return Tile.TURN_LEFT;
		}
		return Tile.STOP;
	}
	
	override public function properAnimation(_d:Int):Array<Dynamic> {
		switch (_d) {
			case FlxObject.UP:
				switch (direction) {
					case FlxObject.UP:
						return [270, 0];
					case FlxObject.RIGHT:
					case FlxObject.DOWN:
					case FlxObject.LEFT:
						return [90, 0, "sourceReverse"];
				}
			case FlxObject.RIGHT:
				switch (direction) {
					case FlxObject.UP:
					case FlxObject.RIGHT:
						return [0, 0];
					case FlxObject.DOWN:
					case FlxObject.LEFT:
						return [180, 0, "sourceReverse"];
				}
			case FlxObject.DOWN:
				switch (direction) {
					case FlxObject.UP:
						return [270, 0, "sourceReverse"];
					case FlxObject.RIGHT:
					case FlxObject.DOWN:
						return [90, 0];
					case FlxObject.LEFT:
				}
			case FlxObject.LEFT:
				switch (direction) {
					case FlxObject.UP:
					case FlxObject.RIGHT:
						return [0, 0, "sourceReverse"];
					case FlxObject.DOWN:
					case FlxObject.LEFT:
						return [180, 0];
				}
		}
		return super.properAnimation(_d);
	}
}