package tiles;
import flixel.FlxObject;
/**
 * ...
 * @author Michael
 */
class PortalOut extends Tile{
	public function new(_x:Float, _y:Float, _t:Int, _d:Int, _m:Bool, _c:Int, _bx:Int, _by:Int) {
		super(_x, _y, _t, _d, _m, _c, _bx, _by);
		passable = true;
		type = Tile.PORTAL_OUT;	
	}
	
	override public function nextMove(_d:Int) {
		switch(direction) {
			case FlxObject.UP:
				return Tile.TURN_UP;
			case FlxObject.RIGHT:
				return 	Tile.TURN_RIGHT;
			case FlxObject.DOWN:
				return 	Tile.TURN_DOWN;
			case FlxObject.LEFT:
				return 	Tile.TURN_LEFT;
		}
		return 	Tile.TURN_UP;
	}
	
		override public function properAnimation(_d:Int):Array<Dynamic> {
			switch (direction) {
				case FlxObject.UP:
					return [0, 1, "teleport"];
				case FlxObject.RIGHT:
					return [90, 0, "teleport"];
				case FlxObject.DOWN:
					return [180, 0, "teleport"];
				case FlxObject.LEFT:
					return [270, 1, "teleport"];
			}

		return super.properAnimation(_d);
	}
}