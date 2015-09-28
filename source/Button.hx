package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.effects.FlxWaveSprite;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
/**
 * ...
 * @author Michael
 */
class Button extends FlxGroup {

	public var text:FlxText;
	public var background:FlxSprite;
	
	public var x:Float;
	public var y:Float;

	public var specialFormat:FlxTextFormat;

	public var colorID:Int;

	public function new(_x:Float, _y:Float, _t:String, _w:Int, _s:Int) {
		super();
		
		x = _x;
		y = _y;

		text = new FlxText(_x, _y, _w, _t, _s);
		text.setFormat(Settings.FONT, _s, FlxColor.BLACK, "center");
		text.bold = true;
		
		background = new FlxSprite(_x, _y);
		background.makeGraphic(_w, Std.int(text.height));
		
		add(background);
		add(text);

		colorID = Std.random(Settings.AVAILABLE_COLORS.length-1);
		specialFormat = new FlxTextFormat(Settings.AVAILABLE_COLORS[colorID], true, false, 0xFFFF8000);
		blink(true);
	}

	public function blink(loop:Bool){
		for(i in 0...text.text.length+1){
			var t = new FlxTimer();
			t.start(i/20, function(_){
				text.addFormat(specialFormat, i, i+1);

				var t2 = new FlxTimer();
				t2.start(.2, function(_){
					text.removeFormat(specialFormat, i-1, i);
				});
			});	
		}

		if (loop) {		
			var t = new FlxTimer();
			t.start(Math.sqrt(Math.random() * 6), function(_) { blink(true); } );
		}
	}

	override public function update(elapsed:Float){
		super.update(elapsed);
		if(FlxG.mouse.justPressed){
			if(FlxG.mouse.overlaps(this)){
				
			}
		}
	}
	
}