package tiles;

import flixel.FlxObject;

class Blank extends Tile {

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
	
}