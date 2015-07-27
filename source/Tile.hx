import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.FlxObject;

class Tile extends FlxSprite {

	public var type:Int;
	public var movable:Bool;
	public var originalPosition:FlxPoint;
	public var passable:Bool;
	public var direction:Int = FlxObject.UP;

	public static inline var BLANK:				Int = 0;
	public static inline var MIRROR:			Int = 1;
	public static inline var BACK_MIRROR:		Int = 2;
	public static inline var BLOCK:				Int = 3;

	public static inline var SOURCE_UP:			Int = 4;
	public static inline var SOURCE_RIGHT:		Int = 5;
	public static inline var SOURCE_DOWN:		Int = 6;
	public static inline var SOURCE_LEFT:		Int = 7;

	public static inline var TARGET_UP:			Int = 8;
	public static inline var TARGET_RIGHT:		Int = 9;
	public static inline var TARGET_DOWN:		Int = 10;
	public static inline var TARGET_LEFT:		Int = 11;

	override public function new(_x:Float, _y:Float, _t:Int, _m:Bool){
		super(_x, _y);
		loadGraphic("assets/images/Tiles.png", true, 32, 32);
		type = _t;
		movable = _m;

		if(movable){
			animation.add("default", [type + 20]);
		} else {
			animation.add("default", [type]);
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
			case SOURCE_UP:
				direction = FlxObject.UP;
				passable = false;
			case SOURCE_RIGHT:
				direction = FlxObject.RIGHT;
				passable = false;
			case SOURCE_DOWN:
				direction = FlxObject.DOWN;
				passable = false;
			case SOURCE_LEFT:
				direction = FlxObject.LEFT;
				passable = false;
			case TARGET_UP:
				direction = FlxObject.UP;
				passable = true;
			case TARGET_RIGHT:
				direction = FlxObject.RIGHT;
				passable = true;
			case TARGET_DOWN:
				direction = FlxObject.DOWN;
				passable = true;
			case TARGET_LEFT:
				direction = FlxObject.LEFT;
				passable = true;
		}

		originalPosition = new FlxPoint(x, y);
	}	

}