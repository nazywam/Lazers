package tiles;

import flixel.FlxObject;

class Mirror extends Tile {

	override public function nextMove(_d:Int){
		switch (_d) {
			case FlxObject.UP:
				return Tile.TURN_RIGHT;
			case FlxObject.RIGHT:
				return Tile.TURN_UP;
			case FlxObject.DOWN:
				return Tile.TURN_LEFT;
			case FlxObject.LEFT:
				return Tile.TURN_DOWN;
		}
		return Tile.STOP;
	}
}