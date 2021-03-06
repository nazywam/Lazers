import flixel.FlxSprite;
import flixel.util.FlxTimer;
import openfl.display.BlendMode;
import tiles.Tile;

class Laser extends FlxSprite {

	public var direction:Int;

	var tile:Tile;
	
	public var laserNumber:Int;
	public var colorId:Int;
	public var becomeHead:FlxTimer;
	
	override public function new(_x:Float, _y:Float, _d:Int, _id:Int, _c:Int, _t:Tile, _l:Int){
		super(_x, _y);
		direction = _d;
		laserNumber = _l;
		colorId = _c;
		tile = _t;
		
		blend = BlendMode.ADD;
		
		loadGraphic(Settings.LASER, true, Settings.LASER_WIDTH, Settings.LASER_HEIGHT);
		animation.add("default", [0, 1, 2, 3, 4, 5, 6, 7], Std.int(8 / Settings.LASER_SPEED), false);
		animation.add("mirror", [8, 9, 10, 11, 12, 13 , 14, 15], Std.int(8 / Settings.LASER_SPEED), false);
		animation.add("sourceReverse", [24, 25, 26, 27], Std.int(4 / Settings.LASER_SPEED), false);
		animation.add("teleport", [59, 60, 61], Std.int(3 / Settings.LASER_SPEED), false);
		animation.add("stopAtTeleport", [56, 57, 58], Std.int(3 / Settings.LASER_SPEED), false);
		animation.add("source", [28, 29, 30, 31], Std.int(4 / Settings.LASER_SPEED), false);
		animation.add("merge", [40, 41, 42, 43,44 ,45 ,46 ,47], Std.int(8 / Settings.LASER_SPEED), false);
		animation.add("target", [0, 1, 2, 3, 4, 5, 6, 7], Std.int(8 / Settings.LASER_SPEED), false);
		animation.add("mergeSplit", [48, 49, 50, 51, 52, 53 ,54 ,55], Std.int(8 / Settings.LASER_SPEED), false);
		animation.add("mergeStop", [24, 25, 26], Std.int(3 / Settings.LASER_SPEED), false);
		animation.add("stopAtSource", [16, 17, 18], Std.int(3 / Settings.LASER_SPEED), false);
		animation.add("disappear", [64], Std.int(1 / Settings.LASER_SPEED), false);
		animation.play("default");

		ID = _id;
		color= Settings.AVAILABLE_COLORS[colorId];
		
		becomeHead = new FlxTimer();
		
		var directionSum = tile.direction + direction;
		
		switch(tile.type) {
			case Tile.BLANK:
				animation.play("default");
			case Tile.MIRROR:
				animation.play("mirror");
				tile.wobble();
			case Tile.BACK_MIRROR:
				animation.play("mirror");
				tile.wobble();
			case Tile.BLOCK:
			case Tile.SOURCE:
				animation.play("source");
			case Tile.TARGET:
				if ((directionSum == Settings.OPPOSITE_DIRECTIONS[Tile.BLANK][0] || directionSum == Settings.OPPOSITE_DIRECTIONS[Tile.BLANK][1])) {
					tile.connectedColors.push(colorId);
					animation.play("target");
					tile.wobble();
				}
			case Tile.MERGE:
				animation.play("merge");
				flipY = false;
		}
		
		var tmp = tile.properAnimation(direction);
		if (tmp[0] != 0) {
			angle = tmp[0];
		}
		if (tmp[1] != 0) {
			if (angle % 180 == 0) {
				flipX = true;	
			} else {
				flipY = true;	
			}
		} 
		if (tmp[2] != null){
			animation.play(tmp[2]);
		}
	}
	override public function destroy() {
		tile = null;
		becomeHead = null;
		super.destroy();	
	}
}