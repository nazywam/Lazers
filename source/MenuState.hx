package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
/**
 * ...
 * @author Michael
 */
class MenuState extends FlxState {

	var playButton : Button;
	var howToplayButton : Button;
	var settingsButton : Button;

	override public function create() {
		super.create();
		


		playButton = new Button(0, 256, "Start", FlxG.width, 48);
		add(playButton);

		howToplayButton = new Button(0, 256 + 96, "How to", FlxG.width, 48);
		add(howToplayButton);

		settingsButton = new Button(0, 256 + 96 + 96, "Settings", FlxG.width, 48);
		add(settingsButton);
		
		transitionScreen = new TransitionScreen();
		transitionScreen.startHalf();
		add(transitionScreen);
	}
	
	function handleMouse() {
		if (FlxG.mouse.justPressed) {
			if (FlxG.mouse.overlaps(playButton)) {
				transitionScreen.running = false;
				transitionScreen.start();
				
				var t = new FlxTimer();
				t.start(.65, function(_) {
					FlxG.switchState(new LevelSelect());		
				});
			}

			if (FlxG.mouse.overlaps(settingsButton)) {
				transitionScreen.running = false;
				transitionScreen.start();
				
				var t = new FlxTimer();
				t.start(.65, function(_) {
					FlxG.switchState(new SettingsState());		
				});
			}
		}
	}	
	
	override public function update(elapsed:Float) {
		super.update(elapsed);
		handleMouse();
	}
}