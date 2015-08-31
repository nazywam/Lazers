package tiles;

import flixel.FlxObject;

class Blank extends Tile {

	override public function nextMove(_d:Int){
		switch (_d) {
			case FlxObject.UP:
				return [0, -1, FlxObject.UP, 0];
			case FlxObject.RIGHT:
				return [1, 0, FlxObject.RIGHT, 0];
			case FlxObject.DOWN:
				return [0, 1, FlxObject.DOWN, 0];
			case FlxObject.LEFT:
				return [-1, 0, FlxObject.LEFT, 0];
		}
		return [0, 0, FlxObject.UP];
	}
	
}