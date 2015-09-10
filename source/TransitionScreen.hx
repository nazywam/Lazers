package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
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
				var s = new FlxSprite(48 * x, 48 * y);
				s.loadGraphic("assets/images/Tiles.png", true, 48, 48);
				s.animation.add("default", [Tile.BLOCK]);
				s.animation.play("default");
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
	
	public function setupHalf() {
		for(y in 0...board.length){
			for(x in 0...board[y].length){
				board[y][x].scale.x = board[y][x].scale.y = 1;
			}
		}
	}

	public function startHalf() {
		if (!running) {
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