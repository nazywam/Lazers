package tiles;

import flixel.FlxObject;

class BackMirror extends Tile {

		override public function nextMove(_d:Int){
		switch (_d) {
			case FlxObject.UP:
				return [-1, 0, FlxObject.LEFT];
			case FlxObject.RIGHT:
				return [0, 1, FlxObject.DOWN];
			case FlxObject.DOWN:
				return [1, 0, FlxObject.RIGHT];
			case FlxObject.LEFT:
				return [0, -1, FlxObject.UP];
		}
		return [0, 0, FlxObject.UP];
	}
	
}