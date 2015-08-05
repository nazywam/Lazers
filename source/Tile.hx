import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;

class Tile extends FlxSprite {

	public var type:Int;
	public var movable:Bool;
	public var originalPosition:FlxPoint;
	public var passable:Bool;
	public var direction:Int = FlxObject.UP;
	public var colorId:Int;
	
	
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

	override public function new(_x:Float, _y:Float, _t:Int, _m:Bool, _c:Int){
		super(_x, _y);
		loadGraphic("assets/images/Tiles.png", true, Settings.TILE_WIDTH, Settings.TILE_HEIGHT);
		type = _t;
		movable = _m;
		colorId = _c;
		
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
				
				var temp:BitmapData = new BitmapData(48, 48, false);
				temp.copyPixels(pixels, new Rectangle(4*48, 0, 48, 48), new Point(0, 0));
				temp.floodFill(18, 23, Settings.AVAILABLE_COLORS[colorId]);
				pixels = temp;
				
			case SOURCE_RIGHT:
				direction = FlxObject.RIGHT;
				passable = false;
				
				var temp:BitmapData = new BitmapData(48, 48, false);
				temp.copyPixels(pixels, new Rectangle(5*48, 0, 48, 48), new Point(0, 0));
				temp.floodFill(3, 19, Settings.AVAILABLE_COLORS[colorId]);
				pixels = temp;
			case SOURCE_DOWN:
				direction = FlxObject.DOWN;
				passable = false;
				
				var temp:BitmapData = new BitmapData(48, 48, false);
				temp.copyPixels(pixels, new Rectangle(6*48, 0, 48, 48), new Point(0, 0));
				temp.floodFill(18, 3, Settings.AVAILABLE_COLORS[colorId]);
				pixels = temp;
			case SOURCE_LEFT:
				direction = FlxObject.LEFT;
				passable = false;
				
				var temp:BitmapData = new BitmapData(48, 48, false);
				temp.copyPixels(pixels, new Rectangle(7*48, 0, 48, 48), new Point(0, 0));
				temp.floodFill(23, 19, Settings.AVAILABLE_COLORS[colorId]);
				pixels = temp;
			case TARGET_UP:
				direction = FlxObject.UP;
				passable = true;
				
				var temp:BitmapData = new BitmapData(48, 48, false);
				temp.copyPixels(pixels, new Rectangle(8*48, 0, 48, 48), new Point(0, 0));
				temp.floodFill(13, 43, Settings.AVAILABLE_COLORS[colorId]);
				temp.floodFill(35, 43, Settings.AVAILABLE_COLORS[colorId]);
				pixels = temp;
				
			case TARGET_RIGHT:
				direction = FlxObject.RIGHT;
				passable = true;
				
					direction = FlxObject.UP;
				passable = true;
				
				var temp:BitmapData = new BitmapData(48, 48, false);
				temp.copyPixels(pixels, new Rectangle(9*48, 0, 48, 48), new Point(0, 0));
				temp.floodFill(8, 14, Settings.AVAILABLE_COLORS[colorId]);
				temp.floodFill(8, 35, Settings.AVAILABLE_COLORS[colorId]);
				pixels = temp;
			case TARGET_DOWN:
				direction = FlxObject.DOWN;
				passable = true;
				
				var temp:BitmapData = new BitmapData(48, 48, false);
				temp.copyPixels(pixels, new Rectangle(10*48, 0, 48, 48), new Point(0, 0));
				temp.floodFill(14, 8, Settings.AVAILABLE_COLORS[colorId]);
				temp.floodFill(35, 8, Settings.AVAILABLE_COLORS[colorId]);
				pixels = temp;
			case TARGET_LEFT:
				direction = FlxObject.LEFT;
				passable = true;
				
				var temp:BitmapData = new BitmapData(48, 48, false);
				temp.copyPixels(pixels, new Rectangle(11*48, 0, 48, 48), new Point(0, 0));
				temp.floodFill(42, 14, Settings.AVAILABLE_COLORS[colorId]);
				temp.floodFill(42, 35, Settings.AVAILABLE_COLORS[colorId]);
				pixels = temp;
		}
		


		originalPosition = new FlxPoint(x, y);
	}	

}