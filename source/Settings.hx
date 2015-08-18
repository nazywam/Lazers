import flixel.FlxObject;
import flixel.math.FlxPoint;

class Settings {
	
	public static var PARTICLES_ON	:Bool = #if mobile false #else true #end;
	public static var FUN			:Bool = 	false;
	
	public static var BOARD_OFFSET	:FlxPoint = FlxPoint.get(3, 3);
	public static var GRID_WIDTH	:Int =		3;
	
	public static var BOARD_WIDTH 	:Int = 		7;
	public static var BOARD_HEIGHT 	:Int = 		7;

	public static var TILE_WIDTH 	:Int = 		48;
	public static var TILE_HEIGHT 	:Int = 		48;
	
	public static var LASER_WIDTH 	:Int = 		48;
	public static var LASER_HEIGHT 	:Int = 		48;
	public static var LASER_SPEED	:Float = 	4/60;

	
	public static var LEVEL_ROWS	:Int = 		5;
	public static var LEVEL_COLUMNS :Int = 		5;
	
	public static var STRIPE_SPEED :Int =		30;
	
	public static var AVAILABLE_COLORS : Array<Int> = [
		0xFFFFFFFF,
		0xFFFF231D,
		0xFF18D224,
		0xFF4F28BD,
		0xFFFFDB1D
	];
	
	public static var OPPOSITE_DIRECTIONS : Array<Array<Int>> = [
	[FlxObject.LEFT + FlxObject.RIGHT, FlxObject.UP + FlxObject.DOWN],
	[FlxObject.LEFT + FlxObject.UP, FlxObject.RIGHT + FlxObject.DOWN],
	[FlxObject.LEFT + FlxObject.DOWN, FlxObject.UP + FlxObject.RIGHT]];
	
	
}