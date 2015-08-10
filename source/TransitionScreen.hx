package;

import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Michael
 */
class TransitionScreen extends FlxGroup {

	var stripes:Array<FlxSprite>;
	
	var running:Bool = false;
	
	public function new() {
		super();
		
		stripes = new Array<FlxSprite>();
		
		for (i in 0...Std.int(FlxG.height / 32)) {
			var s = new FlxSprite(0, 32 * i);
			s.makeGraphic(0, 32, 0);
			s.ID = i;
			add(s);
			stripes.push(s);
		}
	}
	
	public function setupHalf() {
		for (s in stripes) {
			s.makeGraphic(FlxG.width, 32, Settings.AVAILABLE_COLORS[s.ID % 4 + 1]);
		}
	}
	
	public function start() {
		if (!running) {
			running = true;	
			for (s in stripes) {
				var t = new FlxTimer();
				t.start(s.ID / 20, function(_) {
					lengthenStripe(s);
				});
			}
		}
	}
	
	public function startHalf() {
		if (!running) {
			running = true;	
			for (s in stripes) {
				var t = new FlxTimer();
				t.start(s.ID / 20, function(_) {
					shorthenStripe(s);
				});
			}
		}
	}
	
	function shorthenStripe(s:FlxSprite) {
		s.width -= Settings.STRIPE_SPEED;
		s.x += Settings.STRIPE_SPEED;
		s.makeGraphic(Std.int(s.width), 32, Settings.AVAILABLE_COLORS[s.ID%4 + 1]);
		
		if (s.width < FlxG.width) {
			var t = new FlxTimer();
			t.start(.00001, function(_) {
				shorthenStripe(s);
			});
		} else {
			
		}
	}
	
	function lengthenStripe(s:FlxSprite) {
		s.width += Settings.STRIPE_SPEED;
		s.makeGraphic(Std.int(s.width), 32, Settings.AVAILABLE_COLORS[s.ID%4 + 1]);
		
		if (s.width < FlxG.width) {
			var t = new FlxTimer();
			t.start(.00001, function(_) {
				lengthenStripe(s);
			});
		} else {
			
		}
	}
	
	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
	
	
}