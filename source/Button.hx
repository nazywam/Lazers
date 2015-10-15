package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
/**
 * ...
 * @author Michael
 */
class Button extends FlxGroup {

	public var text:FlxText;
	public var background:FlxSprite;
	
	public var x:Float;
	public var y:Float;

	public var colorID:Int;

	public function new(_x:Float, _y:Float, _t:String, _w:Int, _s:Int) {
		super();
		
		x = _x;
		y = _y;

		text = new FlxText(_x, _y, _w, _t, _s);
		text.setFormat(Settings.FONT, _s, FlxColor.BLACK, "center");
		text.bold = true;
		
		background = new FlxSprite(_x, _y);
		background.makeGraphic(_w, Std.int(text.height));
		
		add(background);
		add(text);

		colorID = Std.random(Settings.AVAILABLE_COLORS.length-1);
	}
	
	override public function update(elapsed:Float){
		super.update(elapsed);
		
		text.y = y;
		background.y = y;
	}
	
}