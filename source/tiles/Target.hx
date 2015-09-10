package tiles;
import flixel.FlxObject;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import flixel.effects.particles.FlxEmitter;

class Target extends Tile {

	override public function new(_x:Float, _y:Float, _t:Int, _d:Int, _m:Bool, _c:Int, _bx:Int, _by:Int){
		super(_x, _y, _t, _d, _m, _c, _bx, _by);
		type = Tile.TARGET;
		passable = false;
		
		var temp:BitmapData = new BitmapData(48, 48, true);
		temp.copyPixels(pixels, new Rectangle(tileID * 48, 0, 48, 48), new Point(0, 0));
		
		switch(direction) {
			case FlxObject.UP:
				temp.floodFill(13, 43, Settings.AVAILABLE_COLORS[colorId]);
				temp.floodFill(35, 43, Settings.AVAILABLE_COLORS[colorId]);
			case FlxObject.RIGHT:
				temp.floodFill(8, 14, Settings.AVAILABLE_COLORS[colorId]);
				temp.floodFill(8, 35, Settings.AVAILABLE_COLORS[colorId]);
			case FlxObject.DOWN:
				temp.floodFill(14, 8, Settings.AVAILABLE_COLORS[colorId]);
				temp.floodFill(35, 8, Settings.AVAILABLE_COLORS[colorId]);
			case FlxObject.LEFT:
				temp.floodFill(42, 14, Settings.AVAILABLE_COLORS[colorId]);
				temp.floodFill(42, 35, Settings.AVAILABLE_COLORS[colorId]);
		}
		pixels = temp;
		
		particles = new FlxEmitter(_x + width / 2, _y + height / 2, 50);
		particles.loadParticles("assets/images/LaserParticles.png", 50, 16, true);
		particles.lifespan.set(3, 5);
		particles.color.set(Settings.AVAILABLE_COLORS[colorId], Settings.AVAILABLE_COLORS[colorId], Settings.AVAILABLE_COLORS[colorId], Settings.AVAILABLE_COLORS[colorId]);
		particles.angularVelocity.set( -200, 200, -200, 200);

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
	
	override public function properAnimation(_d:Int) :Array<Dynamic>{
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
}