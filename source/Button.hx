package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;

/**
 * ...
 * @author Michael
 */
class Button extends FlxGroup {

	public var text:FlxText;
	public var background:FlxSprite;
	
	public var x:Float;
	public var y:Float;
	
	public function new(_x:Float, _y:Float, _t:String, _w:Int, _s:Int) {
		super();
		
		x = _x;
		y = _y;
		
		text = new FlxText(_x, _y, _w, _t, _s);
		text.color = 0;
		text.alignment = FlxTextAlign.CENTER;
		
		background = new FlxSprite(_x, _y);
		background.makeGraphic(_w, Std.int(text.height));
		
		add(background);
		add(text);

	}
	
}