package tiles;

import flixel.FlxObject;

class Mirror extends Tile {

	override public function nextMove(_d:Int){
		switch (_d) {
			case FlxObject.UP:
				return Tile.TURN_RIGHT.concat([270, 1]);
			case FlxObject.RIGHT:
				return Tile.TURN_UP.concat([0, 0]);
			case FlxObject.DOWN:
				return Tile.TURN_LEFT.concat([90, 1]);
			case FlxObject.LEFT:
				return Tile.TURN_DOWN.concat([180, 0]);
		}
		return Tile.STOP;
	}
	
	override public function properAnimation(_d:Int):Array<Dynamic> {
		switch (_d) {
			case FlxObject.UP:
				return [270, 1];
			case FlxObject.RIGHT:
				return [0, 0];
			case FlxObject.DOWN:
				return [90, 1];
			case FlxObject.LEFT:
				return [180, 0];
		}
		return super.properAnimation(_d);
	}
}