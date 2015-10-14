package tiles;
import flixel.FlxObject;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;
/**
 * ...
 * @author Michael
 */
class PortalOut extends Tile{
	public function new(_x:Float, _y:Float, _t:Int, _d:Int, _m:Bool, _c:Int, _bx:Int, _by:Int) {
		super(_x, _y, _t, _d, _m, _c, _bx, _by);
		passable = true;
		type = Tile.PORTAL_OUT;	
		

		var temp:BitmapData = new BitmapData(48, 48, true);
		temp.copyPixels(pixels, new Rectangle(tileID * 48, bitmapDataMoveY, 48, 48), new Point(0, 0));
		
		switch(direction) {
			case FlxObject.UP:
				temp.floodFill(24, 32, Settings.AVAILABLE_COLORS[colorId]);
			case FlxObject.RIGHT:
				temp.floodFill(17, 24, Settings.AVAILABLE_COLORS[colorId]);
			case FlxObject.DOWN:
				temp.floodFill(25, 17, Settings.AVAILABLE_COLORS[colorId]);
			case FlxObject.LEFT:
				temp.floodFill(32, 25, Settings.AVAILABLE_COLORS[colorId]);
		}
		pixels = temp;
		
	}
	
	override public function nextMove(_d:Int) {
		if (_d == Tile.TELEPORT[2]) {		
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
		}
		return 	Tile.STOP;
	}
	
	override public function properAnimation(_d:Int):Array<Dynamic> {
		if (_d == Tile.TELEPORT[2]) {		
			switch (direction) {
				case FlxObject.UP:
					return [0, 1, "teleport"];
				case FlxObject.RIGHT:
					return [90, 0, "teleport"];
				case FlxObject.DOWN:
					return [180, 0, "teleport"];
				case FlxObject.LEFT:
					return [270, 0, "teleport"];
			}	
		} else if (Settings.OPPOSITE_DIRECTIONS[0][0] == _d + direction || Settings.OPPOSITE_DIRECTIONS[0][1] == _d + direction ) {
			switch (direction) {
				case FlxObject.UP:
					return [0, 1, "stopAtTeleport"];
				case FlxObject.RIGHT:
					return [90, 0, "stopAtTeleport"];
				case FlxObject.DOWN:
					return [180, 0, "stopAtTeleport"];
				case FlxObject.LEFT:
					return [270, 0, "stopAtTeleport"];
			}	
		}
		
		return [0, 0, "disappear"];
	}
}