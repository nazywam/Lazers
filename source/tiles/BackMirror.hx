package tiles;

import flixel.FlxObject;

class BackMirror extends Tile {

		override public function nextMove(_d:Int){
		switch (_d) {
			case FlxObject.UP:
				return Tile.TURN_LEFT;
			case FlxObject.RIGHT:
				return Tile.TURN_DOWN;
			case FlxObject.DOWN:
				return Tile.TURN_RIGHT;
			case FlxObject.LEFT:
				return Tile.TURN_UP;
		}
		return Tile.STOP;
	}
	
}