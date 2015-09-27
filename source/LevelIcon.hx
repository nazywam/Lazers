package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import openfl.Assets;
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
	public var stage:Int;

	public function new(_x:Float, _y:Float, _s:Int, _l:Int)  {
		super();
		x = _x;
		y = _y;
		level = _l;
		stage = _s;
		
		icon = new FlxSprite(x, y);
		icon.loadGraphic(Settings.LEVEL_ICON);
		add(icon);
		
		text = new FlxText(x, y + icon.height/2, icon.width, Std.string(stage) + '-' + Std.string(level), 20);
		if(stage == 5){
			text.text = '?-?';
		}
		text.alignment = FlxTextAlign.CENTER;
		text.bold = true;
		text.y -= text.height/2;
		add(text);		

		if(Assets.getText(Settings.LEVEL + Std.string(stage)+ '/' + Std.string(level)+".tmx") == null){
			text.color = 0xFFFF0000;
		}
	}
	
	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
	
}