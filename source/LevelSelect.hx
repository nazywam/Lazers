import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.input.FlxPointer;
import flixel.math.FlxPoint;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
class LevelSelect extends FlxState {
	
	var transitionScreen:TransitionScreen;

	var stages:FlxTypedGroup<Stage>;

	var scroll:Float = 0;
	var tmpScroll:Float = 0;
	
	var pressedPoint:FlxPoint;
	var pressedLevelIcon:LevelIcon;
	var scrolling:Bool = false;
	
	
	override public function create(){
		super.create();
		
		if (Settings.SAVES.data.completedLevels == null) {
			Settings.SAVES.data.completedLevels = new Array<Bool>();
		}
		
		stages = new FlxTypedGroup<Stage>();
		add(stages);
		pressedPoint = new FlxPoint(-1, -1);
		
		
		for(i in 0...5){
			var s = new Stage(i);
			stages.add(s);
		}
		
		transitionScreen = new TransitionScreen();
		transitionScreen.startHalf();
		add(transitionScreen);
	}
	
	function handleMouse() {
		if (FlxG.mouse.justPressed) {			
			
			pressedPoint.set(FlxG.mouse.screenX, FlxG.mouse.screenY);
			tmpScroll = scroll;
			for(s in stages){
				for (l in s.levelIcons) {
					if (FlxG.mouse.overlaps(l.icon)) {
						pressedLevelIcon = l;
					}
				}
			}
		}
		
		if (FlxG.mouse.justReleased) {
			pressedPoint.set( -1, -1);
			
			if(pressedLevelIcon != null && FlxG.mouse.overlaps(pressedLevelIcon) && !scrolling){
				transitionScreen.running = false;
				transitionScreen.start();

				var _stage = pressedLevelIcon.stage;
				var _level = pressedLevelIcon.level;

				var t = new FlxTimer();
				t.start(.65, function(_) {
					FlxG.switchState(new PlayState(_stage, _level, true));		
				});
			}
			pressedLevelIcon = null;
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