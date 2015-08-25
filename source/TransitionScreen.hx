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

	var stripes:Array<FlxSprite>;
	
	var running:Bool = false;
	
	public function new() {
		super();
		
		stripes = new Array<FlxSprite>();
		
		for (i in 0...Std.int(FlxG.height / 32)) {
			var s = new FlxSprite(0, 32 * i);
			s.makeGraphic(0, 32, 0);
			s.width = 0;
			s.ID = i;
			add(s);
			stripes.push(s);
		}
	}
	
	public function setup() {
		running = false;
		for (s in stripes) {
			s.x = 0;
		}
	}
	
	public function setupHalf() {
		running = false;
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
		

		if (s.width != 0) {
			s.makeGraphic(Std.int(s.width), 32, Settings.AVAILABLE_COLORS[s.ID%4 + 1]);	
		} else {
			s.makeGraphic(FlxG.width, 32, 0);
			s.width = 0;
		}
		
		
		if (s.width > 0) {
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