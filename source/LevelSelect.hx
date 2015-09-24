import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.input.FlxPointer;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
class LevelSelect extends FlxState {
	
	var levelIcons:FlxTypedGroup<LevelIcon>;
	var transitionScreen:TransitionScreen;

	var stages:FlxTypedGroup<Stage>;

	var scroll:Float = 0;
	var tmpScroll:Float = 0;
	
	var pressedPoint:FlxPoint;
	var scrolling:Bool = false;
	
	override public function create(){
		super.create();
	
		stages = new FlxTypedGroup<Stage>();
		add(stages);
		pressedPoint = new FlxPoint(-1, -1);
		
		
		for(i in 0...5){
			var s = new Stage(i);
			stages.add(s);
		}
/*
		stage1 = new FlxSprite(0, 0, Settings.STAGE_1);
		add(stage1);

		levelIcons = new FlxTypedGroup<LevelIcon>();
		add(levelIcons);
		
		for (y in 0...Settings.LEVEL_ROWS) {
			for (x in 0...Settings.LEVEL_COLUMNS) {
				var moveY = 0;
				if(x % 2 == 1){
					moveY = 32;
				}

				var l = new LevelIcon(x * 64 + (FlxG.width - Settings.LEVEL_COLUMNS * 64 + 16)/2, 24 + y * 64 + moveY, y*Settings.LEVEL_ROWS + x + 1);
				levelIcons.add(l);
			}
		}
		*/
		
		transitionScreen = new TransitionScreen();
		transitionScreen.startHalf();
		add(transitionScreen);
	}
	
	function handleMouse() {
		if (FlxG.mouse.justPressed) {			
			
			pressedPoint.set(FlxG.mouse.screenX, FlxG.mouse.screenY);
			tmpScroll = scroll;
			/*
			for (l in levelIcons) {
				if (FlxG.mouse.overlaps(l.icon)) {
					transitionScreen.running = false;
					transitionScreen.start();

					var t = new FlxTimer();
					t.start(.65, function(_) {
						FlxG.switchState(new PlayState(l.level));		
					});
				}
			}*/
		}
		
		if (FlxG.mouse.justReleased) {
			pressedPoint.set( -1, -1);
			scrolling = false;
		}
		
		if (pressedPoint.y != -1) {
			if (Math.abs(FlxG.mouse.screenY - pressedPoint.y) > 4 || scrolling) {
				scroll = tmpScroll + pressedPoint.y - FlxG.mouse.screenY;
				scrolling = true;
			}
		}
	}
	
	override public function update(elapsed:Float) {
		super.update(elapsed);
		handleMouse();
		if (scroll < 0) {
			scroll += ( -scroll) / 4;
		} else if (scroll + FlxG.height > 4 * Settings.STAGE_HEIGHT) {
			scroll += (4 * Settings.STAGE_HEIGHT - FlxG.height - scroll) / 4;
		}
		FlxG.camera.scroll.y += (scroll - FlxG.camera.scroll.y)/3;
	}
}