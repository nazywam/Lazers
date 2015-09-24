import flixel.FlxObject;
import flixel.math.FlxPoint;

class Settings {	
	
	public static var PARTICLES_ON		:Bool =		true;
	public static var FUN				:Bool = 	false;
	
	public static var BOARD_OFFSET_X	:Int = 		3;
	public static var BOARD_OFFSET_Y	:Int =		3;
	public static var GRID_WIDTH		:Int =		3;
	
	public static var BOARD_WIDTH 		:Int = 		7;
	public static var BOARD_HEIGHT 		:Int = 		7;

	public static var TILE_WIDTH 		:Int = 		48;
	public static var TILE_HEIGHT 		:Int = 		48;
	
	public static var LASER_WIDTH 		:Int = 		48;
	public static var LASER_HEIGHT 		:Int = 		48;
	public static var LASER_SPEED		:Float = 	4/60;

	
	public static var LEVEL_ROWS		:Int = 		5;
	public static var LEVEL_COLUMNS 	:Int = 		5;
	
	public static var STRIPE_SPEED	 	:Int =		30;
	
	public static var STAGE_HEIGHT	 	:Int =		180;
	public static var LEVELS_IN_STAGE	:Int =		10;


	public static var RED : Int = 				0;
	public static var GREEN : Int = 			1;
	public static var BLUE : Int = 				2;
	public static var YELLOW : Int = 			3;
	public static var MAGENTA : Int = 			4;
	public static var CYAN : Int = 				5;
	public static var WHITE : Int = 			6;
	
	public static var MIXED_COLORS : Array<Array<Int>> = [
		[RED, YELLOW, MAGENTA, 0, 0, 0, 0],
		[YELLOW, GREEN, CYAN, 0, 0, 0, 0],
		[MAGENTA, CYAN, BLUE, 0, 0, 0, 0],
		[0, 0, 0, YELLOW, RED, GREEN, 0],
		[0, 0, 0, RED, MAGENTA, BLUE, 0],
		[0, 0, 0, GREEN, BLUE, CYAN, 0],
		[0, 0, 0, 0, 0, 0, 0],
	];
	
	public static var AVAILABLE_COLORS : Array<Int> = [
		0xFFFF0000, //red
		0xFF00FF00, //green
		0xFF0000FF, //blue
		0xFFFFFF00, //yellow
		0xFFFF00FF,	//magenta
		0xFF00FFFF,	//cyan
		0xFFFFFFFF	//white				
	];
	
	public static var TILE_DIRECTIONS : Array<Int> = [FlxObject.UP, FlxObject.UP, FlxObject.UP, FlxObject.UP, FlxObject.UP, FlxObject.RIGHT, FlxObject.DOWN, FlxObject.LEFT, FlxObject.UP, FlxObject.RIGHT, FlxObject.DOWN, FlxObject.LEFT, FlxObject.UP, FlxObject.RIGHT, FlxObject.DOWN, FlxObject.LEFT];
	
	public static var OPPOSITE_DIRECTIONS : Array<Array<Int>> = [
	[FlxObject.LEFT + FlxObject.RIGHT, FlxObject.UP + FlxObject.DOWN],
	[FlxObject.LEFT + FlxObject.UP, FlxObject.RIGHT + FlxObject.DOWN],
	[FlxObject.LEFT + FlxObject.DOWN, FlxObject.UP + FlxObject.RIGHT]];
	
	public static inline var FONT :				String = "assets/edunline.ttf";
	public static inline var TILES_IMAGE : 		String = "assets/images/Tiles.png";
	public static inline var GRID : 			String = "assets/images/Grid.png";
	public static inline var AVAILABLE_TILES : 	String = "assets/images/AvailableTiles.png";
	public static inline var LEVEL_404 : 		String = "assets/data/404.tmx";
	public static inline var LEVEL_ICON : 		String = "assets/images/LevelIcon.png";
	public static inline var LASER : 			String = "assets/images/Laser.png";
	public static inline var LEVEL : 			String = "assets/data/level";
	public static inline var FIRE_DEM_LAZERS : 	String = "assets/images/FireDemLazers.png";

	public static inline var STAGES : 			String = "assets/images/Stages.png";
}