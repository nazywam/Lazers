package tiles;

import flixel.FlxObject;

class Blank extends Tile {

	override public function nextMove(_d:Int){
		switch (_d) {
			case FlxObject.UP:
				return [0, -1, FlxObject.UP];
			case FlxObject.RIGHT:
				return [1, 0, FlxObject.RIGHT];
			case FlxObject.DOWN:
				return [0, 1, FlxObject.DOWN];
			case FlxObject.LEFT:
				return [-1, 0, FlxObject.LEFT];
		}
		return [0, 0, FlxObject.UP];
	}
	
}