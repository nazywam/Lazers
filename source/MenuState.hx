package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;

/**
 * ...
 * @author Michael
 */
class MenuState extends FlxState {

	var levelIcons:FlxTypedGroup<LevelIcon>;
	
	override public function create() {
		super.create();
		
		levelIcons = new FlxTypedGroup<LevelIcon>();
		add(levelIcons);
		
		for (y in 0...Settings.LEVEL_ROWS) {
			for (x in 0...Settings.LEVEL_COLUMNS) {
				var l = new LevelIcon(x * 64 + (FlxG.width - Settings.LEVEL_COLUMNS * 64 + 16)/2, y * 64, y*Settings.LEVEL_ROWS + x + 1);
				levelIcons.add(l);
			}
		}
		
	}
	
	
	override public function update(elapsed:Float) {
		super.update(elapsed);
		
		if (FlxG.mouse.justPressed) {
			for (l in levelIcons) {
				if (FlxG.mouse.overlaps(l.icon)) {
					FlxG.switchState(new PlayState(l.level));
				}
			}
		}
	}
}