package tiles;

import flixel.FlxObject;

class Block extends Tile {

	override public function nextMove(_d:Int){
		return [0, 0, FlxObject.UP];
	}
	
}