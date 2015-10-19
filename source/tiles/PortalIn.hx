package tiles;
import flixel.FlxObject;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.geom.Point;

/**
 * ...
 * @author Michael
 */
class PortalIn extends Tile {

	public function new(_x:Float, _y:Float, _t:Int, _d:Int, _m:Bool, _c:Int, _bx:Int, _by:Int) {
		super(_x, _y, _t, _d, _m, _c, _bx, _by);
		passable = true;
		type = Tile.PORTAL_IN;	
		

		
		var temp:BitmapData = new BitmapData(Settings.TILE_WIDTH, Settings.TILE_HEIGHT, true);
		temp.copyPixels(pixels, new Rectangle(tileID * Settings.TILE_WIDTH, bitmapDataMoveY, Settings.TILE_WIDTH, Settings.TILE_HEIGHT), new Point(0, 0));
		
		switch(direction) {
			case FlxObject.UP:
				temp.floodFill(24*2, 13*2, Settings.AVAILABLE_COLORS[colorId]);
			case FlxObject.RIGHT:
				temp.floodFill(35*2, 26*2, Settings.AVAILABLE_COLORS[colorId]);
			case FlxObject.DOWN:
				temp.floodFill(24*2, 36*2, Settings.AVAILABLE_COLORS[colorId]);
			case FlxObject.LEFT:
				temp.floodFill(13*2, 24*2, Settings.AVAILABLE_COLORS[colorId]);
		}
		pixels = temp;
		
	}
	
	override public function nextMove(_d:Int) {
		if (_d == direction) {
			return 	Tile.TELEPORT;
		}
		return Tile.STOP;
	}
	
	override public function properAnimation(_d:Int):Array<Dynamic> {
		if (_d == direction) {
			switch (_d) {
				case FlxObject.UP:
					return [180, 1, "stopAtTeleport"];
				case FlxObject.RIGHT:
					return [90, 1, "stopAtTeleport"];
				case FlxObject.DOWN:
					return [0, 0, "stopAtTeleport"];
				case FlxObject.LEFT:
					return [270, 1, "stopAtTeleport"];
			}
		}
		return [0, 0, "disappear"];
	}
}