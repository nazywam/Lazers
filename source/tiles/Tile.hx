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
		
		if(movable){
			animation.add("default", [tileID + 20]);
		} else {
			animation.add("default", [tileID]);
		}
		animation.play("default");

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