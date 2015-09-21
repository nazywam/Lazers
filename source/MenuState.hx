package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
/**
 * ...
 * @author Michael
 */
class MenuState extends FlxState {

	var transitionScreen:TransitionScreen;
	var playButton : Button;
	var howToplayButton : Button;
	var settingsButton : Button;
	var logo:FlxSprite;

	override public function create() {
		super.create();
		
		logo = new FlxSprite(FlxG.width/2, 32);
		logo.loadGraphic(Settings.FIRE_DEM_LAZERS, true, 240, 156);
		logo.x -= logo.width/2;
		logo.animation.add("default", [0,1,2,3,4, 4, 4, 4, 4, 4, 4, 3, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0,], 12);
		logo.animation.play("default");
		add(logo);

		playButton = new Button(0, 256, "Start", FlxG.width, 48);
		add(playButton);

		howToplayButton = new Button(0, 256 + 96, "How to", FlxG.width, 48);
		add(howToplayButton);

		settingsButton = new Button(0, 256 + 96 + 96, "Settings", FlxG.width, 48);
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

			if (FlxG.mouse.overlaps(settingsButton)) {
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