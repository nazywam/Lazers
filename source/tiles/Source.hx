package tiles;
import flixel.FlxObject;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.geom.Point;

class Source extends Tile {

	override public function new(_x:Float, _y:Float, _t:Int, _d:Int, _m:Bool, _c:Int, _bx:Int, _by:Int){
		super(_x, _y, _t, _d, _m, _c, _bx, _by);
		type = Tile.SOURCE;
		
		passable = false;
				
		var temp:BitmapData = new BitmapData(48, 48, true);
		temp.copyPixels(pixels, new Rectangle(tileID * 48, 0, 48, 48), new Point(0, 0));
		
		switch(direction) {
			case FlxObject.UP:
				temp.floodFill(18, 23, Settings.AVAILABLE_COLORS[colorId]);
			case FlxObject.RIGHT:
				temp.floodFill(3, 19, Settings.AVAILABLE_COLORS[colorId]);
			case FlxObject.DOWN:
				temp.floodFill(18, 3, Settings.AVAILABLE_COLORS[colorId]);
			case FlxObject.LEFT:
				temp.floodFill(23, 19, Settings.AVAILABLE_COLORS[colorId]);
		}
				
		pixels = temp;
	}

	override public function nextMove(_d:Int){
		switch (_d) {
			case FlxObject.UP:
				return Tile.TURN_UP;
			case FlxObject.RIGHT:
				return Tile.TURN_RIGHT;
			case FlxObject.DOWN:
				return Tile.TURN_DOWN;
			case FlxObject.LEFT:
				return Tile.TURN_LEFT;
		}
		return Tile.STOP;
	}
	
	override public function properAnimation(_d:Int):Array<Dynamic> {
		switch (_d) {
			case FlxObject.UP:
				switch (direction) {
					case FlxObject.UP:
						return [270, 0];
					case FlxObject.RIGHT:
						return [270, 0, "stopAtSource"];
					case FlxObject.DOWN:
						return [90, 0, "sourceReverse"];
					case FlxObject.LEFT:
						return [270, 0, "stopAtSource"];

				}
			case FlxObject.RIGHT:
				switch (direction) {
					case FlxObject.UP:
						return [0, 0, "stopAtSource"];
					case FlxObject.RIGHT:
						return [0, 0];
					case FlxObject.DOWN:
						return [0, 0, "stopAtSource"];
					case FlxObject.LEFT:
						return [180, 0, "sourceReverse"];
				}
			case FlxObject.DOWN:
				switch (direction) {
					case FlxObject.UP:
						return [270, 0, "sourceReverse"];
					case FlxObject.RIGHT:
						return [90, 0, "stopAtSource"];
					case FlxObject.DOWN:
						return [90, 0];
					case FlxObject.LEFT:
						return [90, 0, "stopAtSource"];

				}
			case FlxObject.LEFT:
				switch (direction) {
					case FlxObject.UP:
						return [180, 0, "stopAtSource"];
					case FlxObject.RIGHT:
						return [0, 0, "sourceReverse"];
					case FlxObject.DOWN:
						return [180, 0, "stopAtSource"];
					case FlxObject.LEFT:
						return [180, 0];
				}
		}
		return super.properAnimation(_d);
	}
}