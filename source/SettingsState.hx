import flixel.FlxState;
import flixel.FlxG;
import openfl.events.KeyboardEvent;
import openfl.Lib;

class SettingsState extends FlxState {

	var transitionScreen : TransitionScreen;

	override public function new(){
		super();
		Lib.current.stage.addEventListener (KeyboardEvent.KEY_UP, onKeyUp);
	}

	override public function create(){
		super.create();

		var a = new Button(0, FlxG.height/2, "Lorem Ipsum Dupsum", FlxG.width, 24);
		add(a);

		transitionScreen = new TransitionScreen();
		transitionScreen.startHalf();
		add(transitionScreen);
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