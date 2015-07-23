import flixel.FlxSprite;

class Tile extends FlxSprite {

	public var type:Int;

	override public function new(_x:Float, _y:Float, _t:Int){
		super(_x, _y);
		loadGraphic("assets/images/Tiles.png", true, 32, 32);
		type = _t;
		animation.add("default", [type]);
		animation.play("default");
	}	
}