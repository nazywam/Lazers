package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Michael
 */
class TransitionScreen extends FlxGroup {

	var board : Array<Array<FlxSprite>>;
	
	var running:Bool = false;
	
	public function new() {
		super();
		
		board = new Array < Array < FlxSprite >> ();
		
		
		
		for (y in 0...16) {
			board[y] = new Array<FlxSprite>();
			for (x in 0...9) {
				var s = new FlxSprite(40 * x, 40 * y);
				board[y].push(s);
				add(s);
			}
		}
	}

	public function start() {
		if (!running) {
			running = true;	
			
		}
	}
	
	public function startHalf() {
		if (!running) {
			running = true;	
			
		}
	}
	
	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
	
	
}