import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.util.FlxTimer;

class LogoScreen extends FlxState {
	override public function create(){
		super.create();
		var logo = new FlxSprite(0,0, Settings.LOGO_SCREEN);
		add(logo);

		logo.alpha = 0;
		FlxTween.tween(logo, {alpha:1}, .4, {ease:FlxEase.quadOut});

		var t = new FlxTimer();
		t.start(1.5, function(_){
			FlxTween.tween(logo, {alpha:0}, .5, {ease:FlxEase.quadIn});

		});

		var r = new FlxTimer();
		r.start(1.9, function(_){
			FlxG.switchState(new LevelSelect());
		});

	}
}