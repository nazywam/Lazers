package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;

/**
 * ...
 * @author Michael
 */
class LevelIcon extends FlxGroup {

	public var icon:FlxSprite;
	public var text:FlxText;
	
	public var x:Float;
	public var y:Float;
	
	public var level:Int;
	
	public function new(_x:Float, _y:Float, _l:Int)  {
		super();
		x = _x;
		y = _y;
		level = _l;
		
		icon = new FlxSprite(x, y);
		icon.loadGraphic(Settings.LEVEL_ICON);
		add(icon);
		
		text = new FlxText(x, y + icon.height/2, icon.width, Std.string(level), 32);
		text.font = Settings.FONT;
		text.alignment = FlxTextAlign.CENTER;
		text.bold = true;
		text.y -= text.height/2;
		add(text);		
	}
	
	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
	
}