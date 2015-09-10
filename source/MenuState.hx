package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Michael
 */
class MenuState extends FlxState {

	var levelIcons:FlxTypedGroup<LevelIcon>;
	
	var transitionScreen:TransitionScreen;
	
	var playButton:Button;
	
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
		
		transitionScreen = new TransitionScreen();
		add(transitionScreen);
		
		playButton = new Button(0, 32, "Play", FlxG.width, 32);
		add(playButton);
	}
	
	
	override public function update(elapsed:Float) {
		super.update(elapsed);
		
		if (FlxG.mouse.justPressed) {
			for (l in levelIcons) {
				if (FlxG.mouse.overlaps(l.icon)) {
					transitionScreen.start();
					
					var t = new FlxTimer();
					t.start(.65, function(_) {
						FlxG.switchState(new PlayState(l.level));		
					});
				}
			}
		}
	}
}