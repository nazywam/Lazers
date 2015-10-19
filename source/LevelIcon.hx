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

	var completed:Bool;
	
	public function new(_x:Float, _y:Float, _s:Int, _l:Int, _c:Bool)  {
		super();
		x = _x;
		y = _y;
		level = _l;
		stage = _s;
		completed = _c;
		
		icon = new FlxSprite(x, y);
		icon.loadGraphic(Settings.LEVEL_ICON, true, 104, 104);
		icon.animation.add("default", [0]);
		icon.animation.add("completed", [1, 2, 3, 4, 5, 6, 7, 8], 8);
		add(icon);
		
		if (completed) {
			icon.animation.play("completed");
		} else {
			icon.animation.play("default");
		}
		
		
		text = new FlxText(x, y + icon.height/2, icon.width, Std.string(Settings.LEVELS_IN_STAGE * (stage) + level), 36);
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
		
		icon.y = y;
		text.y = y + (icon.height - text.height)/2;
	}
	
}