import flixel.FlxState;
import flixel.FlxG;

class SettingsState extends FlxState {

	var transitionScreen : TransitionScreen;

	override public function create(){
		super.create();

		var a = new Button(0, FlxG.height/2, "Lorem Ipsum Dupsum", FlxG.width, 24);
		add(a);

		transitionScreen = new TransitionScreen();
		transitionScreen.startHalf();
		add(transitionScreen);
	}	
}