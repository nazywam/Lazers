package tiles;
import openfl.display.BitmapData;
import flixel.FlxObject;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import flixel.FlxSprite;

/**
 * ...
 * @author Michael
 */

class CollectPoint extends Tile {

	
	public var innerCircle : FlxSprite;

	public function new(_x:Float, _y:Float, _t:Int, _d:Int, _m:Bool, _c:Int, _bx:Int, _by:Int) {
		super(_x, _y, _t, _d, _m, _c, _bx, _by);
		type = Tile.COLLECT_POINT;
		passable = true;
		
		var temp:BitmapData = new BitmapData(Settings.TILE_WIDTH, Settings.TILE_HEIGHT, true);
		temp.copyPixels(pixels, new Rectangle(tileID * Settings.TILE_WIDTH, bitmapDataMoveY, Settings.TILE_WIDTH, Settings.TILE_HEIGHT), new Point(0, 0));
		temp.floodFill(48, 7, Settings.AVAILABLE_COLORS[colorId]);
		pixels = temp;
		
		innerCircle = new FlxSprite(_x, _y);
		innerCircle.loadGraphic(Settings.INNER_CIRCLE, true, Settings.TILE_WIDTH, Settings.TILE_HEIGHT);
		innerCircle.animation.add("default", [0]);
		innerCircle.animation.add("complete", [0, 1, 2, 3, 4, 5], Std.int(6 / Settings.LASER_SPEED), false);
		innerCircle.animation.play("default");
		innerCircle.color = Settings.AVAILABLE_COLORS[colorId];
	}
	
	override public function resetState(){
		completed = false;
		innerCircle.animation.play("default");

		while (connectedColors.length != 0) {
			connectedColors.pop();
		}
	}

	override public function complete() {
		completed = true;

		innerCircle.animation.play("complete");
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
				return [270, 0];
			case FlxObject.RIGHT:
				return [0, 0];
			case FlxObject.DOWN:
				return [90, 0];
			case FlxObject.LEFT:
				return [180, 0];
		}
		return super.properAnimation(_d);
	}
	
	function checkConnections() {
		completed = false;
		
		if (connectedColors.length == 1) {
			if (connectedColors[0] == colorId) {
				complete();
				completed = true;
			}
		} else if (connectedColors.length == 2){
			if (Settings.MIXED_COLORS[connectedColors[0]][connectedColors[1]] == colorId) {
				completed = true;
				complete();
			}
		}
	}
	
	override public function update(elapsed:Float) {
		super.update(elapsed);
		if(!completed){
			checkConnections();
		}
	}
}