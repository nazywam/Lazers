package tiles;

import flixel.FlxObject;
import format.SVG;

class BackMirror extends Tile {

	override public function new(_x:Float, _y:Float, _t:Int, _d:Int, _m:Bool, _c:Int, _bx:Int, _by:Int){
		super(_x, _y, _t, _d, _m, _c, _bx, _by);
		passable = true;
		type = Tile.BACK_MIRROR;
		
	}

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
	
	override public function properAnimation(_d:Int):Array<Dynamic> {
		switch (_d) {
			case FlxObject.UP:
				return [270, 0];
			case FlxObject.RIGHT:
				return [180, 1];
			case FlxObject.DOWN:
				return [90, 0];
			case FlxObject.LEFT:
				return [0, 1];
		}
		return super.properAnimation(_d);
	}
	
}