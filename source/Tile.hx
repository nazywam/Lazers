import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Tile extends FlxSprite {

	public var type:Int;
	public var movable:Bool;

	public var originalPosition:FlxPoint;



	public static inline var BLANK 			:Int = 0;
	public static inline var MIRROR 		:Int = 1;
	public static inline var BACK_MIRROR 	:Int = 2;
	public static inline var BLOCK 			:Int = 3;
	public static inline var SOURCE 		:Int = 4;

	override public function new(_x:Float, _y:Float, _t:Int, _m:Bool){
		super(_x, _y);
		loadGraphic("assets/images/Tiles.png", true, 32, 32);
		type = _t;
		movable = _m;

		if(movable){
			animation.add("default", [type + 6]);
		} else {
			animation.add("default", [type]);
		}
		

		animation.play("default");

		originalPosition = new FlxPoint(x, y);
	}	

}