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

	var transitionScreen:TransitionScreen;
	var playButton : Button;
	var howToplayButton : Button;
	var settingsButton : Button;

	override public function create() {
		super.create();
		
		
		
		playButton = new Button(0, 128, "Play", FlxG.width, 64);
		add(playButton);

		howToplayButton = new Button(0, 256, "How to", FlxG.width, 64);
		add(howToplayButton);

		settingsButton = new Button(0, 384, "Settings", FlxG.width, 64);
		add(settingsButton);
		
		transitionScreen = new TransitionScreen();
		add(transitionScreen);

	}
	
	function handleMouse() {
		if (FlxG.mouse.justPressed) {
			if (FlxG.mouse.overlaps(playButton)) {
				transitionScreen.start();
				
				var t = new FlxTimer();
				t.start(.65, function(_) {
					FlxG.switchState(new LevelSelect());		
				});
			}
		}
	}	
	
	override public function update(elapsed:Float) {
		super.update(elapsed);
		handleMouse();
	}
}