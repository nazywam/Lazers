package;


import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import tiles.*;
/**
 * ...
 * @author Michael
 */
class TransitionScreen extends FlxGroup {

	var board : Array<Array<FlxSprite>>;
	
	public var running:Bool = false;
	
	public function new() {
		super();
		
		board = new Array < Array < FlxSprite >> ();

		for (y in 0...16) {
			board[y] = new Array<FlxSprite>();
			for (x in 0...9) {
				var s = new FlxSprite(96 * x, 96 * y);
				s.scrollFactor.x = s.scrollFactor.y = 0;
				s.loadGraphic(Settings.TILES_IMAGE, true, 96, 96);
				s.animation.add("default", [Tile.BLOCK]);
				s.animation.play("default");
				s.color = Settings.AVAILABLE_COLORS[((x+y)*(x+y) + x - y) % Settings.AVAILABLE_COLORS.length];
				s.scale.x = s.scale.y = 0; 
				board[y].push(s);
				add(s);
			}
		}
	}

	public function start() {
		if (!running) {
			running = true;	
			for(y in 0...board.length){
				for(x in 0...board[y].length){
					var t = new FlxTimer();
					t.start(Std.random(15)/100, function(_){
						FlxTween.tween(board[y][x].scale, {x:1, y:1}, .5, {ease:FlxEase.cubeInOut});
					});
				}
			}
		}
	}
	
	public function startHalf() {
		if (!running) {
			
			for(y in 0...board.length){
				for(x in 0...board[y].length){
					board[y][x].scale.x = board[y][x].scale.y = 1;
				}
			}
			
			running = true;	
			for(y in 0...board.length){
				for(x in 0...board[y].length){
					var t = new FlxTimer();
					t.start(Std.random(15)/100, function(_){
						FlxTween.tween(board[y][x].scale, {x:0, y:0}, .5, {ease:FlxEase.cubeInOut});
					});
				}
			}
		}
	}
	
	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
	
	
}