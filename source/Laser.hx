import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxTimer;

//0 - blank
//1 - mirror
//2 - backMirror

class Laser extends FlxSprite {

	public var direction:Int;
	public var head:Bool = false;

	override public function new(_x:Float, _y:Float, _d:Int){
		super(_x, _y);
		direction = _d;

		loadGraphic("assets/images/Laser.png", true, 32, 32);
		animation.add("default", [0]);
		animation.play("default");

		switch(direction){
			case FlxObject.UP:
				angle = 90;
			case FlxObject.RIGHT:

			case FlxObject.DOWN:
				angle = 90;
			case FlxObject.LEFT:
		}

		var t = new FlxTimer();
		t.start(.1, function(_){
			head = true;
		});
	}
}