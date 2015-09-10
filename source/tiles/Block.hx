package tiles;

import flixel.FlxObject;

class Block extends Tile {

	override public function new(_x:Float, _y:Float, _t:Int, _d:Int, _m:Bool, _c:Int, _bx:Int, _by:Int){
		super(_x, _y, _t, _d, _m, _c, _bx, _by);
		passable = false;
	}

	override public function nextMove(_d:Int){
		return Tile.STOP;
	}
	
}