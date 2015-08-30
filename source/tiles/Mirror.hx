package tiles;

import flixel.FlxObject;

class Mirror extends Tile {

	override public function nextMove(_d:Int){
		switch (_d) {
			case FlxObject.UP:
				return [1, 0, FlxObject.RIGHT];
			case FlxObject.RIGHT:
				return [0, -1, FlxObject.UP];
			case FlxObject.DOWN:
				return [-1, 0, FlxObject.LEFT];
			case FlxObject.LEFT:
				return [0, 1, FlxObject.DOWN];
		}
		return [0, 0, FlxObject.UP];
	}

		/*
		switch (_d) {
			case FlxObject.UP:
				switch (direction) {
					case FlxObject.UP:
						return [0, 0, FlxObject.];
					case FlxObject.RIGHT:
						return [0, 0, FlxObject.];
					case FlxObject.DOWN:
						return [0, 0, FlxObject.];
					case FlxObject.LEFT:
						return [0, 0, FlxObject.];
				}
			case FlxObject.RIGHT:
				switch (direction) {
					case FlxObject.UP:
						return [0, 0, FlxObject.];
					case FlxObject.RIGHT:
						return [0, 0, FlxObject.];
					case FlxObject.DOWN:
						return [0, 0, FlxObject.];
					case FlxObject.LEFT:
						return [0, 0, FlxObject.];
				}
			case FlxObject.DOWN:
				switch (direction) {
					case FlxObject.UP:
						return [0, 0, FlxObject.];
					case FlxObject.RIGHT:
						return [0, 0, FlxObject.];
					case FlxObject.DOWN:
						return [0, 0, FlxObject.];
					case FlxObject.LEFT:
						return [0, 0, FlxObject.];
				}
			case FlxObject.LEFT:
				switch (direction) {
					case FlxObject.UP:
						return [0, 0, FlxObject.];
					case FlxObject.RIGHT:
						return [0, 0, FlxObject.];
					case FlxObject.DOWN:
						return [0, 0, FlxObject.];
					case FlxObject.LEFT:
						return [0, 0, FlxObject.];
				}
		}
		return [0, 0, FlxObject.];
	}
	*/
	
}