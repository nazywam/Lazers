package tiles;

import flixel.effects.particles.FlxEmitter;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;

class Tile extends FlxSprite {

	public var tileID:							Int;
	public var type:							Int;
	public var movable:							Bool;
	public var originalPosition:				FlxPoint;
	public var passable:						Bool;
	public var direction:						Int = FlxObject.UP;
	public var colorId:							Int;
	public var connectedColors: 				Array<Int> = [];
	
	public var boardX: 							Int;
	public var boardY: 							Int;
	
	public var particles:						FlxEmitter;
	public var particlesLaunched:				Bool;
	
	public static var TURN_UP: 						Array<Int> = [0, -1, FlxObject.UP];
	public static var TURN_RIGHT: 					Array<Int> = [1, 0, FlxObject.RIGHT];
	public static var TURN_DOWN: 					Array<Int> = [0, 1, FlxObject.DOWN];
	public static var TURN_LEFT: 					Array<Int> = [-1, 0, FlxObject.LEFT];
	public static var STOP: 						Array<Int> = [0, 0, FlxObject.UP];
	
	
	public static inline var BLANK:				Int = 0;
	public static inline var MIRROR:			Int = 1;
	public static inline var BACK_MIRROR:		Int = 2;
	public static inline var BLOCK:				Int = 3;
	public static inline var SOURCE:			Int = 4;
	public static inline var TARGET:			Int = 8;
	public static inline var MERGE:				Int = 12;
	
	override public function new(_x:Float, _y:Float, _t:Int, _d:Int, _m:Bool, _c:Int, _bx:Int, _by:Int){
		super(_x, _y);
		loadGraphic("assets/images/Tiles.png", true, Settings.TILE_WIDTH, Settings.TILE_HEIGHT);
		type = _t;
		movable = _m;
		colorId = _c;
		
		boardX = _bx;
		boardY = _by;

		direction = _d;
		tileID = type;
		
		if (type > SOURCE && type <= SOURCE+3) {
			type = SOURCE;
		} else if (type > TARGET && type <= TARGET +3) {
			type = TARGET;
		} else if (type > MERGE && type <= MERGE + 3) {
			type = MERGE;
		}
		
		if(movable){
			animation.add("default", [tileID + 20]);
		} else {
			animation.add("default", [tileID]);
		}
		animation.play("default");

		switch (type) {
			case BLANK:
				passable = true;
			case MIRROR:
				passable = true;
			case BACK_MIRROR:
				passable = true;
			case BLOCK:
				passable = false;
			case SOURCE:
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
				
				
			case TARGET:
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
			case MERGE:
				passable = true;
		}
		


		originalPosition = new FlxPoint(x, y);
	}	
	
	public function nextMove(_d:Int):Array<Int>{ 
		return [0, 0, FlxObject.UP, 0]; //moveX, moveY, direction, shouldFireOpositeLaser
	}
	
	public function properAnimation(_d:Int):Array<Dynamic> {
		return [0, 0, "default"]; //angle, shouldFlipY, animationName
	}

	public function wobble() {		
		FlxTween.tween(this.scale, {x:1.25, y:1.25}, .2, { ease:FlxEase.elasticOut } );	
		
		
		var t = new FlxTimer();
		t.start(.2, function(_) {
			FlxTween.tween(scale, {x:1, y:1}, .3, {ease:FlxEase.elasticOut});
		});
	} 
	

	public function complete() {
		if (!particlesLaunched) {
			particles.start(true, 0.1, 0);
			particlesLaunched = true;	
		}
	}
	override public function update(elapsed) {
		super.update(elapsed);
		color = 0xFFFFFFFF;
	}
}