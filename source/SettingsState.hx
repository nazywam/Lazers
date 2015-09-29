import flixel.FlxState;
import flixel.FlxG;
import flixel.util.FlxTimer;
import openfl.events.KeyboardEvent;
import openfl.Lib;

class SettingsState extends FlxState {

	var transitionScreen : TransitionScreen;
	
	var transitionButton: Button;
	var soundButton:Button;
	var deleteButton: Button;

	var backButton : Button;
	
	override public function new(){
		super();
		Lib.current.stage.addEventListener (KeyboardEvent.KEY_UP, onKeyUp);
	}

	override public function create(){
		super.create();

		backButton = new Button(0, FlxG.height * 3 / 4, "Back", FlxG.width, 36);
		add(backButton);
		
		transitionButton = new Button(0, 128, "Transitions: Yes", FlxG.width,36);
		add(transitionButton);
		
		soundButton = new Button(0, transitionButton.y + transitionButton.background.height + 48, "Sound: Yes", FlxG.width, 36);
		add(soundButton);
		
		deleteButton = new Button(0, soundButton.y + soundButton.background.height + 48, "Delete saves", FlxG.width, 36);
		add(deleteButton);
		
		transitionScreen = new TransitionScreen();
		transitionScreen.startHalf();
		add(transitionScreen);
	}	

	function handleMouse() {
	
		if (FlxG.mouse.justPressed) {
			if (FlxG.mouse.overlaps(backButton)) {
				transitionScreen.running = false;
				transitionScreen.start();
			
				var t = new FlxTimer();
				t.start(.65, function(_) {
					FlxG.switchState(new MenuState());
				});
			}
		}
		
	}
	
	override public function update(elapsed : Float) {
		super.update(elapsed);	
		
		handleMouse();
		
	}
	

	private function onKeyUp (event:KeyboardEvent) {
		#if android
			if (event.keyCode == 27) {
				event.stopImmediatePropagation();

				//transitionScreen.running = false;
				//transitionScreen.start();

//				var t = new FlxTimer();
//				t.start(.65, function(_) {
					FlxG.switchState(new LevelSelect());	
//				});
			}
		#end
	}
}