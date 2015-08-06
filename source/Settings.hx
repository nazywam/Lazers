import flixel.FlxObject;

class Settings {
	
	public static var BOARD_WIDTH 	:Int = 		7;
	public static var BOARD_HEIGHT 	:Int = 		7;

	public static var TILE_WIDTH 	:Int = 		48;
	public static var TILE_HEIGHT 	:Int = 		48;
	
	public static var LASER_WIDTH 	:Int = 		48;
	public static var LASER_HEIGHT 	:Int = 		48;
	public static var LASER_SPEED	:Float = 	4/60;

	
	public static var LEVEL_ROWS	:Int = 		5;
	public static var LEVEL_COLUMNS :Int = 		5;
	
	
	public static var AVAILABLE_COLORS : Array<Int> = [
		0xFFFFFFFF,
		0xFFCE181E,
		0xFF62A73B,
		0xFF1C3687
		
	];
	
	public static var OPPOSITE_DIRECTIONS : Array<Array<Int>> = [
	[FlxObject.LEFT + FlxObject.RIGHT, FlxObject.UP + FlxObject.DOWN],
	[FlxObject.LEFT + FlxObject.UP, FlxObject.RIGHT + FlxObject.DOWN],
	[FlxObject.LEFT + FlxObject.DOWN, FlxObject.UP + FlxObject.RIGHT]];
	
	
}