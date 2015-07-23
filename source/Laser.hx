import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxTimer;

class Laser extends FlxSprite {

	public var direction:Int;
	public var head:Bool = false;

	override public function new(_x:Float, _y:Float, _d:Int, _id:Int, _c:Int){
		super(_x, _y);
		direction = _d;

		loadGraphic("assets/images/Laser.png", true, 32, 32);
		animation.add("default", [0, 1, 2, 3, 4, 5, 6, 7], Std.int(8/Settings.LASER_SPEED), false);
		animation.play("default");

		ID = _id;
		color = _c;
		
		switch(direction){
			case FlxObject.UP:
				angle = 270;
			case FlxObject.RIGHT:

			case FlxObject.DOWN:
				angle = 90;
				flipY = true;
			case FlxObject.LEFT:
				flipX = true;
		}

		var t = new FlxTimer();
		t.start(Settings.LASER_SPEED, function(_){
			head = true;
		});
	}
}