import flixel.effects.particles.FlxEmitter;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

class Laser extends FlxSprite {

	public var direction:Int;

	var tile:Tile;
	
	public var laserNumber:Int;
	
	public var becomeHead:FlxTimer;
	public var emitParticles:Bool;
	
	public var particleEmitter:FlxEmitter;
	
	override public function new(_x:Float, _y:Float, _d:Int, _id:Int, _c:Int, _t:Tile, _l:Int, _p:Bool){
		super(_x, _y);
		direction = _d;
		emitParticles = _p;
		laserNumber = _l;
		
		tile = _t;
		
		loadGraphic("assets/images/Laser.png", true, Settings.LASER_WIDTH, Settings.LASER_HEIGHT);
		animation.add("default", [0, 1, 2, 3, 4, 5, 6, 7], Std.int(8 / Settings.LASER_SPEED), false);
		animation.add("mirror", [8, 9, 10, 11, 12, 13 , 14, 15], Std.int(8 / Settings.LASER_SPEED), false);
		animation.add("backMirror", [16, 17, 18, 19, 20, 21 , 22, 23], Std.int(8 / Settings.LASER_SPEED), false);
		animation.add("source", [24, 25, 26, 27, 28, 29, 30, 31], Std.int(8 / Settings.LASER_SPEED), false);
		
		animation.add("defaultBlink", [40, 41, 42, 43,44 ,45 ,46 ,47, 7], 16, false);
		animation.add("mirrorBlink", [48, 49, 50, 51], 4);
		animation.add("backMirrorBlink", [56, 57, 58, 59], 4);
		
		animation.add("defaultHalf", [0, 1, 2, 3], Std.int(4 / Settings.LASER_SPEED), false);
		animation.add("mirrorHalf", [8, 9, 10, 11], Std.int(4 / Settings.LASER_SPEED), false);
		animation.add("backMirrorHalf", [16, 17, 18], Std.int(4 / Settings.LASER_SPEED), false);
		animation.add("sourceHalf", [24, 25, 26, 27], Std.int(4 / Settings.LASER_SPEED), false);
		animation.add("completeTarget", [32, 33, 34, 35, 36, 37, 38, 39], Std.int(8 / Settings.LASER_SPEED), false);
		
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

		if (emitParticles) {
			particleEmitter = new FlxEmitter(_x + width / 2, _y + height / 2, 50);
			particleEmitter.loadParticles("assets/images/LaserParticles.png", 50, 16, true);
			particleEmitter.color.set(_c, _c);
			particleEmitter.lifespan.set(.75, 1.25);
		}
	
		var directionSum = tile.direction + direction;
		
		switch(tile.type) {
			case Tile.BLANK:
			case Tile.MIRROR:
				animation.play("mirror");
				tile.wobble();
			case Tile.BACK_MIRROR:
				animation.play("backMirror");
				tile.wobble();
			case Tile.BLOCK:
			case Tile.SOURCE:
				animation.play("source");
			case Tile.TARGET:
				if ((directionSum == Settings.OPPOSITE_DIRECTIONS[Tile.BLANK][0] || directionSum == Settings.OPPOSITE_DIRECTIONS[Tile.BLANK][1]) && color == Settings.AVAILABLE_COLORS[tile.colorId]) {
					animation.play("completeTarget");
					tile.complete();
					becomeHead.cancel();
					
					if(emitParticles){
						particleEmitter.start(true, 0.1, 0);
					}
				}
		}
	}	
}