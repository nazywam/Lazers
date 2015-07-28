import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxTimer;
import haxe.Timer;

class Laser extends FlxSprite {

	public var direction:Int;

	var tile:Tile;
	
	public var becomeHead:FlxTimer;
	
	override public function new(_x:Float, _y:Float, _d:Int, _id:Int, _c:Int, _t:Tile){
		super(_x, _y);
		direction = _d;

		tile = _t;
		
		loadGraphic("assets/images/Laser.png", true, Settings.LASER_WIDTH, Settings.LASER_HEIGHT);
		animation.add("default", [0, 1, 2, 3, 4, 5, 6, 7], Std.int(8 / Settings.LASER_SPEED), false);
		animation.add("mirror", [8, 9, 10, 11, 12, 13 , 14, 15], Std.int(8 / Settings.LASER_SPEED), false);
		animation.add("backMirror", [16, 17, 18, 19, 20, 21 , 22, 23], Std.int(8 / Settings.LASER_SPEED), false);
		animation.add("source", [24, 25, 26, 27, 28, 29, 30, 31], Std.int(8 / Settings.LASER_SPEED), false);
		
		animation.play("default");

		ID = _id;
		color = _c;
		
		becomeHead = new FlxTimer();
		
		switch(direction){
			case FlxObject.UP:
				angle = 270;
				flipY = true;
			case FlxObject.RIGHT:

			case FlxObject.DOWN:
				angle = 90;
				flipY = true;
			case FlxObject.LEFT:
				flipX = true;
				flipY = true;
		}

		switch(tile.type) {
			case Tile.BLANK:
				
			case Tile.MIRROR:
				animation.play("mirror");
			case Tile.BACK_MIRROR:
				animation.play("backMirror");


			case Tile.BLOCK:
				
			case Tile.SOURCE_UP:
				animation.play("source");
			case Tile.SOURCE_RIGHT:
				animation.play("source");
			case Tile.SOURCE_DOWN:
				animation.play("source");
			case Tile.SOURCE_LEFT:
				animation.play("source");
				
			case Tile.TARGET_UP:
			case Tile.TARGET_RIGHT:
			case Tile.TARGET_DOWN:
			case Tile.TARGET_LEFT:
		}
	}
}